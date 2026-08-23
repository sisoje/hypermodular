#!/usr/bin/env python3
"""mapcheck — the map-side half of the registry check (F11).

Walks a repo for APP-MAP.md / MAP.md, parses the mermaid blocks in the
skill's notation, and verifies what the doctrine promises can be
verified from the maps alone:

  identity      every block's parent link resolves; every MAP.md is
                reachable from APP-MAP.md (no orphans)
  id=name       a labeled node's mermaid id equals its name
  grammar       every contract line starts with '· '
  double-entry  a node's label as a child equals its label as a root
  cylinders     every '· dep.func' line names a cylinder in the box;
                a derived cylinder's ingredients sit above it
  evidence      dotted targets are label call lines; bare targets are
                label callbacks or (unverifiable here) stored
                properties; reserved names are quoted; a node with
                calls on its label and no evidence block is reported;
                an in-arrow from anything but User/System is a warning
                (whether a parent-value change is a stimulus is unruled)
  order         the Dependencies column is the injection order (~~~)

Not checked — needs the code: that every call in a node's Swift
appears as a label line, and that bare evidence targets are real
stored properties. Those are the other half of F11.

Usage: mapcheck.py [repo-root]   (exit 1 on any error)
"""
import re, sys, os
from pathlib import Path

RESERVED = set("""accDescr accTitle activate actor alt and as autonumber box
break create critical deactivate destroy details else end left link links
loop note off opt option over par participant properties rect right
title""".split())
STIMULI = {"User", "System"}

errors, warnings, unverified = [], [], []
def err(f, m): errors.append(f"{f}: {m}")
def warn(f, m): warnings.append(f"{f}: {m}")

# ---------------------------------------------------------------- parsing
BLOCK = re.compile(r"```mermaid\n(.*?)```", re.S)
HEAD = re.compile(r"^%% (Root|Evidence): (\w+)(?: · (?:Parent: (\w+) \(([^)]+)\)|(Dependencies|Unmounted)))?\s*$")
LABELED = re.compile(r'(\w+)\["([^"]*)"\]')
CYL = re.compile(r'(\w+)\[\("?([^")\]]*)"?\)\]')
ARROW = re.compile(r'^\s*(\w+)(?:\["[^"]*"\])?\s*-->(?:\|[^|]*\|)?\s*(\w+)')
SEQ = re.compile(r'^\s*("?[\w.]+"?)\s*(-->>|->>)\s*("?[\w.]+"?)\s*:\s*(.*)$')

def split_label(raw):
    parts = raw.split("<br/>")
    return parts[0].strip(), [p.strip() for p in parts[1:]]

def kind(line):
    body = line[2:].strip() if line.startswith("· ") else line
    if body.startswith("@"): return "materialize", body
    if "." in body: return "call", body
    return "callback", body

class Node:
    def __init__(self, name): self.name = name; self.labels = {}; self.evidence = []
nodes, files_seen, blocks = {}, {}, []

def node(name): return nodes.setdefault(name, Node(name))

def parse_file(path, root):
    rel = str(path.relative_to(root))
    files_seen[rel] = []
    for m in BLOCK.finditer(path.read_text()):
        lines = m.group(1).splitlines()
        if not lines: continue
        h = HEAD.match(lines[0])
        if not h: err(rel, f"block has no identity header: {lines[0]!r}"); continue
        kindb, name, parent, ppath, special = h.groups()
        b = dict(file=rel, kind=kindb, name=name, parent=parent, ppath=ppath,
                 special=special, body=lines[1:], dir=path.parent)
        blocks.append(b); files_seen[rel].append(b)

def parse_structure(b):
    rel, labeled = b["file"], set()
    def record(name, contract, role):
        node(name).labels.setdefault(tuple(contract), []).append((rel, role))
    for ln in b["body"]:
        for mid, raw in LABELED.findall(ln):
            name, contract = split_label(raw)
            if mid != name: err(rel, f"id '{mid}' != name '{name}'")
            for c in contract:
                if not c.startswith("· "): err(rel, f"{name}: contract line lacks '· ': {c!r}")
            role = "root" if (b["kind"] == "Root" and name == b["name"]) else f"child-of-{b['name']}"
            if b["special"] == "Unmounted": role = "unmounted"
            record(name, contract, role); labeled.add(name)
    if b["special"]: return
    for ln in b["body"]:
        a = ARROW.match(ln)
        if not a: continue
        src, dst = a.groups()
        if src != b["name"]: err(rel, f"arrow from '{src}' in a block rooted at '{b['name']}' (depth > 1)")
        # a bare id is a copy of the label with an empty contract — it
        # takes part in double-entry like any other appearance
        if dst not in labeled: record(dst, (), f"child-of-{b['name']}"); labeled.add(dst)
        if src == b["name"] and src not in labeled: record(src, (), "root"); labeled.add(src)

