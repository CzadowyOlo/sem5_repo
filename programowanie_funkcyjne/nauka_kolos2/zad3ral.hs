{-# LANGUAGE DataKinds #-}
import Data.List

--duplist xs = foldl (\ ac x -> (if(x == (head (head acc))) then (head acc) ++ [x] else ) ([[ ]]) xs )

--duplist2 xs = foldl (\ ac x -> (foldl if head a == x then head a ++ [x] ) ([[ ]]) xs )

-- helper [[]] a = [[a]]
-- --helper [x] a = if head x == a then x ++ [a] else [x] ++ [[a]]
-- helper (x:xs) a
--     | head x == a = x ++ [a]
--     | otherwise = helper xs

f a = [a]
g [x, y] = [[x, y]]
--h :: [a] -> [b] -> [c] 
h x y = (++) x y

dupsko [[a], [b]] = [[a, b]]
dupsko y = (head y ++ head(tail y)) : tail (tail y)
-- pom [[x]] = [[x]]
-- pom [[x, y]] = [[x, y]]
-- pom [[x, y,z]] = [[x, y, z]]


pom y
    | length y == 1 = y
    | otherwise = if (head (head y)) == head (head (tail y)) then pom (dupsko y) else pom (tail y)
dupa (xs) = pom (map f (sort (xs)))



-- cyce xs = (map f (sort (xs)))
-- wadowice xs = foldl pom (map f (sort (xs))) []