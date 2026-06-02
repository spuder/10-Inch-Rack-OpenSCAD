print_orientation=true;
cross_section_preview=true;
module keystone(
){
    e=0.01; // epsilon for coplanar face fixes, fixes bug where some faces leave a thin sliver of material
    wall=2.5;
    front_hole_width=14.9;
    front_hole_height=16.3;
    front_hole_z_offset=4.35;
    front_hole_lip=0;

    jack_width=front_hole_width+wall;
    jack_height=25;
    jack_depth=9.5;
    front_large_catch_depth=2.8;
    front_chamfer_angle=50; // degrees from horizontal (depth axis)

    back_hole_height=24.4;
    back_hole_z_offset=1.9;

    back_small_catch_length=1.9;
    back_small_catch_depth=1.4;

    back_large_catch_length=2.4;
    back_large_catch_depth=1.4;
    
    back_chamfer=1.2;

    //cut the hole out of the cube
    union(){
        difference(){
            // Make solid cube
            cube([jack_width+wall,jack_depth,jack_height+wall]);
        // Cut out the front hole
        translate([(jack_width+wall-front_hole_width)/2,0,front_hole_z_offset])
            color("blue")
            cube([front_hole_width,jack_depth+wall,front_hole_height]);
        // Cut out the back hole. It should be extruded to front_large_catch_depth
        translate([(jack_width+wall-front_hole_width)/2,front_large_catch_depth,back_hole_z_offset])
            color("red")
            cube([front_hole_width,jack_depth+wall-front_large_catch_depth,back_hole_height]);

        // Cut out chamfer on front face of small catch
        color("green")
        translate([wall + front_hole_width, 0, 0])
            rotate([0, -90, 0])
                linear_extrude(front_hole_width)
                    polygon([
                        [front_hole_z_offset + front_hole_height,                                                       front_hole_lip],  // A: front face, top of front hole
                        [front_hole_z_offset + front_hole_height + (front_large_catch_depth - front_hole_lip) * tan(front_chamfer_angle), front_large_catch_depth],  // B: angle-derived point
                        [front_hole_z_offset + front_hole_height,                                                       front_large_catch_depth]      // C: right-angle corner
                    ]);

        // Cut out chamefer on front face of large catch
        // color("orange")
        // translate([wall + front_hole_width, 0, 0])
        //     rotate([0, -90, 0])
        //         linear_extrude(front_hole_width)
        //             polygon([
        //                 [front_hole_z_offset+e, front_hole_lip],  // A: front face, bottom of front hole
        //                 [back_hole_z_offset,  front_large_catch_depth],     // B: inner ledge, bottom of back hole
        //                 [front_hole_z_offset, front_large_catch_depth]      // C: inner ledge, same Z as A
        //             ]);

        // Front directional triangle emboss (cut into face)
        color("yellow")
            translate([(jack_width+wall)/2, 0.4, (front_hole_z_offset + front_hole_height + jack_height + wall) / 2])
                rotate([90, 0, 0])
                    linear_extrude(height = 0.4+e)
                        polygon([
                            [0, -2],
                            [-2, 2],
                            [2, 2]
                        ]);

        // Chamfer back bottom edge (along X)
        translate([jack_width+wall+e, 0, -e])
            rotate([0, -90, 0])
                linear_extrude(jack_width+wall+2*e)
                    polygon([[-e, jack_depth+e], [back_chamfer, jack_depth+e], [-e, jack_depth-back_chamfer]]);

        // Chamfer back top edge (along X)
        translate([jack_width+wall+e, 0, -e])
            rotate([0, -90, 0])
                linear_extrude(jack_width+wall+2*e)
                    polygon([[jack_height+wall+2*e, jack_depth+e], [jack_height+wall+2*e-back_chamfer, jack_depth+e], [jack_height+wall+2*e, jack_depth-back_chamfer]]);

        // Chamfer back left edge (along Z)
        translate([0, 0, -e])
            linear_extrude(jack_height+wall+2*e)
                polygon([[-e, jack_depth+e], [back_chamfer, jack_depth+e], [-e, jack_depth-back_chamfer]]);

        // Chamfer back right edge (along Z)
        translate([0, 0, -e])
            linear_extrude(jack_height+wall+2*e)
                polygon([[jack_width+wall+e, jack_depth+e], [jack_width+wall+e-back_chamfer, jack_depth+e], [jack_width+wall+e, jack_depth-back_chamfer]]);

        } // end difference

        // Small back catch (added geometry)
        color("purple")
            translate([wall + front_hole_width, 0, 0])
                rotate([0, -90, 0])
                    linear_extrude(front_hole_width)
                        polygon([
                            [back_hole_z_offset + back_hole_height - back_small_catch_length, jack_depth - back_small_catch_depth],  // A
                            [back_hole_z_offset + back_hole_height,                           jack_depth - back_small_catch_depth],  // B
                            [back_hole_z_offset + back_hole_height,                           jack_depth],                           // C
                            [back_hole_z_offset + back_hole_height - back_small_catch_length, jack_depth]                            // D
                        ]);

        // Large back catch (added geometry)
        color("cyan")
            translate([wall + front_hole_width, 0, 0])
                rotate([0, -90, 0])
                    linear_extrude(front_hole_width)
                        polygon([
                            [back_hole_z_offset,                           jack_depth - back_large_catch_depth],  // A
                            [back_hole_z_offset + back_large_catch_length, jack_depth - back_large_catch_depth],  // B
                            [back_hole_z_offset + back_large_catch_length, jack_depth],                           // C
                            [back_hole_z_offset,                           jack_depth]                            // D
                        ]);

    } // end union
}


if ($preview) {
    if (cross_section_preview) {
        intersection() {
            keystone();
            cube([10, 35, 50]);
        }
    } else {
        keystone();
    }

} else {
    if (print_orientation) {
        rotate([90, 0, 0])
            keystone();
    } else {
        keystone();
    }
}
