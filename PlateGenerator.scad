// Rack Width 10 inch or 6 inch
rack_width = 254.0; // [ 254.0:10 inch, 152.4:6 inch]
// Height (measured in U)
rack_height = 1.0; // [0.5:0.5:5]
// Thickness of the front plate
front_thickness = 3.0;
// Radius for rounded corners on the front plate
corner_radius = 4.0;
half_height_holes = true; // [true:Show partial holes at edges, false:Hide partial holes]
//Adds additional strength
ribs = true; // [true:Show structural ribs, false:Hide structural ribs]
//Optional keystone jacks
keystones = 0; // [0:1:10]

/* [Hidden] */
height = 44.45 * rack_height;

tolerance = 0.42;

// Structural rib parameters
rib_thickness = 2.0;
rib_depth = 3.0;
rib_spacing = 15.0; // Distance between ribs
chamfer_size = 0.5; // Size of chamfer on rib edges

module keystone() {
    e=0.01;
    wall=2.5;
    front_hole_width=14.9;
    front_hole_height=16.3;
    front_hole_z_offset=4.28;
    front_hole_lip=0;

    jack_width=front_hole_width+wall;
    jack_height=25;
    jack_depth=9.7;
    front_large_catch_depth=3;
    front_chamfer_angle=50;

    back_hole_height=24.4;
    back_hole_z_offset=1.9;

    back_small_catch_length=2;
    back_small_catch_depth=1.4;

    back_large_catch_length=2.6;
    back_large_catch_depth=1.3;

    back_chamfer=1.2;

    translate([0, 0, jack_height + wall])
    mirror([0, 0, 1]) {
        union(){
            difference(){
                cube([jack_width+wall,jack_depth,jack_height+wall]);
                translate([(jack_width+wall-front_hole_width)/2,0,front_hole_z_offset])
                    cube([front_hole_width,jack_depth+wall,front_hole_height]);
                translate([(jack_width+wall-front_hole_width)/2,front_large_catch_depth,back_hole_z_offset])
                    cube([front_hole_width,jack_depth+wall-front_large_catch_depth,back_hole_height]);
                translate([wall + front_hole_width, 0, 0])
                    rotate([0, -90, 0])
                        linear_extrude(front_hole_width)
                            polygon([
                                [front_hole_z_offset + front_hole_height - e, front_hole_lip - e],
                                [front_hole_z_offset + front_hole_height + (front_large_catch_depth - front_hole_lip) * tan(front_chamfer_angle), front_large_catch_depth],
                                [front_hole_z_offset + front_hole_height - e, front_large_catch_depth]
                            ]);
                translate([jack_width+wall+e, 0, -e])
                    rotate([0, -90, 0])
                        linear_extrude(jack_width+wall+2*e)
                            polygon([[-e, jack_depth+e], [back_chamfer, jack_depth+e], [-e, jack_depth-back_chamfer]]);
                translate([jack_width+wall+e, 0, -e])
                    rotate([0, -90, 0])
                        linear_extrude(jack_width+wall+2*e)
                            polygon([[jack_height+wall+2*e, jack_depth+e], [jack_height+wall+2*e-back_chamfer, jack_depth+e], [jack_height+wall+2*e, jack_depth-back_chamfer]]);
                translate([0, 0, -e])
                    linear_extrude(jack_height+wall+2*e)
                        polygon([[-e, jack_depth+e], [back_chamfer, jack_depth+e], [-e, jack_depth-back_chamfer]]);
                translate([0, 0, -e])
                    linear_extrude(jack_height+wall+2*e)
                        polygon([[jack_width+wall+e, jack_depth+e], [jack_width+wall+e-back_chamfer, jack_depth+e], [jack_width+wall+e, jack_depth-back_chamfer]]);
                translate([(jack_width+wall)/2, 0.4, (front_hole_z_offset + front_hole_height + jack_height + wall) / 2])
                    rotate([90, 0, 0])
                        linear_extrude(height = 0.4+e)
                            polygon([[0, -2], [-2, 2], [2, 2]]);
            }
            translate([wall + front_hole_width, 0, 0])
                rotate([0, -90, 0])
                    linear_extrude(front_hole_width)
                        polygon([
                            [back_hole_z_offset + back_hole_height - back_small_catch_length, jack_depth - back_small_catch_depth],
                            [back_hole_z_offset + back_hole_height,                           jack_depth - back_small_catch_depth],
                            [back_hole_z_offset + back_hole_height,                           jack_depth],
                            [back_hole_z_offset + back_hole_height - back_small_catch_length, jack_depth]
                        ]);
            translate([wall + front_hole_width, 0, 0])
                rotate([0, -90, 0])
                    linear_extrude(front_hole_width)
                        polygon([
                            [back_hole_z_offset,                           jack_depth - back_large_catch_depth],
                            [back_hole_z_offset + back_large_catch_length, jack_depth - back_large_catch_depth],
                            [back_hole_z_offset + back_large_catch_length, jack_depth],
                            [back_hole_z_offset,                           jack_depth]
                        ]);
        }
    }
}

