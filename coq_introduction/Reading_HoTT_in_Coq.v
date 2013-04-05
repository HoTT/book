(**
An Introduction to Reading Coq Files
Started 2013 Feb 12.

----------------------

This document is a light-weight introduction to Coq using examples
from the first half of "The HoTT Book".  Our goal is to give readers a
taste of using a proof assistant.  When you're done, you will be able
to read what other people have proven in Coq and even prove some
simple theorems of your own.

If you are interested in going further with Coq, at the end of this
document are instructions on how to install Coq, links to full
tutorials, and links to the Coq Reference Manual.

This file is written in "plain" Coq 8.4.  This so it can be used with
the official distribution or on the web at http://prover.cs.ru.nl/.
However, this will prevent us from using some HoTT features, such as
higher inductive types, that are only available with a special version
of Coq.

While this file stands on its own, where possible, we use the same
theorem names as the HoTT library for Coq.
*)

(** * Background *)
(**
Coq is a good platform for HoTT work.  Coq has a long history -
created in 1984 - and is supported by INRIA.  Coq has a number of
features that have allowed it to be used for significant proofs, such
as the formalization of the Four Color Theorem and the Feit-Thompson
Theorem.

Coq uses a dependant type theory derived from "The Calculus of
Constructions".  It differs from Martin-Lof's intentional type theory,
but, as we'll see, its propositional equality has the same
higher-groupoid structure that allows us to do HoTT.
*)

(** * Introduction *)
(**
Coq mostly works with two concepts:
  * dependant functions (Pi-types) 
  * inductive types 

Inductive types are used to implement the common types of type theory:
dependent pairs (Sigma-types), disjoint unions, etc..  We'll use those
types as some of our first examples.

We'll start with the familiar example of Peano's natural numbers.
*)

(** ** Natural Numbers *)
(** *** Writing it in Coq *)
(**
The book's description of natural numbers says:
   N is a type,
   0 is a term of type N, and
   given an element n of type N, we can infer succ(n) has type N.

The equivalent in Coq is:
*)

Inductive nat : Set :=
  | O : nat
  | S : nat -> nat.

(**
As you can see, Coq's default library uses different names:
  "nat" instead of "N",
  "O" (the capital letter "oh") instead of "0", and
  "S" instead of "succ".

The command "Inductive" creates a new type.  In this case, the type is
called "nat".  The type "nat" will live in the universe type called
"Set", which in standard Coq is the first universe or "the universe of
small types".

After the ":=" symbol comes the constructors for the new type.  The
first says "O" (the capital letter "oh") is a term of type "nat".  The
second says "S" is a function from "nat"s to "nat"s.

After the last constructor is a period (".").  The command that
started with the word "Inductive" ends at the period.  Every command
in Coq ends with a period.
*)

(** *** Properties of Constructors *)
(**
The constructors of an inductive type have a number of properties:

* Constructors are axiomatic.  The function "S" exists without any
  definition - while it can be called, it cannot be evaluated.

* The constructors are exhaustive.  There is no other way to create a
  term of type "nat".

* Contructors create well-founded terms.  There is no way to create a
  self-referential "nat", such as having an "S" that returns itself.

* By default, terms created with different constructors are not equal.
  "O" is not equal to "S" called with any other "nat". 

If you know Peano's Axioms, these should all seem familiar.  But these
conditions apply to every inductive type, not just "nat".

NOTE: Homotopy type theory changes some of these properties.  The
univalence axiom and the path constructors of higher inductive types
create new elements of the identity type.  Higher inductive types can
have different constructors defined as propositionally equal.
*)

(** *** Examples of Natural Numbers *)
(**
Coq's command "Check" will print out the type of a term.  (Note, if
you're viewing this file in CoqIDE, the commands below will do
nothing.  Instead, highlight the term, open the "Queries" menu, and
select "Check".)

Obviously, "O" is a valid term and the "Check" will print the type
"nat".  (Remember "O" here is the capital letter "oh".)
*)
Check O.

(**
To get the number one, we have to call the function "S".  A function
call (or "function application") in Coq is done by juxtaposition, so
   gcd 4 6
instead of 
   gcd(4, 6)

Thus, the number one is written:
*)
Check S O.

(**
For the number two, we have to add parentheses so that the second S is
interpreted as a function call rather than as a second argument to the
first S.
*)
Check S (S O).

(**
The number five is 
*)
Check S (S (S (S (S O)))).


