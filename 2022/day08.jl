###########
#### Data
fn = "_data/day08.txt"
f = open(fn, "r")
data  = readlines(f)
close(f)

tree_map = parse.(Int64, reduce(vcat, permutedims.(collect.(data))))
N = size(tree_map)[1]
count_visible = N*4-4

###########
#### Part 1
for r in 2:N-1
    for c in 2:N-1
        tree = tree_map[r, c]
        if sum(tree .<= tree_map[r, 1:c-1]) == 0
            count_visible += 1
        elseif sum(tree .<= tree_map[r, c+1:end]) == 0
            count_visible += 1
        elseif sum(tree .<= tree_map[1:r-1, c]) == 0
            count_visible += 1
        elseif sum(tree .<= tree_map[r+1:end, c]) == 0
            count_visible += 1
        end
    end
end

## Consider your map; how many trees are visible from outside the grid?
count_visible

###########
#### Part 2
function getNbTree(view::BitVector)
    if sum(view) == 0
        return length(view)
    else
        return findfirst(x -> x == 1, view)[1]
    end
end

scenic_score = []
for r in 2:N-1
    for c in 2:N-1
        tree = tree_map[r, c]
        tree_score = 1
        
        tree_score *= getNbTree(reverse(tree .<= tree_map[r, 1:c-1]))
        tree_score *= getNbTree(tree .<= tree_map[r, c+1:end])
        tree_score *= getNbTree(reverse(tree .<= tree_map[1:r-1, c]))
        tree_score *= getNbTree(tree .<= tree_map[r+1:end, c])

        push!(scenic_score, tree_score)
    end
end

maximum(scenic_score)