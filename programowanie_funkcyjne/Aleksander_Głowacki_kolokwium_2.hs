-- Aleksander Głowacki kolokwium 2

-- zadanie 1

-- Funkcja words przekształca listę charów na listę list charów.
-- przykładowe wywołanie: "words "I like drink beer" "
-- zwraca: ["I","like","drink","beer"]
-- czyli funkcja pobrała listę znaków i odseparowala ciągi znaków poprze white sign - spację. w ten sposób utworzyła listę słów. 

-- wywołanie: 
-- prompt> concat (map words [ "I was young", "You like beer", "Beer is yellow" ])
-- zwraca: ["I","was","young","You","like","beer","Beer","is","yellow"]
malfunction xs = concat (map words xs)

-- Funkcja unwords: przekształca listę Stringów w jeden String. Odseparowane Stringi łączy w jeden przy pomocy spacji 
-- i zamyka je wszystkie w jednej liście Charów -- jednym Stringu.
-- przykład: 
-- unwords [ "beer", "wheels"]
-- "beer wheels"

-- Moja funkcja końcowa:
-- prompt> unwords (malfunction [ "I was young", "You like Beer", "Beer is yellow" ])
-- "I was young You like Beer Beer is yellow"
-- zadanie 2

--helper x (a, b) = snd/(fst * (x ^ fst)) 
--function a xs = foldr ((+) . (snd/(fst * ((^) a fst)))) 0 (zip [1..] xs)

aciag = [(-1.0) ** k | k <- [1..261702]]
f2 a xs = foldr (\x acc -> (((+) x) . ((snd x) / ((fst x) * (a ** fst x))))) 0 (zip [1..] xs)

---------------------------------------------------------------------------------