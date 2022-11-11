using DataFrames
using StatsBase
using ProgressBars

function readInput(fn::String)
    path = "_data/$fn"

    f = open(path, "r")
        content = read(f, String)
    close(f)

    if occursin("\n", content)
        content = String.(split(content, "\n"))
    end

    return content
end

function parseInput_list(content::String, sep::String, dataType::String)
    tmp = split(content, sep)

    if dataType == "I"
        return parse.(Int64, tmp)
    elseif dataType == "F"
        return parse.(Float64, tmp)
    elseif dataType == "S"
        return String.(tmp)
    end
end