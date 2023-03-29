# Aleksander Głowacki 261702

function naiveTest(first :: Float64, last :: Float64, step :: Float64)
    current = nextfloat(first)
    while (current < last)
        if (nextfloat(current) != current + step)
            return false;
        end
        current = nextfloat(current)
    end
    true
end


"""
Funckcja wyznaczająca na podstawie exponenty i mantysy liczb zmiennoprzecinkowych
w IEEE754 podwójnej precyzji odległość między kolejnymi liczbami w zakresie.
first - początek zakresu
last - koniec zakresu - uznalem że w treści pomijamy koniec zakresu oznaczony jako ...x]
"""

function numberDensity(first :: Float64, last :: Float64)
    last = prevfloat(last)
    firstExp = SubString(bitstring(first), 2:12) #exponenta
    lastExp = SubString(bitstring(last), 2:12)
    # jeżeli eksponenty nie są równe, nie będziemy mieli równego rozmieszczenia
    if (firstExp != lastExp)
        # zero jako błąd
        return 0.0
    end

    return ((2.0^(parse(Int, firstExp, base = 2) - 1023 - 52)))
end

println(numberDensity(0.5, 1.0))
println(numberDensity(1.0, 2.0))
println(numberDensity(2.0, 4.0))