# Aleksander Głowacki 261702
# Obliczenia naukowe, Lista 5, zadanie 1
module blocksys

import SparseArrays
using LinearAlgebra

export readMatrix, b_vs_bcalc

"""
Funkcja czytająca macierz A z pliku.

Dane:
    file - plik z macierzą A

Wyniki:
    A - macierz A
"""
function readMatrix(file::String)
    open(file) do f
        line = split(readline(f))
        n = parse(Int64, line[1])
        l = parse(Int64, line[2])

        rows = Int64[]
        cols = Int64[]
        vals = Float64[]

        for line in eachline(f)
            line = split(line)
            push!(rows, parse(Int64, line[1]))
            push!(cols, parse(Int64, line[2]))
            push!(vals, parse(Float64, line[3]))
        end   

        for i in 2:(n/l)
            #setting 1,1 
            i1_B = (i-1)*(l)
            j1_B = (i-2)*l

            #fill B dodaję zera na i powyżej przekatnej
            for m in 2:l
                for n in 2:m
                    a=i1_B+n
                    b=j1_B+m
                    push!(rows, i1_B+n)
                    push!(cols, j1_B+m)
                    push!(vals, 0.0)
                end
            end

            i1_C = (i-2)*(l)
            j1_C = (i-1)*l

            #fill C dodaję zera na cały blok oprócz przekątnej
            for m in 1:l
                for n in m:l
                    push!(rows, i1_C+n)
                    push!(cols, j1_C+m)
                    push!(vals, 0.0)
                end
                for n in 1:m
                    push!(rows, i1_C+n)
                    push!(cols, j1_C+m)
                    push!(vals, 0.0)
                end
            end
        end

        A = SparseArrays.sparse(rows, cols, vals)
        return (A, n, l)
    end
end

"""
Funkcja czytająca wektor prawych stron z pliku.

Dane:
    file - plik z wektorem prawych stron

Wyniki:
    b - wektor prawych stron
"""
function readVector(file::String)
    open(file) do f
        vector = Float64[]

        #ignoruję pierwszą linijkę, rozmiar sam sie na wektorze zrobi
        readline(f)

        for line in eachline(f)
            push!(vector, parse(Float64, line))
        end

        return vector
    end    
end

"""
Funkcja obliczająca wektor prawych stron.

Dane:
    A - macierz A,
    x - wektor rozwiązań,
    n - wielkość macierzy A,
    l - wielkość bloków macierzy A

Wyniki:
    vector - wektor prawych stron
"""
function calculateVector(A::SparseArrays.SparseMatrixCSC{Float64, Int64}, x::Vector{Float64}, n::Int64, l::Int64)
    m = 1
    vector = zeros(n)
    for k in 1:n
        for i in max(1,k-l):min(k+l,n)
            vector[k] += A[k, i] * x[i]
        end
    end
    return vector
end

"""
Funkcja zapisująca wektor do pliku
Dane wejściowe:
    file - ścieżka do pliku
    x - wektor, który chcemy zapisać
"""
function writeVector(file::String, x::Vector)
    open(file, "w") do f
        foreach(line -> println(f, string(line), "\n"), x)
    end
end

"""Funkcja zapisująca wektor do pliku wraz z błędem względnym
Dane wejściowe:
    file - ścieżka do pliku
    x - wektor, który chcemy zapisać
    A - macierz rzadka w formacie SparseMatrixCSC
    b - wektor prawych stron
"""
function writeVectorWithRelativeError(file::String, x::Vector)
    open(file, "w") do f
        y = ones(Float64, length(x))
        write(f, string(norm(y - x) / norm(x)), "\n")
        foreach(a->write(f, string(a), "\n"), x)
    end
end

"""Funkcja drukująca do pliku rozwiązanie oraz błąd względny jeśli wektor prawych stron był obliczany.

Dane:
    A - macierz wejściowa
    b - wektor wejściowy prawych stron
    X - obliczony wektor X
    n - rozmiar macierzy
    l - rozmiar bloku
"""
function b_vs_bcalc(A::SparseArrays.SparseMatrixCSC{Float64, Int64}, b::Vector{Float64}, X::Vector{Float64}, n::Int64, l::Int64)
    b1 = calculateVector(A, X, n, l)
    #println(abs(norm(b)-norm(b1)) / norm(b))
    println(norm(b-b1) / norm(b))