(** 
By default, Coq loads a plugin that interprets decimal numbers as "nat"s.
*)
Require Import Datatypes.
Declare ML Module "nat_syntax_plugin".

(**
Thus, we could have checked the number five simply by doing
*)
Check 5.

(** 
Now that we have a type with some elements, let's look at
dependent functions.
*)

(** ** Identity function *)
(** *** Writing it in Coq *)
(**

We'll start by defining the identity function on natural numbers and
then we'll write a dependantly-typed identity function that works for
any type.

The identity function (or identity map) for natural numbers is:
*)

Definition idmap_nat : nat -> nat :=
  fun (n:nat) => n.

(**
The "Definition" command assigns a value of a given type to a name.  
  Definition <name> : <type> := <value> .

Here, the name is "idmap_nat".  The type is a function from "nat" to
"nat".  Notice how the "->" operator approximates the arrow used in
the book for non-dependantly typed functions.  The value for "idmap_nat"
is a function.

In Coq, a function is written:
   fun <params> => <term>

In the book, this would have been 
  <param> |-> <term>

Here, the function has one parameter, "n", which has type "nat".  The
resulting term is simply "n" itself, since this is the identity function.
*)

(** *** Shorthand *)
(**
Coq has a shorthand for defining functions.  Here's the identity
function again.
*)

Definition idmap_nat_short (n:nat) : nat :=
  n.

(**
Notice that the parameter is put immediately after the name of the
function being defined and we no longer need "fun ... =>".
*)

(** **** Examples of idmap_nat *)
(**
The Coq command "Compute" will evaluate a function and print the result.

!!! There is no equivalent in CoqIDE?
*)
Compute idmap_nat (S O).
(** returns (S O), like an identity function should. *)


(** *** Dependant types *)
(**
"idmap_nat" is not dependantly typed, so we were able to use the
arrow ("->") shorthand above.  We could have written the function's
type as if it was dependantly typed. In the book, dependant types are
declared with a capital "Pi".  Coq uses the keyword "forall".
*)

Definition idmap_nat_dep : forall nn:nat, nat :=
  fun n:nat => n.

