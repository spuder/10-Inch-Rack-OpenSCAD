rack_width = 254.0; // [ 254.0:10 inch, 152.4:6 inch]
rack_height = 1.0; // [0.5:0.5:5]
half_height_holes = true; // [true:Show partial holes at edges, false:Hide partial holes]

section1_width = 69.75;
section1_depth = 92.0;
section1_height = 28;
section1_x_offset = -56.0;
section1_y_offset = 0.0;

section2_width = 69.75;
section2_depth = 92.0;
section2_height = 28;
section2_x_offset = 56.0;
section2_y_offset = 0.0;

case_thickness = 6; // Thickness of case walls
wire_diameter = 7; // Diameter of power wire holes

front_wire_holes = false; // [true:Show front wire holes, false:Hide front wire holes]
air_holes = true; // [true:Show air holes, false:Hide air holes]
print_orientation = true; // [true: Place on printbed, false: Facing forward]
tolerance = 0.42;

/* [Hidden] */
height = 44.45 * rack_height;


module switch_mount_dual(
    section1_width, section1_height, section1_depth, section1_x_offset, section1_y_offset,
    section2_width, section2_height, section2_depth, section2_x_offset, section2_y_offset
) {
    front_thickness = 3.0;
    corner_radius = 4.0;
    chassis_edge_radius = 2.0;

    zip_tie_hole_count = 8;
    zip_tie_hole_width = 1.5;
    zip_tie_hole_length = 5;
    zip_tie_indent_depth = 2;
    zip_tie_cutout_depth = 7;

    max_chassis_depth = max(section1_depth, section2_depth) + zip_tie_cutout_depth;
    usable_width = (rack_width == 152.4) ? 120.65 : 221.5;

    $fn = 64;

    function section_center_x(offset) = rack_width / 2 + offset;
    function section_center_y(offset) = height / 2 + offset;
    function section_chassis_width(switch_width) = min(switch_width + (2 * case_thickness), usable_width);
    function section_chassis_height(switch_height) = switch_height + (2 * case_thickness);
    function section_chassis_depth(switch_depth) = switch_depth + zip_tie_cutout_depth;

    // Helper modules
    module capsule_slot_2d(L, H) {
        hull() {
            translate([-L / 2 + H / 2, 0]) circle(r = H / 2);
            translate([L / 2 - H / 2, 0]) circle(r = H / 2);
        }
    }

    module rounded_rect_2d(w, h, r) {
        hull() {
            translate([r, r]) circle(r = r);
            translate([w - r, r]) circle(r = r);
            translate([w - r, h - r]) circle(r = r);
            translate([r, h - r]) circle(r = r);
        }
    }

    module rounded_chassis_profile(width, profile_height, radius, depth) {
        hull() {
            translate([radius, radius, 0]) cylinder(h = depth, r = radius);
            translate([width - radius, radius, 0]) cylinder(h = depth, r = radius);
            translate([radius, profile_height - radius, 0]) cylinder(h = depth, r = radius);
            translate([width - radius, profile_height - radius, 0]) cylinder(h = depth, r = radius);
        }
    }

    module section_body(switch_width, switch_height, switch_depth, x_offset, y_offset) {
        chassis_width = section_chassis_width(switch_width);
        chassis_height = section_chassis_height(switch_height);
        chassis_depth = section_chassis_depth(switch_depth);
        center_x = section_center_x(x_offset);
        center_y = section_center_y(y_offset);

        translate([center_x - chassis_width / 2, center_y - chassis_height / 2, front_thickness]) {
            rounded_chassis_profile(chassis_width, chassis_height, chassis_edge_radius, chassis_depth - front_thickness);
        }
    }

    module main_body() {
        union() {
            // Front panel
            linear_extrude(height = front_thickness) {
                rounded_rect_2d(rack_width, height, corner_radius);
            }

            // Sleeve bodies
            section_body(section1_width, section1_height, section1_depth, section1_x_offset, section1_y_offset);
            section_body(section2_width, section2_height, section2_depth, section2_x_offset, section2_y_offset);
        }
    }

    module section_switch_cutout(switch_width, switch_height, switch_depth, x_offset, y_offset) {
        lip_thickness = 1.2;
        lip_depth = 0.60;
        cutout_w = switch_width + (2 * tolerance);
        cutout_h = switch_height + (2 * tolerance);
        center_x = section_center_x(x_offset);
        center_y = section_center_y(y_offset);
        chassis_depth = section_chassis_depth(switch_depth);

        // Main cutout minus lip
        translate([
            center_x - (cutout_w - 2 * lip_thickness) / 2,
            center_y - (cutout_h - 2 * lip_thickness) / 2,
            -tolerance
        ]) {
            cube([cutout_w - 2 * lip_thickness, cutout_h - 2 * lip_thickness, chassis_depth]);
        }

        // Switch cutout above the lip
        translate([
            center_x - cutout_w / 2,
            center_y - cutout_h / 2,
            lip_depth
        ]) {
            cube([cutout_w, cutout_h, chassis_depth]);
        }
    }

    // Create all rack holes
    module all_rack_holes() {
        hole_spacing_x = (rack_width == 152.4) ? 136.526 : 236.525; // 6 inch : 10 inch rack
        hole_left_x = (rack_width - hole_spacing_x) / 2;
        hole_right_x = (rack_width + hole_spacing_x) / 2;

        // 10 inch rack = 10x7mm oval
        // 6 inch rack = 3.25 x 6.5mm oval
        slot_len = (rack_width == 152.4) ? 6.5 : 10.0;
        slot_height = (rack_width == 152.4) ? 3.25 : 7.0;
        u_hole_positions = [6.35, 22.225, 38.1];
        max_u = ceil(rack_height);

        for (side_x = [hole_left_x, hole_right_x]) {
            for (u = [0:max_u - 1]) {
                for (hole_pos = u_hole_positions) {
                    hole_y = height - (u * 44.45 + hole_pos);
                    fully_inside = (hole_y >= slot_height / 2 && hole_y <= height - slot_height / 2);
                    partially_inside = (hole_y + slot_height / 2 > 0 && hole_y - slot_height / 2 < height);
                    show_hole = fully_inside || (half_height_holes && partially_inside && !fully_inside);

                    if (show_hole) {
                        translate([side_x, hole_y, 0]) {
                            linear_extrude(height = max_chassis_depth) {
                                capsule_slot_2d(slot_len, slot_height);
                            }
                        }
                    }
                }
            }
        }
    }

    // Power wire cutouts per sleeve
    module section_power_wire_cutouts(switch_width, switch_depth, x_offset, y_offset) {
        chassis_depth = section_chassis_depth(switch_depth);
        center_x = section_center_x(x_offset);
        center_y = section_center_y(y_offset);
        hole_left_x = center_x - switch_width / 2 - (wire_diameter / 5);
        hole_right_x = center_x + switch_width / 2 + (wire_diameter / 5);

        for (side_x = [hole_left_x, hole_right_x]) {
            translate([side_x, center_y, 0]) {
                linear_extrude(height = chassis_depth) {
                    circle(d = wire_diameter);
                }
            }
        }
    }

    // Zip tie holes and indents per sleeve
    module section_zip_tie_features(switch_width, switch_height, switch_depth, x_offset, y_offset) {
        center_x = section_center_x(x_offset);
        center_y = section_center_y(y_offset);
        chassis_height = section_chassis_height(switch_height);
        y_start = center_y - chassis_height / 2;
        x_start = center_x - switch_width / 2;

        // Zip tie holes
        for (i = [0:zip_tie_hole_count - 1]) {
            x_pos = x_start + (switch_width / (zip_tie_hole_count + 1)) * (i + 1);
            translate([x_pos, y_start, switch_depth]) {
                cube([zip_tie_hole_width, chassis_height, zip_tie_hole_length]);
            }
        }

        // Zip tie indents (top and bottom)
        translate([x_start, y_start, switch_depth]) {
            cube([switch_width, zip_tie_indent_depth, zip_tie_cutout_depth]);
        }

        translate([x_start, y_start + chassis_height - zip_tie_indent_depth, switch_depth]) {
            cube([switch_width, zip_tie_indent_depth, zip_tie_cutout_depth]);
        }
    }

    // Staggered hex ventilation per sleeve
    module section_air_holes(switch_width, switch_height, switch_depth, x_offset, y_offset) {
        hole_d = 16;
        spacing_x = 15;
        spacing_z = 17;
        margin = 3;

        center_x = section_center_x(x_offset);
        center_y = section_center_y(y_offset);
        center_z = front_thickness + switch_depth / 2;
        chassis_width = section_chassis_width(switch_width);
        chassis_height = section_chassis_height(switch_height);

        // Holes through top/bottom surfaces
        available_width = switch_width - (2 * margin);
        available_depth = switch_depth - (2 * margin);
        x_cols = floor(available_width / spacing_x);
        z_rows = floor(available_depth / spacing_z);
        actual_grid_width = (x_cols - 1) * spacing_x;
        actual_grid_depth = (z_rows - 1) * spacing_z;
        x_start = center_x - actual_grid_width / 2;
        z_start = center_z - actual_grid_depth / 2;
        y_end = center_y + chassis_height / 2;

        if (x_cols > 0 && z_rows > 0) {
            for (i = [0:x_cols - 1]) {
                for (j = [0:z_rows - 1]) {
                    z_offset = (i % 2 == 1) ? spacing_z / 2 : 0;
                    x_pos = x_start + i * spacing_x;
                    z_pos = z_start + j * spacing_z + z_offset;

                    if (
                        z_pos + hole_d / 2 <= center_z + switch_depth / 2 - margin &&
                        z_pos - hole_d / 2 >= center_z - switch_depth / 2 + margin
                    ) {
                        translate([x_pos, y_end, z_pos]) {
                            rotate([90, 0, 0]) {
                                cylinder(h = chassis_height, d = hole_d, $fn = 6);
                            }
                        }
                    }
                }
            }
        }

        // Holes through side surfaces
        available_height = switch_height - (2 * margin);
        available_side_depth = switch_depth - (2 * margin);
        y_cols = floor(available_height / spacing_x);
        z_rows_side = floor(available_side_depth / spacing_z);
        actual_grid_height = (y_cols - 1) * spacing_x;
        actual_grid_depth_side = (z_rows_side - 1) * spacing_z;
        y_start = center_y - actual_grid_height / 2;
        z_start_side = center_z - actual_grid_depth_side / 2;
        x_left = center_x - chassis_width / 2;
        x_right = center_x + chassis_width / 2;

        if (y_cols > 0 && z_rows_side > 0) {
            for (i = [0:y_cols - 1]) {
                for (j = [0:z_rows_side - 1]) {
                    z_offset = (i % 2 == 1) ? spacing_z / 2 : 0;
                    y_pos = y_start + i * spacing_x;
                    z_pos = z_start_side + j * spacing_z + z_offset;

                    if (
                        z_pos + hole_d / 2 <= center_z + switch_depth / 2 - margin &&
                        z_pos - hole_d / 2 >= center_z - switch_depth / 2 + margin
                    ) {
                        translate([x_left, y_pos, z_pos]) {
                            rotate([0, 90, 0]) {
                                rotate([0, 0, 90]) {
                                    cylinder(h = chassis_width, d = hole_d, $fn = 6);
                                }
                            }
                        }

                        translate([x_right, y_pos, z_pos]) {
                            rotate([0, -90, 0]) {
                                rotate([0, 0, 90]) {
                                    cylinder(h = chassis_width, d = hole_d, $fn = 6);
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    // Main assembly
    translate([-rack_width / 2, -height / 2, 0]) {
        difference() {
            main_body();
            union() {
                section_switch_cutout(section1_width, section1_height, section1_depth, section1_x_offset, section1_y_offset);
                section_switch_cutout(section2_width, section2_height, section2_depth, section2_x_offset, section2_y_offset);
                all_rack_holes();
                section_zip_tie_features(section1_width, section1_height, section1_depth, section1_x_offset, section1_y_offset);
                section_zip_tie_features(section2_width, section2_height, section2_depth, section2_x_offset, section2_y_offset);

                if (front_wire_holes) {
                    section_power_wire_cutouts(section1_width, section1_depth, section1_x_offset, section1_y_offset);
                    section_power_wire_cutouts(section2_width, section2_depth, section2_x_offset, section2_y_offset);
                }

                if (air_holes) {
                    section_air_holes(section1_width, section1_height, section1_depth, section1_x_offset, section1_y_offset);
                    section_air_holes(section2_width, section2_height, section2_depth, section2_x_offset, section2_y_offset);
                }
            }
        }
    }
}

if (print_orientation) {
    switch_mount_dual(
        section1_width, section1_height, section1_depth, section1_x_offset, section1_y_offset,
        section2_width, section2_height, section2_depth, section2_x_offset, section2_y_offset
    );
} else {
    rotate([-90, 0, 0])
        translate([0, -height / 2, -(max(section1_depth, section2_depth) + 7) / 2])
            switch_mount_dual(
                section1_width, section1_height, section1_depth, section1_x_offset, section1_y_offset,
                section2_width, section2_height, section2_depth, section2_x_offset, section2_y_offset
            );
}
