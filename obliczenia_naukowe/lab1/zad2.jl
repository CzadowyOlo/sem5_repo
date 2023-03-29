# Aleksander Głowacki 261702

types = [Float16, Float32, Float64]

function kahan(type)
    typeOne = one(type)
    3*typeOne*((4*typeOne)/(3*typeOne) - typeOne) - typeOne
end

foreach(type -> println("f: ", kahan(type), " eps: ", eps(type)), types)
