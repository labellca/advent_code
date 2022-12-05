include("../utils.jl")

### input
### heightmap of the floor of the nearby caves for you
fn = "2021_09.txt"
input = readInput(fn)
data = parseInput_Array(input)

function neighbours(mtx, pos_x, pos_y, X, Y)
    val_neighbours = []

    if pos_x != 1
        push!(val_neighbours, mtx[pos_x-1, pos_y])
    end
    if pos_x != X
        push!(val_neighbours, mtx[pos_x+1, pos_y])
    end
    if pos_y != 1
        push!(val_neighbours, mtx[pos_x, pos_y-1])
    end
    if pos_y != Y
        push!(val_neighbours, mtx[pos_x, pos_y+1])
    end

    return val_neighbours
end


X, Y= size(data)
risk_levels = []

for x in 1:X
    for y in 1:Y
        location = data[x, y]
        neighbour_heights = neighbours(data, x, y, X, Y)
        
        if sum(neighbour_heights .> location) == length(neighbour_heights)
            push!(risk_levels, location + 1)
        end
    end
end

sum_risk_levels = sum(risk_levels)
println("Part 1: What is the sum of the risk levels of all low points on your heightmap?")
println(sum_risk_levels)

### basin
### all locations that eventually flow downward to a single low point
### every low point is part of a basin
### location height 9 is never in a basin
### one location is part of a single basin
### size: number of locations within the basin (including low point)
function getHeight_up(data::Matrix{Int}, start_row::Int, col::Int)
    tmp_up = []
    for ri in start_row-1:-1:1
        if data[ri, col] == 9
            return tmp_up
        else
            push!(tmp_up, data[ri, col])
        end 
    end
    return tmp_up
end

function getHeight_down(data::Matrix{Int}, start_row::Int, col::Int)
    last_row = size(data)[1]

    tmp_down = []
    for ri in start_row+1:last_row
        if data[ri, col] == 9
            return tmp_down
        else
            push!(tmp_down, data[ri, col])
        end 
    end
    return tmp_down
end

function getHeight_left(data::Matrix{Int}, start_col::Int, row::Int)
    tmp_left = []
    for ci in start_col:-1:1
        if data[row, ci] == 9
            return tmp_left
        else
            #println(data[row, ci])
            push!(tmp_left, data[row, ci])
            #append!(tmp_left, getHeight_up(data, row, ci))
            #append!(tmp_left, getHeight_down(data, row, ci))
        end 
    end
    return tmp_left
end

function getHeight_right(data::Matrix{Int}, start_col::Int, row::Int)
    last_col = size(data)[2]

    tmp_right = []
    for ci in start_col+1:last_col
        if data[row, ci] == 9
            return tmp_right
        else
            push!(tmp_right, data[row, ci])
            #append!(tmp_right, getHeight_up(data, row, ci))
            #append!(tmp_right, getHeight_down(data, row, ci))
        end 
    end
    return tmp_right
end


basins_size = []

for x in 1:X
    for y in 1:Y
        location = data[x, y]
        neighbour_heights = neighbours(data, x, y, X, Y)
        
        if sum(neighbour_heights .> location) == length(neighbour_heights)
            tmp = []
            append!(tmp, getHeight_left(data, y, x))
            append!(tmp, getHeight_right(data, y, x))

            push!(basins_size, length(tmp))
        end
    end
end


data = parseInput_Array(input)

for x in 1:X
    for y in 1:Y

        

    end
end