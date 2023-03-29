-- Zad 61
import Data.List
pomf (x1:xs)
    | xs == [] = True
    | abs (x1-x2) == 1 = False
    | otherwise = pomf xs
    where  x2 = head xs

hetmans n = filter pomf (permutations [1..n])

-- Zad 63
onetwofive n
    | (n-5) >= 0 = 5:onetwofive (n-5)
    | (n-2) >= 0 = 2:onetwofive (n-2)
    | (n-1) >= 0 = 1:onetwofive (n-1)
    | otherwise = []

-- Zad 44
ssm xs = snd(foldl (\(acc, ys) x -> if x > acc then (x, ys ++ [x]) else (acc, ys)) (head xs, [head xs]) xs)  


