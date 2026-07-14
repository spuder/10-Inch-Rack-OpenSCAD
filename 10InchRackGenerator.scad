include <BOSL2/std.scad>
include <BOSL2/walls.scad>

/* [Panel settings] */
rack_width = 254.0; // [ 254.0:10 inch, 152.4:6 inch]
// Height of the rack in U units, can be a fraction for partial U (e.g. 1.5 for 1U plus half of the next U)
rack_height = 1.0; // [0.5:0.5:5]
// Thickness of the front panel (the flat face plate).
front_plate_thickness = 3.0;
// ========================================
/* [Component1] */
component1 = true;
component1_width = 110.0;
component1_depth = 122.0;
component1_height = 28.30;
component1_side_offset = 0;  // [-100:0.1:100]
component1_up_offset = 0;  // [-100:0.1:100]
// Adds small cutout a USB or Power cable could be routed through to the front
component1_wire_holes=4; // [1: Both Sides, 2: Left, 3: Right, 4: disable]
// ========================================
/* [Component2] */
component2 = true;
component2_width = 110.0;
component2_depth = 122.0;
component2_height = 28.30;
component2_side_offset = 0;  // [-100:0.1:100]
component2_up_offset = 0;  // [-100:0.1:100]
// Adds small cutout a USB or Power cable could be routed through to the front
component2_wire_holes=4; // [1: Both Sides, 2: Left, 3: Right, 4: disable]
// ========================================
/* [Component3] */
component3 = true;
component3_width = 110.0;
component3_depth = 122.0;
component3_height = 28.30;
component3_side_offset = 0;  // [-100:0.1:100]
component3_up_offset = 0;  // [-100:0.1:100]
// Adds small cutout a USB or Power cable could be routed through to the front
component3_wire_holes=4; // [1: Both Sides, 2: Left, 3: Right, 4: disable]
// ========================================
/* [Keystones] */
// Add keystone jacks to the front panel
keystones = false;    // [true: Place keystone jacks, false: Remove keystone jacks]
keystone_left = true;  // [true: Place keystone jack on the left, false: Remove left keystone jack]
keystone_right = true; // [true: Place keystone jack on the right, false: Remove right keystone jacks]
// ========================================
/* [Holes] */
// Diameter of wire to route through front_wire_holes.
wire_diameter = 7; // Diameter of power wire holes
// Adds hexagon air cutouts to reduce material and improve cooling.
air_holes = true; // [true:Show air holes, false:Hide air holes]
// size of struts between hexs.
hex_strut = 4; 
// spacing determines how many hexs will fit in the space.
hex_spacing = 15;
// controls the thickness of the frame around the  hex cutout.
hex_bottom_frame = 10;  // [8:0.5:13]
// ========================================
/* [Advanced] */
// Used when rack_height is a fraction, cuts a half oval for screws, otherwise will cover up the hole
half_height_holes = true; // [true:Show partial holes at edges, false:Hide partial holes]
// Thickness of the shell that wraps around the part.
case_thickness = 6; // Thickness of case walls
// Make the front plate solid (no hole), useful to hide a part not needing to be accessed from the exterior.
front_plate_hole = true; // [true:Show front plate hole, false:Solid front plate]
// Prevent part from sliding out the front by adding a small 0.6mm lip around the front plate hole.
front_lip = true; // [true:Show front lip, false:Hide front lip]
// Default gap between part and print walls
tolerance = 0.42;
// ========================================
/* [Hidden] */
height = 44.45 * rack_height;
//ziptie variables
zip_tie_hole_count = 8;
zip_tie_hole_width = 1.5;
zip_tie_hole_length = 6;
zip_tie_indent_depth = 2;
zip_tie_cutout_depth = 8;
// Keystone placement — jack X span (width) goes horizontal, jack Z span (height) goes vertical
keystone_outer_width  = 19.9; // jack_width + wall = (front_hole_width + wall) + wall
keystone_outer_height = 27.5; // jack_height + wall
// Left edge of left keystone pinned to 210/2 from centreline → 210mm outer-to-outer for the mirrored pair
keystone_tx = rack_width/2 - 105;
keystone_ty = (height - keystone_outer_height) / 2;
e=0.01; // epsilon for coplanar face fixes, fixes bug where some faces leave a thin sliver of material
// ============================================================================
//End parameters

