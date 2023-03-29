-- MOJE ZADANIA: 41, 42, 48

mmap f = map (map f)
mmmap f = map$map$map$f

-- zadanie 41
parzyste xs = foldr ((+) . 1 - flip mod 2) 0 xs
-- za liczbę zwracamy resztę z dzielenia przez 2 i ją sumujemy od 0
------------------------------------------------------------------

-- zadanie 42 
-- rekursja
checkList [] = True
checkList [x] = True
checkList (x:y:xs) = x <= y && checkList (y:xs)

-- zip
checkPair (a, b) = a <= b

nondec xs = all checkPair (zip xs (tail xs))
------------------------------------------------------

-- zadanie 43
-- ta z fold left

------------------------------------------------------

-- zadanie 44
fpom x = [x]
mylast x = x!!((length x)-1)
gun = \x y -> if ((last  x) < last y) then x++y else x
ssn xs = foldl (gun) ([xs!!0]) (map fpom xs)

-- zad 55
remDup xs = let xss = zip xs (tail xs)
        in foldr (\(x,y) acc -> if x == y then acc
        else x : acc) [last xs] xss

-----------------------------------
fun43 [] = []
fun43 [x] = [x]
fun43 (x:xs)
    | x == (head xs) = []
    | otherwise = [x]

dup xs = foldl ((++) . (fun43) ) [] xs
-------------------------------------------------------


-- zadanie 48 suma szeregu naprzemiennego

altSum xs = foldl (+) (0) (zipWith (*) (cycle [1, -1]) xs)
