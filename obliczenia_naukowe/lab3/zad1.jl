# Aleksander Głowacki 261702

module Dupa
export mbisekcji, mstycznych, msiecznych

function mbisekcji(f, a::Float64, b::Float64, delta::Float64, epsilon::Float64)
    r::Float64 = 0
    v::Float64 = 0
    e::Float64 = 0
    it = 0
    err = 0

    u = f(a) #lewo
    v = f(b) #prawo

    if (sign(v) == sign(u))
        return (Nothing, Nothing, Nothing, 1)
    end

    while(true)
        it+=1
        e = (b - a)
        r = a + e/2 #srodek
        v = f(r) #wartość srodka
        if (abs(e) < delta || abs(v) < epsilon)
            return (r, v, it, err)
        end
        if (sign(u) != sign(v)) #zmienia w lewym
            b = r
        else #zmienia w prawym
            a = r
            u = v
        end    
    end


end    


function mstycznych(f, pf, x0::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    r::Float64 = 0  # x(n+1)
    v::Float64 = 0 # value of function in point
    err = 0
    it = 0
    v = f(x0)
    if (abs(v) < epsilon)
        return (x0, v, 0, 0)
    end
    
    while (it <= maxit)
        it+=1
        if (abs(pf(x0)) < eps(Float64))
            return (Nothing, Nothing, Nothing, 2)
        end

        r = x0 - v/pf(x0)
        v = f(r)

        if ( abs(r - x0) < delta || abs(v) < epsilon)
            return (r, v, it, err)
        end
         
        x0 = r  

    end    

    return (Nothing, Nothing, Nothing, 1)
end

function msiecznych(f, x0::Float64, x1::Float64, delta::Float64, epsilon::Float64, maxit::Int)

    r::Float64 = 0.0  # x(n+1) szukany pierwiastek
    v::Float64 = 0.0 # value of function in point wartość funkcji od znalezionego pierwiastka
    err = 0 # kod błędu
    it = 0 # iteracje

    v0 = f(x0)
    v1 = f(x1)

    while (it < maxit)
        it+=1

        if (abs(v1 - v0) < eps(Float64))
            return (Nothing, Nothing, Nothing, 2)
        end
        
        
        r = x0 - v0 * (x1 - x0) / (v1 - v0)
        v = f(r)

        if (abs(v) < epsilon || abs(r - x0) < delta)
            return (r, v, it, err)
        end    
        
        if (sign(v0) != sign(v))
            x1 = r
            v1 = v
        else
            x0 = r
            v0 = v
        end    

    end

    return (Nothing, Nothing, Nothing, 1)

end    

end