// Complete keystone with embossed triangle
module keystone(
    jack_length=16.5,
    jack_width=15,
    wall_height=10,
    wall_thickness=4,
    catch_overhang=2,
    big_clip_clearance=4,
    small_clip_clearance=6.5
) {
    small_clip_depth = catch_overhang;
    big_clip_depth = catch_overhang + 2;
    outer_length = jack_length + small_clip_depth + big_clip_depth + (wall_thickness * 2);
    outer_width = jack_width + (wall_thickness * 2);

    difference() { // This is the new, main difference() block
        union() {
            difference() {
                difference() {
                    difference() {
                        cube([outer_length, outer_width, wall_height]);
                        translate([wall_thickness, wall_thickness, big_clip_clearance]) {
                            cube([outer_length, jack_width, wall_height]);
                        }
                    }
                    translate([wall_thickness + small_clip_depth, wall_thickness, 0]) {
                        cube([jack_length, jack_width, wall_height + 1]);
                    }
                }
            }
            cube([wall_thickness, outer_width, wall_height]);
            cube([wall_thickness + small_clip_depth, outer_width, small_clip_clearance]);
            translate([2, 23, 8]) {
                rotate([90, 0, 0])
                    linear_extrude(height = outer_width)
                        polygon([
                            [0,0],
                            [catch_overhang,0],
                            [wall_thickness,catch_overhang],
                            [0,catch_overhang]
                        ]);
            }
            translate([26.5,0,0]) {
                cube([4, 23, 10]);
            }
            translate([28.5, 0, 8]) {
                rotate([0, 0, -180]) {
                    rotate([90, 0, 0])
                        linear_extrude(height = outer_width)
                            polygon([
                                [0,0],
                                [catch_overhang,0],
                                [wall_thickness,catch_overhang],
                                [0,catch_overhang]
                            ]);
                }
            }
        }
        
        // These are the new shapes to be subtracted
        translate([outer_length-5, outer_width/2, 0]) {
            rotate([0,0,90])
                linear_extrude(height = 0.4) {
                    polygon([
                        [0, 2],
                        [-2, -2],
                        [2, -2]
                    ]);
                }
        }
        
        // Removed the color() and rotate() from the original code since it was for debug.
        // It's still a good idea to comment out this section if you want to see the triangle itself.
        /*
        color("red")
            translate([outer_length-5, outer_width/2, 0]) {
                rotate([0,0,90])
                    linear_extrude(height = 2) {
                        polygon([
                            [0, 2],
                            [-2, -2],
                            [2, -2]
                        ]);
                    }
            }
        */
    }
}
keystone();