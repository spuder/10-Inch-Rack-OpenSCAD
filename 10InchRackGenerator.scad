rack_width = 254.0;   // [ 254.0:10 inch, 152.4:6 inch]
rack_height = 1.0;    // [0.5:0.5:5]
half_height_holes = true; // [true:Show partial holes at edges, false:Hide partial holes]

section_count = 2;    // [1:4]

/* [Section 1] */
section1_device = "Custom"; // [Custom, Firewalla Gold, Firewalla Purple - wifi, Firewalla Purple - Ethernet, Firewalla Purple SE, UniFi Security Gateway, UniFi Cloud Key G2+, UniFi Flex Mini, UniFi Flex Mini 2.5G, UniFi Flex 2.5, UniFi Lite 8 POE, UniFi Lite 16 POE, UniFi Express, UniFi Cloud Gateway Ultra-Max, IBM M70q Gen 5, IBM M70q Gen 4, IBM M90q Gen 5, Dell OptiPlex 7020, HP Elite Mini 800, M4 Mac Mini, BeeLink ME Mini, Xyber Hydra, Synology DS223j, Synology DS223, Synology DS124]
section1_width = 69.75;
section1_height = 28;
section1_depth = 92.0;
section1_x_offset = -56.0;
section1_y_offset = 0.0;
section1_keystone = false;          // [true:Add keystone jacks, false:None]
section1_keystone_count = 1;        // [1:6]
section1_keystone_side = 1;         // [0:Left of opening, 1:Right of opening]
section1_support = false;           // [true:Add angled supports, false:None]

/* [Section 2] */
section2_device = "Custom"; // [Custom, Firewalla Gold, Firewalla Purple - wifi, Firewalla Purple - Ethernet, Firewalla Purple SE, UniFi Security Gateway, UniFi Cloud Key G2+, UniFi Flex Mini, UniFi Flex Mini 2.5G, UniFi Flex 2.5, UniFi Lite 8 POE, UniFi Lite 16 POE, UniFi Express, UniFi Cloud Gateway Ultra-Max, IBM M70q Gen 5, IBM M70q Gen 4, IBM M90q Gen 5, Dell OptiPlex 7020, HP Elite Mini 800, M4 Mac Mini, BeeLink ME Mini, Xyber Hydra, Synology DS223j, Synology DS223, Synology DS124]
section2_width = 69.75;
section2_height = 28;
section2_depth = 92.0;
section2_x_offset = 56.0;
section2_y_offset = 0.0;
section2_keystone = false;
section2_keystone_count = 1;        // [1:6]
section2_keystone_side = 0;         // [0:Left of opening, 1:Right of opening]
section2_support = false;

/* [Section 3] */
section3_device = "Custom"; // [Custom, Firewalla Gold, Firewalla Purple - wifi, Firewalla Purple - Ethernet, Firewalla Purple SE, UniFi Security Gateway, UniFi Cloud Key G2+, UniFi Flex Mini, UniFi Flex Mini 2.5G, UniFi Flex 2.5, UniFi Lite 8 POE, UniFi Lite 16 POE, UniFi Express, UniFi Cloud Gateway Ultra-Max, IBM M70q Gen 5, IBM M70q Gen 4, IBM M90q Gen 5, Dell OptiPlex 7020, HP Elite Mini 800, M4 Mac Mini, BeeLink ME Mini, Xyber Hydra, Synology DS223j, Synology DS223, Synology DS124]
section3_width = 70.0;
section3_height = 28;
section3_depth = 90.0;
section3_x_offset = 0.0;
section3_y_offset = 0.0;
section3_keystone = false;
section3_keystone_count = 1;        // [1:6]
section3_keystone_side = 1;         // [0:Left of opening, 1:Right of opening]
section3_support = false;

/* [Section 4] */
section4_device = "Custom"; // [Custom, Firewalla Gold, Firewalla Purple - wifi, Firewalla Purple - Ethernet, Firewalla Purple SE, UniFi Security Gateway, UniFi Cloud Key G2+, UniFi Flex Mini, UniFi Flex Mini 2.5G, UniFi Flex 2.5, UniFi Lite 8 POE, UniFi Lite 16 POE, UniFi Express, UniFi Cloud Gateway Ultra-Max, IBM M70q Gen 5, IBM M70q Gen 4, IBM M90q Gen 5, Dell OptiPlex 7020, HP Elite Mini 800, M4 Mac Mini, BeeLink ME Mini, Xyber Hydra, Synology DS223j, Synology DS223, Synology DS124]
section4_width = 70.0;
section4_height = 28;
section4_depth = 90.0;
section4_x_offset = 0.0;
section4_y_offset = 0.0;
section4_keystone = false;
section4_keystone_count = 1;        // [1:6]
section4_keystone_side = 1;         // [0:Left of opening, 1:Right of opening]
section4_support = false;

