# Aleksander Głowacki 261702

include("zad1.jl")
using .Dupa

f(x) = exp(1-x) - 1
pf(x) = -exp(1-x)

g(x) = x * exp(-x)
pg(x) = -1.0 * exp(-x) * (x-1)

acc = 10^(-7)

a = -12.0
b = 10.0

# wynikB = mbisekcji(f, a, b, acc, acc)
# println("Biseksja_: wynikf = $wynikB")
# wynikB = mbisekcji(g, a, b, acc, acc)
# println("Biseksja_: wynikg = $wynikB")

# #szybko poszło z funkcją g(x)

# println("szukamy pierwiastka funkcji g(x)")
# wynikB = mbisekcji(g, -1.0, 1000.0, acc, acc)
# println("Biseksja_: wynikg = $wynikB")
# wynikB = mbisekcji(g, a, b, acc, acc)
# println("Biseksja_: wynikg = $wynikB")
# wynikN = mstycznych(g, pg, -2.0, acc, acc, 1000)
# println("Stycznych: wynikg = $wynikN")
# wynikN = msiecznych(g, -2.0, 3.0, acc, acc, 1000)
# println("Siecznych: wynikg = $wynikN")

# println("szukamy pierwiastka funkcji f(x)")
# wynikN = mstycznych(f, pf, -2.0, acc, acc, 10000)
# println("Stycznych: wynikg = $wynikN")
# wynikN = msiecznych(f, -200.0, 300.0, acc, acc, 1000)
# println("Siecznych: wynikg = $wynikN")

# #sprawdzanie pytań
# println("\n dodatek \n")
# wynikN = mstycznych(f, pf, 6.0, acc, acc, 10000)
# println("Stycznych: wynikf = $wynikN")
# wynikN = mstycznych(f, pf, -78.0, acc, acc, 10000)
# println("Stycznych: wynikf = $wynikN")
# wynikN = mstycznych(g, pg, 2.0, acc, acc, 10000)
# println("Stycznych: wynikg = $wynikN")

println("\n dupa dodatek \n")

wynikB = mbisekcji(f, -1.0, 1000.0, acc, acc)
println("Biseksja_: wynikf = $wynikB")
wynikB = mbisekcji(g, -1.0, 1000.0, acc, acc)
println("Biseksja_: wynikg = $wynikB")
wynikB = mbisekcji(f, -10.0, 10.0, acc, acc)
println("Biseksja_: wynikf = $wynikB")
wynikB = mbisekcji(g, -10.0, 10.0, acc, acc)
println("Biseksja_: wynikg = $wynikB")
wynikB = mbisekcji(f, -10.0, -1.0, acc, acc)
println("Biseksja_: wynikf = $wynikB")
wynikB = mbisekcji(g, -10.0, -1.0, acc, acc)
println("Biseksja_: wynikg = $wynikB")
wynikB = mbisekcji(f, -1.0, 2.0, acc, acc)
println("Biseksja_: wynikf = $wynikB")
wynikB = mbisekcji(g, -1.0, 2.0, acc, acc)
println("Biseksja_: wynikg = $wynikB")

println("\n dupa dodatek \n")

wynikN = mstycznych(f, pf, -5.0, acc, acc, 10000)
println("Stycznych: wynikf = $wynikN")
wynikN = mstycznych(g, pg, -5.0, acc, acc, 10000)
println("Stycznych: wynikg = $wynikN")
wynikN = mstycznych(f, pf, 20.5, acc, acc, 10000)
println("Stycznych: wynikf = $wynikN")
wynikN = mstycznych(g, pg, 20.5, acc, acc, 10000)
println("Stycznych: wynikg = $wynikN")
wynikN = mstycznych(f, pf, 100.0, acc, acc, 10000)
println("Stycznych: wynikf = $wynikN")
wynikN = mstycznych(g, pg, 100.0, acc, acc, 100000)
println("Stycznych: wynikg = $wynikN")
wynikN = mstycznych(f, pf, 1.0, acc, acc, 10000)
println("Stycznych: wynikf = $wynikN")
wynikN = mstycznych(g, pg, 1.0, acc, acc, 10000)
println("Stycznych: wynikg = $wynikN")

println("\n dupa dodatek \n")

wynikN = msiecznych(f, 0.0, 2.0, acc, acc, 1000)
println("Siecznych: wynikf = $wynikN")
wynikN = msiecznych(g, 0.0, 2.0, acc, acc, 1000)
println("Siecznych: wynikg = $wynikN")
wynikN = msiecznych(f, -20.0, 30.0, acc, acc, 1000)
println("Siecznych: wynikf = $wynikN")
wynikN = msiecznych(g, -20.0, 30.0, acc, acc, 1000)
println("Siecznych: wynikg = $wynikN")
wynikN = msiecznych(f, -2.0, 3.0, acc, acc, 1000)
println("Siecznych: wynikf = $wynikN")
wynikN = msiecznych(g, -2.0, 3.0, acc, acc, 1000)
println("Siecznych: wynikg = $wynikN")
wynikN = msiecznych(f, 2.0, 5.0, acc, acc, 1000)
println("Siecznych: wynikf = $wynikN")
wynikN = msiecznych(g, 2.0, 5.0, acc, acc, 1000)
println("Siecznych: wynikg = $wynikN")


