using Gtk.ShortNames, Graphics
win = Window("Drawing")
c = canvas(UserUnit)       # create a canvas with user-specified coordinates
push!(win, c)