#!/usr/bin/env python3
"""mapcheck — the registry check (F11): the maps alone, and with
--sources the maps against the Swift.

Walks a repo for APP-MAP.md, MAP.md, and the flow files under Maps/, parses the mermaid blocks in the
skill's notation, and verifies what the doctrine promises can be
verified from the maps alone:

  identity      every block's parent link resolves; every MAP.md is
                reachable from APP-MAP.md (no orphans)
  id=name       a labeled node's mermaid id equals its name
  grammar       every contract line starts with '· '
  double-entry  a node's label as a child equals its label as a root
  cylinders     every '· dep.func()' call, '· dep.value' read, and dotted '· $dep.value' write names
                a cylinder in the box ('· dismiss()', a sealed action
                Apple sets, has no dot and needs none); a derived cylinder's ingredients
                sit above it
  evidence      every call, callback, and '· $' line on a label is the target of some
                block (reported when not); dotted targets are label call lines or dotted '· $' lines; bare targets are
                label callbacks, label '· $binding' lines, or
                (unverifiable here) stored properties; every '· $binding'
                line is written in some block; reserved names are quoted; a node with
                calls on its label and no evidence block is reported;
                an in-arrow is User, System, or a child firing a
                callback its own label carries
  order         the Dependencies column is the order the root sets values (~~~)
  whole         the first diagram of APP-MAP.md is the whole app, merged
                from the depth-1 blocks on their node names: every node
                with its contract, every condition, the dependencies, and
                a dotted line from a node to each dependency its label
                names. --write draws it. Without --write it is compared,
                and a stale one is an error, a missing one a warning

With --sources DIR [DIR ...], the code-side half. Each mapped node is
matched to the Swift type of its name and its label is derived from
the type's body, then compared both ways:

  code          a presence-condition arrow label that names nothing the
                node holds or reads; a call, read, binding write, callback call or hand-down, or
                materialization in the Swift with no line on the label
                (the fence breach); a label line with nothing behind it
                in the Swift (stale); a bare evidence target that is no
                stored property of the type; @AppStorage below the root
                (F32); a View on no map that reads a cylinder (warning)
  habits        a rule of the code skill no map can show, as a
                warning: a Task nobody holds (F37), which is a Task
                expression not assigned, returned, or awaited

Usage: mapcheck.py [repo-root] [--write] [--sources DIR ...]   (exit 1 on any error)
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
HEAD = re.compile(r"^%% (Root|Evidence|Whole): (\w+)(?: · (?:Parent: (\w+) \(([^)]+)\)|(Dependencies|Unmounted|Coupling)))?\s*$")
LABELED = re.compile(r'(\w+)\["([^"]*)"\]')
CYL = re.compile(r'(\w+)\[\("?([^")\]]*)"?\)\]')
ARROW = re.compile(r'^\s*(\w+)(?:\["[^"]*"\])?\s*-->(?:\|([^|]*)\|)?\s*(\w+)')
SEQ = re.compile(r'^\s*("?[\w.]+"?)\s*(-->>|->>)\s*("?[\w.]+"?)\s*:\s*(.*)$')

def split_label(raw):
    parts = raw.split("<br/>")
    return parts[0].strip(), [p.strip() for p in parts[1:]]

def kind(line):
    body = line[2:].strip() if line.startswith("· ") else line
    if body.startswith("@"): return "materialize", body
    if body.startswith("$"): return "binding", body[1:]
    if body.endswith("()"): return "call", body
    if "." in body: return "read", body
    return "callback", body

child_stimuli = []

class Node:
    def __init__(self, name): self.name = name; self.labels = {}; self.evidence = []; self.conditions = []
nodes, files_seen, blocks = {}, {}, []
whole_found = []   # the generated whole-app block as it stands in APP-MAP.md

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
        if kindb == "Whole": whole_found.append(m.group(1).rstrip("\n")); continue
        b = dict(file=rel, kind=kindb, name=name, parent=parent, ppath=ppath,
                 special=special, body=lines[1:], dir=path.parent)
        if kindb == "Evidence" and path.name == "MAP.md":
            warn(rel, f"{name}: evidence block inside MAP.md (F63: a flow is a file of its own in the node's directory under Maps/)")
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
        src, cond, dst = a.groups()
        if src != b["name"]: err(rel, f"arrow from '{src}' in a block rooted at '{b['name']}' (depth > 1)")
        if cond: node(src).conditions.append((rel, cond.strip()))
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
            elif column.index(ing) > column.index(name): err(rel, f"{name}: ingredient '{ing}' sits below it (set order)")
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
            elif dst.strip('"') == n: child_stimuli.append((rel, n, src.strip('"'), msg))
            else: err(rel, f"{n}: arrow '{src}->>{dst}' neither from the node nor a stimulus (depth > 1?)")
        else:
            if dst.strip('"') != n: err(rel, f"{n}: dashed arrow must return to the node, got '{dst}'")
    node(n).evidence.append((rel, outs))

# ---------------------------------------------------------------- code side
SEALED = {"dismiss", "openURL", "openWindow", "dismissWindow", "requestReview", "refresh"}
TYPE = re.compile(r"((?:@\w+(?:\([^)]*\))?\s+)*)(?:(?:public|private|internal|fileprivate|final|nonisolated)\s+)*(struct|class|enum|extension)\s+(\w+)\s*(?::\s*([^{]*?))?\s*\{")
ENV = re.compile(r"@Environment\(\\\.(\w+)\)\s*(?:(?:private|fileprivate|internal|public)\s+)?var\s+(\w+)")
PROP = re.compile(r"^\s*(?:@\w+(?:\([^)]*\))?\s+)*(?:(?:private|fileprivate|internal|public|static|nonisolated)\s+)*(?:let|var)\s+(\w+)")
CLOSURE_PROP = re.compile(r"^\s*(?:@\w+(?:\([^)]*\))?\s+)*(?:(?:private|fileprivate|internal|public)\s+)*(?:let|var)\s+(\w+)\s*:\s*(?:@escaping\s+)?\(")
BINDING = re.compile(r"^\s*@Binding\s+(?:(?:private|fileprivate|internal|public)\s+)?var\s+(\w+)")
MATERIALIZERS = [("@Query", "@Query"), ("QueryView(", "@Query"), ("@SceneStorage", "@SceneStorage"),
                 ("@FocusState", "@FocusState"), ("@AppStorage", "@AppStorage"), ("ProcessInfo", "@ProcessInfo")]

SKIPPED_DIRS = {".build", "DerivedData", "SourcePackages"}   # build output is never the app's source
TASK = re.compile(r"\bTask\s*(?:\.detached\s*)?[({]")

class SwiftType:
    def __init__(self, name, file):
        self.name, self.file, self.body, self.kinds, self.attrs = name, file, "", set(), set()

def strip_comments(src):
    src = re.sub(r"/\*.*?\*/", "", src, flags=re.S)
    return re.sub(r"//[^\n]*", "", src)

def body_at(text, open_idx):
    depth = 0
    for i in range(open_idx, len(text)):
        if text[i] == "{": depth += 1
        elif text[i] == "}":
            depth -= 1
            if depth == 0: return text[open_idx + 1:i]
    return text[open_idx + 1:]

def depth0_lines(body):
    out, depth = [], 0
    for ln in body.splitlines():
        if depth == 0: out.append(ln)
        depth = max(0, depth + ln.count("{") - ln.count("}"))
    return out

def read_swift(dirs):
    types = {}
    for d in dirs:
        for p in sorted(Path(d).rglob("*.swift")):
            if any(part.startswith(".") or part in SKIPPED_DIRS for part in p.parts): continue
            text = strip_comments(p.read_text())
            for m in TYPE.finditer(text):
                attrs, kw, name, conf = m.groups()
                t = types.setdefault(name, SwiftType(name, str(p)))
                t.body += "\n" + body_at(text, m.end() - 1)
                t.attrs |= set(re.findall(r"@\w+", attrs or ""))
                t.kinds |= {c.strip() for c in (conf or "").split(",") if c.strip()}
    return types

def facts(t):
    """What the type's Swift says its label must be."""
    f = dict(calls=set(), reads=set(), binding_writes=set(), bindings=set(), callbacks_called=set(),
             callbacks=set(), materializes=set(), stored=set(), env=set())
    body, top = t.body, depth0_lines(t.body)
    for key, prop in ENV.findall(body):
        f["env"].add(key)
        if key in SEALED:
            if re.search(rf"\b{prop}\s*\(", body): f["calls"].add(f"{key}()")
            continue
        for m in re.finditer(rf"\b{prop}\.(\w+)", body):
            if re.match(r"\s*\(", body[m.end():]): f["calls"].add(f"{key}.{m.group(1)}()")
            else: f["reads"].add(f"{key}.{m.group(1)}")
    for ln in top:
        pm = PROP.match(ln)
        if pm: f["stored"].add(pm.group(1))
        bm = BINDING.match(ln)
        if bm: f["bindings"].add(bm.group(1))
        cm = CLOSURE_PROP.match(ln)
        if cm: f["callbacks"].add(cm.group(1))
        for mark, line in MATERIALIZERS:
            if mark.startswith("@") and mark in ln: f["materializes"].add(line)
    if "QueryView(" in body: f["materializes"].add("@Query")
    if "ProcessInfo" in body: f["materializes"].add("@ProcessInfo")
    for b in f["bindings"]:
        if re.search(rf"\${b}\b", body) or re.search(rf"\b{b}(?:\.wrappedValue)?\s*(?:=[^=]|\+=|-=|\.toggle\(|\.append\()", body):
            f["binding_writes"].add(b)
    for c in f["callbacks"]:
        # called, or handed down by name to the subtree that calls it
        if len(re.findall(rf"\b{c}\b", body)) > 1: f["callbacks_called"].add(c)
    return f

