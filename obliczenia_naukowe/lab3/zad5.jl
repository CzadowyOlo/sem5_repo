# Aleksander Głowacki 261702

include("zad1.jl")
using .Dupa

f(x) = exp(x) - 3*x
acc = 10^(-4)
a = 1.0
b = 10.0
c = -10.0

wynikB = mbisekcji(f, a, b, acc, acc)
println("Biseksja_: wynik1 = $wynikB")

wynikB = mbisekcji(f, c, a, acc, acc)
println("Biseksja_: wynik2 = $wynikB")