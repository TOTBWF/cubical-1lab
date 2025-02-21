```
open import 1Lab.Type
open import 1Lab.Path
open import 1Lab.Equiv

module 1Lab.Counterexamples.Sigma where
```

# $\Sigma$ can not be $\exists$

Defined normally, the _image_ of a function $f : X \to Y$ is the subset
of $Y$ given by the elements $y : Y$ for which _there exists_ an element
$x : X$ with $f(x) = y$. In set theoretical notation: $\mathrm{im}(f) =
\{ y \in Y | \exists x \in X, f(x) = y \}$.

It is a commonly held misunderstanding that when translating such a
definition into type theory, both subsets and existential quantifiers
should be read as special cases of the dependent sum, `Σ`{.Agda} -
perhaps using "subset" to mean "`Σ` for which the type family is
[propositional]". Indeed, the first projection out of these is [a
(generalised) subset inclusion], so this translation is accurate **for
subsets**.

[propositional]: agda://1Lab.HLevel#isProp
[a (generalised) subset inclusion]: agda://1Lab.Equiv.Embedding#Subset-proj-embedding

However, let's see what happens when we naïvely translate the definition
of image above:

```
private variable
  ℓ : Level
  A B : Type ℓ

image : (A → B) → Type _
image {A = A} {B = B} f = Σ[ y ∈ B ] Σ[ x ∈ A ] (f x ≡ y)
```

The definition above, which could be called "Curry-Howard image", does
not accurately represent the image of a function: $\mathrm{image}(f)
\simeq A$, independent of $f$:

```
image≃domain : {f : A → B} → image f ≃ A
image≃domain {f = f} = Iso→Equiv the-iso where
  the-iso : Iso _ _
  the-iso .fst (y , x , p) = x
  the-iso .snd .isIso.g x = f x , x , refl
  the-iso .snd .isIso.right-inverse x = refl
  the-iso .snd .isIso.left-inverse (y , x , p) i = p i , x , λ j → p (i ∧ j)
```

This is a direct cubical interpretation of the following argument, which
goes through in any theory with J[^2]:

> First, observe that we can reorder `Σ[ y ∈ B ] Σ[ x ∈ A ] (f x ≡ y)`
into `Σ[ x ∈ A ] Σ[ y ∈ B ] (f x ≡ y)`. By path induction, the type `Σ[
y ∈ B ] (f x ≡ y)` is contractible (it is a singleton), leaving us with
something isomorphic to `Σ[ x ∈ A ] *`, which is evidently isomorphic to
`A`.

Hence we have, for example, that the "image" of the canonical function
`Bool → ⊤` is isomorphic to `Bool`{.Agda}:

```
ignore-bool : Bool → ⊤
ignore-bool _ = tt

woops : image ignore-bool ≃ Bool
woops = image≃domain
```

[^2]: In fact, note that if we reorder `p i, x, λ j → p (i ∧ j)` we get
`x, p i, λ j → p (i ∧ j)`, which is exactly how it is shown that
[singletons are contractible].

[singletons are contractible]: agda://1Lab.Path#isContr-Singleton