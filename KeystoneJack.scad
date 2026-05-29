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
    chamfer_lead = 2;
    chamfer_depth = 2;

    intersection() {
        // Chamfered outer envelope: full size up to chamfer_depth from the top,
        // then tapers inward so all four top edges get a 45° chamfer.
        hull() {
            cube([outer_length, outer_width, wall_height - chamfer_depth]);
            translate([chamfer_depth, chamfer_depth, wall_height - chamfer_depth])
                cube([outer_length - 2*chamfer_depth, outer_width - 2*chamfer_depth, chamfer_depth]);
        }

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
                
                // LEFT CATCH MECHANISM (Fixed Y-translation and height)
                translate([2, wall_thickness + jack_width, 8]) {
                    rotate([90, 0, 0])
                        linear_extrude(height = jack_width)
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
                
                // RIGHT CATCH MECHANISM (Fixed Y-translation and height)
                translate([28.5, wall_thickness, 8]) {
                    rotate([0, 0, -180]) {
                        rotate([90, 0, 0])
                            linear_extrude(height = jack_width)
                                polygon([
                                    [0,0],
                                    [catch_overhang,0],
                                    [wall_thickness,catch_overhang],
                                    [0,catch_overhang]
                                ]);
                    }
                }
            }
            
            // Embossed triangle on outer face
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

            // Lower: bottom edge (X=6,Z=big_clip_clearance), slope (4,4.5)→(6,6.5)
            hull() {
                // Top of the cut: bites into the solid wall to the right (+X direction)
                translate([wall_thickness + small_clip_depth + jack_length - 0.1, wall_thickness, big_clip_clearance - 0.1])
                    cube([chamfer_lead + 0.1, jack_width, 0.2]);
                
                // Bottom of the cut: tapers back to the flat inner vertical face
                translate([wall_thickness + small_clip_depth + jack_length - 0.1, wall_thickness, big_clip_clearance - chamfer_lead - 0.1])
                    cube([0.2, jack_width, chamfer_lead + 0.1]);
            }
            
            // Upper: top edge (X=6,Z=small_clip_clearance), slope (4,6.5)→(6,4.5)
            hull() {
                translate([wall_thickness + small_clip_depth - chamfer_lead, wall_thickness, small_clip_clearance - 0.1])
                    cube([chamfer_lead, jack_width, 0.2]);
                translate([wall_thickness + small_clip_depth, wall_thickness, small_clip_clearance - chamfer_lead - 0.1])
                    cube([0.2, jack_width, chamfer_lead + 0.1]);
            }
        }
    } // end intersection
}
keystone();