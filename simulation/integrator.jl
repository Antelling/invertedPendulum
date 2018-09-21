module I
include("structs.jl") #S


function get_theta_accel(accel_x::Float64, length::Float64, angle::Float64)
    angle *= -1
    return -1 * ((accel_x/length)*cos(angle) + (-9.81/length)*sin(angle))
end

function euler_simulation(system, accel_x::Float64)
    #cairo graphing has an inverted y axis, so we need to invert it back
    ball::Vector{Float64} = [system.ball[1], system.ball[2] * -1]
    support::Vector{Float64} = [system.support[1], system.support[2] * -1]

    #we can't have unlimited acceleration
    max = 5
    accel_x = abs(accel_x) > max ? max * sign(accel_x) : accel_x

    diff = ball - support
    l = sqrt(sum(diff.^2))
    angle = atan2(diff[2], diff[1]) - 1.5*pi

    x = support[1]
    y = support[2]

    vel_x = system.vel_x
    vel_theta = system.vel_theta

    for _ in 0:system.iterations
        accel_angle = get_theta_accel(accel_x, l, angle)
        vel_theta += accel_angle * system.DT
        angle += vel_theta * system.DT

        vel_x += accel_x * system.DT
        x += vel_x * system.DT
    end

    ball = [x + l * sin(angle), -l*cos(angle) + y]
    support = [x, y]

    #we re-invert the y axis for graphing
    ball[2] *= -1
    support[2] *= -1
    return S.System(support, ball, vel_x, vel_theta, system.DT, system.iterations)
end
end
