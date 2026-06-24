rack_width = 254.0; // [ 254.0:10 inch, 152.4:6 inch]
rack_height = 1.0; // [0.5:0.5:5]
half_height_holes = true; // [true:Show partial holes at edges, false:Hide partial holes]
print_orientation = true; // [true: Place on printbed, false: Facing forward]
ribs = true; // [true:Show structural ribs, false:Hide structural ribs]

/* [Storage Configuration] */
enable_storage = true; 
usb_slots = 6;
sd_slots = 4;
microsd_slots = 12;

/* [Storage Arrangement] */
// Assign unique positions for each group
usb_pos = 1; // [1:Left, 2:Middle, 3:Right]
sd_pos = 2; // [1:Left, 2:Middle, 3:Right]
microsd_pos = 3; // [1:Left, 2:Middle, 3:Right]

/* [Efficiency & Safety] */
stack_microsd = true; 
stack_usb = true;
slot_spacing = 3.0; 
stack_gap = 4.0; 
// Distance between the main groups (USB group vs SD group)
group_gap = 6.0; 

// Enable stops to prevent devices falling through?
sd_stop = true; 
microsd_stop = true; 
usb_stop = true; 

/* [Hidden] */
height = 44.45 * rack_height;
front_thickness = 3.0;
corner_radius = 4.0;
tolerance = 0.42;

// --- Device Physical Dimensions ---
usb_w = 5.2;  usb_h = 13.5; 
sd_w = 2.6;   sd_h = 25.0; 
msd_w = 1.4;  msd_h = 11.5; 

// --- Stop Depths ---
depth_sd_stop = 27.0; 
depth_msd_stop = 12.0; 
depth_usb_stop = 14.0; 
default_pass_through = 10.0; 

// Rib parameters
rib_thickness = 2.0;
rib_depth = 3.0;
chamfer_size = 0.5; 

module plate_generator() {
    $fn = 64;

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
    
    module chamfered_rib(width, thickness, depth, chamfer) {
        difference() {
            cube([width, thickness, depth]);
            translate([depth - depth * 2, -tolerance, depth])
                rotate([0, 45, 0])
                    cube([depth * 1.5, thickness + 2*tolerance, depth * 1.5]);
            translate([width - depth + depth, -tolerance, 0])
                rotate([0, -45, 0])
                    cube([depth * 1.5, thickness + 2*tolerance, depth * 1.5]);
        }
    }

    // --- 1. Dimensions Calculations ---
    
    has_usb = (usb_slots > 0);
    has_sd = (sd_slots > 0);
    has_msd = (microsd_slots > 0);

    // Calculate depths
    d_req_usb = has_usb ? (usb_stop ? depth_usb_stop : default_pass_through) : 0;
    d_req_sd  = has_sd  ? (sd_stop ? depth_sd_stop : default_pass_through) : 0;
    d_req_msd = has_msd ? (microsd_stop ? depth_msd_stop : default_pass_through) : 0;
    
    block_depth = max(d_req_usb, max(d_req_sd, d_req_msd)) + 2.0;

    // Calculate Heights
    usb_stack_height = stack_usb ? (usb_h * 2) + stack_gap : usb_h;
    msd_stack_height = stack_microsd ? (msd_h * 2) + stack_gap : msd_h;
    max_element_h = max(has_usb?usb_stack_height:0, max(has_sd?sd_h:0, has_msd?msd_stack_height:0));
    block_h = max_element_h + 6.0; 
    
    center_x = rack_width / 2;
    center_y = height / 2;
    block_min_y = center_y - block_h/2;

    // --- 2. Positioning Logic ---

    // Calculate raw widths of each group
    usb_cols = (stack_usb && has_usb) ? ceil(usb_slots / 2) : usb_slots;
    w_usb_raw = has_usb ? (usb_cols * (usb_w + slot_spacing)) - slot_spacing : 0;
    
    w_sd_raw = has_sd ? (sd_slots * (sd_w + slot_spacing)) - slot_spacing : 0;
    
    msd_cols = (stack_microsd && has_msd) ? ceil(microsd_slots / 2) : microsd_slots;
    w_msd_raw = has_msd ? (msd_cols * (msd_w + slot_spacing)) - slot_spacing : 0;

    // Determine the width of the group at Rank 1 (Left), Rank 2 (Middle), Rank 3 (Right)
    function get_width_at_rank(r) = 
        (usb_pos == r && has_usb) ? w_usb_raw : 
        (sd_pos == r && has_sd) ? w_sd_raw :
        (microsd_pos == r && has_msd) ? w_msd_raw : 0;
    
    w_rank1 = get_width_at_rank(1);
    w_rank2 = get_width_at_rank(2);
    w_rank3 = get_width_at_rank(3);

    // Calculate gaps: Gap exists only if both the Left item and Right item exist
    gap_1_2 = (w_rank1 > 0 && (w_rank2 > 0 || w_rank3 > 0)) ? group_gap : 0;
    gap_2_3 = (w_rank2 > 0 && w_rank3 > 0) ? group_gap : 0;

    total_content_width = w_rank1 + gap_1_2 + w_rank2 + gap_2_3 + w_rank3;
    start_x = center_x - (total_content_width / 2);

    // Calculate absolute starting X for each Rank
    x_rank1 = start_x;
    x_rank2 = x_rank1 + w_rank1 + gap_1_2;
    x_rank3 = x_rank2 + w_rank2 + gap_2_3;

    // --- Modules ---

