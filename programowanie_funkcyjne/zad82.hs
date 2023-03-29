-- Funkcja solveQuadraticEquation oblicza rozwiązania równania kwadratowego ax^2 + bx + c = 0.
solveQuadraticEquation :: Float -> Float -> Float -> (Float, Float)
solveQuadraticEquation a b c =
  let
    delta = b * b - 4 * a * c
    x1 = (-b + sqrt(delta)) / (2 * a)
    x2 = (-b - sqrt(delta)) / (2 * a)
  in
    (x1, x2)

main = do
  -- Wczytaj liczby a, b, c.
  putStrLn "Podaj a:"
  aStr <- getLine
  let a = read aStr :: Float

  putStrLn "Podaj b:"
  bStr <- getLine
  let b = read bStr :: Float

  putStrLn "Podaj c:"
  cStr <- getLine
  let c = read cStr :: Float

  -- Oblicz rozwiązania równania kwadratowego.
  let (x1, x2) = solveQuadraticEquation a b c

  -- Wyświetl rozwiązania równania kwadratowego.
  putStrLn ("x1 = " ++ show x1)
  putStrLn ("x2 = " ++ show x2)
