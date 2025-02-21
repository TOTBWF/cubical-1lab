```agda
module index where
```

# Cubical 1lab {style="margin-top: 0;"}

A formalised, cross-linked reference resource for mathematics done in
Homotopy Type Theory. Unlike the [HoTT book], the 1lab is not a "linear"
resource: Concepts are presented as a directed graph, with links
indicating _dependencies_. For instance, the statement of the univalence
axiom depends on [_universes_](agda://1Lab.Type), [_propositional
equality_](agda://1Lab.Path) (paths) and [_equivalences_](agda://1Lab.Equiv):

[HoTT book]: https://homotopytypetheory.org/book/

<!--
```agda
open import 1Lab.Type
open import 1Lab.Equiv
open import 1Lab.Path
open import 1Lab.Univalence
open import 1Lab.HLevel
```
-->

```agda
_ : ∀ {ℓ} {A B : Type ℓ} → isEquiv (pathToEquiv {A = A} {B})
_ = univalence
```

If you don't know what those concepts refer to, it could be challenging
to figure out what the definition above is even saying - or how it's
proven. Fortunately, every single element there is a link! Try clicking
on the word `isEquiv`{.Agda} - either here in the text, or there in the
code. It'll take you to the definition, which will be highlighted in
orange to draw your attention.

Links are colour-coded to indicate what they point to. In body text,
links rendered in [blue (or purple) sans-serif font](index.html) link to
_pages_; Links rendered in one of the syntax highlighting colours and
`monospace`{.agda ident=Category} link to a _definition_. Specifically,
the following colours are used:

* Blue for records and functions: `isEquiv`{.Agda}, `sym`{.agda}

* Green for inductive constructors, coinductive constructors, and the
endpoints of the interval: `i0`{.agda}

* Maroon for modules: `1Lab.Type`{.Agda}

* Purple for record selectors: `isEqv`{.agda ident="isEquiv.isEqv"}

<!--
```agda
_ = i0
_ = isEquiv
_ = isEquiv.isEqv
_ = sym
```
-->

## About

The 1lab is an [open-source] project with the goal of making formalised
mathematics, and especially formalised mathematics done in Homotopy Type
Theory, accessible to as wide as audience as possible. However, the
pages here still do assume a baseline level of knowledge: Nothing
specific to HoTT, but familiarity with MLTT, especially with Agda, is
helpful.

[open-source]: https://github.com/plt-amy/cubical-1lab

Contributions are, of course, welcome! If you need help getting set up,
want to discuss a contribution, or just ask a question, [join our
Discord server]! If you don't feel like your contribution merits a pull
request (i.e.: it's just fixing a typo), it's fine to just mention it on
the server and I'll see that it gets addressed as soon as possible.

[join our Discord server]: https://discord.gg/NvXkUVYcxV

Since this website is about mathematics, and mathematics is done by
people, there is a page where contributors can write short profiles
about themselves: Keeping with the theme, it's an Agda module:
`Authors`{.Agda} (there isn't any code there, though!)

<!--
```agda
open import Authors
```
-->

It'd be very unfair of me not to mention other resources that could be
helpful for learning about Homotopy Type Theory:

* Of course, the “canonical” reference is [the HoTT Book], written by a
variety of mathematicians at the IAS Special Year for Univalent
Mathematics, held between 2012-2013 and organised by Steve Awodey,
Thierry Coquand, and the late Vladimir Voevodsky.

  The Book is often referred to on this site - with those words - so if
  you don't know which book "The Book" is, it's the HoTT book! It's
  split into two parts: Type Theory, which introduces the concepts of
  Homotopy Type Theory with no previous knowledge of type theory
  assumed; and Mathematics, which develops some mathematics (homotopy
  theory, category theory, set theory, and real analysis) in this theory.

[the HoTT Book]: https://homotopytypetheory.org/book

* Prof. Martín Escardó, at Birmingham, has done a great service to the
community by _also_ formalising a great deal of univalent mathematics in
Literate Agda, in his [Introduction to Univalent Foundations of
Mathematics with Agda].

  Prof. Escardó's notes, unlike the 1lab, are done in base Agda, with
  univalence assumed explicitly in the theorems that need it. This is a
  principled decision when the goal is introducing univalent
  mathematics, but it is not practical when the goal is to _practice_
  univalent mathematics in Agda.

  Even still, that document is _much better_ than this site will _ever_
  be as an introduction to the subject! While many of the pages of the
  1lab have introductory _flavour_, it is not meant as an introduction
  to the subject of univalent mathematics.

[Introduction to Univalent Foundations of Mathematics with Agda]: https://www.cs.bham.ac.uk/~mhe/HoTT-UF-in-Agda-Lecture-Notes/HoTT-UF-Agda.html

With those two references in mind, the 1lab aims to:

* Provide a comprehensibly documented example of mathematics done in
HoTT, formalised entirely in safe[^1] Cubical Agda, for other students
of homotopy type theory to consult. This doesn't bring anything new to
the table for HoTT: Many, if not most, of the theorems in the book were
already formalised in Coq.

[^1]: The 1lab is not compiled with `--safe` because some modules
explicitly assume inconsistent principles with the goal of providing
_counterexamples_. For instance, to formalise how [type-in-type leads to
Russell's paradox], we need to enable type-in-type!

[type-in-type leads to Russell's paradox]: 1Lab.Counterexamples.Russell.html

* Provide an introduction to HoTT as it's done in Cubical Type Theory to
those who are already familiar with "Book HoTT". There are significant
differences, including, but very much not limited to, univalence having
computational content!

* Do both of these in a _discoverable_ manner:

  * All Agda identifiers are
  cross-linked (this is an Agda feature and requires no effort on my
  part);

  * Concepts are linked to the first time they are used in a
  page[^2];

  * Diagrams are employed where appropriate, and there is
  infrastructure in place to make this easy to do;

  * Definitions are done in multiple ways, when appropriate, so it is
  possible to compare different approaches.

[^2]: If you encounter a case where this isn't true, please do not
hesitate to contribute!

Again, I want to stress that _the 1lab is free and open-source
software_. If you feel like _any_ of the goals above are not being
achieved, [submit a merge request]!

[submit a merge request]: https://github.com/plt-amy/cubical-1lab/pulls

## Technology

The 1Lab uses [Iosevka](https://typeof.net/Iosevka/) as its monospace
typeface. Iosevka is licensed under the SIL Open Font License, v1.1, a
copy of which can be found [here](/static/licenses/LICENSE.Iosevka).

Mathematics is rendered using [KaTeX](https://katex.org), and as so, the
1Lab redistributes KaTeX's fonts and stylesheets, even though the
rendering is done entirely at build-time. KaTeX is licensed under the
MIT License, a copy of which can be found
[here](/static/licenses/LICENSE.KaTeX).

Our favicon is Noto Emoji's ice cube (cubical type theory - get it?),
codepoint U+1F9CA. This is the only image from Noto we redistribute.
Noto fonts are licensed under the Apache 2.0 License, a copy of which
can be found [here](/static/licenses/LICENSE.Noto).

Commutative diagrams appearing in body text are created using
[quiver](https://q.uiver.app), and rendered to SVG using a combination of
[rubber-pipe](https://github.com/petrhosek/rubber) and
[pdftocairo](https://poppler.freedesktop.org/), part of the Poppler
project. No part of these projects is redistributed.

And, of course, the formalisation would not be possible without
[Agda](https://github.com/agda/agda).

# Type Theory

<div class=warning>
Specifically for the type theory namespace, there is a **[recommended
reading order]** for modules, which should be useful as a first
introduction to Cubical Type Theory.
</div>

[recommended reading order]: agda://1Lab.index

The first things to be explained are the foundational constructions in
(cubical) type theory - things like types themselves, [universes],
[paths], [equivalences], [glueing] and the [univalence] "axiom". These
are developed under the `1Lab` namespace. Start here:

[universes]: agda://1Lab.Type
[paths]: agda://1Lab.Path
[equivalences]: agda://1Lab.Equiv
[glueing]: agda://1Lab.Univalence#Glue
[univalence]: agda://1Lab.Univalence#univalence

```agda
-- All of these module names are links you can click!

open import 1Lab.Type -- Universes

open import 1Lab.Path          -- Path types
open import 1Lab.Path.Partial  -- Partial elements
open import 1Lab.Path.Groupoid -- Groupoid structure of types

open import 1Lab.Equiv           -- Contractible fibre equivalences, isomorphisms
open import 1Lab.Equiv.Biinv     -- Biinvertible maps
open import 1Lab.Equiv.Embedding -- Embeddings
open import 1Lab.Equiv.Fibrewise -- Fibrewise equivalences

open import 1Lab.HLevel          -- h-levels
open import 1Lab.HLevel.Sets     -- K, Rijke's theorem, Hedberg's theorem
open import 1Lab.HLevel.Retracts -- Closure of h-levels under retractions/isos

open import 1Lab.Univalence     -- Equivalence is equivalent to equality
open import 1Lab.Univalence.SIP -- Univalence + preservation of structure

open import 1Lab.Data.Dec            -- Decidable types, discrete types
open import 1Lab.Data.Bool           -- Booleans and their automorphisms
open import 1Lab.Data.List           -- Finite lists
open import 1Lab.Data.Relation.Order -- Prop-valued ordering relations

open import 1Lab.HIT.S1              -- The circle as a cell complex
open import 1Lab.HIT.Truncation      -- Propositional truncation

open import 1Lab.Counterexamples.IsIso -- Counterexample: isIso is not a prop
open import 1Lab.Counterexamples.Russell -- Counterexample: Russell's paradox
```
