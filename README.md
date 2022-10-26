# PyData2022Talk

## Executing the code 

Prior to executing the code:
1. Install [Julia](https://julialang.org/) if you don't have it yet.
2. Open a terminal and clone the repo.
3. Go to the code directory. In Unix-like systems: `cd PyData2022Talk/code`
4. Execute `julia -t 4` to start a Julia session with 4 threads. 
5. Activate the Pkg manager by typing `]`
6. Run `activate .` and then `instantiate`

To execute the code **from the current julia session** run:
`include("knapsack.jl")`

The first time will take time. Dependencies must be built (JuMP may be a bit expensive!)
and the functions to execute compiled.

After the code has been run. You can give it another try by running:

`@time solve_problem_using_jump(knapsack_weight, items)`

or 

`@time solve_problem_using_dynamic_programming(knapsack_weight, items)`

To execute the code **as a script**, exit the current Julia session. You can do it
pressing `ctrl + d` or typing `exit()`. Then, run this in the terminal:

`julia --project=. -t 4 knapsack.jl`

Note that it is taking longer than the 2nd execution in the Julia session because
the code is compiled again.

## Understanding the output

The last lines printed on the screen look like this:
```
Result - Optimal solution found

Objective value:                563647.00000000
Enumerated nodes:               8
Total iterations:               27
Time (CPU seconds):             0.41
Time (Wallclock seconds):       0.33

Total time (CPU seconds):       0.41   (Wallclock seconds):       0.33

 10.997383 seconds (25.72 M allocations: 1.513 GiB, 5.84% gc time, 96.85% compilation time)
Solving problem with 4 threads
[optimal value]: 563647
  0.954701 seconds (292.42 k allocations: 24.318 MiB, 11.56% gc time, 10.26% compilation time)
```

Let's analyze them!

### Output when solving the problem using JuMP and CBC

```
Result - Optimal solution found

Objective value:                563647.00000000
Enumerated nodes:               8
Total iterations:               27
Time (CPU seconds):             0.41
Time (Wallclock seconds):       0.33

Total time (CPU seconds):       0.41   (Wallclock seconds):       0.33

 10.997383 seconds (25.72 M allocations: 1.513 GiB, 5.84% gc time, 96.85% compilation time)
```

The last line says that it has taken about 11 seconds to execute the function. However,
notice later in that line, it says that about 97% of the time was spent on the compilation.
It also says that about 6% of the time was spent by the Garbage Collector. As you can tell,
the numbers don't add up. Obviously, the measures were not very accurate. However, it is
clear that if we execute the function once more, the running time will be way much better (try it!).
Actually, the output of the solver says that we spent 0.33 seconds solving the problem.

### Output when solving the problem using Dynamic Programming

```
Solving problem with 4 threads
[optimal value]: 563647
  0.954701 seconds (292.42 k allocations: 24.318 MiB, 11.56% gc time, 10.26% compilation time)
```

Similar interpretation as before. However, this time, if you execute the function again,
although no compilation or time in the gc will be spent, the running will not improve. Why?
Because the number of allocations needed seems to dominate the running time.