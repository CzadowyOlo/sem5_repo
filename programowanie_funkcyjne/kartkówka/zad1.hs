gcdList :: [Integer] -> Integer -> Integer
gcdList [] acc = acc
-- gcdList acc = acc
-- gcdList (x1:xs) acc = gcdList xs (gcd x1 acc)`
gcdList xs acc = foldl (flip gcd) acc xs
                        
gcdListDo (x1:xs) = gcdList (x1:xs) x1

--------------------------------------------------

divSum x = sum[i | i <- [1..x], mod x i == 0]

composite f x = f$f$f x

-- dirichlet f g n = sum[f d * g n `div` d | d <- [1..n], mod n d == 0]
dirichlet f g n = sum (map (\d -> f d * g (div n d)) dn)
        where dn = [d | d <- [1..n], mod n d == 0]



sram f n = map f [1..n]        

f1 x = 1
f2 x = x
