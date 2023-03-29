# Aleksander Głowacki 261702
include("interpolacja.jl")
using .Interpolacja
using Plots

f = x -> exp(x)
g = x -> x^2 * sin(x)

for n in [5, 10, 15]
    plot_f = rysujNnfx2(f, 0., 1., n)
    plot_g = rysujNnfx2(g, -1., 1., n)
    savefig(plot_f, "z5f_$n.png")
    savefig(plot_g, "z5g_$n.png")
end