// The main module for the plate generator
module plate_generator() {
    $fn = 64;

    // Helper module for capsule-shaped slots (oval holes)
    module capsule_slot_2d(L, H) {
        hull() {
            translate([-L/2 + H/2, 0]) circle(r=H/2);
            translate([L/2 - H/2, 0]) circle(r=H/2);
        }
    }
    
    // Helper module for rounded rectangle
    module rounded_rect_2d(w, h, r) {
        hull() {
            translate([r, r]) circle(r=r);
            translate([w-r, r]) circle(r=r);
            translate([w-r, h-r]) circle(r=r);
            translate([r, h-r]) circle(r=r);
        }
    }
    
    // Helper module for simple chamfered rib (much faster)
    module chamfered_rib(width, thickness, depth, chamfer) {
        difference() {
            // Main rib body
            cube([width, thickness, depth]);
            
            // Large 45° chamfer to remove entire corner
            // Left end chamfer - dynamic positioning based on depth
            translate([depth - depth * 2, -tolerance, depth])
                rotate([0, 45, 0])
                    cube([depth * 1.5, thickness + 2*tolerance, depth * 1.5]);
            // Right end chamfer - dynamic positioning based on depth
            translate([width - depth + depth, -tolerance, 0])
                rotate([0, -45, 0])
                    cube([depth * 1.5, thickness + 2*tolerance, depth * 1.5]);
        }
    }

    // Create the main plate body
    module plate_body() {
        union() {
            // Main front plate
            linear_extrude(height = front_thickness) {
                rounded_rect_2d(rack_width, height, corner_radius);
            }
            // Structural ribs on the back (conditional)
            if (ribs) {
                structural_ribs();
            }
        }
    }
    
    // Create structural ribs within usable space constraints
    module structural_ribs() {
        // TODO: verify usable_width is correct
        //6 inch racks (mounts=152.4mm; rails=15.875mm; usable space=120.65mm)
        //10 inch racks (mounts=254.0mm; rails=15.875mm; usable space=221.5mm)
        // Use 90% of the usable width for safety margin
        usable_width = (rack_width == 152.4) ? 120.65 * 0.9 : 221.5 * 0.9;
        
        // Calculate rib positioning within usable space
        rib_start_x = (rack_width - usable_width) / 2;
        
        // Align bars with rack holes - same logic as hole positioning
        // Standard rack hole positions within each 1U (44.45mm) unit:
        // First hole: 6.35mm from top of U
        // Second hole: 22.225mm from top of U (middle)  
        // Third hole: 38.1mm from top of U (6.35mm from bottom)
        u_hole_positions = [6.35, 22.225, 38.1]; // positions within each U
        
        // Calculate maximum U units to consider - use same logic as holes
        max_u = ceil(rack_height);
        
        // Create ribs for each hole position that fits within the actual height
        for (u = [0:max_u-1]) {
            for (hole_pos = u_hole_positions) {
                // Calculate rib position from top of entire rack (same as hole logic)
                bar_y = height - (u * 44.45 + hole_pos);
                
                // Only create rib if the position is within the actual plate height
                // Use same logic as the holes: show if it fits within bounds
                if (bar_y >= rib_thickness/2 && bar_y <= height - rib_thickness/2) {
                    translate([rib_start_x, bar_y - rib_thickness/2, front_thickness]) {
                        chamfered_rib(usable_width, rib_thickness, rib_depth, chamfer_size);
                    }
                }
            }
        }
    }
    
