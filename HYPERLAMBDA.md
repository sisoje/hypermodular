# Hyperlambda — reference notes

Research notes on AINIRO's Hyperlambda, gathered because it solves a
problem this repo is circling: how a *declarative description* replaces
a codebase, and what has to be true for a machine to generate from it
safely. Not doctrine — background. The last section is the only part
about hypermodular.

Everything below is either quoted from AINIRO's own material or
paraphrased from it; their marketing numbers are reproduced as claims,
not endorsed. Sources at the bottom.

## 1. What it is

> "Hyperlambda is a declarative, event-driven programming language
> designed for creating APIs, automation, workflows, and business logic
> with minimal boilerplate."

And the sharper self-description:

> "In its purest form, it's a relational file format, similar to XML and
> JSON, that allows you to declaratively create execution trees, that
> just so happens to allow for executing functionality."

That second sentence is the whole idea. It is a **file format first** —
a way of writing down a tree — and execution is a consequence of the
tree being interpretable, not the primary framing.

It is implemented in C#, runs on .NET Core 8, and sits at the core of
**Magic Cloud**, AINIRO's platform. Its stated role today is as the
execution layer beneath AI agents: "The agent produces instructions, and
Hyperlambda safely performs the actions — invoking APIs, updating
databases, running workflows, and handling automation."

## 2. The node model

Everything is a **node**, and a node has exactly three attributes:

- **name**
- **value**
- **children**

The text format is YAML-shaped. Name and value are separated by a colon;
children are indented **three spaces** beneath their parent:

```
foo:bar
foo:int:5
foo
   child1:its-value
   child2:its-value
```

Strings are the default type and need no quotes unless the value
contains colons or special characters. Single quotes, double quotes and
`@"..."` multiline strings are all supported, with `\r\n`-style escapes.

**Types go between name and value:**

```
.foo1:int:5
.foo2:string:Howdy world
```

Built-in types: `string`, `short`, `ushort`, `int`, `uint`, `long`,
`ulong`, `decimal`, `double`, `single`/`float`, `bool`, `date`
(DateTime, UTC), `time` (TimeSpan), `guid`, `char`, `byte`, `sbyte`,
plus two that matter structurally — `x` (a lambda **Expression**) and
`node` (a Node). The type system is extensible from C# via
`Converter.AddConverter`.

### Why not JSON or YAML

Their own argument, and it is a good one: JSON objects are dictionaries,
so keys must be unique. Hyperlambda children are an **ordered list**, so
the same name can appear many times at the same level. Two consecutive
`if` statements are natural in Hyperlambda and awkward in JSON/YAML.
Ordering is semantic, and repetition is legal.

### Hyperlambda vs lambda

The distinction is the XML one:

> "Hyperlambda is the name of the file format in its text
> representation, while lambda is the name of the nodes in memory, after
> having been parsed into a graph object."

Parsing (`HyperlambdaParser.Parse`) wraps everything in an explicitly
created **root node**. The reverse direction exists too
(`HyperlambdaGenerator.GetHyperlambda`), so text → graph → text is a
round trip.

## 3. Execution model

The executor walks nodes **sequentially, top to bottom**, and treats
each node as an invocation of a **slot** named by the node's name.
Arguments are the node's children. Slots are implemented in C#.

The one syntactic exception carries most of the language's discipline:

> Data nodes begin with `.` and are ignored during evaluation, allowing
> separation of function calls from data storage.

So `.arguments` and `.data` are inert; `if`, `for-each`, `data.read`
execute. One character separates the data half of a file from the code
half. In prose and docs, slots are conventionally written in square
brackets — `[if]`, `[for-each]` — but the brackets are notation for
talking about slots, not part of the file syntax.

A minimal invocation, showing arguments-as-children:

```
eq
   .:lhs
   .:rhs
```

## 4. The slot vocabulary

"Everything is a slot." The core plugin (`magic.lambda`) supplies the
constructs a language would normally hard-code as keywords:

