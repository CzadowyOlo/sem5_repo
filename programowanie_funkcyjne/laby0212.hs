-- fun Leaf a = f a
-- fun Inner a b = Inner ((fun a) (fun b))


-- maxSum (x : xs) = [[x] ++ ys | ys <- drop ] 
func :: Float -> Float -> Float
func a b = a Prelude.+ b


class VectorSpace a where
    vnull ::a
    vadd :: a -> a -> a
    vmul :: Float -> a -> a
    ilocz :: a -> a -> Float
data RF2 = RF2 Float Float deriving (Eq, Show)

instance VectorSpace RF2 where
    vnull = RF2 0.0 0.0
    vadd (RF2 a b) (RF2 c d) = RF2 (a Prelude.+ c) (b Prelude.+ d)
    vmul c (RF2 a b) = RF2 (c Prelude.* a) (c Prelude.* b)
    ilocz (RF2 a c) (RF2 b d) = a Prelude.* b Prelude.+ c Prelude.* d

isBasis  [RF2 a b, RF2 c d] = a Prelude.* d - b Prelude.* c /= 0
isBasis _  = False

type MyReal = Float
type CompPart = Float
data Complex = C MyReal CompPart

instance Num Complex where
(+) (C a b) (C c d) = C (a Prelude.+ c) (b Prelude.+ d)
(*) (C a b) (C c d) = C (a Prelude.* d - b Prelude.* c) (a Prelude.* c Prelude.+ b Prelude.* d)
(negate) (C a b) = C (- a) (- b)
(abs) (C a b) = sqrt (a^2 Prelude.+ b^2) 
(signum) (C a b) = C (a / Main.abs(C a b)) (b / Main.abs(C a b))

data Prop a = V String | T | F | And (Prop a) (Prop a) | OR (Prop a) (Prop a) | Not (Prop a)
dup (V a) = [a]
dup (Not a) = dup a
dup (And a b) = dup a ++ dup b
dup (OR a b) = dup a ++ dup b
dup _ = []
vars [] = []
vars a = (((map head) (group sort)) . dup) a


Monada - trójka (funktor - M, eta - return, mi - contcat)

eta pozwala przechodzić na złożenia: M eta-----> M^2
mi pozwala wracać na niższy poziom:  M^2 mi----> M

z70

eta x = Leaf x
mikro (Leaf t) = t
mikro (Inner t1 t2) = Inner (mikro t1) (mikro t2) -- jak w liściu mamy drzewo to rozwalamy obudowe liścia i podłączamy do węzła po korzeniu
    

