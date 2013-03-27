{-# OPTIONS --type-in-type #-}
module prelim where

open import Relation.Binary.PropositionalEquality

data Bool : Set where
  true  : Bool
  false : Bool

RecBool : (C : Set) → C → C → Bool → C
RecBool C b0 b1 false = b0
RecBool C b0 b1 true = b1


IndBool : (C : Bool → Set) →  C false →  C true → (x : Bool) → C x
IndBool C b0 b1 false = b0
IndBool C b0 b1 true = b1


data Σ (A : Set)(B : A → Set) : Set where
  _,_ : (a : A)(b : B a) → Σ A B

RecΣ[_,_] : (A : Set)(B : A → Set)(C : Set) → ((a : A) → B a → C) → Σ A B → C
RecΣ[ A , B ] C g ( a , b) = g a b

IndΣ[_,_] : (A : Set)(B : A → Set)(C : (Σ A B) → Set)
               → ((a : A)(b : B a) → C (a , b))
               → (x : Σ A B) → C x
IndΣ[ A , B ] C g ( a , b) = g a b

{- definition of A + B -}

_+_ : Set → Set → Set
A + B = Σ Bool (RecBool Set A B)

inl : ∀ {A B} → A → A + B
inl a = false , a

inr : ∀ {A B} → B → A + B
inr b = true , b

Rec+[_,_] : (A B C : Set) → (A → C) → (B → C) → (A + B) → C
Rec+[ A , B ] C g0 g1 = RecΣ[ Bool , RecBool Set A B ] C (IndBool (λ x → RecBool Set A B x → C) g0 g1) 

Ind+[_,_] : (A B : Set)(C : A + B → Set) 
          → ((a : A) → C (inl a)) → ((b : B) → C (inr b)) 
          → (x : A + B) → C x
Ind+[ A , B ] C g0 g1 = 
  IndΣ[ Bool , RecBool Set A B ] C 
    (IndBool (λ x → (y : RecBool Set A B x) → C (x , y)) g0 g1)

β-Indβ : (A B : Set)(C : A + B → Set) 
          → (g0 : (a : A) → C (inl a)) → (g1 : (b : B) → C (inr b)) 
          → (a : A) → Ind+[ A , B ] C g0 g1 (inl a) ≡ g0 a
β-Indβ A B C g0 g1 a = refl

_×_ : Set → Set → Set
A × B = (x : Bool) → RecBool Set A B x

pair : ∀ {A B} → A → B → A × B
pair {A} {B} a b = IndBool (RecBool Set A B) a b

Rec× : {A B C : Set} → (A → B → C) → A × B → C
Rec× g x = g (x false) (x true)

postulate ext : {A : Set}{B : A → Set}{f g : (a : A) → B a} → ((x : A) → f x ≡ g x) → f ≡ g

Ind× : {A B : Set}(C : A × B → Set)(g : (a : A)(b : B) → C (pair a b))(x : A × B) → C x
Ind× {A} {B} C g x = subst C aux (g (x false) (x true)) 
               where Ind×aux : (b : Bool) → IndBool (RecBool Set A B) (x false) (x true) b ≡ x b
                     Ind×aux = IndBool (λ b → IndBool (RecBool Set A B) (x false) (x true) b ≡ x b) refl refl
                     aux : IndBool (RecBool Set A B) (x false) (x true) ≡ x
                     aux = ext Ind×aux