end    
"""
Funkcja drukująca do pliku rozwiązanie oraz błąd względny jeśli wektor prawych stron był obliczany.

Dane:
    X - wektor rozwiązań,
    file - plik do którego zostanie zapisane rozwiązanie,
    n - wielkość macierzy A,
    was_b_from_the_file - tak jeśli b było czytanie z pliku, nie jeśli b było obliczane
"""
function printSolution(X::Vector, file::String, n::Int64, calb::Bool)
    open(file, "w") do f
        if calb
            writeVectorWithRelativeError(file, X);
        else
            writeVector(file, X);
        end    
    end
end


"""
Funkcja obliczająca rozwiązanie dla eliminacji Gaussa bez wyboru elementu głównego.

Dane:
    A1 - macierz A,
    b - wektor prawych stron,
    n - wielkość macierzy A,
    l - wielkość bloków macierzy A

Wyniki:
    X - wektor rozwiązań
"""
function gaussCalculator(A1::SparseArrays.SparseMatrixCSC{Float64, Int64}, b1::Vector{Float64}, n::Int64, l::Int64)
    X = ones(n)
    A = copy(A1);
    b = copy(b1);
    X[n] = b[n] / A[n,n]

    for i in n-1:-1:1
        sum = b[i]
        for j in i+1:min(n, (i+l))
            sum = sum - A[i, j] * X[j]
        end
        X[i] = sum / A[i, i]
    end
    return X
end

"""
Eliminacja Gaussa bez wyboru elementu głównego

Dane:
    A1 - macierz A,
    b - wektor prawych stron,
    n - wielkość macierzy A,
    l - wielkość bloków macierzy A

Wyniki:
    X - wektor rozwiązań
"""

function GaussianElimination(A1::SparseArrays.SparseMatrixCSC{Float64, Int64}, b1::Vector{Float64}, n::Int64, l::Int64)
    A = copy(A1);
    b = copy(b1);
    for k in 1:(n-1)
        diag = A[k, k]
        for i in (k+1):min(k+l, n) #k+1 bo zeruję te pod przekątną (k,k), (k+l) stała długość bloku(w dół)
            fctr = A[i, k] / diag
            for j in k:min(k+l+1, n) #
                A[i, j] -= fctr * A[k, j]
            end
            b[i] -= fctr * b[k]
        end
    end
    X = gaussCalculator(A, b, n, l)
    return X
end

"""
Funkcja obliczająca rozwiązanie dla eliminacji Gaussa z częściowym wyborem elementu głównego.

Dane:
    A1 - macierz A,
    b - wektor prawych stron,
    n - wielkość macierzy A,
    l - wielkość bloków macierzy A

Wyniki:
    X - wektor rozwiązań
"""

function pivotGaussCalculator(A1::SparseArrays.SparseMatrixCSC{Float64, Int64}, b1::Vector{Float64}, n::Int64, l::Int64)
    X = ones(n)
    A = copy(A1);
    b = copy(b1);
    X[n] = b[n] / A[n,n]

    for i in n-1:-1:1
        sum = b[i]
        for j in i+1:min(i+2*l,n)
            sum = sum - A[i, j] * X[j]
        end
        X[i] = sum / A[i, i]
    end
    return X
end



"""
Eliminacja Gaussa z częściowym wyborem elementu głównego

Dane:
    A1 - macierz A,
    b - wektor prawych stron,
    n - wielkość macierzy A,
    l - wielkość bloków macierzy A

Wyniki:
    X - wektor rozwiązań
"""
function GaussianEliminationWithPartialPivoting(A1::SparseArrays.SparseMatrixCSC{Float64, Int64}, b1::Vector{Float64}, n::Int64, l::Int64)
    A = copy(A1);
    b = copy(b1);
    for k in 1:n-1
        maxabs = -1 #największy moduł
        ixmaxabs = -1 #jego index
        for i = k:min(k+l, n)
            temp = abs(A[i,k])
            if temp > maxabs
                maxabs = temp
                ixmaxabs = i
            end
        end
        
        if ixmaxabs != k
            for i in k:min(k+2*l+1,n)
                A[k, i], A[ixmaxabs,i] = A[ixmaxabs,i], A[k, i]
            end
            b[k], b[ixmaxabs] = b[ixmaxabs], b[k]
        end

        diag = A[k, k]
        for i in (k+1):min(k+l, n)
            fctr = A[i, k] / diag
            for j in k:min(k+2*l, n)
                A[i, j] -= fctr * A[k, j]
            end
            b[i] -= fctr * b[k]
        end
    end
    X = pivotGaussCalculator(A, b, n, l)
    return X
end

end