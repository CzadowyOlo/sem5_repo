--Aleksander Głowacki kolokwium 3 14.12.2022

--zadanie 1
-- Funkcja fromEnum jako argument wywołania przyjmuje obiekt klasy Enum. Do tej klasy należą np znaki - Char, które podajemy
-- otoczone pojedynczym cudzysłowem: 'znak'.
-- Kodziedziną tej funkcji są obiekty typu Int, czyli wartości liczbowe.
-- Funkcja przypisuje znakom wartości liczbowe z nimi skojarzone, pradwopodobnie wartości w kodzie Ascii w przypadku pojedynczych znaków.
-- Przyklad wywołania:
-- ghci> fromEnum 'a' ----> 97
-- ghci> fromEnum 'b' ----> 98
-- ghci> fromEnum '1' ----> 49
-- ghci> fromEnum '2' ----> 50
-- W przypadku użycia na typach Int, funkcja działa jak identyczność:
-- ghci> fromEnum 1 ----> 1
-- W przypadku typów numerycznych niecałkowitych - Float zwraca podłogę.
-- ghci> fromEnum 1.9 ----> 1
-- nie znam skladni do tej monady, a użycie bez funkcjonalności komunikatów to by było:
fun x = map fromEnum x
-- ghci> fun "Piję piwo, bo jest zdrowe"
-- [80,105,106,281,32,112,105,119,111,44,32,98,111,32,106,101,115,116,32,122,100,114,111,119,101]

-- poniżej próba obsłużenia tej funkcjonalności, al enie wiem jak Inta zmienić na jego reprezentację w char/string
fun1 x = ["zmieniam " ++ toString(x) ++ "na " ++ toString(fromEnum x) ++ "\n"]
fun2 [] = []
fun2 x = fun1 (head x) ++ fun2 (tail x)
