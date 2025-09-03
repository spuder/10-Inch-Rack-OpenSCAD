// Only these parameters will be visible to the user
switch_width = 190.0;
switch_height = 28.30;
switch_depth = 100.20;

/* [Hidden] */
front_width = 254.0;
height = 44.45; // 1U
// ---
// The main module containing all internal variables
module switch_mount(switch_width, switch_height, switch_depth) {
    // Hidden parameters - users won't see these
    chassis_width = 221.5;
    front_thickness = 3.0;
    corner_radius = 2.0;
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
    
    // New parameters for the added holes
    hole_count = 8;
    hole_width = 1.5;
    hole_length = 5.0; // The 5mm length of the hole along the Z-axis
    
    // New parameter for the chassis depth
    chassis_depth = switch_depth + 7;
    
    // Calculate spacing for the holes across the entire part width
    hole_total_width = hole_count * hole_width;
    space_between_holes = (front_width - hole_total_width) / (hole_count + 1);

    $fn = 64;

    // Internal Calculations (using the user parameters)
    cutout_w = switch_width + cutout_gap;
    cutout_h = switch_height + cutout_gap;
    cutout_x = (front_width - cutout_w) / 2;
    cutout_y = (height - cutout_h) / 2;
    
    // Helper functions and geometry
    module capsule_slot_2d(L, H) {
        union() {
            translate([-(L-H)/2, -H/2]) square([L-H, H], center=false);
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
    
    module rack_hole(x_pos, y_pos) {
        translate([x_pos, y_pos, -50]) {
            linear_extrude(height = 200) {
                capsule_slot_2d(slot_len, slot_height);
            }
        }
    }
    
    translate([-front_width/2, -height/2, 0]) {
        union() {
            difference() {
                // Solid body
                union() {
                    linear_extrude(height = front_thickness) {
                        rounded_rect_2d(front_width, height, corner_radius);
                    }
                    translate([side_margin, 0, front_thickness])
                        cube([chassis_width, height, chassis_depth - front_thickness], center = false);
                }
                
                // Cut switch hole, but NOT all the way to the front
                translate([cutout_x, cutout_y, lip_depth])
                    cube([cutout_w, cutout_h, 200], center = false);
                
                // Cut the inner area all the way through (for the actual switch)
                translate([cutout_x + lip_thickness, cutout_y + lip_thickness, -50])
                    cube([cutout_w - 2*lip_thickness, cutout_h - 2*lip_thickness, 200], center = false);
                
                // Cut rack holes all the way through
                rack_hole(hole_left_x, hole_top_y);
                rack_hole(hole_left_x, hole_center_y);
                rack_hole(hole_left_x, hole_bottom_y);
                rack_hole(hole_right_x, hole_top_y);
                rack_hole(hole_right_x, hole_center_y);
                rack_hole(hole_right_x, hole_bottom_y);
                
                for (i = [0:hole_count -1]) {
                    // Divide holes evenly across the switch_width, centered in the front panel
                    x_pos = (front_width - switch_width)/2 + (switch_width/(hole_count+1)) * (i+1);
                    y_pos = 0;
                    z_pos = switch_depth;
                    translate([x_pos, y_pos, z_pos])
                        cube([2,9000,5]);
                }
            }
        }
    }
}
// Call the module - now centered in 3D space
switch_mount(switch_width, switch_height, switch_depth);