include("drawer.jl") #D
include("integrator.jl") #I
include("controller.jl") #C
include("structs.jl") #S

#system = I.S.System([50.0, 20.0], [50.0, 40.0], 0.0, 0.0, .000001, 50000)
system = S.System([50.0, 40.0], [60.0, 10.0], 0.0, 0.0, .000001, 50000)
prev_system = system

#params = S.ControlParams(0.00460598, -0.274369, 0.20111)
#params = S.make_cubic([1.28149, 0.335645, -1.23069, 1.0598, -0.725879, 1.06125, -1.29624, -0.865518, 0.650739, 1.72911, -0.649038, 0.448781])
#params = S.make_cubic([0.202568, 0.364594, -0.565889, 1.00253, -1.65327, -0.254008, -0.747381, 0.376003, 2.36398, 1.2085, -1.83218, 1.24284])
#params = S.make_cubic([-0.18247, -0.201492, 1.70912, -0.725726, -0.187275, -1.7406, -1.24264, 0.335829, 1.18052, 0.186649, -0.543023, 0.0599313])

#params for starting above
params = S.ControlParams([-17.0477, 3.28155e-5, -17.4022]...)
#params = S.make_cubic([-0.0126334, -0.022044, -17.05, 0.0165513, 0.0206449, -0.0184163, -0.00522583, 0.0133856, 0.0246477, -0.0104467, -17.3905, -0.00823554])


accumulated_error = 0.0
accel_x = 0.0

while true
    println("")
    prev_system = system
    system = I.euler_simulation(system, accel_x)
    println(system)
    accel_x, accumulated_error= C.support_controller(system, prev_system, params, accumulated_error)
    println(system)

    D.drawCircle(system.support[1], system.support[2], 5.0, [.2, .2, .2])
    D.drawLine(system.support[1], system.support[2], system.ball[1], system.ball[2], [1.0, 1.0, 1.0, .1])
    D.drawCircle(system.ball[1], system.ball[2], 2.0, [.4, .4, .4])

    diff = system.ball - system.support
    center_pos = [70.0, 70.0]
    ball_pos = center_pos + diff
    D.drawCircle(center_pos[1], center_pos[2], 5.0, [.9, .2, .2])
    D.drawLine(center_pos[1], center_pos[2], ball_pos[1], ball_pos[2], [1.0, 1.0, 1.0, .1])
    D.drawCircle(ball_pos[1], ball_pos[2], 2.0, [.4, .1, .9])

    D.resetFrame()
end
