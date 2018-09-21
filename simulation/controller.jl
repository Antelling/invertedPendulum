module C
include("integrator.jl") #I
push!(LOAD_PATH, (join(split(Base.source_path(), "/")[1:end-1], "/")))
using structs

function determine_angle(y::Float64, x::Float64)
    n = atan2(y, x) - .5*pi
    if abs(n) > pi
        n = (2*pi - abs(n)) * -1 * sign(n)
    end
    return n
end

function pid_controller(value::Float64, prev_value::Float64, accumulated_error::Float64, params, DT::Float64)
    accumulated_error += value * DT
    deriv = (value-prev_value)/DT

    p_adj = value * params.p
    i_adj = accumulated_error * params.i
    d_adj = deriv * params.d

    return p_adj + i_adj + d_adj, accumulated_error
end

function cubic(a::Float64, b::Float64, c::Float64, d::Float64, x::Float64)
    return a*x^3 + b*x^2 + c*x + d
end

function cubic_pid_controller(value::Float64, prev_value::Float64, accumulated_error::Float64, params, DT::Float64)
    accumulated_error += value * DT
    deriv = (value-prev_value)/DT

    p = cubic(params.p..., value)
    i = cubic(params.i..., accumulated_error)
    d = cubic(params.d..., deriv)

    return p + i + d, accumulated_error
end

#module I must be provided by the file that includes this file
function support_controller(system, prev_system, params, accumulated_error::Float64)
    angles::Vector{Float64} = []
    for sb in [[system.support, system.ball], [prev_system.support, prev_system.ball]]
        sb = sb
        s = sb[1]
        b = sb[2]
        b[2] *= -1
        s[2] *= -1

        diff = b - s
        angle = determine_angle(diff[2], diff[1])
        append!(angles, angle)

        b[2] *= -1
        s[2] *= -1
    end
    if isa(params.p, Float64)
        return pid_controller(angles[1], angles[2], accumulated_error, params, system.DT * system.iterations)
    else
        return cubic_pid_controller(angles[1], angles[2], accumulated_error, params, system.DT * system.iterations)
    end
end

export ControlParams, support_controller
end
