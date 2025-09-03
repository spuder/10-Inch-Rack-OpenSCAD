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
    $fn = 64;
    // Internal Calculations (using the user parameters)
    cutout_w = switch_width + cutout_gap;
    cutout_h = switch_height + cutout_gap;
    cutout_x = (front_width - cutout_w) / 2;
    cutout_y = (height - cutout_h) / 2;
    
    // Helper functions and geometry
    // This module creates the 2D capsule shape on the XY-plane
    module capsule_slot_2d(L, H) {
        union() {
            translate([-(L-H)/2, -H/2]) square([L-H, H], center=false);
            translate([-L/2 + H/2, 0]) circle(r=H/2);
            translate([L/2 - H/2, 0]) circle(r=H/2);
        }
    }
    
    // Module for rounded rectangle
    module rounded_rect_2d(w, h, r) {
        hull() {
            translate([r, r]) circle(r=r);
            translate([w-r, r]) circle(r=r);
            translate([w-r, h-r]) circle(r=r);
            translate([r, h-r]) circle(r=r);
        }
    }
    
    // Module for the rack holes - cut all the way through
    module rack_hole(x_pos, y_pos) {
        translate([x_pos, y_pos, -50]) {
            linear_extrude(height = 200) {
                capsule_slot_2d(slot_len, slot_height);
            }
        }
    }
    // Simple approach: build everything then add lip at the end, centered on 0,0
    translate([-front_width/2, -height/2, 0]) {
        union() {
            // Main body with all cuts
            difference() {
                // Solid body
                union() {
                    // Front plate with rounded corners - exact 3mm thickness
                    linear_extrude(height = front_thickness) {
                        rounded_rect_2d(front_width, height, corner_radius);
                    }
                    // Chassis behind front plate
                    translate([side_margin, 0, front_thickness])
                        cube([chassis_width, height, switch_depth - front_thickness], center = false);
                }
                
                // Cut switch hole, but NOT all the way to the front - leave lip_depth material
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
            }
            
            // No need to add anything - the lip is created by the cutting pattern above
        }
    }
}
// Call the module - now centered in 3D space
switch_mount(switch_width, switch_height, switch_depth);