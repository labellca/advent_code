###########
#### Data
fn = "_data/day12.txt"
f = open(fn, "r")
data  = readlines(f)
close(f)

heightmap = permutedims(reduce(hcat, collect.(data)))
alphabet = "SabcdefghijklmnopqrstuvwxyzE"

function findHeightRank(h::Char)
    return findfirst(x -> x == h, alphabet)
end

function getNeighbors(xᵢ::Int64, yᵢ::Int64)
    neighbors = []
    
    ## Up
    if xᵢ-1 ≥ 1 && findHeightRank(heightmap[xᵢ-1, yᵢ]) - findHeightRank(heightmap[xᵢ, yᵢ]) ≤ 1
        push!(neighbors, (xᵢ-1, yᵢ))
    end

    ## Right
    if yᵢ+1 ≤ size(heightmap)[2] && findHeightRank(heightmap[xᵢ, yᵢ+1]) - findHeightRank(heightmap[xᵢ, yᵢ]) ≤ 1
        push!(neighbors, (xᵢ, yᵢ+1))
    end

    ## move down
    if xᵢ+1 ≤ size(heightmap)[1] && findHeightRank(heightmap[xᵢ+1, yᵢ]) - findHeightRank(heightmap[xᵢ, yᵢ]) ≤ 1
        push!(neighbors, (xᵢ+1, yᵢ))
    end

    ## move left
    if yᵢ-1 > 0 && findHeightRank(heightmap[xᵢ, yᵢ-1]) - findHeightRank(heightmap[xᵢ, yᵢ]) ≤ 1
        push!(neighbors, (xᵢ, yᵢ-1))
    end

    return neighbors    
end

function getPathLenght(x::Int64, y::Int64, queue::Array, univisited::Matrix{Float64})
    while length(queue) != 0
        ## removed height from queue to visit
        queue = filter(i -> i != (x, y), queue)
        print(length(queue), "...")

        ## get neighbors and update path values
        neigbors = getNeighbors(x, y)
        for n in neigbors
            unvisited[n[1], n[2]] = minimum([unvisited[x, y]+1, unvisited[n[1], n[2]]])
        end

        ## select smallest path to explore next
        if length(queue) != 0
            min_val = minimum([unvisited[p[1], p[2]] for p in queue])
            min_coord = filter(x -> x ∈ queue, Tuple.(findall(x -> x == min_val, unvisited)))[1]
            x = min_coord[1]
            y = min_coord[2]
        end
    end

    return univisited
end

###########
#### Part 1
start_pos = findfirst(x -> x == 'S', heightmap)
end_pos = findfirst(x -> x == 'E', heightmap)
x = start_pos[1]
y = start_pos[2]
xₙ = end_pos[1]
yₙ = end_pos[2]

### initiate
unvisited = fill(Inf, size(heightmap))
unvisited[x, y] = 0
queue = [(i, j) for i in 1:size(heightmap)[1] for j in 1:size(heightmap)[2]]

## What is the fewest steps required to move from your current position to the location that should get the best signal?
unvisited_1 = getPathLenght(x, y, queue, unvisited)
unvisited_1[xₙ, yₙ]



###########
#### Part 2
start_pos = findall(x -> x ∈ ['S', 'a'], heightmap)
end_pos = findfirst(x -> x == 'E', heightmap)
x = start_pos[1][1] ## random first
y = start_pos[1][2] ## random first
xₙ = end_pos[1]
yₙ = end_pos[2]

### initiate
unvisited = fill(Inf, size(heightmap))
for i in start_pos  
    unvisited[i[1], i[2]] = 0
end
queue = [(i, j) for i in 1:size(heightmap)[1] for j in 1:size(heightmap)[2]]

## What is the fewest steps required to move starting from any square with elevation a to the location that should get the best signal?
unvisited_2 = getPathLenght(x, y, queue, unvisited)
unvisited_2[xₙ, yₙ]