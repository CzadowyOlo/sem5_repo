# Aleksander Glowacki 261702

function a()
    current = one(Float64)
    while nextfloat(current) * (one(Float64)/nextfloat(current)) == one(Float64) && current < 2
        current = nextfloat(current)
    end
    nextfloat(current)
end

result = a()
println("dla ", result, " x*(1/x) = ", result*(one(Float64)/result))


function b()
    current = zero(Float64)
    while nextfloat(current) * (one(Float64)/nextfloat(current)) == one(Float64)
        current = nextfloat(current)
    end
    nextfloat(current)
end

result = b()
println("dla ", result, " x*(1/x) = ", result*(one(Float64)/result))