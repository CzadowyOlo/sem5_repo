# Aleksander Głowacki 261702

using LinearAlgebra

function matcond(n::Int, c::Float64)
# Function generates a random square matrix A of size n with
# a given condition number c.
# Inputs:
#	n: size of matrix A, n>1
#	c: condition of matrix A, c>= 1.0
#
# Usage: matcond(10, 100.0)
#
# Pawel Zielinski
        if n < 2
         error("size n should be > 1")
        end
        if c< 1.0
         error("condition number  c of a matrix  should be >= 1.0")
        end
        (U,S,V)=svd(rand(n,n))
        return U*diagm(0 =>[LinRange(1.0,c,n);])*V'
end

function hilb(n::Int)
    # Function generates the Hilbert matrix  A of size n,
    #  A (i, j) = 1 / (i + j - 1)
    # Inputs:
    #	n: size of matrix A, n>=1
    #
    #
    # Usage: hilb(10)
    #
    # Pawel Zielinski
            if n < 1
             error("size n should be >= 1")
            end
            return [1 / (i + j - 1) for i in 1:n, j in 1:n]
    end

function Hilberta(size)
    macierz = hilb(size)
    x = ones(size)
    b = macierz * x

    gauss = macierz \ b # tu liczymy wektor niewiadomych x' metodą eliminacji gausa
    inverse = inv(macierz) * b # a tu metodą odwrotności
    println("$size & $(rank(macierz)) & $(cond(macierz)) & $(norm(inverse - x)) & $(norm(gauss - x))\\\\ \n\\hline")
end

# przeprowadza eksperyment obliczenia dwiema metodami
# dla macierzy losowej o podanym rozmiarze
function Randomowa(n, c)
    macierz = matcond(n, c)
    x = ones(n)
    b = macierz * x

    gauss = macierz \ b
    inverse = inv(macierz) * b

    println("$n & $(rank(macierz)) & $(cond(macierz)) & $(norm(inverse - x)) & $(norm(gauss - x))\\\\ \n\\hline")
end    

println("Hilbert:")
for i in 1:2:30
    Hilberta(i)
end

rozmiary = [5, 10, 20]
conds = [1.0, 10.0, 10^3, 10^7, 10^12, 10^16]

println("Random:")
for rozmiar in rozmiary
    for cond in conds
        Randomowa(rozmiar, cond)
    end
end