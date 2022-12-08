###########
#### Data
fn = "_data/day05.txt"
f = open(fn, "r")
data  = readlines(f)
close(f)

function parseData(data::Vector{String})
    sep = findfirst(x -> x == "", data)

    raw_stacks = replace.(data[1:sep-2], "    " => "*")
    parsed_stacks = replace.(raw_stacks, " " => "", "[" => "", "]" => "")
    mtx_stacks = string.(reduce(vcat, permutedims.(collect.(parsed_stacks))))
    stacks = [reverse(filter(x -> x != "*", i)) for i in eachcol(mtx_stacks)]

    raw_moves = data[sep+1:end]
    parsed_moves = replace.(raw_moves, "move " => "", "from " => "", " to" => "")
    moves = parse.(Int64, reduce(vcat, permutedims.(split.(parsed_moves))))
    return stacks, moves
end

stacks, moves = parseData(data)

###########
#### Part 1
for spec in eachrow(moves)
    n, from, to = spec
    for i in 1:n 
        push!(stacks[to], stacks[from][end])
        pop!(stacks[from])
    end
end

## After the rearrangement procedure completes, what crate ends up on top of each stack?
join([i[end] for i in stacks])

###########
#### Part 2
stacks, moves = parseData(data)
for spec in eachrow(moves)
    n, from, to = spec
    append!(stacks[to], stacks[from][end-n+1:end])
    stacks[from] = stacks[from][1:end-n]
    end

## After the rearrangement procedure completes, what crate ends up on top of each stack?
join([i[end] for i in stacks])