(** 
In Coq, a dependent function type is written:
   forall <params> , <type>

In the book, this would have used capital Pi and a subscript:
  \Pi_{<param>} <type>

The names created in the param list of a "forall" are only bound
inside the "<type>" part of the "forall" statement.  In this example,
the parameter "nn" cannot be used when defining the function.
(Usually, we use the same name in the "forall" and the "fun" parts;
different ones were used here to demonstrate the point.)

A "forall" can have multiple parameters.  If a parameter is
dependently typed on another parameter, the dependent one must come
later in the list.  (We'll see an example soon.)


Now that we know how to write a dependantly-typed function, we can
write an identity function that works for any type.
*)

Definition idmap : forall A:Type, A -> A := 
  fun (A:Type) (x:A) => x.

(** 
"idmap" is a dependantly-typed function: its return type depends on the
type of its first parameter.  Therefore, we had to use the "forall"
operator for that parameter.  

In Coq, the type "Type" refers to _some_ universe type.  Coq will do
the work of figuring out which universe type, as long as we don't
implicitly cause impredicativity.

We can, of course, rewrite the definition of "idmap" using the shorthand.
*)

Definition idmap_short (A:Type) (x:A) : A := 
  x.

(** **** Examples of idmap *)
Compute idmap nat (S (S O)).
(** returns (S (S O)), like an identity function should. *)


(** *** Partial application *)
(**
Since we've defined identity for any type, we can now define identity
for "nat"s in terms of it.
*)

Definition idmap_nat_from_idmap : nat -> nat :=
  idmap nat.

(**
The value "idmap nat" is a function call.  It calls the function
"idmap" with the type "nat".  Since "idmap" expected 2 arguments and
we only provided 1, this is called a "partial application".  The
result of the partial application is a function that is still waiting
for 1 more argument.  That function is the identity function on "nat"s
and this command assigns it a name.

We can check that this works by passing the second of the two arguments.
*)
Compute idmap_nat_from_idmap (S (S (S O))).


(** *** Implicit Arguments *)
(**

Calling "idmap nat (S O)" seems repetitive because Coq can determine
that "(S O)" has type "nat".  We can use Coq's implicit arguments
feature to tell Coq to always infer some argument values.

You mark a parameter for implicit arguments using curly braces.
*)
Definition idmap_implicit {A:Type} (x:A) : A := 
  x.
(**
Now, we can call the general identity function with just one argument.
*)
Compute  idmap_implicit (S O).

(**
Implicit arguments are usually handy, but sometimes they get in the
way.  Before, we declared a version of "idmap_nat" by calling "idmap".
We did it by passing "nat" as the first parameter of "idmap".

If we call "idmap_implicit" with "nat", Coq will assume that "nat" is
"x" and use the type of "nat", which is "Set", for the implicit
parameter.  Obviously, we don't want that.  We can prevent Coq from
using implicit arguments by putting an "at sign" ("@") in front of the
function name.
*)

Definition idmap_nat_from_idmap_implicit : nat -> nat :=
  @idmap_implicit nat.

Compute idmap_nat_from_idmap_implicit (S O).


(** **** Automatic Inferred Arguments *)
(** By running the command
*)
Set Implicit Arguments.
(**
Coq will turn every argument that can always be inferred into an
implicit argument.

It's good practice _not_ to use this command, since syntactic
reminders, like curly braces, are important.
*)


(** **** Explicit Listing of Inferred Arguments *)
(**
Coq has a command, "Arguments", that allows detailed control over
inferred arguments.  Because it has a lot of features and complex
syntax, we won't go into the detail in this document.  

In this document, we will use the command (although not explain it),
so that our examples look like those of the HoTT Coq library.
*)


(** *** Type Inferencing *)
(**
In many cases, Coq can infer the type of something without us have to
state it explicitly.  The type of a parameter or even a whole function
can be determined by Coq.
*)
Definition idmap_inferred {A} (n:A) :=
  n.
(**
Here, both the type of "A" (which is "Type") and the returned type of
the function (which is "A") are both inferred.  As you can see, this
allows very concise definitions.
*)
Compute idmap_inferred (S (S O)).


(** ** Addition of Natural Numbers *)
(**
In the last part of our introduction, we define addition as a function
on natural numbers and show how to use "+" to call it.
*)
(** *** Induction *)
(**
When we issued the command "Inductive" to create the type "nat", Coq
also created a function "nat_rect" for induction on natural numbers.
It's type is:

  nat_rect
     : forall P : nat -> Type,
       P 0 -> 
       (forall n : nat, P n -> P (S n)) -> 
       forall n : nat, P n

This is identical to the induction constant named "ind_N" in the HoTT
book.  We can use it to define addition.  
*)

Definition plus (m n: nat) :  nat :=
  nat_rect (fun _ => nat) n (fun m' sum => S sum) m.

(**
The function "plus" is defined by a call to "nat_rect" with 4
arguments.  

The first argument determines the type of the result.  Here, it is a
function that always returns the type "nat".  Using underscore ("_")
as a parameter name indicates to Coq that the parameter isn't used in
the function.

The second argument is "n".  This is the base case, when "m" is zero.

The third argument is the inductive case.  It takes "m"-prime and the
result (sum) upto "m"-prime and produces the result for the successor
of "m"-prime, which is just the sum plus one.

The fourth argument is "m", the value to calculate the sum at.
*)
Compute plus 4 2.

(*
Coq has an alternate notation for calling the induction constant. 
*)
(** *** Match Expressions *)

Fixpoint plus_alternate (m n: nat) :  nat :=
  match m with
      | 0 => n
      | S m' => S (plus_alternate m' n)
  end.

(** 
The "match" expression represents case analysis on an element of an
inductive type.  Since every canonial element of an inductive type
must have been made with a constructor, the "match" expression gives a
value that depends on which constructor was used.  The "match"
expression is very expressive, but a simplified understanding is:
  match <element> with
    | <constructor_pattern> => <value>
    | <constructor_pattern> => <value>
    ...
  end

NOTE: In HoTT, not every element of the identity type is made with a
constructor.  Nonetheless, the same case analysis still works.  We'll
address why later.

In this function, "m" is treated as a canonical "nat".  If "m" was
made with the constructor constant "O" (capital-oh), the value of the
"match" expression is "n".  If "m" was made with the constructor
function "S" called with some other nat, called "m"-prime here, then
the value of the match expression is the successor of "m"-prime plus
"n".

Notice that the function is defined in terms of itself.  In order to
allow that, we had to use command "Fixpoint" instead of the usual
"Definition".  

Coq will transform the match expression into a call to "nat_rect".  If
it cannot, Coq will inform you.
*)
(** *** Notations *)
(**
We could always represent addition with "plus 4 2", but it's more
natural to read and write "4 + 2".  You can enable this through the
"Notation" command.
*)
Notation "n + m" := (plus n m) : nat_scope.
Open Scope nat_scope.
(**
Now we can write.
*)
Compute 4 + 2.
(**
We've actually already been using a notation.  The "->" operator is
defined as: 
*)
Reserved Notation "x -> y" (at level 99, right associativity, y at level 200).
Notation "A -> B" := (forall (_ : A), B) : type_scope.
(**
Because "Notation"s could conflict, every "Notation" goes into a
scope.  Here, the scopes are called "nat_scope" and "type_scope".
When a scope is opened, all of its notations become available to be
used.  If two notations in open scopes conflict, the one opened more
recently is used.  Here, "nat_scope" was opened by the command "Open
Scope nat_scope" and "type_scope" is always open anywhere a type is
expected.

If we ever wanted to stop using the plus "Notation", we could issue the
command:
Close Scope nat_scope.


A more complex example is:
*)
Definition compose {A B C : Type} (g : B -> C) (f : A -> B) :=
  fun x => g (f x).

Notation "g 'o' f" := (compose g f) (at level 40, left associativity).
(**
The single quotes are used to turn the letter "o" (small-oh) into an
operator. 

"at level 40" indicates the precedence of the operator.  A lower
precedence level means that an operator "binds more tightly".  That
is, that a "Notation" is selected over another.  Thus for natural
numbers, multiplication is at level 40, while addition is at 50.  
(Those operators have default precedences.)

"left associativity" is what you would expect.
*)

(**
That covers most of the basics of reading Coq theorems.  The rest of
this document goes over the types, functions, and operators used in
HoTT with some further details. 
*)

(** * Type Theory Fundamentals *)
(**
After a short discussion about universe types in Coq, we go through
how each of the common types of type theory are implemented as
inductive types.
*)

(** ** Universes *)
(**
The HoTT Book describes an infinite hierarchy of universes U_0, U_1,
U_2, ... that are cumulative.  That is, that every type in a universe
is also in every higher universe.

Coq's universes have a similar structure, except that the lowest
universe is split into two: "Prop" and "Set".  

The "Prop" universe contains propositions - statements that can be
proven or disproven.  In practice, that means types that are shown to
be either inhabited or uninhabited.  Types in "Prop" must be "proof
irrelavent": it cannot matter which term inhabits the type.

The "Set" universe contains all other "small types".  (Small types are
ones that do not contain references to a universe.)  Since in Homotopy
Type Theory every equality proof is relavent, all of our inductive
types will lie in the "Set" universe.

The infinite number of universes above "Prop" and "Set" are known as
"Type(1)", "Type(2)", "Type(3)", etc.  However, the user only ever has
to enter "Type".  Coq will, behind the scenes, assigned a numbered
universe to every usage of "Type", as long as there is no
impedicativity.
*)

(** ** Dependent Function Types *)
(**
Covered in detail earlier.

The dependent type:
Book: \Pi_{<params>}    <type>
Coq:  forall <params> , <type>

The non-dependent type:
Book: <type> -> <type>
Coq:  <type> -> <type>

An unnamed function:
Book:    <params> |-> <term>
Coq: fun <params>  => <term>

A function call (or "function application"):
Book:   <fun>(<arg1>, <arg2>)
Coq:    <fun> <arg1> <arg2>

Function composition:
Book:  <fun> o <fun>
Coq:   <fun> o <fun>

*)
(** ** Non-Dependent Pair Types *)
(**
In The HoTT book, the non-dependent pair type is a special case of a
dependent pair.  For example, the projection functions work the same
on both the non-dependent and dependent types.  In Coq, it is more
convenient to have two separate types.

In the book, the non-dependent pair type, or cartesian product, requires
  * a type A : U, and
  * a type B : U
and is written
  A \times B  
(with "\times" representing the cross-product operator).

In Coq, the inductive type is written:
*)

(** Polymorphic *)
Inductive prod (A B:Type) : Type :=
  pair : A -> B -> prod A B.

(**
Here, "pair" is the constructor that takes two arguments, an element
of type "A" and an element of type "B", and produces an element of
type "prod A B".  So, "prod A B" is the type of non-dependent pairs
and "pair a b" creates a pair.

The keyword "Polymorphic" before "Inductive" indicates "universe
polymorphism".  That is, the universe of the result may depend on the
universes of the inputs.  Thus, if "A" and "B" both belong in the
universe "Set", then "prod A B" will be in "Set".

This inductive type definition uses a shortcut.  The types "A" and "B"
are used in the constructor "pair", but are not listed as parameters.
This is because any parameters listed immediately after the type name
("prod") are treated as parameters to both the type of "prod" and to
all constructors.

The HoTT Book uses a similar shortcut in its notation.
??? MDN: is this changing?

An equivalent (but longer) definition of "prod" would be
*)
(** Polymorphic *)
Inductive prod_long : Type -> Type -> Type :=
  pair_long : forall (A B: Type), A -> B -> prod_long A B.

(** 
When Coq creates "prod", it also creates the induction constant
"prod_rect".  "prod_rect" puts the type it creates in the "Type"
universe.  Coq also creates two other induction constants: "prod_rec"
which puts the resulting type in "Set" and "prod_ind" which puts it in
"Prop".  Usually, we'll use a "match" expression and let Coq chose the
correct induction constant.

Coq has a second non-dependent pair type called "and", which takes
arguments from the "Prop" universe and puts the resulting type in
"Prop".  But, since we're not using "Prop", we won't cover it in
detail here.
*)


(** *** Pair Notation *)
(**
From definition of "pair_long", it is clear that the constructor takes
4 parameters: two types and an element of each type.  But given the
two elements, Coq can always infer their types.  Since we executed the
command "Set Implicit Arguments", Coq treat those arguments as
implicit and we can create a pair using just the two elements.  For
example:
*)
Check (pair 4 2).
(** 
In the book, we use "A \times B" to denote the type and "(a,b)" to
denote a pair.  Coq allows us to use a similar syntax by the
"Notation" command.
*)
Notation "x * y" := (prod x y) : type_scope.
Notation "( x , y , .. , z )" := (pair .. (pair x y) .. z) : core_scope.
(**
Now when Coq sees "nat * nat", it will translate it into "(prod nat
nat)" and, likewise, translate "(4, 2)" into "(pair 4 2)".  The second
"Notation" command will also convert tuples of any length into
pairs-of-pairs.

Now, we can write the type and elements of dependent pairs like we're
accustomed.
*)
Check (4,2).

