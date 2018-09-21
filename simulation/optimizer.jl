include("integrator.jl") #I
include("controller.jl") #C
include("structs.jl") #S

using Distributions: Normal, Uniform


#we need a heuristic and an optimizer
orig_system = S.System([50.0, 20.0], [50.0, 40.0], 0.0, 0.0, .000001, 50000)
orig_system = S.System([50.0, 40.0], [60.0, 10.0], 0.0, 0.0, .001, 50)

function heuristic(params::Vector{Float64}, system::S.System)::Float64
    #params = S.ControlParams(params...)
    params = S.make_cubic(params)
    total = 0.0
    accel_x = 0.0
    accumulated_error = 0.0
    for _ in 1:2000
        prev_system = system
        system = I.euler_simulation(system, accel_x)
        accel_x, accumulated_error= C.support_controller(system, prev_system, params, accumulated_error)

        diff = system.ball - system.support
        angle = C.determine_angle(-1 * diff[2], diff[1])
        total += abs(angle)
    end
    return total
end

function random_walk(start_params::Vector{Float64}, system::S.System; variance=.01, trials=50)::Vector{Float64}
    best_score = heuristic(start_params, system)
    best_params = start_params
    tries = 0
    d = Normal(0, variance)
    while tries < trials
        tries += 1
        #new_params = rand(d, 3) + best_params
        new_params = rand(d, 12) + best_params
        new_score = heuristic(new_params, system)
        println(new_score)
        if new_score < best_score
            println("$(new_params): $(new_score)")
            best_score = new_score
            best_params = new_params
            tries = 0
        end
    end
    return best_params
end

function jitter_walk(start_params::Vector{Float64}, system::S.System; variance=.01, trials=50)::Vector{Float64}
    best_score = heuristic(start_params, system)
    best_params = start_params
    tries = 0
    d = Normal(0, variance)
    while tries < trials
        tries += 1
        jitter_index = rand(1:12)
        jitter_value = rand(d)
        new_params = copy(best_params)
        new_params[jitter_index] += jitter_value
        new_score = heuristic(new_params, system)
        println(new_score)
        if new_score < best_score
            println("$(new_params): $(new_score)")
            best_score = new_score
            best_params = new_params
            tries = 0
        end
    end
    return best_params
end

function random_search(orig_system::S.System; trials::Int64=50)::Vector{Float64}
    d = Uniform(-30, 30)
    best_score = 9999999.0
    #best_params = Vector{Float64}(3)
    best_params = Vector{Float64}(12)
    for _ in 1:trials
        #params = random_walk(rand(d, 3), system, trials=10)
        #params = random_walk(rand(d, 12), system, trials=10)
        params = rand(d, 12)
        system = deepcopy(orig_system)
        score = heuristic(params, system)
        if score < best_score
            best_score = score
            best_params = params
            println("$(score): $(params)")
        end
    end
    return best_params
end

#new_params = random_search(orig_system; trials=500000)
#new_params = random_walk([-0.18247, -0.201492, 1.70912, -0.725726, -0.187275, -1.7406, -1.24264, 0.335829, 1.18052, 0.186649, -0.543023, 0.0599313], system)
#new_params = random_walk([0.40708, -0.939618, -0.27659, -0.930071, -0.909913, 0.790865, -0.346741, 0.401887, -0.0816204, -0.182697, -1.57678, -0.703714], system, trials=5000)#
new_params = random_walk([0.0, 0.0, -17.0477, 0.0,  0.0, 0.0, 0.0, 0.0,  0.0, 0.0, -17.4022, 0.0], orig_system, trials=400)

println(new_params)
