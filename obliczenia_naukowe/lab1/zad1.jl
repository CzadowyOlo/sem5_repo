# Aleksander Glowacki 261702

arithmetics = [Float16, Float32, Float64]

function machEps(type)
    x = one(type)
    while one(x) + x / 2 != one(x)
        x /= 2
    end
    x
end

println("Epsilon maszynowy")
foreach(type -> println("f: ", machEps(type), " eps: ", eps(type)), arithmetics)

function eta(type)
    x = one(type)
    while x / 2 != zero(type)
        x /= 2
    end
    x
end

println("Eta")
foreach(type -> println("f: ", eta(type), " nextfloat: ", nextfloat(zero(type))), arithmetics)

function maxNumber(type)
    x = one(type)
    while !isinf(x * 2)
        x *= 2
    end
    # aktualnie x = inf/2, musimy uzupełnić brakującą wartość
    gap = x / 2
    while !isinf(x + gap) && gap >= one(type)
        x += gap
        gap /= 2
    end
    x
end

println("Max")
foreach(type -> println("f: ", maxNumber(type), " floatmax: ", floatmax(type)), arithmetics)