def check_habits(dirs):
    """A rule of the code skill that no map can show. A warning, since a rule may be broken on purpose."""
    for d in dirs:
        for p in sorted(Path(d).rglob("*.swift")):
            if any(part.startswith(".") or part in SKIPPED_DIRS for part in p.parts): continue
            lines = strip_comments(p.read_text()).splitlines()
            for i, ln in enumerate(lines):
                m = TASK.search(ln)
                if not m: continue
                before = ln[:m.start()].rstrip()
                if not before:   # the assignment may end the line above
                    before = next((l.rstrip() for l in reversed(lines[:i]) if l.strip()), "")
                    before = before if before.endswith("=") else ""
                discarded = re.search(r"(?:^|[\s({,;])_\s*=$", before)
                held = (before.endswith("=") and not discarded) or re.search(r"\b(?:return|await)$", before)
                if not held: warn("code", f"{p.name}: a Task nobody holds, '{ln.strip()[:48]}' (F37: assign it to a slot the node holds, or use .task)")

def check_code(dirs, cyls, treeroots):
    types = read_swift(dirs)
    check_habits(dirs)
    for n in nodes.values():
        contract = max(n.labels, key=len, default=())
        t = types.get(n.name)
        if t is None:
            if contract or n.evidence: warn("code", f"{n.name}: no Swift type of that name under --sources")
            continue
        f = facts(t)
        is_root = "@main" in t.attrs or "App" in t.kinds or n.name in treeroots
        on_label = {kind(c)[0] + ":" + kind(c)[1] for c in contract}
        label_calls = {b for k, b in map(kind, contract) if k == "call"}
        label_reads = {b for k, b in map(kind, contract) if k == "read"}
        label_bindings = {b for k, b in map(kind, contract) if k == "binding"}
        label_callbacks = {b for k, b in map(kind, contract) if k == "callback"}
        label_mats = {b for k, b in map(kind, contract) if k == "materialize"}
        # label -> code
        for c in sorted(label_calls - f["calls"]): err("code", f"{n.name}: label '· {c}' has no such call in {Path(t.file).name}")
        for r in sorted(label_reads - f["reads"] - {c[:-2] for c in f["calls"]}): err("code", f"{n.name}: label '· {r}' is never read in {Path(t.file).name}")
        for b in sorted(label_bindings):
            if "." in b:
                if b not in f["reads"]: err("code", f"{n.name}: label '· ${b}' but {Path(t.file).name} never touches {b}")
            elif b not in f["bindings"]: err("code", f"{n.name}: label '· ${b}' but {Path(t.file).name} has no @Binding {b}")
            elif b not in f["binding_writes"]: err("code", f"{n.name}: label '· ${b}' but {Path(t.file).name} never writes {b}")
        for c in sorted(label_callbacks - f["callbacks_called"]): err("code", f"{n.name}: label '· {c}' but {Path(t.file).name} never calls a closure {c}")
        for m in sorted(label_mats - f["materializes"]): err("code", f"{n.name}: label '· {m}' but {Path(t.file).name} has no {m[1:]}")
        # code -> label
        for c in sorted(f["calls"] - label_calls): err("code", f"{n.name}: {Path(t.file).name} calls {c} with no line on the label")
        for r in sorted(f["reads"] - label_reads - label_bindings): err("code", f"{n.name}: {Path(t.file).name} reads {r} with no line on the label")
        for b in sorted(f["binding_writes"] - label_bindings): err("code", f"{n.name}: {Path(t.file).name} writes @Binding {b} with no '· ${b}' on the label")
        for c in sorted(f["callbacks_called"] - label_callbacks): err("code", f"{n.name}: {Path(t.file).name} calls closure {c} with no '· {c}' on the label")
        for m in sorted(f["materializes"] - label_mats):
            if m == "@AppStorage" and not is_root: err("code", f"{n.name}: @AppStorage below the root in {Path(t.file).name} (F32: the root owns the keys, a feature receives a binding)")
            elif m != "@AppStorage": err("code", f"{n.name}: {Path(t.file).name} materializes {m} with no '· {m}' on the label")
        # a presence condition names a value the node holds or reads
        known = f["stored"] | f["env"] | {r.split(".")[-1] for r in f["reads"]} | {b.split(".")[-1] for b in label_bindings} | {r.split(".")[-1] for r in label_reads}
        for rel, cond in n.conditions:
            if not (set(re.findall(r"[A-Za-z_]\w*", cond)) & known):
                err(rel, f"{n.name}: arrow label '{cond}' names no stored property or read of {n.name} in {Path(t.file).name}")
        # evidence bare targets are stored properties
        for rel, outs in n.evidence:
            for tgt in outs:
                if "." in tgt or tgt in label_callbacks or tgt in label_calls: continue
                if tgt not in f["stored"]: err(rel, f"{n.name}: evidence target '{tgt}' is no stored property of {n.name} in {Path(t.file).name}")
                unverified[:] = [u for u in unverified if not u.endswith(f"{n.name}: bare target '{tgt}' assumed a stored property (needs code)")]
    for t in types.values():
        if t.name in nodes or t.name.endswith("Scenario") or not ({"View", "ViewModifier"} & t.kinds): continue
        f = facts(t)
        for key in sorted(f["env"] & set(cyls)):
            derives = "ViewModifier" in t.kinds and any(key in ings and re.search(rf"\\\.{d}\b", t.body) for d, ings in cyls.items())
            if not derives: warn("code", f"{t.name} ({Path(t.file).name}): on no map, reads dependency {key}")
        if "@Query" in f["materializes"]: warn("code", f"{t.name} ({Path(t.file).name}): on no map, materializes @Query")
        if "@AppStorage" in f["materializes"] and not ("@main" in t.attrs or "App" in t.kinds): warn("code", f"{t.name} ({Path(t.file).name}): @AppStorage below the root (F32)")
    return len(types)

