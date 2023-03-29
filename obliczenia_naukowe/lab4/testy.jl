# Aleksander Głowacki 261702
include("interpolacja.jl")
using .Interpolacja

x = [0.0, 0.5, 1.0, 1.5, 2.0]
f = [1.0, 0.6931, 0.5, 0.4082, 0.3466]
fx = ilorazyRoznicowe(x, f)

x = [0.0, 0.5, 1.0, 1.5, 2.0]
fx = [1.0, 0.6931, 0.5, 0.4082, 0.3466]
t = 1.0
nt = warNewton(x, fx, t)

x = [0.0, 0.5, 1.0, 1.5, 2.0]
fx = [1.0, 0.6931, 0.5, 0.4082, 0.3466]
a = naturalna(x, fx)

f(x) = sin(x)
rysujNnfx2(f, 0, pi, 10)

################################