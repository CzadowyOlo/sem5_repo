# Aleksander Głowacki 261702
include("interpolacja.jl")
using .Interpolacja
using Plots

f = x -> abs(x)
g = x -> 1 / (1 + x^2)

for n in [5,7, 8, 10, 15]
    plot_f = rysujNnfx2(f, -1.0, 1.0, n)
    plot_g = rysujNnfx2(g, -5.0, 5.0, n)
    savefig(plot_f, "popz6f_$n.png")
    savefig(plot_g, "popz6g_$n.png")
end
