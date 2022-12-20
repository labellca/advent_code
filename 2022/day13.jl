###########
#### Data
fn = "_data/day13.txt"
f = open(fn, "r")
data  = readlines(f)
close(f)

function convertToArray(item::Any)
    if typeof(item) == Int64
        println("-- Convert $item to list")
        return [item]
    else
        return item
    end
end 

function isOrdered(left::Any, right::Any, ordered::Bool, stop::Bool)
    println("- Compare $left vs $right")

    if typeof(left) == typeof(right) == Int64
        if left == right
            return false, false
        elseif left < right
            println("-- Left side is smaller, so inputs are in the right order")
            return true, true
        else
            println("-- Right side is smaller, so inputs are not in the right order")
            return false, true
        end
    elseif typeof(left) == Int64 && typeof(right) != Int64 || typeof(right) == Int64 && typeof(left) != Int64
        left = convertToArray(left)
        right = convertToArray(right)
        ordered, stop = isOrdered(left, right, ordered, stop)
    else
        len_left = length(left)
        i = 1
        while i ≤ len_left && !stop
            if !isassigned(right, i)
                println("-- Right side ran out of items, so inputs are not in the right order")
                return false, true
            end

            ordered, stop = isOrdered(left[i], right[i], ordered, stop)
            i += 1
        end

        if isassigned(right, i) && !stop
            println("-- Left side ran out of items, so inputs are in the right order")
            return true, true
        end
    end
    return ordered, stop
end

###########
#### Part 1
N = length(data)
n = 1
count = 1
idx_ordered = []

while n < N
    if n == "" ## in case file starts with empty line
        n += 1
    else
        println("=== Pair $count ===")
        packet_1 = eval(Meta.parse(data[n]))
        packet_2 = eval(Meta.parse(data[n+1]))

        ordered, stop = isOrdered(packet_1, packet_2, false, false)
        
        if ordered
            push!(idx_ordered, count)
        end

        n += 3
        count += 1
        println("===> Ordered: $ordered")
        println()
    end

end

## Determine which pairs of packets are already in the right order. What is the sum of the indices of those pairs?
sum(idx_ordered)


###########
#### Part 2
function partition(sorted::Array, low_idx::Int, high_idx::Int)
    pvt = sorted[high_idx]
    i = low_idx - 1

    for p in low_idx:high_idx
        if isOrdered(sorted[p], pvt, false, false)[1]
            i += 1

            val_i = sorted[i]
            val_p = sorted[p]

            sorted[i] = val_p
            sorted[p] = val_i
        end
    end

    val_high = sorted[high_idx]
    val_i = sorted[i+1]

    sorted[i+1] = val_high
    sorted[high_idx] = val_i

    return i + 1
end

function quickSort(sorted::Array, pos1::Int, pos2::Int)
    if pos1 < pos2
        prt = partition(sorted, pos1, pos2)

        quickSort(sorted, pos1, prt-1)
        quickSort(sorted, prt+1, pos2)
    end

    return sorted
end

## Filter and parse data
sorted = filter(x -> x != "", data)
sorted = [eval(Meta.parse(i)) for i in sorted]

## Add divider packets
push!(sorted, [[2]])
push!(sorted, [[6]])

## Sort
sorted_packets = quickSort(sorted, 1, length(sorted))

## Find pos of divider packets
idx_2 = findfirst(x -> x == [[2]], sorted_packets)
idx_6 = findfirst(x -> x == [[6]], sorted_packets)

## Organize all of the packets into the correct order. What is the decoder key for the distress signal?
idx_2 * idx_6