- **Execution / invocation** — `[eval]`, `[invoke]`, `[compose]`
- **Branching** — `[if]`, `[else-if]`, `[else]`, `[switch]`
- **Iteration** — `[for-each]`, `[while]`
- **Exceptions** — `[try]`, `[throw]`
- **Comparison** — `[eq]`, `[neq]`, `[lt]`, `[lte]`, `[mt]`, `[mte]`
- **Boolean** — `[and]`, `[or]`, `[not]`
- **Node manipulation** — `[add]`, `[insert-before]`, `[set-value]`,
  `[get-value]`, `[unwrap]`, `[exists]`, `[reference]`
- **Types** — `[types]`, `[type]`, `[convert]`, `[format]`,
  `[vocabulary]`

Other plugins add the world: SQL, HTTP, files, queues, scheduling,
auth. `[slots.create]` defines new slots from Hyperlambda itself, so the
vocabulary is open — user-defined slots and C# slots are invoked
identically.

Crucially, this vocabulary is **enumerable at runtime** (that is what
`[vocabulary]` is for). A running installation knows exactly which slots
exist. Section 8 is why that matters.

## 5. Lambda expressions

Hyperlambda has no variables:

> "Hyperlambda doesn't have variables. This is because everything is a
> potential variable."

Instead it has **lambda expressions** — XPath for the node graph,
written as the `x` type:

```
.foo:hello world
get-value:x:@.foo
```

An expression is a chain of **iterators** separated by `/`. Each
iterator takes an `IEnumerable<Node>` and returns another — "dynamically
chained Linq statements."

### Iterator reference

| Iterator | Meaning |
|----------|---------|
| `*` | all children of the previous result |
| `**` | all descendants, breadth-first |
| `#` | the previous result's *value* dereferenced as a node |
| `-` | previous (younger) sibling |
| `+` | next (elder) sibling |
| `.` | parent node(s) |
| `..` | root node |
| `^xxx` | first ancestor named `xxx` |
| `--` | all ancestors and older siblings, upward |
| `!xxx` | descendants except those matching `xxx` |
| `@xxx` | first node *before in the hierarchy* named `xxx` |
| `=xxx` | node whose **value** is `xxx` |
| `n` | the n'th child of the previous result set |
| `[n,n]` | a subset — skip, count |
| `[x\|y]` | nodes matching either name |
| `{x}` | extrapolated: evaluate the inner expression first, substitute |

Iterators are extensible too — `Iterator.AddDynamicIterator('%', ...)`
adds a custom one at runtime.

### Examples

Plain lookup:

```
.data
   item1:john
   item2:thomas
   item3:peter
get-value:x:@.data/*/item2
```

"Find `.data`, take its children, filter for `item2`" → `thomas`.

Parameterised lookup — the inner expression resolves first:

```
.arg1:foo2
.data
   foo1:john
   foo2:thomas
   foo3:peter
get-value:x:@.data/*/{@.arg1}
```

Iteration, with `[.dp]` as the loop's current-item pointer, `#`
dereferencing it:

```
for-each:x:@.data/*
   log.info:x:@.dp/#
```

And the deep end — quoted, escaped, extrapolated, value-matched:

```
.foo
   howdy:wo/rld
   jo:nothing
   howdy:earth
.dyn:.foo
for-each:x:@"./*/{@.dyn}/*/""=wo/rld"""
   set-value:x:@.dp/#
      :thomas was here
```

## 6. Homoiconicity and meta programming

Because code is a node graph and the graph is manipulable by the same
slots that manipulate data, a Hyperlambda program can rewrite itself
before or during execution — `[add]`, `[set-value]`, `[insert-before]`
work on lambda objects as readily as on `.data`, and `[eval]` runs the
result.

> "code is data" — mutable executable code that transforms itself.

This is what they mean by meta programming: "the art of creating
software that creates software," and it is the basis of their CRUD
generator, which points at a database and emits endpoints without any AI
in the loop. Deterministic generation, not inference.

## 7. Endpoints

An HTTP API is a file on disk. Resolution is purely conventional:

- URL path + HTTP verb + `.hl` → the file, under `/files/`
- verbs: GET, POST, PUT, DELETE, PATCH
- filenames restricted to `a-z`, `0-9`, `-`, `_`, `/`
- files must live under `/files/modules/` or `/files/system/`