(** *** Projection functions *)
(**
The projection functions extract the first or second part of a pair.
For non-dependent pairs in Coq, these are called "fst" and "snd".
*)

Section projections.
  Context {A : Type} {B : Type}.

  (** Polymorphic *)
  Definition fst (p:A * B) := 
    match p with
      | (x, y) => x
    end.

  (** Polymorphic *)
  Definition snd (p:A * B) := 
    match p with
      | (x, y) => y
    end.

End projections.

(**
The section feature is used here to simplify the list of parameters.
The section starts with "Section projections" and ends at "End
projections".  The statement "Context ..." signals that "A" and "B"
are parameters to every subsequent definition that uses them inside
the section.  Thus, both "fst" and "snd" have two type parameters and,
because curly braces ("{", "}") were used, those parameters are
implicit.

In the "match" expressions, constructor function "pair" is written
using the notation "(x, y)".
*)
(** **** Defining Equation *)
(**
We have to wait until we've defined equality to prove
  forall (A B : Type) (p : A*B), p = (fst p, snd p).
*)


(** ** Dependent Pair Types *)
(**
In The HoTT Book, the dependent pair type, also called Sigma type,
requires
  * a type A : U, and
  * a type family P : A -> U
and is written
  Sigma_{x:A} P(x)

In Coq, it is defined by:
*)

