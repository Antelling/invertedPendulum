struct System
    support::Vector{Float64}
    ball::Vector{Float64}
    vel_x::Float64
    vel_theta::Float64
    DT::Float64
    iterations::Int64
end

struct ControlParams
    p::Float64
    i::Float64
    d::Float64
end

struct CubicControlParams
    p::Vector{Float64}
    i::Vector{Float64}
    d::Vector{Float64}
end

function make_cubic(params::Vector{Float64})
    return CubicControlParams(params[1:4], params[5:8], params[9:12])
end