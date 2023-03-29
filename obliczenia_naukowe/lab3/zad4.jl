# Aleksander Głowacki 261702

include("zad1.jl")
using .Dupa

f(x) = sin(x) - (x/2)^2
pf(x) = cos(x) - (x/2)
a = 1.5
b = 2.0
delta = 0.5 * 10^(-5)
epsilon = 0.5 * 10^(-5)
x0_newton = 1.5
x_0 = 1.0
x_1 = 2.0

wynikB = mbisekcji(f, a, b, delta, epsilon)
println("Biseksja_: wynik = $wynikB")
wynikN = mstycznych(f, pf, x0_newton, delta, epsilon, 100)
println("Stycznych: wynik = $wynikN")
wynikN = msiecznych(f, x_0, x_1, delta, epsilon, 100)
println("Siecznych: wynik = $wynikN")
println("-------nowe testy----------------")

a = 0.5
b = 8.0
delta = 0.5 * 10^(-5)
epsilon = 0.5 * 10^(-5)
x0_newton = 15.5
x_0 = 10.0
x_1 = 20.0

wynikB = mbisekcji(f, a, b, delta, epsilon)
println("Biseksja_: wynik = $wynikB")
wynikN = mstycznych(f, pf, x0_newton, delta, epsilon, 100)
println("Stycznych: wynik = $wynikN")
wynikN = msiecznych(f, x_0, x_1, delta, epsilon, 100)
println("Siecznych: wynik = $wynikN")
println("-------nowe testy----------------")
