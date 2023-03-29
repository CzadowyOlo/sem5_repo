trójki :: Integer -> [(Integer, Integer, Integer)]
trójki n = [(x,y,z) | x<-[1..n], y<-[1..n], z<-[1..n]]

pit :: (Integer, Integer, Integer) -> Bool
pit (x, y, z) = (x*x + y*y == z*z) && gcd x y == 1

trójkipit :: Integer -> [(Integer, Integer, Integer)]
trójkipit = (filter pit) . trójki