    module storage_block_solid() {
        if (enable_storage && total_content_width > 0) {
             translate([start_x - slot_spacing, block_min_y, front_thickness])
                cube([total_content_width + slot_spacing*2, block_h, block_depth]);
        }
    }

    // Individual Group Drawers that take an X offset
    module draw_usb_group(x_offset) {
        for (i = [0 : usb_slots-1]) {
            col = stack_usb ? floor(i / 2) : i;
            is_top_row = stack_usb ? ((i % 2) == 0) : true;
            
            x_pos = x_offset + (col * (usb_w + slot_spacing));
            y_pos = stack_usb 
                ? (is_top_row ? (center_y + stack_gap/2) : (center_y - stack_gap/2 - usb_h))
                : (center_y - usb_h/2);

            this_cut_depth = usb_stop ? depth_usb_stop : (block_depth + 10);
            
            translate([x_pos, y_pos, -1])
                cube([usb_w, usb_h, front_thickness + this_cut_depth]);
        }
    }

    module draw_sd_group(x_offset) {
        for (i = [0 : sd_slots-1]) {
            x_pos = x_offset + (i * (sd_w + slot_spacing));
            this_cut_depth = sd_stop ? depth_sd_stop : (block_depth + 10);
            translate([x_pos, center_y - sd_h/2, -1])
                cube([sd_w, sd_h, front_thickness + this_cut_depth]);
        }
    }

    module draw_msd_group(x_offset) {
        for (i = [0 : microsd_slots-1]) {
            col = stack_microsd ? floor(i / 2) : i;
            is_top_row = stack_microsd ? ((i % 2) == 0) : true;
            
            x_pos = x_offset + (col * (msd_w + slot_spacing));
            y_pos = stack_microsd 
                ? (is_top_row ? (center_y + stack_gap/2) : (center_y - stack_gap/2 - msd_h))
                : (center_y - msd_h/2);

            this_cut_depth = microsd_stop ? depth_msd_stop : (block_depth + 10);

            translate([x_pos, y_pos, -1])
                cube([msd_w, msd_h, front_thickness + this_cut_depth]);
        }
    }

    module storage_cuts() {
        if (enable_storage && total_content_width > 0) {
            
            // Render Rank 1 (Left)
            if (usb_pos == 1 && has_usb) draw_usb_group(x_rank1);
            if (sd_pos == 1 && has_sd) draw_sd_group(x_rank1);
            if (microsd_pos == 1 && has_msd) draw_msd_group(x_rank1);

            // Render Rank 2 (Middle)
            if (usb_pos == 2 && has_usb) draw_usb_group(x_rank2);
            if (sd_pos == 2 && has_sd) draw_sd_group(x_rank2);
            if (microsd_pos == 2 && has_msd) draw_msd_group(x_rank2);

            // Render Rank 3 (Right)
            if (usb_pos == 3 && has_usb) draw_usb_group(x_rank3);
            if (sd_pos == 3 && has_sd) draw_sd_group(x_rank3);
            if (microsd_pos == 3 && has_msd) draw_msd_group(x_rank3);
        }
    }

    // --- Assembly ---

    module plate_body() {
        union() {
            linear_extrude(height = front_thickness) {
                rounded_rect_2d(rack_width, height, corner_radius);
            }
            if (ribs) {
                structural_ribs();
            }
            storage_block_solid();
        }
    }
    
    module structural_ribs() {
        usable_width = (rack_width == 152.4) ? 120.65 * 0.9 : 221.5 * 0.9;
        rib_start_x = (rack_width - usable_width) / 2;
        u_hole_positions = [6.35, 22.225, 38.1];
        max_u = ceil(rack_height);
        
        for (u = [0:max_u-1]) {
            for (hole_pos = u_hole_positions) {
                bar_y = height - (u * 44.45 + hole_pos);
                overlaps_storage = enable_storage && (bar_y > block_min_y - 2 && bar_y < block_min_y + block_h + 2);
                
                if (!overlaps_storage && bar_y >= rib_thickness/2 && bar_y <= height - rib_thickness/2) {
                    translate([rib_start_x, bar_y - rib_thickness/2, front_thickness]) {
                        chamfered_rib(usable_width, rib_thickness, rib_depth, chamfer_size);
                    }
                }
            }
        }
    }
    
    module all_rack_holes() {
        hole_spacing_x = (rack_width == 152.4) ? 136.526 : 236.525;
        hole_left_x = (rack_width - hole_spacing_x) / 2;
        hole_right_x = (rack_width + hole_spacing_x) / 2;
        slot_len = (rack_width == 152.4) ? 6.5 : 10.0;
        slot_height = (rack_width == 152.4) ? 3.25 : 7.0;
        u_hole_positions = [6.35, 22.225, 38.1];
        max_u = ceil(rack_height);
        
        for (side_x = [hole_left_x, hole_right_x]) {
            for (u = [0:max_u-1]) {
                for (hole_pos = u_hole_positions) {
                    hole_y = height - (u * 44.45 + hole_pos);
                    fully_inside = (hole_y >= slot_height/2 && hole_y <= height - slot_height/2);
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

    translate([-rack_width/2, -height/2, 0]) {
        difference() {
            plate_body();
            all_rack_holes();
            storage_cuts(); 
        }
    }
}

if (print_orientation) {
    plate_generator();
} else {
    rotate([-90,0,0])
        translate([0, -height/2, -front_thickness/2])
            plate_generator();
}