Arguments are **declared as data** at the top of the file, and the
runtime type-converts and validates against the declaration:

```
.arguments
   arg1:string
   arg2:int

strings.concat
   get-value:x:@.arguments/*/arg1
   .:" - "
   get-value:x:@.arguments/*/arg2

unwrap:x:+/*
return
   result:x:@strings.concat
```

Omitting `[.arguments]` accepts anything; a declared type of `*` accepts
any type for that one argument. `[return]` serialises to JSON by
default; `[return-value]` streams without buffering.

## 8. Safety: the sandbox and the closed vocabulary

Two separate mechanisms, often conflated:

**The sandbox.** "Hyperlambda is sandboxed by design, limiting
destructive operations unless explicitly whitelisted." The language
cannot reach the machine except through slots that exist, and which
slots exist is a deployment decision.

**Slot verification at generation time.** This is the interesting one.
Their code generator is not a general LLM:

> "At the heart of Magic you'll find the Hyperlambda Generator — our own
> proprietary SLM (Small Language Model), fine-tuned with more than
> 600,000 training snippets, transforming natural language into working
> Hyperlambda code in typically 1.5 to 5 seconds. Unlike general purpose
> LLMs, it cannot hallucinate function invocations — every slot the
> generated code invokes is verified against the slots that actually
> exist in your cloudlet before the code is returned to you."

If the model invokes something that doesn't exist, the code is rejected
and regenerated automatically. The vocabulary is closed and
enumerable (§4), so "does this call exist?" is a lookup, not a judgement
call. That is the actual product — not the token count.

## 9. The FAQ, condensed

Their FAQ answers sixteen questions. Stripped of repetition, it makes
five points — and one of them is a surprise.

**It is positioned as an agent's execution layer, not a developer
language.** "Hyperlambda acts as the execution layer beneath AI agents.
The agent produces instructions, and Hyperlambda safely performs the
actions." Every other answer follows from that framing.

**It reaches the world through built-in modules, not bindings.** "SQL
databases, REST APIs, file systems, queues, and more" ship as slots, and
custom high-performance modules can be written in C# and exposed as
slots — so the vocabulary a generator draws from is both broad and
enumerable (§4, §8).

**It handles the awkward half of orchestration.** Asynchronous
execution, scheduled tasks, queue-based orchestration and multi-step
workflows are claimed as first-class, which is what lets a declarative
tree stand in for a service rather than just a script.

**Security is by construction, not by review.** "Sandboxed by design,
limiting destructive operations unless explicitly whitelisted." The FAQ
gives this as a property of the language, not of the code written in it.

**And the surprise: nobody is expected to read it.**

> **Q: Do I need to know Hyperlambda to use your platform or solutions?**
> "Not at all. We create and maintain the Hyperlambda logic for you."

A language whose vendor's own FAQ says you never have to learn it. The
terseness, then, is not for a human reader — it is to make the artifact
cheap for a model to emit and cheap for a machine to verify. Human
legibility is a side effect they are happy to have and unwilling to
depend on. §10 takes this seriously, because it is the one place the two
methods genuinely disagree.

### The numbers

Reproduced without endorsement:

| Claim | Their number |
|-------|--------------|
| Verbosity vs traditional languages | "5% of the verbosity" |
| Complexity vs Python, counting tokens | Python is "5 to 10 times more complex" |
| Cognitive load reduction for models | "up to 95%" |
| Throughput vs Python | 5–7× |
| vs FastAPI | ~19× |
| vs N8N under heavy load | ~7× |
| vs LangChain | ~20× |
| vs Rust with Actix-Web | ~2× |
| Declarative vs imperative learnability | "20 to 50 times easier to learn" |

The verbosity claim is plausible for the domain they target (CRUD, API
orchestration) and worth taking seriously. The performance table —
notably "twice as fast as Rust" — is marketing and should be treated as
such. None of it is load-bearing for anything in this repo.

## 10. What any of this has to do with hypermodular

The relevant claim is not that Hyperlambda is fast or terse. It is that
**a description can replace a codebase when the description is a tree
over a closed, verifiable vocabulary.** That is exactly the bet this
repo makes with maps — arrived at independently, and from the other
end (architecture rather than execution).

