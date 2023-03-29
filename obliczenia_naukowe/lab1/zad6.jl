# Aleksander Glowacki 261702
function f(x)
    sqrt((x^2) + 1) - 1
end

function g(x)
    (x^2)/(sqrt((x^2) + 1) + 1)
end

foreach(x -> println(x, " & ", f(8.0^(-x)), " & ", g(8.0^(-x)), "\\\\\n\\hline"), 0:22)