// Power wire cutouts: Make holes on left and/or right of the component_mount
module power_wire_cutouts(component_width, component_height, component_depth, component_side_offset, component_up_offset, front_wire_holes) {
    
    // When the front is solid the switch slides in from the back, so everything
    // shifts rearward by front_plate_thickness to keep zip ties at the switch's back face.
    solid_z_offset = front_plate_hole ? 0 : front_plate_thickness;
    chassis_depth_main = component_depth + zip_tie_cutout_depth + solid_z_offset;
        
    mid_y = height/2 - component_up_offset; // Midplane of switch opening
    hole_spacing_x = component_width; // match rack holes
        
    if (front_wire_holes == 1 || front_wire_holes == 2){   //make left hole
        hole_left_x = (rack_width - component_width) / 2 - (wire_diameter /5) + component_side_offset;
        translate([hole_left_x, mid_y, -.1]) {
            linear_extrude(height = chassis_depth_main + .2) {circle(d=wire_diameter);}
            }
    }
    if (front_wire_holes == 1 || front_wire_holes == 3){   //make right hole
        hole_right_x = (rack_width + component_width) / 2 + (wire_diameter /5) + component_side_offset;
        translate([hole_right_x, mid_y, -.1]) {
            linear_extrude(height = chassis_depth_main + .2) {circle(d=wire_diameter);}
            }
    }
}

// front_panel: used to create Rack panel with mounting holes
module front_panel() {
    $fn = 64;
    // Create all rack holes
    module all_rack_holes() {
        // Rack standard: 3 holes per U, with specific positioning
        // Each U is 44.45mm, holes are at specific positions within each U
        hole_spacing_x = (rack_width == 152.4) ? 136.526 : 236.525; // 6 inch : 10 inch rack
        hole_left_x = (rack_width - hole_spacing_x) / 2;
        hole_right_x = (rack_width + hole_spacing_x) / 2;

        // 10 inch rack = 10x7mm oval
        // 6 inch rack = 3.25 x 6.5mm oval
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
                    // Show partial holes at edge only if half_heighc v v c  t_holes is true
                    partially_inside = (hole_y + slot_height/2 > 0 && hole_y - slot_height/2 < height);
                    show_hole = fully_inside || (half_height_holes && partially_inside && !fully_inside);
                    if (show_hole) {
                        translate([side_x, hole_y, front_plate_thickness/2]) {
                            cuboid([slot_len, slot_height, front_plate_thickness + e*2],rounding=3.5,edges=["Z"]);
                        }
                    }
                }
            }
        }
    }
    // Punch the full keystone footprint through the front face plate
    module keystone_front_cutout() {
        translate([keystone_tx, keystone_ty, -tolerance]) {
            cube([keystone_outer_width, keystone_outer_height, front_plate_thickness + 2 * tolerance]);
        }
    }
    module component_front_cutout(component, component_width, component_height, component_depth, component_side_offset, component_up_offset, component_wire_holes ){
        if (component) {            // add y offset here V
            translate([rack_width/2 + component_side_offset, height/2 - component_up_offset, front_plate_thickness/2])
                cuboid([component_width + tolerance*2, component_height + tolerance*2, front_plate_thickness+1]);
            if (component1_wire_holes < 4){
                power_wire_cutouts(component_width, component_height, component_depth, component_side_offset, component_up_offset, component_wire_holes); 
            }
        }
    }
    // Making the plate
    //====================================================================================
    difference(){
        translate([rack_width/2, height/2, front_plate_thickness/2]) // this undoes the first translate in the main assembly might get rid of later. Translate Mark
        cuboid([rack_width, height, front_plate_thickness], rounding=4, edges=["Z"]); 
        all_rack_holes(); 
        if (keystones) {
            if (keystone_left) {      //Cutout for left Keystone
                keystone_front_cutout();
            }
            if (keystone_right){     //Cutout for Right Keystone
                translate([rack_width, 0, 0]) mirror([1, 0, 0])
                keystone_front_cutout();
            }
        } //Cutout window in rack panel for componets. will need to change translates later Translate Mark
        component_front_cutout(component1, component1_width, component1_height, component1_depth, component1_side_offset, component1_up_offset, component1_wire_holes );
        component_front_cutout(component2, component2_width, component2_height, component2_depth, component2_side_offset, component2_up_offset, component2_wire_holes );
        component_front_cutout(component3, component3_width, component3_height, component3_depth, component3_side_offset, component3_up_offset, component3_wire_holes );
    }
   
}
//========================================================================================
// component_mount: used to make the soild shape of the holder for each component 
// with air holes and ziptie modules inside as well.
module component_mount(component, component_width, component_height, component_depth, component_side_offset, component_up_offset, front_wire_holes) {
    
