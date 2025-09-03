// Only these parameters will be visible to the user
switch_width = 190.0;
switch_height = 28.30;
switch_depth = 100.20;

/* [Hidden] */
front_width = 254.0;
height = 44.45; // 1U

// The main module containing all internal variables
module switch_mount(switch_width, switch_height, switch_depth) {
    // Hidden parameters - users won't see these
    chassis_width = 221.5;
    front_thickness = 3.0;
    corner_radius = 2.0;
    chassis_edge_radius = 2.0;
    tolerance = 0.15;
    cutout_gap = 2.0 + 2 * tolerance;
    lip_thickness = 1.0;
    lip_depth = 1.0;
    side_margin = (front_width - chassis_width) / 2;
    slot_len = 10.0;
    slot_height = 5.5;
    hole_top_y = height - 6.5;
    hole_center_y = height / 2;
    hole_bottom_y = 6.5;
    hole_spacing_x = 236.525;
    hole_left_x = (front_width - hole_spacing_x) / 2;
    hole_right_x = (front_width + hole_spacing_x) / 2;
    
    zip_tie_hole_count = 8;
    zip_tie_hole_width = 1.5;
    zip_tie_hole_length = 5.0;
    zip_tie_indent_depth = 2;

    chassis_depth_main = switch_depth + 7;
    chassis_depth_indented = chassis_depth_main - zip_tie_indent_depth;

    hole_total_width = zip_tie_hole_count * zip_tie_hole_width;
    space_between_holes = (front_width - hole_total_width) / (zip_tie_hole_count + 1);

    $fn = 64;

    // Calculated dimensions
    cutout_w = switch_width + cutout_gap;
    cutout_h = switch_height + cutout_gap;
    cutout_x = (front_width - cutout_w) / 2;
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
        union() {
            // Front panel
            linear_extrude(height = front_thickness) {
                rounded_rect_2d(front_width, height, corner_radius);
            }
            // Chassis body
            translate([side_margin, 0, front_thickness]) {
                rounded_chassis_profile(chassis_width, height, chassis_edge_radius, chassis_depth_main - front_thickness);
            }
        }
    }
    
    // Create switch cutout with proper lip
    module switch_cutout() {
        // Outer cutout (preserves lip)
        translate([cutout_x, cutout_y, lip_depth]) {
            cube([cutout_w, cutout_h, chassis_depth_main], center = false);
        }
        // Inner cutout (full depth for switch body)
        translate([cutout_x + lip_thickness, cutout_y + lip_thickness, 0]) {
            cube([cutout_w - 2*lip_thickness, cutout_h - 2*lip_thickness, chassis_depth_main], center = false);
        }
    }
    
    // Create all rack holes
    module all_rack_holes() {
        positions = [
            [hole_left_x, hole_top_y],
            [hole_left_x, hole_center_y], 
            [hole_left_x, hole_bottom_y],
            [hole_right_x, hole_top_y],
            [hole_right_x, hole_center_y],
            [hole_right_x, hole_bottom_y]
        ];
        
        for (pos = positions) {
            translate([pos[0], pos[1], 0]) {
                linear_extrude(height = chassis_depth_main) {
                    capsule_slot_2d(slot_len, slot_height);
                }
            }
        }
    }
    
    // Create zip tie holes and indents
    module zip_tie_features() {
        // Zip tie holes
        for (i = [0:zip_tie_hole_count-1]) {
            x_pos = (front_width - switch_width)/2 + (switch_width/(zip_tie_hole_count+1)) * (i+1);
            translate([x_pos, 0, switch_depth]) {
                cube([zip_tie_hole_width, height, zip_tie_hole_length]);
            }
        }
        
        // Zip tie indents (top and bottom)
        x_pos = (front_width - switch_width)/2;
        translate([x_pos, 0, switch_depth]) {
            cube([switch_width, 2, 8]);
        }
        translate([x_pos, height-2, switch_depth]) {
            cube([switch_width, 2, 8]);
        }
    }
    
    // Main assembly - cleaner boolean structure
    translate([-front_width/2, -height/2, 0]) {
        difference() {
            main_body();
            union() {
                switch_cutout();
                all_rack_holes();
                zip_tie_features();
            }
        }
    }
}

// Call the module
switch_mount(switch_width, switch_height, switch_depth);