/* [Shared] */
case_thickness = 6;                 // Thickness of case walls
wire_diameter = 7;                  // Diameter of power wire holes
front_wire_holes = false;           // [true:Show front wire holes, false:Hide]
air_holes = true;                   // [true:Show air holes, false:Hide]
print_orientation = true;           // [true:Place on printbed, false:Facing forward]
tolerance = 0.42;

/* [Keystone Jacks] */
keystone_width = 14.94;             // Standard keystone cutout width
keystone_height = 16.51;            // Standard keystone cutout height
keystone_spacing = 3.0;             // Gap between adjacent jacks
keystone_gap_from_section = 3.0;    // Gap between jack and opening edge

/* [Angled Supports] */
support_depth_requested = 18.0;     // How far back along sleeve the gusset runs
support_width_requested = 10.0;     // How far along faceplate the gusset runs
support_rail_margin = 1.5;          // Clearance between support and rack rail slots
support_min_width = 3.0;            // Don't render support thinner than this

/* [Hidden] */
height = 44.45 * rack_height;

// Device preset table: [name, width, height, depth]  (width = across rack, height = up, depth = into rack)
device_presets = [
    ["Custom",                          0,     0,     0    ],
    ["Firewalla Gold",                  130,   34,    110  ],
    ["Firewalla Purple - wifi",         90,    30,    60   ],
    ["Firewalla Purple - Ethernet",     130,   34,    110  ],
    ["Firewalla Purple SE",             90,    30,    60   ],
    ["UniFi Security Gateway",          135,   28.3,  135  ],
    ["UniFi Cloud Key G2+",             131.2, 134.2, 27.1 ],
    ["UniFi Flex Mini",                 107,   21,    70   ],
    ["UniFi Flex Mini 2.5G",            117.1, 21.2,  90   ],
    ["UniFi Flex 2.5",                  212.9, 33.5,  76   ],
    ["UniFi Lite 8 POE",                99.6,  31.7,  163.7],
    ["UniFi Lite 16 POE",               192,   44,    185  ],
    ["UniFi Express",                   98,    30,    98   ],
    ["UniFi Cloud Gateway Ultra-Max",   141.8, 30,    127.6],
    ["IBM M70q Gen 5",                  179,   36.5,  182.9],
    ["IBM M70q Gen 4",                  179,   34.5,  183  ],
    ["IBM M90q Gen 5",                  179,   36.5,  182.9],
    ["Dell OptiPlex 7020",              182,   36,    178  ],
    ["HP Elite Mini 800",               177.5, 34.3,  175.2],
    ["M4 Mac Mini",                     127,   50,    127  ],
    ["BeeLink ME Mini",                 99,    99,    99   ],
    ["Xyber Hydra",                     140,   34.5,  98.5 ],
    ["Synology DS223j",                 165,   225.5, 100  ],
    ["Synology DS223",                  165,   232.7, 108  ],
    ["Synology DS124",                  166,   224,   71   ]
];

function _preset_lookup(name) =
    let (m = [ for (p = device_presets) if (p[0] == name) [p[1], p[2], p[3]] ])
        (len(m) > 0) ? m[0] : undef;

function _effective_dims(device, w, h, d) =
    (device == "Custom")
        ? [w, h, d]
        : let (p = _preset_lookup(device)) (p == undef) ? [w, h, d] : p;

// Per-section data: [width, height, depth, x_off, y_off,
//                    keystone_on, keystone_count, keystone_side, support_on]
_s1_dims = _effective_dims(section1_device, section1_width, section1_height, section1_depth);
_s2_dims = _effective_dims(section2_device, section2_width, section2_height, section2_depth);
_s3_dims = _effective_dims(section3_device, section3_width, section3_height, section3_depth);
_s4_dims = _effective_dims(section4_device, section4_width, section4_height, section4_depth);

