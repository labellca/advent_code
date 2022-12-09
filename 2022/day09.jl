###########
#### Data
fn = "_data/day09.txt"
f = open(fn, "r")
data  = readlines(f)
close(f)

motions = reduce(vcat, permutedims.(split.(data, " ")))

## the head (H) and tail (T) must always be touching 
##(diagonally adjacent and even overlapping both count as touching)
## (Δpos[1] == 2) !=  (Δpos[2] == 2) && 
function moveTail(head::Array{Int64}, tail::Array{Int64})
    Δpos = abs.(head .- tail)
    if 0 <= sum(Δpos) <= 2 && !(Δpos[1] == 2 || Δpos[2] == 2)
        ## touching
        return tail
    else
        if head[1] == tail[1] || head[2] == tail[2]
            ## 2 steps L, R, U or D
            if head[2] - tail[2] > 0 ## right
                return moveRight(tail)
            elseif head[2] - tail[2] < 0 ## left
                return moveLeft(tail)
            elseif head[1] - tail[1] < 0 ## up
                return moveUp(tail)
            else    ## down
                return moveDown(tail)
            end
        else
            ## not touching in diagonal
            return moveDiagonal(head, tail)
        end
    end
end

# moves the head right N steps
function moveRight(pos::Array{Int64})
    pos[2] += 1
    return pos
end

function moveLeft(pos::Array{Int64})
    pos[2] -= 1
    return pos
end

function moveUp(pos::Array{Int64})
    pos[1] -= 1
    return pos
end

function moveDown(pos::Array{Int64})
    pos[1] += 1
    return pos
end

function moveDiagonal(head::Array{Int64}, tail::Array{Int64})
    ## Up vs. Down
    if head[1] - tail[1] < 0 ## Up
        tail[1] -= 1
    else ## Down
        tail[1] += 1
    end

    ## Lef vs. Right
    if head[2] - tail[2] > 0
        tail[2] += 1 ## right
    else
        tail[2] -= 1 ## left
    end

    return tail
end


###########
#### Part 1
head = [0,0]
tail = [0,0]
tail_pos = []


for cmd in eachrow(motions)
    direction = string(cmd[1])
    steps = parse(Int64, cmd[2])
    println(direction, steps)
    println("====== H: ", head, "   T: ", tail)

    for n in 1:steps
        if direction == "R"
            head = moveRight(head)
        elseif direction == "L"
            head = moveLeft(head)
        elseif direction == "U"
            head = moveUp(head)
        else
            head = moveDown(head)
        end
        tail = moveTail(head, tail)
        push!(tail_pos, copy(tail))
        println("==($n)== H: ", head, "   T: ", tail)
    end
end

## How many positions does the tail of the rope visit at least once?
unique(tail_pos) |> length


###########
#### Part 2
knots = zeros(Int64, 10, 2)
knots_pos = []

for cmd in eachrow(motions)
    direction = string(cmd[1])
    steps = parse(Int64, cmd[2])
    println(direction, steps)
    println("====== H: ", knots[1,:],)

    for n in 1:steps
        if direction == "R"
            knots[1,:] = moveRight(knots[1,:])
        elseif direction == "L"
            knots[1,:] = moveLeft(knots[1,:])
        elseif direction == "U"
            knots[1,:] = moveUp(knots[1,:])
        else
            knots[1,:] = moveDown(knots[1,:])
        end
        

        for i in 2:10
            #println(knots[i-1,:], " ", knots[i,:])
            knots[i,:] = moveTail(knots[i-1,:], knots[i,:])
        end

        if knots[10,:] ∉ knots_pos
            push!(knots_pos, copy(knots[10,:]))
        end
        println("==($n)== H: ", knots[1,:], " ", knots[2,:], " ", knots[3,:], " ", knots[4,:], " ", knots[5,:], " ", knots[6,:], " ", knots[7,:], " ", knots[8,:], " ", knots[9,:], "   T: ", knots[10,:])
    end
end

## How many positions does the tail of the rope visit at least once?
length(knots_pos)