    //6 inch racks (mounts=152.4mm; rails=15.875mm; usable space=120.65mm)
    //10 inch racks (mounts=254.0mm; rails=15.875mm; usable space=221.5mm)
    chassis_width = min(component_width + (2 * case_thickness), (rack_width == 152.4) ? 120.65 : 221.5);
    chassis_edge_radius = 2.0;
    tolerance = 0.42;

    // When the front is solid the switch slides in from the back, so everything
    // shifts rearward by front_plate_thickness to keep zip ties at the switch's back face.
    solid_z_offset = front_plate_hole ? 0 : front_plate_thickness + tolerance;
    chassis_depth_main = component_depth + zip_tie_cutout_depth + solid_z_offset;
    chassis_depth_indented = chassis_depth_main - zip_tie_indent_depth;
    $fn = 64;

    // Helper module
    module rounded_chassis_profile(width, height, radius, depth) {
        hull() {
            translate([radius, radius, 0]) cylinder(h = depth, r = radius);
            translate([width - radius, radius, 0]) cylinder(h = depth, r = radius);
            translate([radius, height - radius, 0]) cylinder(h = depth, r = radius);
            translate([width - radius, height - radius, 0]) cylinder(h = depth, r = radius);
        }
    }
    // Create the main body as a separate module
    module body() {
        side_margin = ((rack_width - chassis_width) / 2) + component_side_offset;
        chassis_height = min(component_height + (2 * case_thickness), height);
        // Chassis body
        translate([side_margin, (height - chassis_height) / 2 - component_up_offset, front_plate_thickness]) {
            rounded_chassis_profile(chassis_width, chassis_height, chassis_edge_radius, chassis_depth_main - front_plate_thickness);   
        }
    }
    // component_cutout: used to create cutout with optional lip for component_mount
    module component_cutout(){
 
    // When the front is solid the switch slides in from the back, so everything
    // shifts rearward by front_plate_thickness to keep zip ties at the switch's back face.
    solid_z_offset = front_plate_hole ? 0 : front_plate_thickness;
    chassis_depth_main = component_depth + zip_tie_cutout_depth + solid_z_offset;

    // Calculated dimensions
    cutout_w = component_width + (2 * tolerance);
    cutout_h = component_height + (2 * tolerance);
    cutout_x = (rack_width - cutout_w) / 2;
    cutout_y = (height - cutout_h) / 2;
        
