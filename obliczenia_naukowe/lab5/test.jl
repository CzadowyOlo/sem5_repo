# Aleksander Głowacki 261702
# Obliczenia naukowe, Lista 5

include("bloc.jl")
include("matrixgen.jl")
using .matrixgen
using .blocksys
using LinearAlgebra
using Printf

println("Podaj wielkość macierzy: ")
size = readline();
print("Wybierz sposób: \nBez wyboru el. głównego: 1\nZ wyborem elementu: 2\nObie metodki: 3\n")
decision = parse(Int64, readline());
print("Czy b wczytać z pliku?: \nTak: 1\nNie: 2\n")
calb = parse(Int64, readline());
println("Czytam plik:")
@time begin
A, n, l = blocksys.readMatrix("./Dane"*size*"/A.txt")
end

if (calb == 1)
    b = blocksys.readVector("./Dane"*size*"/b.txt")
elseif (calb == 2)
    x = ones(n)
    b = blocksys.calculateVector(A, x, n, l)
end

if(decision == 1)
    @time begin
        X = blocksys.GaussianElimination(A,b,n,l)
    end
    blocksys.printSolution(X, "./wyniki_zwykly_Gauss/"*size*".txt", n, (calb == 2))
elseif (decision == 2)
    @time begin
        X = blocksys.GaussianEliminationWithPartialPivoting(A,b,n,l)
    end
    blocksys.printSolution(X, "./wyniki_pivot_Gauss/"*size*".txt", n, (calb == 2))
elseif (decision == 3)
    println("Zwykły Gauss:")
    @time begin
        X = blocksys.GaussianElimination(A,b,n,l)
        b_vs_bcalc(A, b, X, n, l)
    end
    blocksys.printSolution(X, "./wyniki_zwykly_Gauss/"*size*".txt", n, (calb == 2))    
    println("Pivot Gauss:")
    @time begin
        X = blocksys.GaussianEliminationWithPartialPivoting(A,b,n,l)
        b_vs_bcalc(A, b, X, n, l)
    end
    blocksys.printSolution(X, "./wyniki_pivot_Gauss/"*size*".txt", n, (calb == 2))
end