(** Polymorphic *)
Inductive sigT (A:Type) (P:A -> Type) : Type :=
    existT : forall x:A, P x -> sigT P.

(**
Here, "existT" is the constructor that takes two arguments, an element
"x" of type "A" and an element (unnamed) of type "P x", and produces
an element of "sigT A P".  So, "sigT A P" is the type of pairs and
"existT x p" creates a pair (when "p" has type "P x").

If you read closely, you'll see that the type produced by "existT" is
"sigT P" not "sigT A P".  The "A" can always be inferred from "P".
The earlier command "Set Implicit Arguments" automatically turns
parameters like "A" into implicit args.

Coq has two other dependent pair types, "ex" and "sig", which puts the
result in the "Prop" universe.  But, since we're not using "Prop", we
won't cover them in detail here.
*)

(** *** Pair Notation *)
(**
To create a dependent pair, we must supply a function taking an
element of the first type to a type for the second element.  Thus, we
can create a pair of "nat"s by supplying a function that always
returns "nat".
*)
Check (existT (fun x:nat => nat) 4 2).
(** 

Obviously, that expression is long to write and difficult to read and
we want to use a "Notation" for it.  Since we've already used "(a,b)"
for non-dependent pairs, we use the semicolon here.
*)
Notation "{ x : A  & P }" := (sigT (fun x:A => P)) : type_scope.
Notation "( x ; y )" := (existT _ x y) : fibration_scope.
Open Scope fibration_scope.
(**
When Coq sees "(4;2)", it will translate that into "(existT _ 4 2)".
The "_" in a function application indicates that Coq should try to
infer the argument or ask for help from the user.  

Here the dependent-pair "Notation" goes into the "fibration_scope".
Since that is a new scope, we must "Open" it to make the "Notation"
available.
*)

