
struct Item
    weight::Int
    value::Int
end


function _get_n_items_and_knapsack_weight(file::IOStream)
    line = readline(file)
    line_split = split(line, " ")
    n_items = parse(Int, line_split[1])
    knapsack_weight = parse(Int, line_split[2])
    return n_items, knapsack_weight
end


function get_problem_data(path_to_file::String)
    file = open(path_to_file)
    n, knapsack_weight = _get_n_items_and_knapsack_weight(file)
    items = Vector{Item}(undef, n)
    for i in 1:n
        line = readline(file)
        line_split = split(line, " ")
        value = parse(Int, line_split[1])
        weight = parse(Int, line_split[2])
        items[i] = Item(weight, value)
    end
    return knapsack_weight, items
end
