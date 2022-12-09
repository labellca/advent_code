###########
#### Data
fn = "_data/day07.txt"
f = open(fn, "r")
data  = readlines(f)
close(f)

filesystem = DataFrame(parent=[""], name=["/"], size=[0])
pwd = ""

for line in data 
    cmd = split(line, " ")

    ### Change directory
    if cmd[1] == "\$"
        if cmd[2] == "cd"
            if cmd[3] == ".."
                idx = findall("/", pwd)[end-1][1]
                pwd = pwd[1:idx]
            elseif cmd[3] == "/"
                pwd = "/"
            else
                pwd = pwd*cmd[3]*"/"
            end
        end

    ### Dir
    elseif cmd[1] == "dir"
        push!(filesystem, [pwd, pwd*cmd[2]*"/", 0])

    ### File
    else 
        push!(filesystem, [pwd, pwd*cmd[2], parse(Int64, cmd[1])])
    end
end

###########
#### Part 1
## Calculate size
parent_dir = unique(filesystem.parent)
parent_sorted = parent_dir[sortperm(length.(parent_dir), rev=true)]

for d in parent_sorted
    dir_content = filter(:parent => x -> x == d, filesystem)
    dir_size = sum(dir_content.size)
    filesystem[filesystem.name .== d, :size] .= [dir_size]
end

## Dir subset
dir_subset = filter(:name => x -> x ∈ parent_dir, filesystem)

## Find all of the directories with a total size of at most 100000. What is the sum of the total sizes of those directories?
sum(dir_subset[dir_subset.size .<= 100000, :size])


###########
#### Part 1
M = 70000000
total_needed = 30000000

total_used = dir_subset[dir_subset.name .== "/", :size][1]
total_unused = M - total_used
must_free = total_needed - total_unused

## Find the smallest directory that, if deleted, would free up enough space on the filesystem to run the update. What is the total size of that directory?
minimum(filesystem[filesystem.size .>= must_free, :size])