    // Create all rack holes (copied from 10InchRackGenerator.scad)
    module all_rack_holes() {
        // Rack standard: 3 holes per U, with specific positioning
        // Each U is 44.45mm, holes are at specific positions within each U
        hole_spacing_x = (rack_width == 152.4) ? 136.526 : 236.525; // 6 inch : 10 inch rack
        hole_left_x = (rack_width - hole_spacing_x) / 2;
        hole_right_x = (rack_width + hole_spacing_x) / 2;

        // 10 inch rack = 10x7mm oval
        // 6 inch rack = 3.25 x 6.5mm oval
        slot_len = (rack_width == 152.4) ? 6.5 : 10.0;
        slot_height = (rack_width == 152.4) ? 3.25 : 7.0;

        // Standard rack hole positions within each 1U (44.45mm) unit:
        // First hole: 6.35mm from top of U
        // Second hole: 22.225mm from top of U (middle)
        // Third hole: 38.1mm from top of U (6.35mm from bottom)
        u_hole_positions = [6.35, 22.225, 38.1]; // positions within each U
        
        // Calculate how many full and partial U units we need to consider
        max_u = ceil(rack_height); // Include partial U units
        
        for (side_x = [hole_left_x, hole_right_x]) {
            for (u = [0:max_u-1]) {
                for (hole_pos = u_hole_positions) {
                    // Calculate hole position from top of entire rack
                    hole_y = height - (u * 44.45 + hole_pos);
                    // Always show holes that are at least partially within the rack height
                    // Always show holes fully inside the rack
                    fully_inside = (hole_y >= slot_height/2 && hole_y <= height - slot_height/2);
                    // Show partial holes at edge only if half_height_holes is true
                    partially_inside = (hole_y + slot_height/2 > 0 && hole_y - slot_height/2 < height);
                    show_hole = fully_inside || (half_height_holes && partially_inside && !fully_inside);
                    if (show_hole) {
                        translate([side_x, hole_y, 0]) {
                            linear_extrude(height = front_thickness + tolerance) {
                                capsule_slot_2d(slot_len, slot_height);
                            }
                        }
                    }
                }
            }
        }
    }

    // Keystone outer dimensions (must match keystone() module internals)
    // width = jack_width + wall = (14.9 + 2.5) + 2.5 = 19.9
    // height = jack_height + wall = 25 + 2.5 = 27.5
    ks_w = 19.9;
    ks_h = 27.5;
    ks_d = 9.7;

    // Rectangular cutouts through the plate face where keystone housings sit.
    // Required so the plate's solid material doesn't fill the keystone's internal holes.
    module keystone_cutouts() {
        if (keystones > 0) {
            for (i = [0:keystones-1]) {
                translate([
                    rack_width/2 - keystones*ks_w/2 + i*ks_w,
                    height/2 - ks_h/2,
                    -tolerance
                ])
                    cube([ks_w, ks_h, ks_d + 2*tolerance]);
            }
        }
    }

    // Keystone housings, front face flush with plate front (Z = 0).
    // rotate([90,0,0]) maps keystone depth (Y) to plate +Z, keystone height (Z) to plate -Y.
    module keystone_array() {
        if (keystones > 0) {
            for (i = [0:keystones-1]) {
                translate([
                    rack_width/2 - keystones*ks_w/2 + i*ks_w,
                    height/2 + ks_h/2,
                    0
                ])
                    rotate([90, 0, 0])
                        keystone();
            }
        }
    }

    // Main assembly
    translate([-rack_width/2, -height/2, 0]) {
        union() {
            difference() {
                plate_body();
                all_rack_holes();
                keystone_cutouts();
            }
            keystone_array();
        }
    }
}

if ($preview) {
    rotate([-90,0,0])
        translate([0, -height/2, -front_thickness/2])
            plate_generator();
} else {
    // Full render with details
    plate_generator();
}