// Only these parameters will be visible to the user
switch_width = 190.0;
switch_height = 28.30;
depth = 100.20;
// ---
// Global variables for external transformations
front_width = 254.0;
height = 44.45; // 1U
// ---

// The main module containing all internal variables
module switch_mount(switch_width, switch_height, depth) {

    // Internal Variables (not visible to user)
    chassis_width = 222.0;
    front_thickness = 5.0;
    tolerance = 0.15;
    cutout_gap = 2.0 + 2 * tolerance;
    lip_thickness = 1.0;
    lip_depth = 1.0;
    side_margin = (front_width - chassis_width) / 2;
    slot_len = 10.0;
    slot_height = 5.5;
    hole_top_z = height - 6.5;
    hole_center_z = height / 2;
    hole_bottom_z = 6.5;
    hole_spacing_x = 236.525;
    hole_left_x = (front_width - hole_spacing_x) / 2;
    hole_right_x = (front_width + hole_spacing_x) / 2;
    $fn = 64;

    // Internal Calculations (using the user parameters)
    cutout_w = switch_width + cutout_gap;
    cutout_h = switch_height + cutout_gap;
    cutout_x = (front_width - cutout_w) / 2;
    cutout_z = (height - cutout_h) / 2;

    // Helper functions and geometry
    module capsule_slot_2d(L, H) {
        union() {
            translate([-(L-H)/2, -H/2]) square([L-H, H], center=false);
            translate([-L/2 + H/2, 0]) circle(r=H/2);
            translate([L/2 - H/2, 0]) circle(r=H/2);
        }
    }

    module rack_hole(x_pos, z_pos) {
        translate([x_pos, 0, z_pos]) {
            rotate([90, 0, 0]) {
                linear_extrude(height = front_thickness * 2, center = true) {
                    capsule_slot_2d(slot_len, slot_height);
                }
            }
        }
    }

    // Model generation logic
    union() {
        difference() {
            union() {
                // Front plate
                cube([front_width, front_thickness, height], center = false);
                // Chassis
                translate([side_margin, front_thickness, 0])
                    cube([chassis_width, depth - front_thickness, height], center = false);
            }
            // Full switch cutout
            translate([cutout_x, 0, cutout_z])
                cube([cutout_w, depth, cutout_h], center = false);

            // Rack mount holes
            rack_hole(hole_left_x, hole_top_z);
            rack_hole(hole_left_x, hole_center_z);
            rack_hole(hole_left_x, hole_bottom_z);
            rack_hole(hole_right_x, hole_top_z);
            rack_hole(hole_right_x, hole_center_z);
            rack_hole(hole_right_x, hole_bottom_z);
        }

        // Hollow lip frame
        difference() {
            translate([cutout_x, 0, cutout_z])
                cube([cutout_w, lip_depth, cutout_h], center = false);
            translate([cutout_x + lip_thickness, 0, cutout_z + lip_thickness])
                cube([cutout_w - 2 * lip_thickness, lip_depth, cutout_h - 2 * lip_thickness], center = false);
        }
    }
}

// Rotate and then translate the entire model for centering and 3D printing.
// These variables are now accessible here
rotate([90, 0, 0]) {
    translate([-front_width/2, -height/2, -depth/2]) {
        switch_mount(switch_width, switch_height, depth);
    }
}