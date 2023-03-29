# Aleksander Głowacki 261702

include("zad1.jl")
using .Dupa


f(x) = x^2 - 2
pf(x) = 2*x
acc = 1e-6
maxit = 100
x0 = 20.0
a = 0.0
b = 2.0

wynikB = mbisekcji(f, Float64(a), Float64(b), acc, acc)
println("Biseksja_: wynik = $wynikB")
wynikN = mstycznych(f, pf, x0, acc, acc, maxit)
println("Stycznych: wynik = $wynikN")
wynikN = msiecznych(f, a, b, acc, acc, maxit)
println("Siecznych: wynik = $wynikN")
println("-----------------------")

f(x) = x^2 - 2
pf(x) = 2*x
acc = 1e-11
maxit = 1000
x0 = 20.0
a = 0.0
b = 2.0

wynikB = mbisekcji(f, Float64(a), Float64(b), acc, acc)
println("Biseksja_: wynik = $wynikB")
wynikN = mstycznych(f, pf, x0, acc, acc, maxit)
println("Stycznych: wynik = $wynikN")
wynikN = msiecznych(f, a, b, acc, acc, maxit)
println("Siecznych: wynik = $wynikN")
println("-----------------------")

f(x) = x^2 - 2
pf(x) = 2*x
acc = 1e-14
maxit = 1000
x0 = 20.0
a = 0.0
b = 7.0

wynikB = mbisekcji(f, Float64(a), Float64(b), acc, acc)
println("Biseksja_: wynik = $wynikB")
wynikN = mstycznych(f, pf, x0, acc, acc, maxit)
println("Stycznych: wynik = $wynikN")
wynikN = msiecznych(f, a, b, acc, acc, maxit)
println("Siecznych: wynik = $wynikN")

println("-----------------------")

f(x) = x^2 - 2
pf(x) = 2*x
acc = 1e-11
maxit = 1000
x0 = 20.0
a = -10.0
b = -2.0

wynikB = mbisekcji(f, Float64(a), Float64(b), acc, acc)
println("Biseksja_: wynik = $wynikB")
wynikN = mstycznych(f, pf, x0, acc, acc, maxit)
println("Stycznych: wynik = $wynikN")
wynikN = msiecznych(f, a, b, acc, acc, maxit)
println("Siecznych: wynik = $wynikN")

println("------new f below-----------------")

f(x) = x^3 - x^2 + 20*x
pf(x) = 3*(x^2) - 2*x + 20
acc = 1e-8
maxit = 1000
x0 = 20.0
a = -0.01
b = 2.0

wynikB = mbisekcji(f, Float64(a), Float64(b), acc, acc)
println("Biseksja_: wynik = $wynikB")
wynikN = mstycznych(f, pf, x0, acc, acc, maxit)
println("Stycznych: wynik = $wynikN")
wynikN = msiecznych(f, a, b, acc, acc, maxit)
println("Siecznych: wynik = $wynikN")

println("-----------------------")

f(x) = x^3 - x^2 + 20*x
pf(x) = 3*(x^2) - 2*x + 20
acc = 1e-11
maxit = 200
x0 = -200.0
a = -1.0
b = 20.0
wynikB = mbisekcji(f, Float64(a), Float64(b), acc, acc)
println("Biseksja_: wynik = $wynikB")
wynikN = mstycznych(f, pf, x0, acc, acc, maxit)
println("Stycznych: wynik = $wynikN")
wynikN = msiecznych(f, a, b, acc, acc, maxit)
println("Siecznych: wynik = $wynikN")

println("-----------------------")