(**
Here is an example using the dependent pair "(4;2)".  It is necessary
to say what its type is, so that Coq can infer the hidden argument to
"existT".
*)
Definition dep_pair_example_type := 
  { x:nat & nat }.
Definition dep_pair_example : dep_pair_example_type := 
  (4;2).
Check dep_pair_example.

(** *** Projection functions *)
(**
The projection functions extract the first or second part of a pair.
For dependent pairs in Coq, these are "projT1" and "projT2".
*)

Section Projections.

  Variable A : Type.
  Variable P : A -> Type.

  (** Polymorphic *)
  Definition projT1 (x:sigT P) : A := 
    match x with
      | existT a _ => a
    end.

  (** Polymorphic *)
  Definition projT2 (x:sigT P) : P (projT1 x) :=
    match x return P (projT1 x) with
      | existT _ h => h
    end.

End Projections.

(** 
These are pretty much as you'd expect.  There are two items worth
commenting on.

The underscore ("_") in the constructor pattern is used to indicate an
unused parameter.  We've seen this before in parameters to "fun" and
"forall".

The other feature worth commenting on is the "return <type>" in the
"match" expression of "projT2".  This is used when the "match"
expression has a type that depends on the element of the inductive
type being matched on.  

We will not go into all the details on the variations of the "match"
expression, because this document is about reading what has been
proven - that is, the _type_ of an expression - and not about
understanding the proof, which is the value of the expression.


The "Notation"s for the projectors are:
*)
Notation "x .1" := (projT1 x) (at level 3) : fibration_scope.
Notation "x .2" := (projT2 x) (at level 3) : fibration_scope.
(**
And some examples of it are:
*)
Check (dep_pair_example .1).
Check (dep_pair_example .2).

(** ** Disjoint Union Type*)
(**
In The HoTT Book, the disjoint union type, also called coproduct,
requires
  * a type A : U, and
  * a type B : U
and is written
  A + B.

In Coq, it is defined by:
*)

(** Polymorphic *)
Inductive sum (A B:Type) : Type :=
  | inl : A -> sum A B
  | inr : B -> sum A B.

Arguments inl {A B} _ , [A] B _.
Arguments inr {A B} _ , A [B] _.

Notation "x + y" := (sum x y) : type_scope.

(** 
Ignoring the "Arguments" command, which we aren't covering, the rest
should be familiar by now.  

Since the type "sum" has two constructors, "inl" and "inr", we can
have two examples that build an element of a type.
*)

Definition dijoint_union_example_type : Type := 
  (sum nat (prod nat nat)).
(*!!! Why does Coq 8.4 have trouble with this?  
  (nat + (nat * nat)). *)
Definition dijoint_union_example1 : dijoint_union_example_type := 
  inl 4.
Definition dijoint_union_example2 : dijoint_union_example_type := 
  inr (4,2).

(**
Likewise, any "match" expression needs to handle both constructors.
*)

Definition left_or_first (a : dijoint_union_example_type) : nat :=
  match a with
      | inl x => x
      | inr p => fst p
  end.

(** ** Zero, One, and Two Types *)
(**
The finite types with 0, 1, and 2 elements play special roles in type
theory.  In the HoTT Coq library those types are:
*)
Inductive Empty : Set :=.

Inductive Unit : Set :=
    tt : Unit.

Inductive Bool : Type :=
  | true : Bool
  | false : Bool.

(**
In the standard version of Coq, the types have slightly different
names.  (Although their constructors have the same names.)
*)
Definition Empty_set := Empty.
Definition unit      := Unit.
Definition bool      := Bool.

(** *** Not operator *)
(**
In HoTT, the not operator indicates that elements of a type can be
mapped to the elements of the empty (zero) type.
*)
Definition not (A:Type) : Type := A -> Empty.
Notation "~ x" := (not x) : type_scope.

