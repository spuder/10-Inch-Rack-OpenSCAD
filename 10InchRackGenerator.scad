rack_width = 254.0; // [ 254.0:10 inch, 152.4:6 inch]
rack_height = 1.0; // [0.5:0.5:5]
half_height_holes = true; // [true:Show partial holes at edges, false:Hide partial holes]

switch_width = 194.20;
switch_depth = 200.20;
switch_height = 29.30;


front_wire_holes = false; // [true:Show front wire holes, false:Hide front wire holes]
air_holes = true; // [true:Show air holes, false:Hide air holes]
print_orientation = true; // [true: Place on printbed, false: Facing forward]

/* [Hidden] */
height = 44.45 * rack_height;


// The main module containing all internal variables
module switch_mount(switch_width, switch_height, switch_depth) {
    //6 inch racks (mounts=152.4mm; rails=15.875mm; usable space=120.65mm)
    //10 inch racks (mounts=254.0mm; rails=15.875mm; usable space=221.5mm)
    chassis_width = min(switch_width + 12, (rack_width == 152.4) ? 120.65 : 221.5);
    front_thickness = 3.0;
    corner_radius = 4.0;
    chassis_edge_radius = 2.0;
    tolerance = 0.42;

    zip_tie_hole_count = 8;
    zip_tie_hole_width = 1.5;
    zip_tie_hole_length = 5;
    zip_tie_indent_depth = 2;
    zip_tie_cutout_depth = 7;

    chassis_depth_main = switch_depth + zip_tie_cutout_depth;
    chassis_depth_indented = chassis_depth_main - zip_tie_indent_depth;

    hole_total_width = zip_tie_hole_count * zip_tie_hole_width;
    space_between_holes = (rack_width - hole_total_width) / (zip_tie_hole_count + 1);

    $fn = 64;

    // Calculated dimensions
    cutout_w = switch_width + (2 * tolerance);
    cutout_h = switch_height + (2 * tolerance);
    cutout_x = (rack_width - cutout_w) / 2;
    cutout_y = (height - cutout_h) / 2;
    
    // Helper modules
    module capsule_slot_2d(L, H) {
        hull() {
            translate([-L/2 + H/2, 0]) circle(r=H/2);
            translate([L/2 - H/2, 0]) circle(r=H/2);
        }
    }
    
    module rounded_rect_2d(w, h, r) {
        hull() {
            translate([r, r]) circle(r=r);
            translate([w-r, r]) circle(r=r);
            translate([w-r, h-r]) circle(r=r);
            translate([r, h-r]) circle(r=r);
        }
    }

    module rounded_chassis_profile(width, height, radius, depth) {
        hull() {
            translate([radius, radius, 0]) cylinder(h = depth, r = radius);
            translate([width - radius, radius, 0]) cylinder(h = depth, r = radius);
            translate([radius, height - radius, 0]) cylinder(h = depth, r = radius);
            translate([width - radius, height - radius, 0]) cylinder(h = depth, r = radius);
        }
    }
    
    // Create the main body as a separate module
    module main_body() {
        side_margin = (rack_width - chassis_width) / 2;
        chassis_height = switch_height + 12;
        union() {
            // Front panel
            linear_extrude(height = front_thickness) {
                rounded_rect_2d(rack_width, height, corner_radius);
            }
            // Chassis body
            translate([side_margin, (height - chassis_height) / 2, front_thickness]) {
                rounded_chassis_profile(chassis_width, chassis_height, chassis_edge_radius, chassis_depth_main - front_thickness);
            }
        }
    }
    
    // Create switch cutout with proper lip
    module switch_cutout() {
        lip_thickness = 1.2;
        lip_depth = 0.60;
        // Main cutout minus lip (centered)
        translate([
            (rack_width - (cutout_w - 2*lip_thickness)) / 2,
            (height - (cutout_h - 2*lip_thickness)) / 2,
            -tolerance
        ]) {
            cube([cutout_w - 2*lip_thickness, cutout_h - 2*lip_thickness, chassis_depth_main]);
        }