        z_start = front_plate_hole ? -tolerance : front_plate_thickness;
        z_depth = front_plate_hole ? chassis_depth_main + 2*tolerance : chassis_depth_main - front_plate_thickness + tolerance;
        translate([((rack_width - cutout_w) / 2) + component_side_offset, ((height - cutout_h) / 2) - component_up_offset, z_start]) 
            cube([cutout_w, cutout_h, z_depth]);
}
    // Create zip tie holes and indents
    module zip_tie_features() {
        // Zip tie holes
        zip_z = component_depth + solid_z_offset;
        for (i = [0:zip_tie_hole_count-1]) {
            x_pos = (rack_width - component_width)/2 + component_side_offset + (component_width/(zip_tie_hole_count + 1)) * (i+1);
            translate([x_pos, 0, zip_z]) {
                cube([zip_tie_hole_width, height, zip_tie_hole_length]);
            }
        }
        // Zip tie indents (top and bottom)
        x_pos = ((rack_width - component_width)/2) + component_side_offset;
        chassis_height = min(component_height + (2 * case_thickness), height);
        // Top indent
        translate([x_pos, ((height - chassis_height)/2) - component_up_offset - e, zip_z]) {
            cube([component_width, zip_tie_indent_depth + e, zip_tie_cutout_depth + e]);
        }
        // Bottom indent
        translate([x_pos, ((height + chassis_height)/2 - zip_tie_indent_depth) + .1 - component_up_offset, zip_z]) {
            cube([component_width, zip_tie_indent_depth + e , zip_tie_cutout_depth + e]);
        }
    }
    // Simplified air holes with staggered honeycomb pattern on all faces
    module air_holes(){
        
        test_hex_fit_Y = (component_height + case_thickness*2) - ( hex_spacing + hex_bottom_frame*2);
        test_hex_fit_x = (component_width + case_thickness*2) - ( hex_spacing + hex_bottom_frame*2);
        
        if(air_holes){
            translate([rack_width/2 + component_side_offset, height/2 - component_up_offset, component_depth/2]){
                if(test_hex_fit_x >= 0){
                    difference(){         
                        cuboid([component_width + case_thickness*2 + e*2, component_height + case_thickness*2 + e*2, component_depth],rounding=0,edges=["Z"]);
                        hex_panel([component_width + case_thickness*2 + e*2, component_depth, component_height + case_thickness*2 + e*2], hex_strut, hex_spacing, frame=hex_bottom_frame, orient=FRONT); 
                    }
                }
                if (test_hex_fit_Y >= 0){
                    difference(){            
                        cuboid([component_width+ case_thickness*2 + e*2, component_height + case_thickness*2 + e*2, component_depth],rounding=0,edges=["Z"]);
                        hex_panel([ component_depth, component_height + case_thickness*2 + e*2, component_width+ case_thickness*2 + e*2 ], hex_strut, hex_spacing, frame=hex_bottom_frame, orient=LEFT); 
                    }
                }
            }
        }
    }
    
    // Adds a lip to each component
    module add_lip() {
        if(front_lip){
            difference() {
                translate([rack_width/2 + component_side_offset, height/2 - component_up_offset, 0])
                    rect_tube(size=[component_width + tolerance*2,component_height + tolerance*2], wall=.6, h=.6);
                power_wire_cutouts(component_width, component_height, component_depth, component_side_offset, component_up_offset, front_wire_holes);
            }
        }
    }
    // Complete keystone with embossed triangle
    module keystone() {
        
        wall=2.5;
        front_hole_width=14.9;
        front_hole_height=16.3;
        front_hole_z_offset=4.28;
        front_hole_lip=0;
        jack_width=front_hole_width+wall;
        jack_height=25;
        jack_depth=9.7;
        front_large_catch_depth=3;
        front_chamfer_angle=50; // degrees from horizontal (depth axis)
        back_hole_height=24.4;
        back_hole_z_offset=1.9;
        back_small_catch_length=2;
        back_small_catch_depth=1.4;
        back_large_catch_length=2.6;
        back_large_catch_depth=1.3;
        back_chamfer=1.2;