(** *** Absurdity Implies Anything *)
(**
Obviously, a match expression for the "Unit" type handles one
constructor and the match expression for the "Bool" type handles two
constructors.  But what about the "Empty" type?  It has no
constructors, so it doesn't require any.  In logic, this is the
equivalent of "absurdity implies anything". 
*)

Definition absurdity_implies_anything (a:Empty) (C:Type) : C :=
  match a with
      end.
(**
The induction constant for Empty is
  Empty_rect : forall (P : Empty -> Type) (e : Empty), P e
*)


(** ** Identity Type *)
(**
The identity type is defined as:
*) 
Inductive paths {A : Type} (a : A) : A -> Type :=
  idpath : paths a a.

(**
Where "paths" equates to "Id" in The HoTT Book and "idpath" to "refl".

The standard Coq library does equality using a type "eq" with
constructor "refl".  These are different from "paths" and "idpath"
because they live in the "Prop" universe and are not proof-relevant.
*)

(*
The equal sign is reserved for the identity type.  There is also a
"Notation" that allows the user to explicitly state the type, if it
cannot be inferred by Coq.
*)
Notation "x = y :> A" := (@paths A x y) : type_scope.
Notation "x = y" := (x = y :>_) : type_scope.

Arguments idpath {A a} , [A] a.
Arguments paths_ind [A] a P f y p.
Arguments paths_rec [A] a P f y p.
Arguments paths_rect [A] a P f y p.

Notation "1" := idpath : path_scope.
Local Open Scope path_scope.

(**
EXPLANATION OF INDUCTION WITH paths/eq
*)

(** * Homotopy Type Theory *)
(** ** Properties of Paths *)
(**
For every element of a type, there is a reflexive path.  This is
witnessed by "idpath", which has type:

  @idpath
     : forall (A : Type) (a : A), a = a

Next, we prove that every path has an inverse.  In Coq, this proof
looks like a function that takes any path and returns its inverse.
*)

Definition inverse {A : Type} {x y : A} (p : x = y) : y = x
  := match p with 
       | idpath => idpath
     end.

Arguments inverse {A x y} p : simpl nomatch.

Notation "p ^" := (inverse p) (at level 3) : path_scope.

(** 
The "match" expression hides a number of inferences by Coq.  The type
of "p" is "paths A x y", which had to be constructed using "idpath A
x" with "y" being the same as "x".  The value returned by the match
has type "paths A y x", so Coq can infer that the arguments to
"idpath" are "A" and "x" and intrepret the resulting "A x x" as "A y
x".

Notice that the "proof" is similar to The HoTT Book's proof where "y"
is assumed to be the same as "x" and "refl_x" is mapped to "refl_x".


Next, we prove that paths concatenate.  Like before, this is a
function that forall paths "x=y" and "y=z" returns a path with type
"x=z".
*)

Definition concat {A : Type} {x y z : A} (p : x = y) (q : y = z) : x = z :=
  match p, q with 
     | idpath, idpath => idpath 
  end.

Arguments concat {A x y z} p q : simpl nomatch.

Notation "p @ q" := (concat p q) (at level 20) : path_scope.


(**
The comma in the "match" expression is part of the "match" syntax.  It
is not a non-dependent pair.  It is a shortcut that allows two
"match"es to be done at once.  When the "match" gets translated into
two calls to "paths_rect", we don't care which order they are called
in; the results are the same.  But, as The HoTT Book explains, this
proof could be done with just one call to "path_rec", but the results
would not behave symmetrically.

The following proofs show the relationship of "idpath", "inverse" and
"concat". 
*)



Definition concat_p1 {A : Type} {x y : A} (p : x = y) : p @ 1 = p :=
  match p with idpath => 1 end.
Definition concat_1p {A : Type} {x y : A} (p : x = y) : 1 @ p = p :=
  match p with idpath => 1 end.

Definition concat_pV {A : Type} {x y : A} (p : x = y) : p @ p^ = 1 :=
  match p with idpath => 1 end.
Definition concat_Vp {A : Type} {x y : A} (p : x = y) : p^ @ p = 1 :=
  match p with idpath => 1 end.

Definition inv_V {A : Type} {x y : A} (p : x = y) : p^^ = p :=
  match p with idpath => 1 end.