# ---------------------------------------------------------------- the whole app
WHOLE_OPEN = "<!-- whole-app: drawn by mapcheck.py --write from the maps below and under Maps/, never by hand -->"
WHOLE_CLOSE = "<!-- /whole-app -->"

def whole_map():
    """The whole app as one flowchart, merged from the depth-1 blocks on their node names."""
    labels, children, roots, unmounted, cyl_lines, cyl_names = {}, {}, [], [], [], []
    for b in blocks:
        if b["kind"] != "Root": continue
        if b["special"] == "Dependencies":
            for ln in b["body"]:
                for cid, raw in CYL.findall(ln):
                    if cid not in cyl_names: cyl_names.append(cid); cyl_lines.append(ln.strip())
            continue
        if b["special"] == "Coupling": continue
        for ln in b["body"]:
            for mid, raw in LABELED.findall(ln):
                if len(raw) > len(labels.get(mid, "")): labels[mid] = raw
                if b["special"] == "Unmounted" and mid not in unmounted: unmounted.append(mid)
            a = ARROW.match(ln)
            if a and not b["special"]:
                src, cond, dst = a.groups()
                if (cond, dst) not in children.setdefault(src, []): children[src].append((cond, dst))
        if not b["special"] and b["parent"] is None and b["name"] not in roots: roots.append(b["name"])
    def decl(n): return f'{n}["{labels[n]}"]' if n in labels else n
    order, edges = [], []
    def walk(n):
        if n in order: return
        order.append(n)
        for cond, dst in children.get(n, []):
            edges.append(f"    {n} -->{'|' + cond.strip() + '|' if cond else ''} {dst}")
            walk(dst)
    for r in roots: walk(r)
    out = [f"%% Whole: {roots[0] if roots else 'App'}", "flowchart TD"]
    out += [f"    {decl(n)}" for n in order] + edges
    boxes = []
    if unmounted:
        out += ["    subgraph Unmounted"] + [f"        {decl(n)}" for n in unmounted] + ["    end"]; boxes.append("Unmounted")
    if cyl_names:
        out += ["    subgraph Dependencies", "        direction TB"] + [f"        {ln}" for ln in cyl_lines] + ["    end"]; boxes.append("Dependencies")
    for n in order + unmounted:
        named = []
        for line in labels.get(n, "").split("<br/>")[1:]:
            k, body = kind(line.strip())
            dep = body.split(".")[0]
            if k in ("call", "read", "binding") and "." in body and dep in cyl_names and dep not in named: named.append(dep)
        out += [f"    {n} -.-> {d}" for d in sorted(named, key=cyl_names.index)]
    if boxes: out += ["    classDef plain fill:none", f"    class {','.join(boxes)} plain"]
    return "\n".join(out)