            union(){
                // Back edge chamfer via intersection with hull (4 separate cuts → 1 operation)
                intersection() {
                    difference(){
                        cube([jack_width+wall,jack_depth,jack_height+wall]);
                        // Front hole
                        translate([(jack_width+wall-front_hole_width)/2,-e,front_hole_z_offset])
                            cube([front_hole_width,jack_depth+wall,front_hole_height]);
                        // Back hole
                        translate([(jack_width+wall-front_hole_width)/2,front_large_catch_depth - e,back_hole_z_offset])
                            cube([front_hole_width,jack_depth+wall-front_large_catch_depth,back_hole_height]);
                        // Chamfer on front face of small catch
                        translate([wall + front_hole_width, 0, 0])
                            rotate([0, -90, 0])
                                linear_extrude(front_hole_width)
                                    polygon([
                                        [front_hole_z_offset + front_hole_height - e, front_hole_lip - e],
                                        [front_hole_z_offset + front_hole_height + (front_large_catch_depth - front_hole_lip) * tan(front_chamfer_angle), front_large_catch_depth],
                                        [front_hole_z_offset + front_hole_height - e, front_large_catch_depth]
                                    ]);
                        // Front directional triangle emboss (cut into face)
                        translate([(jack_width+wall)/2, 0.4, (front_hole_z_offset + front_hole_height + jack_height + wall) / 2])
                            rotate([90, 0, 0])
                                linear_extrude(height = 0.4+e)
                                    polygon([[0, -2], [-2, 2], [2, 2]]);
                    } // end difference
                    // Chamfer all 4 back edges in one hull operation
                    hull() {
                        cube([jack_width+wall, jack_depth-back_chamfer, jack_height+wall]);
                        translate([back_chamfer, 0, back_chamfer])
                            cube([jack_width+wall-2*back_chamfer, jack_depth, jack_height+wall-2*back_chamfer]);
                    }
                } // end intersection

                // Small back catch
                translate([wall + front_hole_width, 0, 0])
                    rotate([0, -90, 0])
                        linear_extrude(front_hole_width)
                            polygon([
                                [back_hole_z_offset + back_hole_height - back_small_catch_length, jack_depth - back_small_catch_depth],
                                [back_hole_z_offset + back_hole_height,                           jack_depth - back_small_catch_depth],
                                [back_hole_z_offset + back_hole_height,                           jack_depth],
                                [back_hole_z_offset + back_hole_height - back_small_catch_length, jack_depth]
                            ]);

                // Large back catch
                translate([wall + front_hole_width, 0, 0])
                    rotate([0, -90, 0])
                        linear_extrude(front_hole_width)
                            polygon([
                                [back_hole_z_offset,                           jack_depth - back_large_catch_depth],
                                [back_hole_z_offset + back_large_catch_length, jack_depth - back_large_catch_depth],
                                [back_hole_z_offset + back_large_catch_length, jack_depth],
                                [back_hole_z_offset,                           jack_depth]
                            ]);

            } // end union
    } // end module keystone
    // Assembly - boolean structure
    // ==============================================================
    if(component){
        union() {
            difference() {
                body();
                component_cutout();  
                power_wire_cutouts(component_width, component_height, component_depth, component_side_offset, component_up_offset, front_wire_holes);
                zip_tie_features();
                air_holes();
            }
            add_lip(); 
        }
    }
    if (keystones) {
        //rotate([90,0,0]) maps keystone Y→rack Z (depth), keystone Z→rack -Y (compensated by +keystone_outer_height in translate)
        if (keystone_left){    //Make left Keystone
            translate([keystone_tx, keystone_ty + keystone_outer_height, 0]) rotate([90,0,0]) keystone();
        }
        if (keystone_right){   //Make right Keystone
            translate([rack_width, 0, 0]) mirror([1, 0, 0]){
            translate([keystone_tx, keystone_ty + keystone_outer_height, 0]) rotate([90,0,0])        
            keystone();            
            }
        }
    }
}

//  make_rack(): Main assembly - boolean structure
// ==============================================================
module make_rack(){
        translate([-rack_width/2, -height/2, 0]){
                union(){
                    front_panel();
                    component_mount(component1, component1_width, component1_height, component1_depth, component1_side_offset, component1_up_offset, component1_wire_holes);  
                    component_mount(component2, component2_width, component2_height, component2_depth, component2_side_offset, component2_up_offset, component2_wire_holes);
                    component_mount(component3, component3_width, component3_height, component3_depth, component3_side_offset, component3_up_offset, component3_wire_holes);
                }
    }
}
// ==============================================================
// Call the module
if ($preview) {
    rotate([-90,0,0])
        translate([0, -height/2, -component1_depth/2]){
            make_rack();
        }
} else {
    make_rack();
}
