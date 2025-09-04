// Only these parameters will be visible to the user
switch_width = 190.20;
switch_height = 28.30;
switch_depth = 100.20;

rack_size = 254.0; // [254.0:10 inch]
rack_u = 1;

front_wire_holes = false; // [true:Show front wire holes, false:Hide front wire holes]
air_holes = false; // [true:Show air holes, false:Hide air holes]

/* [Hidden] */
height = 44.45 * rack_u;

// The main module containing all internal variables
module switch_mount(switch_width, switch_height, switch_depth) {
    
    lip_thickness = 1.0;
    lip_depth = 0.40;
    // TODO: make chassis_width support 6 inch racks
    chassis_width = min(switch_width + 12, 221.5); // Object must be smaller than 221.5 or it won't fit in 10 slot
    front_thickness = 3.0;
    corner_radius = 2.0;
    chassis_edge_radius = 2.0;
    tolerance = 0.25;

    side_margin = (rack_size - chassis_width) / 2;
    slot_len = 10.0;
    slot_height = 5.5;
    
    zip_tie_hole_count = 8;
    zip_tie_hole_width = 1.5;
    zip_tie_hole_length = 5;
    zip_tie_indent_depth = 2;
    zip_tie_cutout_depth = 7;

    chassis_depth_main = switch_depth + zip_tie_cutout_depth;
    chassis_depth_indented = chassis_depth_main - zip_tie_indent_depth;

    hole_total_width = zip_tie_hole_count * zip_tie_hole_width;
    space_between_holes = (rack_size - hole_total_width) / (zip_tie_hole_count + 1);

    $fn = 64;

    // Calculated dimensions
    cutout_w = switch_width + (2 * tolerance);
    cutout_h = switch_height + (2 * tolerance);
    cutout_x = (rack_size - cutout_w) / 2;
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
                rounded_rect_2d(rack_size, height, corner_radius);
            }
            // Chassis body
            translate([side_margin, 0, front_thickness]) {
                rounded_chassis_profile(chassis_width, height, chassis_edge_radius, chassis_depth_main - front_thickness);
            }
        }
    }
    
    // Create switch cutout with proper lip
    module switch_cutout() {
        // Main cutout minus lip (centered)
        translate([
            (rack_size - (cutout_w - 2*lip_thickness)) / 2,
            (height - (cutout_h - 2*lip_thickness)) / 2,
            -tolerance
        ]) {
            cube([cutout_w - 2*lip_thickness, cutout_h - 2*lip_thickness, chassis_depth_main]);
        }

        // Switch cutout above the lip (centered)
        translate([
            (rack_size - cutout_w) / 2,
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
        hole_spacing_x = 236.525; // 10 inch rack, TODO: support 6 inch rack
        hole_left_x = (rack_size - hole_spacing_x) / 2;
        hole_right_x = (rack_size + hole_spacing_x) / 2;
        
        // Standard rack hole positions within each 1U (44.45mm) unit:
        // First hole: 6.35mm from top of U
        // Second hole: 22.225mm from top of U (middle)
        // Third hole: 38.1mm from top of U (6.35mm from bottom)
        u_hole_positions = [6.35, 22.225, 38.1]; // positions within each U
        
        for (side_x = [hole_left_x, hole_right_x]) {
            for (u = [0:rack_u-1]) {
                for (hole_pos = u_hole_positions) {
                    // Calculate hole position from top of entire rack
                    hole_y = height - (u * 44.45 + hole_pos);
                    translate([side_x, hole_y, 0]) {
                        linear_extrude(height = chassis_depth_main) {
                            capsule_slot_2d(slot_len, slot_height);
                        }
                    }
                }
            }
        }
    }

    // Power wire cutouts: 5mm diameter holes at top and bottom rack hole positions
    module power_wire_cutouts() {
        hole_spacing_x = switch_width; // match rack holes
        hole_left_x = (rack_size - hole_spacing_x) / 2;
        hole_right_x = (rack_size + hole_spacing_x) / 2;
        hole_diameter = 7;
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
            x_pos = (rack_size - switch_width)/2 + (switch_width/(zip_tie_hole_count+1)) * (i+1);
            translate([x_pos, 0, switch_depth]) {
                cube([zip_tie_hole_width, height, zip_tie_hole_length]);
            }
        }
        
        // Zip tie indents (top and bottom)
        x_pos = (rack_size - switch_width)/2;
        translate([x_pos, 0, switch_depth]) {
            cube([switch_width, zip_tie_indent_depth, zip_tie_cutout_depth]);
        }
        translate([x_pos, height-2, switch_depth]) {
            cube([switch_width, zip_tie_indent_depth, zip_tie_cutout_depth]);
        }
    }
    
    // Array of 10mm holes through the body on the Y axis
    // Helper module for grid of circles
    module air_holes_grid(switch_width, switch_depth, spacing_x=20, spacing_y=20, hole_d=10) {
        cols = floor(switch_width / spacing_x);
        min_z = front_thickness;
        max_z = switch_depth - hole_d;
        rows = floor((max_z - min_z) / spacing_y);
        for (i = [0:cols-1]) {
            x_pos = i*spacing_x;
            for (j = [0:rows-1]) {
                y_offset = (i % 2 == 1) ? spacing_y/2 : 0;
                z_pos = min_z + j*spacing_y + y_offset;
                // Ensure the square is fully inside the bounds
                if ((x_pos - hole_d/2 >= 0) && (x_pos + hole_d/2 <= switch_width) && (z_pos - hole_d/2 >= min_z) && (z_pos + hole_d/2 <= max_z)) {
                    translate([x_pos, z_pos, 0])
                        rotate(45)
                            square([hole_d, hole_d], center=true);
                }
            }
        }
    }

    module air_holes() {
        // Calculate grid width and height
        spacing_x = 12;
        spacing_y = 20;
        hole_d = 10;
        cols = floor(switch_width / spacing_x);
        grid_width = cols * spacing_x;
        x_offset = (rack_size - grid_width) / 2;
        z_offset = front_thickness; // minimum Z
        translate([x_offset, 400, (front_thickness+hole_d)])
            rotate([90,0,0])
                linear_extrude(height = 5000) {
                    air_holes_grid(switch_width, switch_depth, spacing_x, spacing_y, hole_d);
                }
    }

    // Main assembly - cleaner boolean structure
    translate([-rack_size/2, -height/2, 0]) {
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
rotate([-90,0,0])
    translate([0, -height/2, -switch_depth/2])
        switch_mount(switch_width, switch_height, switch_depth);