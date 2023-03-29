# Aleksander Głowacki 261702
function population(n, r, p0)
    if (n == 0) 
        return p0
    end
    
    pn_1 = population(n-1, r, p0)
    # if (mod(n, 5) == 0)
    println(pn_1)
    # end    
    return pn_1 + r*pn_1*(1 - pn_1)
end

println("40 iterations Float32: ", population(40, Float32(3), Float32(0.01)))
println("40 iterations Float64: ", population(40, Float32(3), Float64(0.01)))

res = population(10, Float32(3), Float32(0.01))
res = population(10, Float32(3), Float32(trunc(res*1000)/1000))
res = population(10, Float32(3), Float32(res))
res = population(10, Float32(3), Float32(res))
println("40 iterations, truncated to 3 significant ditits every 10 iterations: ", res)