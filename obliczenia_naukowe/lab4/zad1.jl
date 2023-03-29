# Aleksander Głowacki 261702

module Interpolacja
export ilorazyRoznicowe, warNewton, naturalna, rysujNnfx, rysujNnfx2
using Plots


function ilorazyRoznicowe(x::Vector{Float64}, f::Vector{Float64})
    n = length(x) - 1 # liczba węzłów
    fx = zeros(n+1) # wektor ilorazów różnicowych

    for i in 1:n
        fx[i] = f[i] # wartość ilorazu dla x0
    end
    for j in 2:n # obliczanie ilorazów dla kolejnych węzłów
        for i in n:-1:j
            fx[i] = (fx[i] - fx[i-1]) / (x[i] - x[i-j+1])
        end
    end
    return fx
end

function warNewton(x::Vector{Float64}, fx::Vector{Float64}, t::Float64)
    n = length(x) -1 # liczba węzłów
    nt = fx[n] # wartość wielomianu w punkcie t
    for i in (n-1):-1:1
        nt = fx[i] + (t - x[i]) * nt
    end
    return nt
end

function naturalna(x::Vector{Float64}, fx::Vector{Float64})
    n = length(x) - 1 # liczba węzłów
    a = zeros(n + 1) # wektor współczynników postaci naturalnej
    a[n] = fx[n]

    for i in (n-1):(-1):(1)
        a[i] = fx[i] - x[i] * a[i+1]
        for j in (i+1):(n-1)
            a[j] += -x[i] * a[j+1]
        end
    end
    
    return a
end


function rysujNnfx2(f,a::Float64,b::Float64,n::Int)
    x = zeros(n+2) #węzły
    fx = zeros(n+2) #wartości funkcji w węzłach
    e = (b-a)/n
    for i in 0:(n+1)
        x[i+1] = a +i*e
        fx[i+1] = f(x[i+1])
    end
    c = ilorazyRoznicowe(x, fx)

    points_count = 50 * (n+1) #
    points = (b-a)/(points_count-1)
    xs = zeros(points_count)
    poly = zeros(points_count)
    func = zeros(points_count)
    xs[1] = a
    poly[1] = func[1] = fx[1]

    for i in 2:points_count
        xs[i] = xs[i-1] + points
        poly[i] = warNewton(x, c, xs[i])#obliczamy wartości skonstruowanego wielomianu na przedziale
        func[i] = f(xs[i])
    end
    print("$(warNewton(x, c, xs[points_count])) \n")
    p = plot(xs, [poly func], label=["wielomian" "funkcja"], title="n = $n")
    return p
end


end