--myinits xs = take n xs | n <- [1.. length xs]
 
--mytails [] = []
-- mytails (x:xs) = cons (x:xs) (mytails (xs))


myfunct n acc 
    | mod n 10 == 0 = myfunct (div n 10) acc+1
    | otherwise = acc

howmany n = myfunct (fac n) 0

fac n 
    | n < 0 = error "dupa"
    | otherwise = foldr (*) 1 [1..n]

mmap f = map$ map f    
mmmap f = map$ map$ map f