        // Switch cutout above the lip (centered)
        translate([
            (rack_width - cutout_w) / 2,
            (height - cutout_h) / 2,
            lip_depth
        ]) {
            cube([cutout_w, cutout_h, chassis_depth_main]);
        }
    }
    
    // Create all rack holes
    module all_rack_holes() {
        // Rack standard: 3 holes per U, with specific positioning
        // Each U is 44.45mm, holes are at specific positions within each U
        hole_spacing_x = (rack_width == 152.4) ? 136.526 : 236.525; // 6 inch : 10 inch rack
        hole_left_x = (rack_width - hole_spacing_x) / 2;
        hole_right_x = (rack_width + hole_spacing_x) / 2;

        // 10 inch rack = 10x7mm oval
        // 6 inchr rack = 3.25 x 6.5mm oval
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
                            linear_extrude(height = chassis_depth_main) {
                                capsule_slot_2d(slot_len, slot_height);
                            }
                        }
                    }
                }
            }
        }
    }

    // Power wire cutouts: 5mm diameter holes at top and bottom rack hole positions
    module power_wire_cutouts() {
        hole_spacing_x = switch_width; // match rack holes
        hole_diameter = 7;
        hole_left_x = (rack_width - hole_spacing_x) / 2 - (hole_diameter /5);
        hole_right_x = (rack_width + hole_spacing_x) / 2 + (hole_diameter /5);
        // Midplane of switch opening
        mid_y = (height - switch_height) / 2 + switch_height / 2;
        for (side_x = [hole_left_x, hole_right_x]) {
            translate([side_x, mid_y, 0]) {
                linear_extrude(height = chassis_depth_main) {
                    circle(d=hole_diameter);
                }
            }
        }
    }
    
    // Create zip tie holes and indents
    module zip_tie_features() {
        // Zip tie holes
        for (i = [0:zip_tie_hole_count-1]) {
            x_pos = (rack_width - switch_width)/2 + (switch_width/(zip_tie_hole_count+1)) * (i+1);
            translate([x_pos, 0, switch_depth]) {
                cube([zip_tie_hole_width, height, zip_tie_hole_length]);
            }
        }
        
        // Zip tie indents (top and bottom)
        x_pos = (rack_width - switch_width)/2;
        chassis_height = switch_height + 12;
        // Bottom indent
        translate([x_pos, (height - chassis_height)/2, switch_depth]) {
            cube([switch_width, zip_tie_indent_depth, zip_tie_cutout_depth]);
        }
        // Top indent
        translate([x_pos, (height + chassis_height)/2 - zip_tie_indent_depth, switch_depth]) {
            cube([switch_width, zip_tie_indent_depth, zip_tie_cutout_depth]);
        }
    }

   // Hexagonal tessellation air holes with proper spacing for pointy-side-up hexagons
    module air_holes() {
        hole_d = 16;
        
        // For true hexagonal tessellation (like honeycomb):
        // Each hexagon should be surrounded by 6 others at equal distances
        // With pointy-side-up orientation, we need:
        center_distance = hole_d * 1.1;  // Distance between hexagon centers (adjust this for density)
        
        // Convert to rectangular grid coordinates:
        spacing_x = center_distance * 0.5;
        spacing_z = center_distance * 0.866025; // sqrt(3)/2
        
        margin = 3; // Keep holes away from edges
        
        // BACK FACE HOLES (Y-axis through back)
        available_width = switch_width - (2 * margin);
        available_depth = switch_depth - (2 * margin);
        
        x_cols = floor(available_width / spacing_x);
        z_rows = floor(available_depth / spacing_z);
        
        actual_grid_width = (x_cols - 1) * spacing_x;
        actual_grid_depth = (z_rows - 1) * spacing_z;
        
        cutout_center_x = rack_width / 2;
        cutout_center_z = front_thickness + switch_depth / 2;
        
        x_start = cutout_center_x - actual_grid_width / 2;
        z_start = cutout_center_z - actual_grid_depth / 2;
        
        if (x_cols > 0 && z_rows > 0) {
            for (i = [0:x_cols-1]) {
                for (j = [0:z_rows-1]) {
                    // Alternate columns are offset by half a row spacing
                    z_offset = (i % 2 == 1) ? spacing_z * 1 : 0;
                    x_pos = x_start + i * spacing_x;
                    z_pos = z_start + j * spacing_z * 2 + z_offset;  // Use 2x spacing for rows
                    
                    if (z_pos + hole_d/2 <= cutout_center_z + switch_depth/2 - margin && 
                        z_pos - hole_d/2 >= cutout_center_z - switch_depth/2 + margin) {
                        translate([x_pos, height, z_pos]) {
                            rotate([90, 30, 0]) {
                                cylinder(h = height, d = hole_d, $fn = 6);
                            }
                        }
                    }
                }
            }
        }
        
        // SIDE FACE HOLES (X-axis through left and right sides)
        chassis_width = min(switch_width + 12, (rack_width == 152.4) ? 120.65 : 221.5);
        side_margin = (rack_width - chassis_width) / 2;
        
        available_height = switch_height - (2 * margin);
        available_side_depth = switch_depth - (2 * margin);
        
        // Side faces need different spacing due to 90-degree rotation
        // Try values between the extremes that caused overlap vs large gaps
        side_spacing_y = spacing_x * 1;  // Between 0.5 (too close) and 1.2 (too far)
        side_spacing_z = spacing_z * 1;   // Between 0.866 (overlap) and 1.2 (too far)
        
        y_cols = floor(available_height / side_spacing_y);
        z_rows_side = floor(available_side_depth / side_spacing_z);
        
        actual_grid_height = (y_cols - 1) * side_spacing_y;
        actual_grid_depth_side = (z_rows_side - 1) * side_spacing_z;
        
        cutout_center_y = height / 2;
        
        y_start = cutout_center_y - actual_grid_height / 2;
        z_start_side = cutout_center_z - actual_grid_depth_side / 2;
        
        if (y_cols > 0 && z_rows_side > 0) {
            for (side = [0, 1]) {
                side_x = side == 0 ? side_margin : rack_width - side_margin;
                
                for (i = [0:y_cols-1]) {
                    for (j = [0:z_rows_side-1]) {
                        z_offset = (i % 2 == 1) ? side_spacing_z : 0;  // Use full spacing offset
                        y_pos = y_start + i * side_spacing_y;
                        z_pos = z_start_side + j * side_spacing_z * 2 + z_offset;  // Use 2x spacing like back face
                        
                        if (z_pos + hole_d/2 <= cutout_center_z + switch_depth/2 - margin && 
                            z_pos - hole_d/2 >= cutout_center_z - switch_depth/2 + margin) {
                            translate([side_x, y_pos, z_pos]) {
                                rotate([0, 90, 0]) {
                                    rotate([0, 0, 30]) {
                                        cylinder(h = chassis_width, d = hole_d, $fn = 6);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Main assembly - cleaner boolean structure
    translate([-rack_width/2, -height/2, 0]) {
        difference() {
            main_body();
            union() {
                switch_cutout();
                all_rack_holes();
                zip_tie_features();
                if (front_wire_holes) {
                    power_wire_cutouts();
                }
                if (air_holes) {
                    air_holes();
                }
            }
        }
    }
}

// Call the module
if (print_orientation) {
    switch_mount(switch_width, switch_height, switch_depth);
} else {
    rotate([-90,0,0])
        translate([0, -height/2, -switch_depth/2])
            switch_mount(switch_width, switch_height, switch_depth);
}