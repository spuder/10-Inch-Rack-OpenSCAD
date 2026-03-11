rack_width = 254.0; // [ 254.0:10 inch, 152.4:6 inch]
rack_height = 4.0; // [0.5:0.5:5]
half_height_holes = true; // [true:Show partial holes at edges, false:Hide partial holes]

switch_width = 190.0;
switch_depth = 135.0;
switch_height = 28.30;
switch_count = 3; // Number of switches to stack

case_thickness = 6; // Thickness of case walls
wire_diameter = 7; // Diameter of power wire holes
zip_tie_hole_width = 1.5; // Width of zip tie slots

front_wire_holes = false; // [true:Show front wire holes, false:Hide front wire holes]
air_holes = true; // [true:Show air holes, false:Hide air holes]
print_orientation = true; // [true: Place on printbed, false: Facing forward]
tolerance = 0.42;

/* [Hidden] */
// Calculate required height based on switch count
function calc_required_height(count, sw_height, tolerance, case_thickness) = 
    let(
        wall_thickness = case_thickness,
        divider_thickness = case_thickness,
        required_height = (2 * wall_thickness) + (count * sw_height) + ((count - 1) * divider_thickness)
    ) required_height;

// Adjust rack_height if necessary
function adjust_rack_height(count, sw_height, tolerance, current_rack_height, half_height, case_thickness) =
    let(
        required_height = calc_required_height(count, sw_height, tolerance, case_thickness),
        required_u = required_height / 44.45
    )
    (count > 1 && required_u > current_rack_height) ?
        (half_height ? required_u : ceil(required_u)) :
        current_rack_height;

adjusted_rack_height = adjust_rack_height(switch_count, switch_height, tolerance, rack_height, half_height_holes, case_thickness);
height = 44.45 * adjusted_rack_height;


// The main module containing all internal variables
module switch_mount(switch_width, switch_height, switch_depth, switch_count, case_thickness, wire_diameter) {
    //6 inch racks (mounts=152.4mm; rails=15.875mm; usable space=120.65mm)
    //10 inch racks (mounts=254.0mm; rails=15.875mm; usable space=221.5mm)
    
    // Standard chassis width based on switch width
    standard_chassis_width = switch_width + (2 * case_thickness);
    
    // Maximum allowed chassis width based on rack size
    max_chassis_width = (rack_width == 152.4) ? 120.65 : 221.5;
    
    // Choose chassis width: don't exceed rack limits
    chassis_width = min(standard_chassis_width, max_chassis_width);
    
    front_thickness = 3.0;
    corner_radius = 4.0;
    chassis_edge_radius = 2.0;
    tolerance = 0.42;

    zip_tie_hole_count = 8;
    zip_tie_hole_length = 5;
    zip_tie_indent_depth = 2;
    zip_tie_cutout_depth = 7;

    chassis_depth_main = switch_depth + zip_tie_cutout_depth;
    chassis_depth_indented = chassis_depth_main - zip_tie_indent_depth;

    hole_total_width = zip_tie_hole_count * zip_tie_hole_width;
    space_between_holes = (rack_width - hole_total_width) / (zip_tie_hole_count + 1);

    $fn = 64;

    // Calculated dimensions for chassis
    wall_thickness = case_thickness;
    divider_thickness = case_thickness;
    
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
        union() {
            // Front panel
            linear_extrude(height = front_thickness) {
                rounded_rect_2d(rack_width, height, corner_radius);
            }
            
            // Calculate total height needed for all switches and dividers
            total_switch_area = (switch_count * switch_height) + ((switch_count - 1) * divider_thickness);
            
            // Calculate starting Y position (centered in rack)
            y_start = (height - total_switch_area - (2 * wall_thickness)) / 2 + wall_thickness;
            