def parse_dependencies(b):
    rel, order, cyls, chain = b["file"], [], {}, []
    for ln in b["body"]:
        for cid, raw in CYL.findall(ln):
            name, ingredients = split_label(raw)
            if cid != name: err(rel, f"cylinder id '{cid}' != name '{name}'")
            cyls[name] = [kind(i)[1] for i in ingredients]; order.append(name)
        if "~~~" in ln: chain = [t.strip() for t in ln.split("~~~")]
    if chain and chain != [c for c in order if c in chain]:
        err(rel, "Dependencies ~~~ chain disagrees with cylinder listing order")
    # the chain is the semantic order; the listing merely should agree
    column = [c for c in chain if c in cyls] + [c for c in order if c not in chain] if chain else order
    for name, ings in cyls.items():
        for ing in ings:
            if ing not in cyls: err(rel, f"{name}: ingredient '{ing}' is not a cylinder")
            elif column.index(ing) > column.index(name): err(rel, f"{name}: ingredient '{ing}' sits below it (injection order)")
    return cyls

def parse_evidence(b):
    rel, n = b["file"], b["name"]
    if not (b["body"] and b["body"][0].startswith("%% Given:")): err(rel, f"{n}: evidence block lacks '%% Given:' second line")
    outs, ins = [], []
    for ln in b["body"]:
        s = SEQ.match(ln)
        if not s: continue
        src, arrow, dst, msg = s.groups()
        for t in (src, dst):
            if t in RESERVED: err(rel, f"{n}: target '{t}' is a mermaid reserved word — quote it")
        if arrow == "->>":
            if src.strip('"') == n: outs.append(dst.strip('"'))
            elif src in STIMULI: ins.append(src)
            elif dst.strip('"') == n: warn(rel, f"{n}: in-arrow from '{src}' — only User and System are ruled stimuli; a parent-value change as a stimulus is an open question (TODO)")
            else: err(rel, f"{n}: arrow '{src}->>{dst}' neither from the node nor a stimulus (depth > 1?)")
        else:
            if dst.strip('"') != n: err(rel, f"{n}: dashed arrow must return to the node, got '{dst}'")
    node(n).evidence.append((rel, outs))

# ---------------------------------------------------------------- checks
def main(root):
    root = Path(root).resolve()
    app = root / "APP-MAP.md"
    if not app.exists(): print(f"no APP-MAP.md under {root}"); return 2
    for p in [app, *root.rglob("MAP.md")]:
        if p.name == "MAP.md" or p == app: parse_file(p, root)
    cyls = {}
    for b in blocks:
        if b["special"] == "Dependencies": cyls.update(parse_dependencies(b))
        elif b["kind"] == "Root": parse_structure(b)
        elif b["kind"] == "Evidence": parse_evidence(b)
    if not cyls: warn("APP-MAP.md", "no Dependencies block found")

    # identity: parent links resolve; reachability
    roots = {b["name"] for b in blocks if b["kind"] == "Root" and not b["special"]}
    reachable = {"APP-MAP.md"}
    for b in blocks:
        if b["parent"] is None:
            if b["kind"] == "Evidence" or (b["file"] != "APP-MAP.md" and not b["special"]):
                err(b["file"], f"{b['name']}: block has no Parent link")
            continue
        target = (root / b["dir"] / b["ppath"]).resolve()
        if not target.exists(): err(b["file"], f"{b['name']}: parent path {b['ppath']} does not exist")
        elif b["parent"] not in roots and b["parent"] != "Unmounted":
            err(b["file"], f"{b['name']}: parent '{b['parent']}' is not the root of any block")
        else: reachable.add(b["file"])
    for f in files_seen:
        if f not in reachable: err(f, "orphan: no block in this file links to a parent")

    # double-entry + cylinders + evidence
    for n in nodes.values():
        if len(n.labels) > 1:
            views = "; ".join(f"{'/'.join(c) or '(name only)'} @ {', '.join(r for _, r in w)}" for c, w in n.labels.items())
            err("double-entry", f"{n.name}: label differs between copies — {views}")
        contract = max(n.labels, key=len, default=())
        calls, callbacks = set(), set()
        for c in contract:
            k, body = kind(c)
            if k == "call":
                dep = body.split(".")[0]; calls.add(body)
                if dep not in cyls: err("cylinders", f"{n.name}: '· {body}' names no cylinder '{dep}' in the Dependencies box")
            elif k == "callback": callbacks.add(body)
        for rel, outs in n.evidence:
            for t in outs:
                if "." in t:
                    if t not in calls: err(rel, f"{n.name}: evidence target '{t}' is not a call line on the label")
                elif t not in callbacks: unverified.append(f"{rel}: {n.name}: bare target '{t}' assumed a stored property (needs code)")
        if (calls or callbacks) and not n.evidence:
            warn("evidence", f"{n.name}: label has calls ({', '.join(sorted(calls | callbacks))}) but no evidence block")

    for e in errors: print("ERROR   ", e)
    for w in warnings: print("WARNING ", w)
    for u in dict.fromkeys(unverified): print("UNVERIF ", u)
    print(f"\n{len(files_seen)} files, {len(blocks)} blocks, {len(nodes)} nodes, {len(cyls)} cylinders — "
          f"{len(errors)} errors, {len(warnings)} warnings, {len(unverified)} unverified")
    return 1 if errors else 0

if __name__ == "__main__":
    sys.exit(main(sys.argv[1] if len(sys.argv) > 1 else "."))