_sections = [
    [_s1_dims[0], _s1_dims[1], _s1_dims[2], section1_x_offset, section1_y_offset,
     section1_keystone, section1_keystone_count, section1_keystone_side, section1_support],
    [_s2_dims[0], _s2_dims[1], _s2_dims[2], section2_x_offset, section2_y_offset,
     section2_keystone, section2_keystone_count, section2_keystone_side, section2_support],
    [_s3_dims[0], _s3_dims[1], _s3_dims[2], section3_x_offset, section3_y_offset,
     section3_keystone, section3_keystone_count, section3_keystone_side, section3_support],
    [_s4_dims[0], _s4_dims[1], _s4_dims[2], section4_x_offset, section4_y_offset,
     section4_keystone, section4_keystone_count, section4_keystone_side, section4_support]
];

// Warn about sections that won't fit in the chosen rack_height
for (i = [0:section_count - 1]) {
    if (_sections[i][1] > height) {
        echo(str("WARNING: section ", i + 1, " height (", _sections[i][1],
                 "mm) exceeds rack_height (", height, "mm). Increase rack_height."));
    }
}

module switch_mount_multi() {
    front_thickness = 3.0;
    corner_radius = 4.0;
    chassis_edge_radius = 2.0;

    zip_tie_hole_count = 8;
    zip_tie_hole_width = 1.5;
    zip_tie_hole_length = 5;
    zip_tie_indent_depth = 2;
    zip_tie_cutout_depth = 7;

    usable_width = (rack_width == 152.4) ? 120.65 : 221.5;
    max_depth = max([ for (i = [0:section_count - 1]) _sections[i][2] ]);
    max_chassis_depth = max_depth + zip_tie_cutout_depth;

    hole_spacing_x = (rack_width == 152.4) ? 136.526 : 236.525;
    slot_len = (rack_width == 152.4) ? 6.5 : 10.0;
    rail_left_edge  = (rack_width - hole_spacing_x) / 2 + slot_len / 2 + support_rail_margin;
    rail_right_edge = (rack_width + hole_spacing_x) / 2 - slot_len / 2 - support_rail_margin;

    $fn = 64;

    function section_center_x(i) = rack_width / 2 + _sections[i][3];
    function section_center_y(i) = height / 2 + _sections[i][4];
    function section_chassis_width(sw)  = min(sw + (2 * case_thickness), usable_width);
    function section_chassis_height(sh) = sh + (2 * case_thickness);
    function section_chassis_depth(sd)  = sd + zip_tie_cutout_depth;
    function chassis_left(i)  = section_center_x(i) - section_chassis_width(_sections[i][0]) / 2;
    function chassis_right(i) = section_center_x(i) + section_chassis_width(_sections[i][0]) / 2;