            // Create one continuous chassis body
            total_chassis_height = total_switch_area + (2 * wall_thickness);
            translate([side_margin, (height - total_chassis_height) / 2, front_thickness]) {
                rounded_chassis_profile(chassis_width, total_chassis_height, chassis_edge_radius, chassis_depth_main - front_thickness);
            }
        }
    }
    
    // Create switch cutout with proper lip
    module switch_cutout() {
        lip_thickness = 1.2;
        lip_depth = 0.60;
        
        // Calculate total height needed for all switches and dividers
        total_switch_area = (switch_count * switch_height) + ((switch_count - 1) * divider_thickness);
        
        // Calculate starting Y position (centered in rack)
        y_start = (height - total_switch_area - (2 * wall_thickness)) / 2 + wall_thickness;
        
        // Repeat cutout for each switch
        for (i = [0:switch_count-1]) {
            // Y position for this switch
            y_center = y_start + (i * (switch_height + divider_thickness)) + (switch_height / 2);
            
            cutout_w = switch_width + (2 * tolerance);
            cutout_h = switch_height + (2 * tolerance);
            
            // Main cutout minus lip (centered)
            translate([
                (rack_width - (cutout_w - 2*lip_thickness)) / 2,
                y_center - (cutout_h - 2*lip_thickness) / 2,
                -tolerance
            ]) {
                cube([cutout_w - 2*lip_thickness, cutout_h - 2*lip_thickness, chassis_depth_main + 10]);
            }

            // Switch cutout above the lip (centered)
            translate([
                (rack_width - cutout_w) / 2,
                y_center - cutout_h / 2,
                lip_depth
            ]) {
                cube([cutout_w, cutout_h, chassis_depth_main + 10]);
            }
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
        max_u = ceil(adjusted_rack_height); // Include partial U units
        
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
                            linear_extrude(height = chassis_depth_main + 10) {
                                capsule_slot_2d(slot_len, slot_height);
                            }
                        }
                    }
                }
            }
        }
    }

    // Power wire cutouts: configurable diameter holes at top and bottom rack hole positions
    module power_wire_cutouts() {
        hole_spacing_x = switch_width; // match rack holes
        hole_left_x = (rack_width - hole_spacing_x) / 2 - (wire_diameter /5);
        hole_right_x = (rack_width + hole_spacing_x) / 2 + (wire_diameter /5);
        
        // Calculate total height needed for all switches and dividers
        total_switch_area = (switch_count * switch_height) + ((switch_count - 1) * divider_thickness);
        
        // Calculate starting Y position (centered in rack)
        y_start = (height - total_switch_area - (2 * wall_thickness)) / 2 + wall_thickness;
        
        // Repeat for each switch
        for (i = [0:switch_count-1]) {
            // Y position for this switch (midplane)
            y_center = y_start + (i * (switch_height + divider_thickness)) + (switch_height / 2);
            
            for (side_x = [hole_left_x, hole_right_x]) {
                translate([side_x, y_center, 0]) {
                    linear_extrude(height = chassis_depth_main + 10) {
                        circle(d=wire_diameter);
                    }
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
        
        // Calculate total height needed for all switches and dividers
        total_switch_area = (switch_count * switch_height) + ((switch_count - 1) * divider_thickness);
        total_chassis_height = total_switch_area + (2 * wall_thickness);
        y_center = (height - total_chassis_height) / 2;
        
        // Bottom indent
        translate([x_pos, y_center, switch_depth]) {
            cube([switch_width, zip_tie_indent_depth, zip_tie_cutout_depth]);
        }
        // Top indent
        translate([x_pos, y_center + total_chassis_height - zip_tie_indent_depth, switch_depth]) {
            cube([switch_width, zip_tie_indent_depth, zip_tie_cutout_depth]);
        }
    }

    // Simplified air holes with staggered honeycomb pattern on all faces
    module air_holes() {
        hole_d = 16;
        spacing_x = 15;  // Horizontal spacing (X and Y directions)
        spacing_z = 17;  // Vertical spacing (Z direction)
        margin = 3; // Keep holes away from edges
        
        // Calculate total height needed for all switches and dividers
        total_switch_area = (switch_count * switch_height) + ((switch_count - 1) * divider_thickness);
        
        // Calculate starting Y position (centered in rack)
        y_start = (height - total_switch_area - (2 * wall_thickness)) / 2 + wall_thickness;
        
        // Repeat for each switch
        for (switch_idx = [0:switch_count-1]) {
            // Y position for this switch
            y_center = y_start + (switch_idx * (switch_height + divider_thickness)) + (switch_height / 2);
            
            // BACK FACE HOLES (Y-axis through back)
            // Calculate available space for holes within switch dimensions
            available_width = switch_width - (2 * margin);
            available_depth = switch_depth - (2 * margin);
            
            // Calculate number of holes that fit
            x_cols = floor(available_width / spacing_x);
            z_rows = floor(available_depth / spacing_z);
            
            // Calculate actual grid size for centering
            actual_grid_width = (x_cols - 1) * spacing_x;
            actual_grid_depth = (z_rows - 1) * spacing_z;
            
            // Center the grid within the switch cutout area
            cutout_center_x = rack_width / 2;
            cutout_center_z = front_thickness + switch_depth / 2;
            
            x_start = cutout_center_x - actual_grid_width / 2;
            z_start = cutout_center_z - actual_grid_depth / 2;
            
            // Create back face holes with VERTICAL staggered pattern
            if (x_cols > 0 && z_rows > 0) {
                for (i = [0:x_cols-1]) {
                    for (j = [0:z_rows-1]) {
                        // Stagger every other column for vertical honeycomb pattern
                        z_offset = (i % 2 == 1) ? spacing_z/2 : 0;
                        x_pos = x_start + i * spacing_x;
                        z_pos = z_start + j * spacing_z + z_offset;
                        
                        // Only place hole if it fits within bounds after staggering
                        if (z_pos + hole_d/2 <= cutout_center_z + switch_depth/2 - margin && 
                            z_pos - hole_d/2 >= cutout_center_z - switch_depth/2 + margin) {
                            translate([x_pos, height + 12, z_pos]) {
                                rotate([90, 30, 0]) {
                                    cylinder(h = height + 24 * 2, d = hole_d, $fn = 6);
                                }
                            }
                        }
                    }
                }
            }
            
            // SIDE FACE HOLES (X-axis through left and right sides)
            // Calculate chassis dimensions
            side_margin = (rack_width - chassis_width) / 2;
            
            // Calculate available space within switch height
            available_height = switch_height - (2 * margin);
            available_side_depth = switch_depth - (2 * margin);
            
            // Calculate number of holes that fit on sides
            y_cols = floor(available_height / spacing_x);
            z_rows_side = floor(available_side_depth / spacing_z);
            
            // Calculate actual grid size for sides
            actual_grid_height = (y_cols - 1) * spacing_x;
            actual_grid_depth_side = (z_rows_side - 1) * spacing_z;
            
            // Center the grid within the switch cutout area (Y and Z)
            y_start_holes = y_center - actual_grid_height / 2;
            z_start_side = cutout_center_z - actual_grid_depth_side / 2;
            
            // Create holes on both left and right sides with VERTICAL staggered pattern
            if (y_cols > 0 && z_rows_side > 0) {
                for (side = [0, 1]) { // 0 = left side, 1 = right side
                    side_x = side == 0 ? side_margin : rack_width - side_margin;
                    
                    for (i = [0:y_cols-1]) {
                        for (j = [0:z_rows_side-1]) {
                            // Stagger every other column for vertical honeycomb pattern
                            z_offset = (i % 2 == 1) ? spacing_z/2 : 0;
                            y_pos = y_start_holes + i * spacing_x;
                            z_pos = z_start_side + j * spacing_z + z_offset;
                            
                            // Only place hole if it fits within bounds after staggering
                            if (z_pos + hole_d/2 <= cutout_center_z + switch_depth/2 - margin && 
                                z_pos - hole_d/2 >= cutout_center_z - switch_depth/2 + margin) {
                                translate([side_x, y_pos, z_pos]) {
                                    rotate([0, 90, 0]) {
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
    switch_mount(switch_width, switch_height, switch_depth, switch_count, case_thickness, wire_diameter);
} else {
    rotate([-90,0,0])
        translate([0, -height/2, -switch_depth/2])
            switch_mount(switch_width, switch_height, switch_depth, switch_count, case_thickness, wire_diameter);
}
