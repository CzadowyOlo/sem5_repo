-- zadanie 1
klincz = map f1 [1..]

f1 n = sum [1..n]

-- uruchomienie - "take x klincz"

------------------------------------
--bSlabo n k = 
-- bSlabo n k = bSlabo n-k k if k < n

-- reverse (x1:xs) = foldl (++) [xs] x1



tMors :: Int -> [Int]
--ThueMorse 0 = [0]
tMors 0 = [0]
tMors 1 = [0, 1]
tMors n = tMors (n-1) (++) map f2 tMors (n-1)

f2  = neg