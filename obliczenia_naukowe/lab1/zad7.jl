
# Aleksander Głowacki 261702

function f(x)
    return sin(x) + cos(3x)
end

function der_f(x) #pochodna z karty wzorów
    return cos(x) - 3sin(3x)
end

function aproksymacja_der_f(x, h)
    return (f(x + h) - f(x)) / h
end

function difference(x, y)
    return abs(x-y)
end

function testing(limit)
    println("f'(x) = ", der_f(1))
    println("\$n\$ & przybliżona pochodna & błąd & 1+h \\\\ \\hline")
    for n in 0:limit
        h = 2.0^(-n)
        derivative = der_f(1)
        aproks = aproksymacja_der_f(1, h)
        błąd = difference(derivative, aproks)
        println(n, " & ", aproks, " & ", błąd, " & ", 1+h, " \\\\ \\hline")
    end
end

testing(54)