### Where the two line up

| Hyperlambda | hypermodular |
|---|---|
| relational file format declaring execution trees | depth-1 maps joined on node name; "the name is the join key" |
| node = name + value + children | node = name + contract lines + children |
| slot: a named unit, invoked by name | cylinder: a named boundary, called by name |
| leading `.` marks inert data vs executing code | `· @Wrapper` materialises (no evidence) vs `· dep.func` calls (evidence) |
| arguments declared as data at the top of the file | contract lines declared on the label, before the code |
| sandbox: destructive ops must be whitelisted | rule 2: touch only the capabilities the label names |
| generated slots verified against slots that exist | *(nothing — the gap)* |
| code is data: the tree is diffable, mergeable, rewritable | maps are markdown: diffable in the PR, merged on names |

### Where they deliberately diverge

- **Duplicate names.** Hyperlambda *wants* them — children are an
  ordered list and order is meaning. Hypermodular *forbids* them — the
  name is the merge key, and one name must mean one node. Both follow
  from what the tree is for: theirs is a program, ours is a set of rows
  to be joined.
- **Depth.** Their trees are arbitrarily deep; that is the point. Ours
  are depth 1 everywhere, and that is the point. Different laws because
  one tree executes and the other is reviewed.
- **Who reads it.** Their FAQ says customers never need to learn the
  language (§9) — the artifact is written by a model and checked by a
  machine, and human legibility is incidental. A map inverts this
  exactly: it renders in every PR *because* the human review is the
  point, and the map diff **is** the design review. Same artifact
  serving opposite masters. It is why terseness is their whole game and
  only a side effect here — and why the mermaid constraint is worth
  paying for, since a notation that renders is one a person will
  actually argue with.
- **Who interprets.** Hyperlambda has an interpreter, so re-running is
  deterministic. A map is generated *from*, by a model, so it is not.
  Determinism has to come from somewhere else — which is what the
  evidence log is for. A nondeterministic generator with a deterministic
  acceptance oracle is deterministic where it counts.

### Worth stealing

1. **The map as a verified slot registry.** Their generator checks every
   invocation against the slots that actually exist before returning
   code. The map already *is* that registry — the dependency box is the
   catalogue, a node's `·` lines are its permitted subset — but rule 2
   states it as etiquette rather than as a gate. Three mechanical checks
   would change that: every call in a node's code appears as a contract
   line; every contract line names a cylinder in the box or a wrapper;
   every participant in a node's evidence names one of the two.
2. **An execution half of the notation.** Structure has three diagrams;
   behaviour has prose and a bare array literal. An evidence log is an
   ordered sequence of messages from a node to its boundaries, which
   mermaid draws natively — and `->>` vs `-->>` already distinguishes
   "the call is the event" from "the return is supplied data."
3. **Naming the data/code marker.** Their leading `.` and our `·` lines
   encode the same distinction. Ours is already correct; it is just
   never stated as the single organising principle it is.

### Not worth stealing

The fine-tuned SLM. Their moat is that no general model knows
Hyperlambda, so they had to train one. The inverse is true here: every
model already knows SwiftUI. The scarce thing is not fluency in the
target language — it is a fence the model cannot argue its way past, and
a log it cannot fake.

## Sources

- [Hyperlambda, THE AI Programming Language](https://ainiro.io/hyperlambda) — marketing page and FAQ
- [Hyperlambda — Magic Cloud docs](https://docs.ainiro.io/hyperlambda/)
- [magic.node — nodes, Hyperlambda, lambda expressions](https://docs.ainiro.io/plugins/magic.node/)
- [magic.lambda — the core slot vocabulary](https://docs.ainiro.io/plugins/magic.lambda/)
- [magic.endpoint — files as HTTP endpoints](https://docs.ainiro.io/plugins/magic.endpoint/)
- [Hyperlambda Generator](https://docs.ainiro.io/dashboard/hyperlambda-generator/)
- [Hyperlambda, a Web Query Language](https://ainiro.io/blog/hyperlambda-web-query-language)

Retrieved 2026-08-23.
