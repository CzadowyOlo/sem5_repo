gcdList :: [Integer] -> Integer -> Integer
gcdList [] acc = acc
-- gcdList acc = acc
-- gcdList (x1:xs) acc = gcdList xs (gcd x1 acc)
gcdList xs acc = foldl (flip gcd) acc xs
                        

