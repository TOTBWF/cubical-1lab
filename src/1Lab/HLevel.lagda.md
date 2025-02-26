```agda
open import 1Lab.Path
open import 1Lab.Type

module 1Lab.HLevel where
```

# h-Levels

The "homotopy level" (h-level for short) of a type is a measure of how
[truncated] it is, where the numbering is offset by 2. Specifically, a
(-2)-truncated type is a type of h-level 0. In another sense, h-level
measures how "homotopically interesting" a given type is:

* The contractible types are maximally uninteresting because there is
only one.

* The only interesting information about a proposition is whether it is
inhabited.

* The interesting information about a set is the collection of its inhabitants.

* The interesting information about a groupoid includes, in addition to
its inhabitants, the way those are related by paths. As an extreme
example, the delooping groupoid of a group -- for instance, [the circle] --
has uninteresting points (there's only one), but interesting _loops_.

[the circle]: agda://1Lab.HIT.S1

For convenience, we refer to the collection of types of h-level $n$ as
_homotopy $(n-2)$-types_. For instance: "The sets are the homotopy
0-types". The use of the $-2$ offset is so the naming here matches that
of the HoTT book.

The h-levels are defined by induction, where the base case are the
_contractible types_.

[truncated]: https://ncatlab.org/nlab/show/truncated+object

```agda
record isContr {ℓ} (A : Type ℓ) : Type ℓ where
  constructor contr
  field
    centre : A
    paths : (x : A) → centre ≡ x

open isContr
```

A contractible type is one for which the unique map `X → ⊤` is an
equivalence. Thus, it has "one element". This doesn't mean that we can't
have multiple, distinctly named, inhabitants of the type, it just means
any inhabitants of the type must be connected by a path, and this path
can be picked uniformly.

```agda
module _ where
  data [0,1] : Type where
    ii0 : [0,1]
    ii1 : [0,1]
    seg : ii0 ≡ ii1
```

An example of a contractible type that is not directly defined as
another name for `⊥` is the unit interval, defined as a higher inductive
type.

```agda
  interval-contractible : isContr [0,1]
  interval-contractible .centre = ii0
  interval-contractible .paths ii0 i = ii0
  interval-contractible .paths ii1 i = seg i
  interval-contractible .paths (seg i) j = seg (i ∧ j)
```

A type is (n+1)-truncated if its path types are all n-truncated.
However, if we directly take this as the definition, the types we end up
with are very inconvenient! That's why we introduce this immediate step:
An h-proposition, or proposition for short, is a type where any two
elements are connected by a path.

```agda
isProp : ∀ {ℓ} → Type ℓ → Type _
isProp A = (x y : A) → x ≡ y
```

With this, we can define the `isHLevel`{.Agda} predicate. For h-levels
greater than zero, this definition results in much simpler types!

```agda
isHLevel : ∀ {ℓ} → Type ℓ → Nat → Type _
isHLevel A 0 = isContr A
isHLevel A 1 = isProp A
isHLevel A (suc n) = (x y : A) → isHLevel (Path A x y) n
```

The types of h-level 2 are the _sets_.

```agda
isSet : ∀ {ℓ} → Type ℓ → Type _
isSet A = isHLevel A 2
```

The universe of all sets of a given level is called `Set`{.Agda}.

```agda
Set : (ℓ : _) → Type (lsuc ℓ)
Set _ = Σ isSet

Set₀ = Set lzero
```

The types of h-level 3 are the _groupoids_.

```agda
isGroupoid : ∀ {ℓ} → Type ℓ → Type _
isGroupoid A = isHLevel A 3
```

The universe of all groupoids of a given level is called `Grpd`{.Agda}.

```agda
Grpd : (ℓ : _) → Type (lsuc ℓ)
Grpd _ = Σ isGroupoid

Grpd₀ = Grpd lzero
```

---

```agda
private
  variable
    ℓ : Level
    A : Type ℓ
```

# Preservation of h-levels

If a type is of h-level $n$, then it's automatically of h-level $k+n$,
for any $k$. We first prove a couple of common cases that deserve their
own names:

```agda
isContr→isProp : isContr A → isProp A
isContr→isProp C x y i =
  hcomp (λ j → λ { (i = i0) → C .paths x j
                 ; (i = i1) → C .paths y j
                 } )
        (C .centre)
```

This enables another useful characterisation of being a proposition,
which is that the propositions are precisely the types which are
contractible when they are inhabited:

```agda
inhContr→isProp : ∀ {ℓ} {A : Type ℓ} → (A → isContr A) → isProp A
inhContr→isProp cont x y = isContr→isProp (cont x) x y
```

The proof that any contractible type is a proposition is not too
complicated. We can get a line connecting any two elements as the lid of
the square below:

~~~{.quiver}
\[\begin{tikzcd}
  x && y \\
  \\
  {C \mathrm{.centre}} && {C .\mathrm{centre}}
  \arrow[dashed, from=1-1, to=1-3]
  \arrow["{C \mathrm{.paths}\ x\ j}", from=3-1, to=1-1]
  \arrow["{C \mathrm{.paths}\ y\ j}"', from=3-3, to=1-3]
  \arrow["{C \mathrm{.centre}}"', from=3-1, to=3-3]
\end{tikzcd}\]
~~~

This is equivalently the composition of `sym (C .paths x) ∙ C.paths y` -
a path $x \to y$ which factors through the `centre`{.Agda}. The direct
cubical description is, however, slightly more efficient.

```agda
isProp→isSet : isProp A → isSet A
isProp→isSet h x y p q i j =
  hcomp (λ k → λ { (i = i0) → h x (p j) k
                 ; (i = i1) → h x (q j) k
                 ; (j = i0) → h x x k
                 ; (j = i1) → h x y k
                 })
        x
```

The proof that any proposition is a set is slightly more complicated.
Since the desired equality `p ≡ q` is a square, we need to describe a
_cube_ where the missing face is the square we need. I have
painstakingly illustrated it here:

~~~{.quiver .tall-2}
\[\begin{tikzcd}
  x &&&& x \\
  & x && y \\
  \\
  & x && y \\
  x &&&& x
  \arrow[""{name=0, anchor=center, inner sep=0}, "p"{description}, from=2-2, to=2-4]
  \arrow[""{name=1, anchor=center, inner sep=0}, "q"{description}, from=4-2, to=4-4]
  \arrow[from=1-1, to=2-2]
  \arrow[from=5-1, to=4-2]
  \arrow[from=5-5, to=4-4]
  \arrow[""{name=2, anchor=center, inner sep=0}, from=5-1, to=5-5]
  \arrow[""{name=3, anchor=center, inner sep=0}, from=5-1, to=1-1]
  \arrow[""{name=4, anchor=center, inner sep=0}, from=4-2, to=2-2]
  \arrow[""{name=5, anchor=center, inner sep=0}, from=4-4, to=2-4]
  \arrow[""{name=6, anchor=center, inner sep=0}, from=5-5, to=1-5]
  \arrow[""{name=7, anchor=center, inner sep=0}, from=1-1, to=1-5]
  \arrow[from=1-5, to=2-4]
  \arrow["{h(x,p(j),k)}", shorten <=4pt, shorten >=4pt, Rightarrow, from=7, to=0]
  \arrow["{h(x,q(j),k)}"', shorten <=4pt, shorten >=4pt, Rightarrow, from=2, to=1]
  \arrow["{h(x,x,k)}"', shorten <=6pt, shorten >=6pt, Rightarrow, from=3, to=4]
  \arrow["{h(x,y,k)}", shorten <=6pt, shorten >=6pt, Rightarrow, from=6, to=5]
\end{tikzcd}\]
~~~

To set your perspective: You are looking at a cube that has a
transparent front face. The front face has four `x` corners, and four `λ
i → x` edges. Each double arrow pointing from the front face to the back
face is one of the sides of the composition. They're labelled with the
terms in the `hcomp`{.Agda} for `isProp→isSet`{.Agda}: For example, the
square you get when fixing `i = i0` is on top of the diagram. Since we
have an open box, it has a lid --- which, in this case, is the back face
--- which expresses the equality we wanted: `p ≡ q`.

With these two base cases, we can prove the general case by recursion:

```agda
isHLevel-suc : ∀ {ℓ} {A : Type ℓ} (n : Nat) → isHLevel A n → isHLevel A (suc n)
isHLevel-suc 0 x = isContr→isProp x
isHLevel-suc 1 x = isProp→isSet x
isHLevel-suc (suc (suc n)) h x y = isHLevel-suc (suc n) (h x y)
```

By another inductive argument, we can prove that any offset works:

```agda
isHLevel-+ : ∀ {ℓ} {A : Type ℓ} (n k : Nat) → isHLevel A n → isHLevel A (k + n)
isHLevel-+ n zero x    = x
isHLevel-+ n (suc k) x = isHLevel-suc _ (isHLevel-+ n k x)
```

# isHLevel is a proposition

Perhaps surprisingly, "being of h-level n" is a proposition, for any n!
To get an intuitive feel for why this might be true before we go prove
it, I'd like to suggest an alternative interpretation of the proposition
`isHLevel A n`: The type `A` admits _unique_ fillers for any `n`-cube.

A contractible type is one that has a unique point: It has a unique
filler for the 0-cube, which is just a point. A proposition is a type
that admits unique fillers for 1-cubes, which are lines: given any
endpoint, there is a line that connects them. A set is a type that
admits unique fillers for 2-cubes, or squares, and so on.

Since these fillers are _unique_, if a type has them, it has them in at
most one way!

```agda
isProp-isContr : isProp (isContr A)
isProp-isContr {A = A} (contr c₁ h₁) (contr c₂ h₂) i =
  record { centre = h₁ c₂ i
         ; paths = λ x j → hcomp (λ k → λ { (i = i0) → h₁ (h₁ x j) k 
                                          ; (i = i1) → h₁ (h₂ x j) k
                                          ; (j = i0) → h₁ (h₁ c₂ i) k
                                          ; (j = i1) → h₁ x k })
                                 c₁
         }
```

First, we prove that being contractible is a proposition. Next, we prove
that being a proposition is a proposition. This follows from
`isProp→isSet`{.Agda}, since what we want to prove is that `h₁` and `h₂`
always give equal paths.

```agda
isProp-isProp : isProp (isProp A)
isProp-isProp {A = A} h₁ h₂ i x y = isProp→isSet h₁ x y (h₁ x y) (h₂ x y) i
```

Now we can prove the general case by the same inductive argument we used
to prove h-levels can be raised:

```agda
isProp-isHLevel : ∀ {ℓ} {A : Type ℓ} (n : Nat) → isProp (isHLevel A n)
isProp-isHLevel 0 = isProp-isContr
isProp-isHLevel 1 = isProp-isProp
isProp-isHLevel (suc (suc n)) x y i a b = isProp-isHLevel (suc n) (x a b) (y a b) i
```

# Dependent h-Levels

In cubical type theory, it's natural to consider a notion of _dependent_
h-level for a _family_ of types, where, rather than having (e.g.)
`Path`{.Agda}s for any two elements, we have `PathP`{.Agda}s. Since
dependent contractibility doesn't make a lot of sense, this definition
is offset by one to start at the propositions.

```agda
isHLevelDep : ∀ {ℓ ℓ'} {A : Type ℓ} → (A → Type ℓ') → Nat → Type _
isHLevelDep B zero = ∀ {x y} (α : B x) (β : B y) (p : x ≡ y)
                   → PathP (λ i → B (p i)) α β
isHLevelDep B (suc n) =
   ∀ {a0 a1} (b0 : B a0) (b1 : B a1)
   → isHLevelDep {A = a0 ≡ a1} (λ p → PathP (λ i → B (p i)) b0 b1) n
```

It's sufficient for a type family to be of an h-level everywhere for the
whole family to be the same h-level.

```agda
isProp→PathP : ∀ {B : I → Type ℓ} → ((i : I) → isProp (B i))
             → (b0 : B i0) (b1 : B i1)
             → PathP (λ i → B i) b0 b1
isProp→PathP {B = B} hB b0 b1 =
  transport (λ i → PathP≡Path B b0 b1 (~ i)) (hB _ _ _)
```

The base case is turning a proof that a type is a proposition uniformly
over the interval to a filler for any PathP.

```agda
isHLevel→isHLevelDep : ∀ {ℓ ℓ'} {A : Type ℓ} {B : A → Type ℓ'}
                     → (n : Nat) → ((x : A) → isHLevel (B x) (suc n))
                     → isHLevelDep B n
isHLevel→isHLevelDep zero hl α β p = isProp→PathP (λ i → hl (p i)) α β
isHLevel→isHLevelDep {A = A} {B = B} (suc n) hl {a0} {a1} b0 b1 =
  isHLevel→isHLevelDep n (λ p → helper a1 p b1)
  where
    helper : (a1 : A) (p : a0 ≡ a1) (b1 : B a1)
           → isHLevel (PathP (λ i → B (p i)) b0 b1) (suc n)
    helper a1 p b1 = J (λ a1 p → ∀ b1 → isHLevel (PathP (λ i → B (p i)) b0 b1) (suc n))
                      (λ _ → hl _ _ _) p b1
```

<!--
```
isProp→SquareP : ∀ {B : I → I → Type ℓ} → ((i j : I) → isProp (B i j))
             → {a : B i0 i0} {b : B i0 i1} {c : B i1 i0} {d : B i1 i1}
             → (r : PathP (λ j → B j i0) a c) (s : PathP (λ j → B j i1) b d)
             → (t : PathP (λ j → B i0 j) a b) (u : PathP (λ j → B i1 j) c d)
             → SquareP B t u r s
isProp→SquareP {B = B} isPropB {a = a} r s t u i j =
  hcomp (λ { k (i = i0) → isPropB i0 j (base i0 j) (t j) k
           ; k (i = i1) → isPropB i1 j (base i1 j) (u j) k
           ; k (j = i0) → isPropB i i0 (base i i0) (r i) k
           ; k (j = i1) → isPropB i i1 (base i i1) (s i) k
        }) (base i j) where
    base : (i j : I) → B i j
    base i j = transport (λ k → B (i ∧ k) (j ∧ k)) a
```
-->