Definition concat_p_pp {A : Type} {x y z t : A} (p : x = y) (q : y = z) (r : z = t) :
  p @ (q @ r) = (p @ q) @ r :=
  match r with idpath =>
    match q with idpath =>
      match p with idpath => 1
      end end end.
Definition concat_pp_p {A : Type} {x y z t : A} (p : x = y) (q : y = z) (r : z = t) :
  (p @ q) @ r = p @ (q @ r) :=
  match r with idpath =>
    match q with idpath =>
      match p with idpath => 1
      end end end.

(**
All of these should be understandable.  Some may have alternate
proofs.  Some have noticed that many of these proofs are shorter than
even the "second proofs" of The HoTT Book.

The HoTT Coq library has a naming scheme where:
* [1] means the identity path
* [p] means 'the path'
* [V] means 'the inverse path'
* [A] means '[ap]'
* [M] means the thing we are moving across equality
* [x] means 'the point' which is not a path, e.g. in [transport p x]
* [2] means relating to 2-dimensional paths
* [3] means relating to 3-dimensional paths, and so on

We'll see more of this as we proceed.


Next, we define the function "transport" with its "Notation".
*)

Definition transport {A : Type} (P : A -> Type) {x y : A} (p : x = y) (u : P x) : P y :=
  match p with idpath => u end.

Notation "p # x" := (transport _ p x) (right associativity, at level 65, only parsing) : path_scope.

(*
Next comes the non-dependent and dependent versions of "ap".
("application of a function to a path" or "action across paths").
*)

Definition ap {A B:Type} (f:A -> B) {x y:A} (p:x = y) : f x = f y
  := match p with idpath => idpath end.

Arguments ap {A B} f {x y} p : simpl nomatch.

Definition apD {A:Type} {B:A->Type} (f:forall a:A, B a) {x y:A} (p:x=y):
  p # (f x) = f y
  :=
  match p with idpath => idpath end.

Arguments apD {A B} f {x y} p : simpl nomatch.

(**
We skip over homotopy and go straight to equivalences.  For that, we
need a definition of a "section" or the inverse to a function.
*)
Definition Sect {A B : Type} (s : A -> B) (r : B -> A) :=
  forall x : A, r (s x) = x.

(**
The actual definition of equivalence requires some new commands.
*)
Class IsEquiv {A B : Type} (f : A -> B) := BuildIsEquiv {
  equiv_inv : B -> A ;
  eisretr : Sect equiv_inv f;
  eissect : Sect f equiv_inv;
  eisadj : forall x : A, eisretr (f x) = ap f (eissect x)
}.

Arguments eisretr {A B} f {_} _.
Arguments eissect {A B} f {_} _.
Arguments eisadj {A B} f {_} _.

(** A record that includes all the data of an adjoint equivalence. *)
Record Equiv A B := BuildEquiv {
  equiv_fun :> A -> B ;
  equiv_isequiv :> IsEquiv equiv_fun
}.
(** 
I'm going to address these commands from easiest to hardest, not first
to last.

The easiest is the "Argument" commands.  Ignore them.  They just
define implicit arguments and we aren't covering the "Argument"
command in this tutorial.

Next, the "Record" command creates an inductive type with a single
constructor.  So, the type "Equiv" is very close to the dependent pair
type "sigT".  The constructor for the type is "BuildEquiv".  The
"Record" command also creates projection functions for extracting the
two elements stored in an "Equiv".  These are called "equiv_fun" and
"equiv_isequiv".

Lastly, we come to the "Class" command.  "Class" operates similar to a
"Record", but it has special implicit argument rules.  Thus, when Coq
searches for an argument of type "Equiv f", it will look at all
elements of that type declared with the "Instance" command.  As a
result, the second argument to "BuildEquiv" can often be left
implicit.

The HoTT Coq library declares one default instance, which is the
second part of the "Equiv" record.  
*)
Existing Instance equiv_isequiv.

(**
And of course, there is a "Notation" for equivalence.
*)
Notation "A <~> B" := (Equiv A B) (at level 85) : equiv_scope.
Local Open Scope equiv_scope.




(* TODO:
? Are transliterations book-then-Coq or Coq-then-book?
? What names do we want to use - Standard Coq or HoTT Coq?

"Hints" command.
"Class" and "Instance" commands
"Theorem" + "Proof" + "Defined." vs. "Qed"
mention "Ltac"
"Require Import/Export"
"Import"
"Let"?  (local def in section)

*)


(*
1.2.5 Identity

?? Martin-Lof Rule vs. Paulin-Mohring Rule
*)