    module capsule_slot_2d(L, H) {
        hull() {
            translate([-L / 2 + H / 2, 0]) circle(r = H / 2);
            translate([ L / 2 - H / 2, 0]) circle(r = H / 2);
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
    module rounded_chassis_profile(w, h, r, d) {
        hull() {
            translate([r, r, 0]) cylinder(h = d, r = r);
            translate([w - r, r, 0]) cylinder(h = d, r = r);
            translate([r, h - r, 0]) cylinder(h = d, r = r);
            translate([w - r, h - r, 0]) cylinder(h = d, r = r);
        }
    }

    module section_sleeve(i) {
        sw = _sections[i][0]; sh = _sections[i][1]; sd = _sections[i][2];
        cw = section_chassis_width(sw);
        ch = section_chassis_height(sh);
        cd = section_chassis_depth(sd);
        cx = section_center_x(i);
        cy = section_center_y(i);
        translate([cx - cw / 2, cy - ch / 2, front_thickness]) {
            rounded_chassis_profile(cw, ch, chassis_edge_radius, cd - front_thickness);
        }
    }

    function nearest_obstacle_x(i, side) =
        let (own_edge = (side == -1) ? chassis_left(i) : chassis_right(i))
        let (rail_limit = (side == -1) ? rail_left_edge : rail_right_edge)
        let (neighbor_edges = [
            for (j = [0:section_count - 1])
                if (j != i)
                    let (nl = chassis_left(j), nr = chassis_right(j))
                        (side == -1)
                            ? (nr <= own_edge ? nr : -1e9)
                            : (nl >= own_edge ? nl :  1e9)
        ])
        (side == -1)
            ? max(concat([rail_limit], neighbor_edges))
            : min(concat([rail_limit], neighbor_edges));

    function available_space(i, side) =
        let (own_edge = (side == -1) ? chassis_left(i) : chassis_right(i))
        (side == -1) ? own_edge - nearest_obstacle_x(i, -1)
                     : nearest_obstacle_x(i, +1) - own_edge;

    module side_support_gusset(i, side) {
        sh = _sections[i][1];
        ch = section_chassis_height(sh);
        cy = section_center_y(i);
        y_lo = cy - ch / 2;
        y_hi = cy + ch / 2;
        sx_attach = (side == -1) ? chassis_left(i) : chassis_right(i);

        avail = available_space(i, side) - 1.0;
        sup_w = min(support_width_requested, avail);

        if (sup_w >= support_min_width) {
            translate([0, y_hi, 0])
                rotate([90, 0, 0])
                linear_extrude(height = y_hi - y_lo)
                polygon([
                    [sx_attach, 0],
                    [sx_attach, front_thickness + support_depth_requested],
                    [sx_attach + side * sup_w, 0]
                ]);
        } else {
            echo(str("WARNING: support skipped on section ", i + 1,
                     " side ", side, " (available=", avail, ")"));
        }
    }

    module main_body() {
        union() {
            linear_extrude(height = front_thickness) {
                rounded_rect_2d(rack_width, height, corner_radius);
            }
            for (i = [0:section_count - 1]) section_sleeve(i);
            for (i = [0:section_count - 1])
                if (_sections[i][8])
                    for (side = [-1, 1]) side_support_gusset(i, side);
        }
    }

    module section_switch_cutout(i) {
        sw = _sections[i][0]; sh = _sections[i][1]; sd = _sections[i][2];
        cx = section_center_x(i); cy = section_center_y(i);
        cd = section_chassis_depth(sd);
        lip_thickness = 1.2;
        lip_depth = 0.60;
        cutout_w = sw + 2 * tolerance;
        cutout_h = sh + 2 * tolerance;

        translate([
            cx - (cutout_w - 2 * lip_thickness) / 2,
            cy - (cutout_h - 2 * lip_thickness) / 2,
            -tolerance
        ]) cube([cutout_w - 2 * lip_thickness, cutout_h - 2 * lip_thickness, cd]);

        translate([cx - cutout_w / 2, cy - cutout_h / 2, lip_depth])
            cube([cutout_w, cutout_h, cd]);
    }

    module all_rack_holes() {
        hole_left_x  = (rack_width - hole_spacing_x) / 2;
        hole_right_x = (rack_width + hole_spacing_x) / 2;
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
                        translate([side_x, hole_y, 0])
                            linear_extrude(height = max_chassis_depth)
                                capsule_slot_2d(slot_len, slot_height);
                    }
                }
            }
        }
    }

    module section_power_wire_cutouts(i) {
        sw = _sections[i][0]; sd = _sections[i][2];
        cx = section_center_x(i); cy = section_center_y(i);
        cd = section_chassis_depth(sd);
        hx_left  = cx - sw / 2 - wire_diameter / 5;
        hx_right = cx + sw / 2 + wire_diameter / 5;
        for (sxp = [hx_left, hx_right]) {
            translate([sxp, cy, 0])
                linear_extrude(height = cd)
                    circle(d = wire_diameter);
        }
    }

    module section_zip_tie_features(i) {
        sw = _sections[i][0]; sh = _sections[i][1]; sd = _sections[i][2];
        cx = section_center_x(i); cy = section_center_y(i);
        ch = section_chassis_height(sh);
        y_start = cy - ch / 2;
        x_start = cx - sw / 2;

        for (k = [0:zip_tie_hole_count - 1]) {
            x_pos = x_start + (sw / (zip_tie_hole_count + 1)) * (k + 1);
            translate([x_pos, y_start, sd])
                cube([zip_tie_hole_width, ch, zip_tie_hole_length]);
        }
        translate([x_start, y_start, sd])
            cube([sw, zip_tie_indent_depth, zip_tie_cutout_depth]);
        translate([x_start, y_start + ch - zip_tie_indent_depth, sd])
            cube([sw, zip_tie_indent_depth, zip_tie_cutout_depth]);
    }

    module section_air_holes(i) {
        sw = _sections[i][0]; sh = _sections[i][1]; sd = _sections[i][2];
        cx = section_center_x(i); cy = section_center_y(i);
        cw = section_chassis_width(sw);
        ch = section_chassis_height(sh);
        center_z = front_thickness + sd / 2;

        hole_d = 16; spacing_x = 15; spacing_z = 17; margin = 3;

        avail_w = sw - 2 * margin;
        avail_d = sd - 2 * margin;
        x_cols = floor(avail_w / spacing_x);
        z_rows = floor(avail_d / spacing_z);
        grid_w = (x_cols - 1) * spacing_x;
        grid_d = (z_rows - 1) * spacing_z;
        x0 = cx - grid_w / 2;
        z0 = center_z - grid_d / 2;
        y_end = cy + ch / 2;
        if (x_cols > 0 && z_rows > 0) {
            for (ii = [0:x_cols - 1]) for (jj = [0:z_rows - 1]) {
                z_off = (ii % 2 == 1) ? spacing_z / 2 : 0;
                xp = x0 + ii * spacing_x;
                zp = z0 + jj * spacing_z + z_off;
                if (zp + hole_d / 2 <= center_z + sd / 2 - margin &&
                    zp - hole_d / 2 >= center_z - sd / 2 + margin) {
                    translate([xp, y_end, zp])
                        rotate([90, 0, 0])
                            cylinder(h = ch, d = hole_d, $fn = 6);
                }
            }
        }

        avail_h = sh - 2 * margin;
        avail_sd = sd - 2 * margin;
        y_cols = floor(avail_h / spacing_x);
        z_rows_s = floor(avail_sd / spacing_z);
        grid_h = (y_cols - 1) * spacing_x;
        grid_ds = (z_rows_s - 1) * spacing_z;
        y0 = cy - grid_h / 2;
        z0s = center_z - grid_ds / 2;
        x_left = cx - cw / 2;
        x_right = cx + cw / 2;
        if (y_cols > 0 && z_rows_s > 0) {
            for (ii = [0:y_cols - 1]) for (jj = [0:z_rows_s - 1]) {
                z_off = (ii % 2 == 1) ? spacing_z / 2 : 0;
                yp = y0 + ii * spacing_x;
                zp = z0s + jj * spacing_z + z_off;
                if (zp + hole_d / 2 <= center_z + sd / 2 - margin &&
                    zp - hole_d / 2 >= center_z - sd / 2 + margin) {
                    translate([x_left,  yp, zp]) rotate([0,  90, 0]) rotate([0, 0, 90])
                        cylinder(h = cw, d = hole_d, $fn = 6);
                    translate([x_right, yp, zp]) rotate([0, -90, 0]) rotate([0, 0, 90])
                        cylinder(h = cw, d = hole_d, $fn = 6);
                }
            }
        }
    }

    module section_keystone_cutouts(i) {
        sw = _sections[i][0]; sh = _sections[i][1];
        ks_count = _sections[i][6];
        ks_side  = _sections[i][7];

        kw = keystone_width + 2 * tolerance;
        kh = keystone_height + 2 * tolerance;
        pitch = kw + keystone_spacing;
        total_w = ks_count * kw + (ks_count - 1) * keystone_spacing;

        cx = section_center_x(i); cy = section_center_y(i);
        sec_left = cx - sw / 2;
        sec_right = cx + sw / 2;

        wire_bump = front_wire_holes ? (wire_diameter / 5 + wire_diameter / 2) : 0;

        row_y = cy - kh / 2;
        cut_depth = front_thickness + 2 * tolerance;

        eff_left  = sec_left  - wire_bump - keystone_gap_from_section;
        eff_right = sec_right + wire_bump + keystone_gap_from_section;
        start_x = (ks_side == 0) ? eff_left - total_w : eff_right;

        for (k = [0:ks_count - 1]) {
            jx = start_x + k * pitch;
            clears_rails = (jx >= rail_left_edge) && (jx + kw <= rail_right_edge);
            if (clears_rails) {
                translate([jx, row_y, -tolerance])
                    cube([kw, kh, cut_depth]);
            } else {
                echo(str("WARNING: keystone skipped on section ", i + 1,
                         " index=", k, " x=", jx));
            }
        }
    }

    translate([-rack_width / 2, -height / 2, 0]) {
        difference() {
            main_body();
            union() {
                for (i = [0:section_count - 1]) {
                    section_switch_cutout(i);
                    section_zip_tie_features(i);
                    if (front_wire_holes)         section_power_wire_cutouts(i);
                    if (air_holes)                section_air_holes(i);
                    if (_sections[i][5])          section_keystone_cutouts(i);
                }
                all_rack_holes();
            }
        }
    }
}

if (print_orientation) {
    switch_mount_multi();
} else {
    rotate([-90, 0, 0])
        translate([0, -height / 2,
                   -(max([ for (i = [0:section_count - 1]) _sections[i][2] ]) + 7) / 2])
            switch_mount_multi();
}
