using DataFrames
using ProgressBars

function readInput(fn::String)
    path = "_data/$fn"

    f = open(path, "r")
        content = read(f, String)
    close(f)

    return content
end

function parseInput_list(content::String, sep::String)
    tmp = split(content, sep)
    return parse.(Int64, tmp)
end