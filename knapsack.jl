
# Instances at http://artemisa.unicauca.edu.co/~johnyortega/instances_01_KP/

using JuMP
using Cbc

include("reader.jl")

function solve_problem_using_jump(knapsack_weight::Int, items::Vector{Item})
    model = Model(Cbc.Optimizer)
    set_optimizer_attribute(model, "logLevel", 1)

    n_items = length(items)
    @variable(model, x[i=1:n_items], Bin)

    @constraint(model, sum(items[i].weight * x[i] for i in 1:n_items)
                       ≤ # This is not the font, but syntax supported by Julia!
                       knapsack_weight)

    @objective(model, Max, sum(items[i].value * x[i] for i in 1:n_items))
    optimize!(model)
end

function solve_problem_using_dynamic_programming(knapsack_weight::Int, items::Vector{Item})
    println("Solving problem with ", Threads.nthreads(), " threads")
    n_items = length(items)
    n_weights = knapsack_weight + 1
    accumulated_value = zeros(Int, n_weights)
    current_value = zeros(Int, n_weights)

    for i in 1:n_items
        Threads.@threads for j in 1:n_weights
            weight_left_in_knapsack = j - 1
            δ = weight_left_in_knapsack - items[i].weight
            if δ ≥ 0
                j₂ = δ + 1
                val_if_taking_the_item = accumulated_value[j₂] + items[i].value
                current_value[j] = max(accumulated_value[j], val_if_taking_the_item)
            end
        end
        accumulated_value .= current_value
    end

    println("[optimal value]: ", current_value[end])
end


# path_to_file = "./data/f2_l-d_kp_20_878"
path_to_file = "./data/knapPI_1_10000_1000"

knapsack_weight, items = get_problem_data(path_to_file)

@time solve_problem_using_jump(knapsack_weight, items)
@time solve_problem_using_dynamic_programming(knapsack_weight, items)