def write_whole(app, text):
    """Puts the whole-app diagram first in APP-MAP.md, after its title, replacing the one that is there."""
    src = app.read_text()
    section = f"{WHOLE_OPEN}\n```mermaid\n{text}\n```\n{WHOLE_CLOSE}"
    if WHOLE_OPEN in src and WHOLE_CLOSE in src:
        a, b = src.index(WHOLE_OPEN), src.index(WHOLE_CLOSE) + len(WHOLE_CLOSE)
        src = src[:a] + section + src[b:]
    else:
        lines = src.split("\n")
        at = 1 if lines and lines[0].startswith("# ") else 0
        lines[at:at] = ["", section] if at else [section, ""]
        src = "\n".join(lines)
    app.write_text(src)

# ---------------------------------------------------------------- checks
def main(root, sources=(), write=False):
    root = Path(root).resolve()
    app = root / "APP-MAP.md"
    if not app.exists(): print(f"no APP-MAP.md under {root}"); return 2
    maps = root / "Maps"
    flows = [p for p in maps.rglob("*.md") if p.name != "MAP.md"] if maps.is_dir() else []
    for p in [app, *sorted(root.rglob("MAP.md")), *sorted(flows)]:
        parse_file(p, root)
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
        calls, callbacks, bindings = set(), set(), set()
        for c in contract:
            k, body = kind(c)
            if k == "binding":
                bindings.add(body)
                dep = body.split(".")[0]
                if "." in body and dep not in cyls: err("cylinders", f"{n.name}: '· ${body}' names no cylinder '{dep}' in the Dependencies box")
            elif k in ("call", "read"):
                dep = body.split(".")[0]
                if k == "call": calls.add(body[:-2])   # evidence targets name the closure, no parens
                if "." in body and dep not in cyls: err("cylinders", f"{n.name}: '· {body}' names no cylinder '{dep}' in the Dependencies box")
            elif k == "callback": callbacks.add(body)
        for rel, src, msg in [(r, s, m2) for r, node, s, m2 in child_stimuli if node == n.name]:
            child = nodes.get(src)
            cb = msg.split()[0] if msg.split() else ""
            if src == "Parent":
                warn(rel, f"{n.name}: in-arrow from 'Parent' — a parent-value change as a stimulus is an open question (TODO); a new value is a new given")
            elif child is None:
                err(rel, f"{n.name}: in-arrow from '{src}' — not a node; stimuli are User, System, or a child firing a callback")
            elif not any(kind(c)[0] == "callback" and kind(c)[1] == cb
                         for c in max(child.labels, key=len, default=())):
                warn(rel, f"{n.name}: in-arrow '{src}->>{n.name}: {msg}' — '{cb}' is not a callback line on {src}'s label")
        for rel, outs in n.evidence:
            for t in outs:
                if "." in t:
                    if t not in calls and t not in bindings: err(rel, f"{n.name}: evidence target '{t}' is neither a call nor a $ line on the label")
                elif t not in callbacks and t not in calls and t not in bindings: unverified.append(f"{rel}: {n.name}: bare target '{t}' assumed a stored property (needs code)")
        written = {t for _, outs in n.evidence for t in outs}
        for b in sorted(bindings - written):
            warn("evidence", f"{n.name}: label has '· ${b}' but no evidence block writes it")
        if (calls or callbacks or bindings) and not n.evidence:
            warn("evidence", f"{n.name}: label has calls ({', '.join(sorted(calls | callbacks | bindings))}) but no evidence block")
        elif n.evidence:
            for line in sorted((calls | callbacks) - written):
                warn("evidence", f"{n.name}: label line '{line}' is written in no evidence block")

    treeroots = {b["name"] for b in blocks if b["kind"] == "Root" and not b["special"] and b["parent"] is None}
    ntypes = check_code(sources, cyls, treeroots) if sources else None

    # the whole app, derived and never maintained
    text = whole_map()
    if write: write_whole(app, text)
    elif not whole_found: warn("APP-MAP.md", "no whole-app diagram: run mapcheck.py with --write to draw it")
    elif whole_found[0] != text: err("APP-MAP.md", "the whole-app diagram is stale: run mapcheck.py with --write to redraw it")

    for e in errors: print("ERROR   ", e)
    for w in warnings: print("WARNING ", w)
    for u in dict.fromkeys(unverified): print("UNVERIF ", u)
    code = f", {ntypes} Swift types" if ntypes is not None else ""
    print(f"\n{len(files_seen)} files, {len(blocks)} blocks, {len(nodes)} nodes, {len(cyls)} cylinders{code} — "
          f"{len(errors)} errors, {len(warnings)} warnings, {len(dict.fromkeys(unverified))} unverified")
    return 1 if errors else 0

if __name__ == "__main__":
    args = sys.argv[1:]
    sources = []
    if "--sources" in args:
        i = args.index("--sources"); sources = args[i + 1:]; args = args[:i]
    write = "--write" in args
    args = [a for a in args if a != "--write"]
    sys.exit(main(args[0] if args else ".", sources, write))
