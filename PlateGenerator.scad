rack_width = 254.0; // [ 254.0:10 inch, 152.4:6 inch]
rack_height = 1.0; // [0.5:0.5:5]
half_height_holes = true; // [true:Show partial holes at edges, false:Hide partial holes]
print_orientation = true; // [true: Place on printbed, false: Facing forward]
ribs = true; // [true:Show structural ribs, false:Hide structural ribs]

/* [Hidden] */
height = 44.45 * rack_height;
front_thickness = 3.0;
corner_radius = 4.0;
tolerance = 0.42;

// Structural rib parameters
rib_thickness = 2.0;
rib_depth = 3.0;
rib_spacing = 15.0; // Distance between ribs
chamfer_size = 0.5; // Size of chamfer on rib edges

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

    // Main assembly
    translate([-rack_width/2, -height/2, 0]) {
        difference() {
            plate_body();
            all_rack_holes();
        }
    }
}

// Call the module with print orientation
if (print_orientation) {
    plate_generator();
} else {
    rotate([-90,0,0])
        translate([0, -height/2, -front_thickness/2])
            plate_generator();
}