# Aleksander Glowacki 261702
function values(reps, c, x0)
    values = [x0]
    for i in 1:reps-1
        append!(values, values[i]^2+c)
    end
    return values
end

c_val = [
    -2.0,
    -2.0,
    -2.0,
    -1.0,
    -1.0,
    -1.0,
    -1.0,      
]
x0_val = [
    1.0,
    2.0,
    1.99999999999999,
    1.0,
    -1,
    0.75,
    0.25
]

reps = 40

for i in 1:7
    println("dataset nr = $i: $(values(40, c_val[i], x0_val[i])) \\")
end    

for i in 1:7
    println("$i. c = $(c_val[i]), x0 = $(x0_val[i]) : x40 = $(values(40, c_val[i], x0_val[i])[40])")
end 