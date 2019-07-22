module D

using Graphics, Gtk

win = Gtk.@Window("Test", 1000, 1000) #define a window
c = Gtk.Canvas(win)
Gtk.pack(c, expand=true, fill="both") #make the canvas object fill the window
ctx = Gtk.getgc(c) #get the graphics context

#set up the coordinates to go from 0 to 100
Graphics.set_coordinates(ctx, 0, 0, 1000, 1000, 0, 100, 0, 100)

Cairo.set_line_width(ctx, 1)

Cairo.Cairo.set_source_rgb(ctx, 0, 0, 0)
Cairo.paint(ctx)

function drawCircle(x::Float64, y::Float64, r::Float64, color::Array{Float64,1})
    Cairo.arc(ctx, x, y, r, 0, 2pi)
    Cairo.set_source_rgb(ctx, 1, 1, 1)
    Cairo.stroke_preserve(ctx)
    Cairo.set_source_rgb(ctx, color[1], color[2], color[3])
    Cairo.fill(ctx)
end

function drawLine(start_x::Float64, start_y::Float64, end_x::Float64, end_y::Float64, color::Vector{Float64})
    Cairo.move_to(ctx, start_x, start_y)
    Cairo.line_to(ctx, end_x, end_y)

    Cairo.set_source_rgba(ctx, color[1], color[2], color[3], color[4])
    Cairo.stroke(ctx)
end

function resetFrame()
    Gtk.reveal(c)

    Cairo.Cairo.set_source_rgba(ctx, 0, 0, 0, .01)
    Cairo.paint(ctx) # paint the entire clip region
end


export drawCircle, resetFrame
end
