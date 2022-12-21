###########
#### Data
fn = "_data/day14.txt"
f = open(fn, "r")
data  = readlines(f)
close(f)

## Parse data
rocks = []
rock_path = split.(data, " -> ")

for path in rock_path
    coord = split.(path, ",")
    n_coord = length(coord)

    println(coord)
    for i in 1:n_coord-1
        pos_1 = parse.(Int, coord[i])
        pos_2 = parse.(Int, coord[i+1])
        
        if pos_1[1] == pos_2[1]
            for y in collect(minimum([pos_1[2], pos_2[2]]):maximum([pos_1[2], pos_2[2]]))
                push!(rocks, (pos_1[1], y))
            end
        else
            for x in collect(minimum([pos_1[1], pos_2[1]]):maximum([pos_1[1], pos_2[1]]))
                push!(rocks, (x, pos_1[2]))
            end
        end
        
    end

    println()
end

###########
#### Part 1 

## coord of unique
rocks_unique = unique(rocks)
sand_x = (500, 0)
sand_count = 0
fall_in_void = false


#### make grid
rocks_x = [i[1] for i in rocks]
rocks_y = [i[2] for i in rocks]
mod = minimum(rocks_x) - 1

grid = Array{String, 2}(undef, maximum(rocks_y)+1, maximum(rocks_x)-minimum(rocks_x)+1)
fill!(grid, ".")

for r in rocks_unique
    grid[r[2]+1,r[1]%mod] = "#"
end

grid[1, 500%mod] = "+"
println.(join.(eachrow(grid)));
max_depth = size(grid)[1]
###################################

function fallTrajectory(pos::Tuple, hurdles::Matrix{String})
    ## straigth, left, right
    sand_traj = [(0, 1), (-1, 1), (1, 1)]
    for t in sand_traj
        tmp = pos .+ t
        if tmp[2]+1 <= max_depth && hurdles[tmp[2]+1, tmp[1]%mod] == "."
            return tmp
        end
    end

    ## if stuck
    return pos
end

while !fall_in_void
    prev_pos = fallTrajectory(sand_x, grid)
    stop = false

    while !stop
        pos = fallTrajectory(prev_pos, grid)

        if prev_pos != pos && pos[1] != max_depth
            prev_pos = pos
        else
            stop = true
        end
    end

    if pos[2]+1 != max_depth
        grid[pos[2]+1, pos[1]%mod] = "o"
        sand_count += 1
    else
        fall_in_void = true
    end
    
    if sand_count % 50 == 0
        println.(join.(eachrow(grid[1:40,:])))
        println()
    end
end

## Using your scan, simulate the falling sand. How many units of sand come to rest before sand starts flowing into the abyss below?
sand_count


###########
#### Part 2
sand_count = 0

#### init grid
max_depth = maximum(rocks_y)+1 + 2
grid = Array{String, 2}(undef, max_depth, 1000)
fill!(grid, ".")

for r in rocks_unique
    grid[r[2]+1,r[1]] = "#"
end

## Add floor
#grid[1, 500] = "+"
grid[max_depth, :] = repeat(["#"], size(grid)[2])
println.(join.(eachrow(grid[:, 480:550])));

function fallTrajectory2(pos::Tuple, hurdles::Matrix{String})
    ## straigth, left, right
    sand_traj = [(0, 1), (-1, 1), (1, 1)]
    for t in sand_traj
        tmp = pos .+ t
        if hurdles[tmp[2]+1, tmp[1]] == "."
            return tmp
        end
    end

    ## if stuck
    return pos
end

while grid[1,500] != "o"
    prev_pos = fallTrajectory2(sand_x, grid)
    stop = false

    while !stop
        pos = fallTrajectory2(prev_pos, grid)

        if prev_pos != pos && pos[1] != max_depth
            prev_pos = pos
        else
            stop = true
        end
    end

    grid[pos[2]+1, pos[1]] = "o"
    sand_count += 1

    if sand_count % 1000 == 0
        println.(join.(eachrow(grid[:, 475:585])))
        println()
    end
end

## Using your scan, simulate the falling sand. How many units of sand come to rest before sand starts flowing into the abyss below?
sand_count

