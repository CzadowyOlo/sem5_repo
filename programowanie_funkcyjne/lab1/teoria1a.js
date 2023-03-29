// laby

function isEmpty(array){
    return length(array) == 0
}
function head(array){
    return array[0]
}
function tail(array){
    return array.slice(1)
}

function sumT(array, sum){
    if (isEmpty(array)){
        return sum
    }
    sum += head(array)
    return sumT(tail(array), sum)

}