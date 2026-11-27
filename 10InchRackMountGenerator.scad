include <BOSL2/std.scad>
include <BOSL2/walls.scad>

/* [Panel settings] */
rack_width = 254.0; // [ 254.0:10 inch, 152.4:6 inch]
// Height of the rack in U units, can be a fraction for partial U (e.g. 1.5 for 1U plus half of the next U)
rack_height = 1.0; // [0.5:0.5:5.5]
// Thickness of the front panel (the flat face plate).
front_plate_thickness = 3.0;
// Guide rails show the suggested boundrys of the mounts of the rack.(guide rails will not show up in final rendering).
guide_rails_on = true;
//============================================================================================
/* [Component1] */
component1 = 1; // [1: Insert Mount, 2: Shelf Mount, 3: Drawer Mount, 4: Hard Drive Mount, 5: disable]
component1_width = 110.0;
component1_depth = 122.0;
component1_height = 28.30;
component1_side_offset = 0;  // [-100:0.1:100]
component1_up_offset = 0;  // [-100:0.1:100]
// when true it will turn the component on its side 90 degrees.
component1_90 = false; // when true turn component 90 degrees clockwise while facing it.
// Adds small cutout a USB or Power cable could be routed through to the front
component1_wire_holes=4; // [1: Both Sides, 2: Left, 3: Right, 4: disable]
// Diameter of wire to route through front_wire_holes.
component1_wire_diameter=7; // Diameter of power wire holes
// Adds hexagon air hole cutouts to reduce material and improve cooling.
component1_air_holes=true; // [true:Show air holes, false:Hide air holes]
// cutout a big openings in place of air holes on sides. good for if  you have ports on the sides.
component1_side_windows=false; // [true:cutout big openings on sides, false:dont do that.]
//============================================================================================
/* [Component2] */
component2 = 4; // [1: Insert Mount, 2: Shelf Mount, 3: Drawer Mount, 4: Hard Drive Mount, 5: disable]
component2_width = 110.0;
component2_depth = 122.0;
component2_height = 28.30;
component2_side_offset = 0;  // [-100:0.1:100]
component2_up_offset = 0;  // [-100:0.1:100]
// when true it will turn the component on its side 90 degrees.
component2_90 = false; // when true turn component 90 degrees clockwise while facing it.
// Adds small cutout a USB or Power cable could be routed through to the front
component2_wire_holes=4; // [1: Both Sides, 2: Left, 3: Right, 4: disable]
// Diameter of wire to route through front_wire_holes.
component2_wire_diameter=7; // Diameter of power wire holes
// Adds hexagon air hole cutouts to reduce material and improve cooling.
component2_air_holes=true; // [true:Show air holes, false:Hide air holes]
// cutout a big openings in place of air holes on sides. good for if  you have ports on the sides.
component2_side_windows=false; // [true:cutout big openings on sides, false:dont do that.]
//============================================================================================
/* [Component3] */
component3 = 4; // [1: Insert Mount, 2: Shelf Mount, 3: Drawer Mount, 4: Hard Drive Mount, 5: disable]
component3_width = 110.0;
component3_depth = 122.0;
component3_height = 28.30;
component3_side_offset = 0;  // [-100:0.1:100]
component3_up_offset = 0;  // [-100:0.1:100]
// when true it will turn the component on its side 90 degrees.
component3_90 = false; // when true turn component 90 degrees clockwise while facing it.
// Adds small cutout a USB or Power cable could be routed through to the front
component3_wire_holes=4; // [1: Both Sides, 2: Left, 3: Right, 4: disable]
// Diameter of wire to route through front_wire_holes.
component3_wire_diameter=7; // Diameter of power wire holes
// Adds hexagon air hole cutouts to reduce material and improve cooling.
component3_air_holes=true; // [true:Show air holes, false:Hide air holes]
// cutout a big openings in place of air holes on sides. good for if  you have ports on the sides.
component3_side_windows=false; // [true:cutout big openings on sides, false:dont do that.]
//============================================================================================
/* [Keystone group 1] */
// Add keystone jacks to the front panel.
keystones1 = false;    // [true: Place keystone jacks, false: Remove keystone jacks]
//Rotate keystone jacks individually.
keystones1_I_rotate = 0;  // [-90:90:180]
//Move keystone group left or right. When jack is at 90 degrees recommend -91 as max offset
keystones1_side_offset = -95;  // [-95:0.1:95]
//Move keystone group up or down.
keystones1_up_offset = 0;  // [-100:0.1:100]
//increase or decrease the number of keystone jacks in the group.
keystones1_num = 1; // [1:1:10]
//increase or decrease the space between each keystone jacks in the group. When jack is at 90 degrees recommend 6.5 as min spaceing
keystones1_spaceing = 0; // [0:0.1:20]
//Enabling this feature will stack the keystones vertically instead of horazontally
keystones1_vertical = false;
//============================================================================================
/* [Keystone group 2] */
// Add keystone jacks to the front panel.
keystones2 = false;    // [true: Place keystone jacks, false: Remove keystone jacks]
//Rotate keystone jacks individually.
keystones2_I_rotate = 0;  // [-90:90:180]
//Move keystone group left or right. When jack is at 90 degrees recommend -91 as max offset
keystones2_side_offset = 95;  // [-95:0.1:95]
//Move keystone group up or down.
keystones2_up_offset = 0;  // [-100:0.1:100]
//increase or decrease the number of keystone jacks in the group.
keystones2_num = 1; // [1:1:10]
//increase or decrease the space between each keystone jacks in the group.
keystones2_spaceing = 0; // [0:0.1:20]
//Enabling this feature will stack the keystones vertically instead of horazontally
keystones2_vertical = false;
//============================================================================================
/* [Air Hole Settings] */
// size of struts between hexs.
hex_strut = 4; // [1:1:14]
// spacing determines how many hexs will fit in the space.
hex_spacing = 15;
// controls the thickness of the frame around the  hex cutout.
hex_bottom_frame = 10;  // [8:0.5:13]
//============================================================================================
/* [Drawer Handle Settings] */
//Length from top of the drawer to the bottom of the handle.
handle_height = 7;
//Length from side of the handle to the other side of it.
handle_width = 20;
//Radius of the bottom inner corners of the handle.
handle_bottom_fillet = 3;
//The top corners of the handle is based on handle_height and handle_bottom_fillet. This limits how big it can get.
limit_fillet = 6;
//============================================================================================
/* [Advanced] */
// Used when rack_height is a fraction, cuts a half oval for screws, otherwise will cover up the hole
half_height_holes = true; // [true:Show partial holes at edges, false:Hide partial holes]
// Thickness of the shell that wraps around the part.
case_thickness = 6; // Thickness of case walls
// Make the front plate solid (no hole), useful to hide a part not needing to be accessed from the exterior.
front_plate_hole = true; // [true:Show front plate hole, false:Solid front plate]
// Prevent part from sliding out the front by adding a small 0.6mm lip around the front plate hole.
front_lip = true; // [true:Show front lip, false:Hide front lip]
//Changes the size of the stopper for shelfs
stopper_size=10;
// Default gap between part and print walls
tolerance = 0.42;
//Cooming soon
PCB_mount=false;
//============================================================================================
/* [Hidden] */
height = 44.45 * rack_height;
lip_offset = .6;
//ziptie variables
zip_tie_hole_count = 8;
zip_tie_hole_width = 1.5;
zip_tie_hole_length = 6;
zip_tie_indent_depth = 2;
zip_tie_cutout_depth = 8;
// Keystone jack dementions
keystone_width = 19.9;
keystone_height = 27.5;
keystone_depth = 9.7;
// epsilon for coplanar face fixes, fixes bug where some faces leave a thin sliver of material
e=0.01; 
//***********************************End parameters*********************************//
//***********************************Helper Modules*********************************//
{// General Modules
// Makes a temp red rail on both sides of the mounting plate to show rec placement limit for component mounts.
module guide_rails(){
    
    translate([-105, 0, 2.9])
    color("red")
    cuboid([3, height, 6], chamfer=1, edges=["ALL"], $fn = 5);
    translate([105, 0, 2.9])
    color("red")
    cuboid([3, height, 6], chamfer=1, edges=["ALL"], $fn = 5);
}

// Builds one keystonejack mounting hole.
module build_keystone(){
    // This module makes one cuboid then cuts it with three more and one cut for the triangle.
    
    hole_width=14.9;
    
    cut_1_height=3;
    cut_1_depth=19.3;
    cut_1_z_offset=-3.36;
    cut_1_y_offset=-.18;
    
    cut_2_height=5.35;
    cut_2_depth=24.4;
    cut_2_z_offset=.8;
    cut_2_y_offset=-.35;
    
    cut_3_height=2.35;
    cut_3_depth=19.8;
    cut_3_z_offset=4.5;
    cut_3_y_offset=-.65;

    
    translate([0, 0, keystone_depth/2])//makes the origin the face 
        difference(){
            //main body cuts are made from
            cuboid([keystone_width, keystone_height, keystone_depth], chamfer=1.25, edges=[TOP], $fn = 10);
            //cut 1
            translate([0, cut_1_y_offset,cut_1_z_offset])
                    cuboid([hole_width, cut_1_depth, cut_1_height], chamfer=3, edges=[FRONT+BOTTOM], $fn = 10);
            //cut 2
            translate([0, cut_2_y_offset, cut_2_z_offset])
                    cuboid([hole_width, cut_2_depth, cut_2_height], $fn = 10);
            //cut  3
            translate([0, cut_3_y_offset, cut_3_z_offset])
                    cuboid([hole_width, cut_3_depth, cut_3_height]);
            // cut for the triangle
            translate([0,(-keystone_height/2)+2.5 , -keystone_depth/2-.01])
                rotate([0,0,90])
                    linear_extrude(1)
                        circle(r=3, $fn=3);
        } 
}

// Builds a rounded rec body with matching cut out centered facing the the mounting plate.
module build_component_body(component_width, component_height, component_depth, component_side_offset, component_up_offset){
  {//Varibles
  chassis_edge_radius = 2.0;
  no_front_cutout = front_plate_hole ? 0 : front_plate_thickness + tolerance;
  $fn = 64;
  }
  //used to make a sold rounded square to be cut up.
  module build_body(){
    translate([component_side_offset,- component_up_offset, (component_depth +  no_front_cutout + lip_offset)/2])
      cuboid([component_width + (2 * case_thickness), component_height + (2 * case_thickness), component_depth +lip_offset + no_front_cutout ], rounding = chassis_edge_radius, edges=["Z"], $fn = 20);
  }
  // used to create cutout for the componet
  module cut_component_cutout(){
    translate([component_side_offset, - component_up_offset,(component_depth + 2*tolerance)/2]) 
      cube([component_width + (2 * tolerance), component_height + (2 * tolerance), component_depth + 2*tolerance + lip_offset + no_front_cutout], center = true);
  }
  difference() {
    build_body();
    cut_component_cutout();
  }
}

// Builds an extention of the component body to the back end of the component body. "component_ext" is the controling varible for how much the body is extened.
module build_ext_component_body(component_width, component_height, component_depth, component_side_offset, component_up_offset, component_ext){
  {//Varibles
  chassis_edge_radius = 2.0;
  no_front_cutout = front_plate_hole ? 0 : front_plate_thickness + tolerance;
  $fn = 64;
  }
  //used to make a sold rounded square to be cut up.
  module build_body(){
    translate([component_side_offset, - component_up_offset, component_depth + lip_offset + ((component_ext + no_front_cutout)/2)-e])
      cuboid([component_width + (2 * case_thickness), component_height + (2 * case_thickness), component_ext + no_front_cutout ], rounding = chassis_edge_radius, edges=["Z"], $fn = 20);
  }
  // used to create cutout for the componet
  module cut_component_cutout(){
    translate([ component_side_offset, - component_up_offset, component_depth + lip_offset + (component_ext + no_front_cutout )/2-e]) 
      cube([component_width + (2 * tolerance), component_height + (2 * tolerance), component_ext + no_front_cutout +e], center = true);
  }
  difference() {
    build_body();
    cut_component_cutout();
  }
}

// builds a small lip around the edges of the cutout of the component at the mounting plate end.
module build_lip(component_width, component_height, component_depth, component_side_offset, component_up_offset){
  if(front_lip){
    difference() {
      translate([component_side_offset, - component_up_offset, 0])
        rect_tube(size=[component_width + tolerance*2,component_height + tolerance*2], wall=lip_offset, h=lip_offset, $fn = 10);
    }
  }
}

// builds small triangle stoppers on the back end of the component body farthest from the mounting plate.
module build_stopper(component_width, component_height, component_depth, component_side_offset, component_up_offset){
  no_front_cutout = front_plate_hole ? 0 : front_plate_thickness + tolerance;
  translate([component_side_offset - component_width/2-2, component_height/2 + case_thickness/2 - component_up_offset, component_depth +  no_front_cutout + 3.5 + tolerance])rotate([90,90,0])
      wedge([3,stopper_size,stopper_size]);
  translate([component_side_offset + component_width/2+2, component_height/2 + case_thickness/2 - component_up_offset, component_depth +  no_front_cutout + lip_offset + tolerance])rotate([90,-90,0])
      wedge([3,stopper_size,stopper_size]);
}

// Makes a cutout on the backend of the component body farthest from the mounting plate for zipties.
module cut_zip_tie_holes(component_width, component_height, component_depth, component_side_offset, component_up_offset) {
  no_front_cutout = front_plate_hole ? 0 : front_plate_thickness + tolerance;
  // Zip tie holes
  zip_z = component_depth + (zip_tie_cutout_depth/2) + no_front_cutout + lip_offset;
  for (i = [0:zip_tie_hole_count - 1]) {
      x_pos = (component_width)/2 + component_side_offset - (component_width/(zip_tie_hole_count + 1)) * (i+1);
      translate([x_pos, - component_up_offset, zip_z]) {
          cube([zip_tie_hole_width, height, zip_tie_hole_length], center = true);
      }
  }
  // Zip tie indents (top and bottom)
  x_pos = component_side_offset;
  // Top indent
  translate([x_pos, (- (component_height+(2*case_thickness))/2) - component_up_offset, zip_z]) {
      cube([component_width, zip_tie_indent_depth + e, zip_tie_cutout_depth + e], center = true);
  }
  // Bottom indent
  translate([x_pos, ((component_height+(2*case_thickness))/2) - component_up_offset, zip_z]) {
      cube([component_width, zip_tie_indent_depth + e , zip_tie_cutout_depth + e], center = true);
  }
}

// Cuts out hexagon holes on both top and bottom, and the sides of the component body.
module cut_air_holes(component_width, component_height, component_depth, component_side_offset, component_up_offset, air_holes){
        
  test_hex_fit_Y = (component_height + case_thickness*2) - ( hex_spacing + hex_bottom_frame*2);
  test_hex_fit_x = (component_width + case_thickness*2) - ( hex_spacing + hex_bottom_frame*2);
  test_hex_fit_z = (component_depth) - ( hex_spacing + hex_bottom_frame*2);        
  
  if(air_holes && test_hex_fit_z > 0){
    translate([component_side_offset, - component_up_offset, component_depth/2]){
      if(test_hex_fit_x >= 0){// cut hex hole from top and bottom
        difference(){         
          cuboid([component_width + case_thickness*2 + e*2, component_height + case_thickness*2 + e*2, component_depth],rounding=0,edges=["Z"], $fn = 10);
          hex_panel([component_width + case_thickness*2 + e*2, component_depth, component_height + case_thickness*2 + e*2], hex_strut, hex_spacing, frame=hex_bottom_frame, orient=FRONT, $fn = 10); 
        }
      }
      if (test_hex_fit_Y >= 0){//  cut hex holes form the sides
        difference(){ 
          rotate([90,0,0])
            cuboid([component_width+ case_thickness*2 + e*2, component_depth, component_height + case_thickness*2 + e*2],rounding=0,edges=["Z"], $fn = 10);
          rotate([90,0,0])
            hex_panel([ component_height + case_thickness*2 + e*2, component_depth, component_width+ case_thickness*2 + e*2 ], hex_strut, hex_spacing, frame=hex_bottom_frame, orient=LEFT, $fn = 10);     
        }
      }
    }
  }
}

// Power wire cutouts: Make holes on left and/or right of the component_mount.
module cut_power_wire_holes(component_width, component_height, component_depth, component_side_offset, component_up_offset, front_wire_holes, wire_diameter, component_90) {
    
    // When the front is solid the switch slides in from the back, so everything
    // shifts rearward by front_plate_thickness to keep zip ties at the switch's back face.
    solid_z_offset = front_plate_hole ? 0 : front_plate_thickness;
    chassis_depth_main = component_depth + zip_tie_cutout_depth + solid_z_offset;
        
    mid_y = - component_up_offset; // Midplane of switch opening
    hole_spacing_x = component_width; // match rack holes
        
    if (front_wire_holes == 1 || front_wire_holes == 2){   //make left hole
        hole_left_x = (-component_width) / 2 - (wire_diameter /5) + component_side_offset;
        translate([hole_left_x, mid_y, -.1]) {
            linear_extrude(height = chassis_depth_main + .2) {circle(d=wire_diameter, $fn = 20);}
            }
    }
    if (front_wire_holes == 1 || front_wire_holes == 3){   //make right hole
        hole_right_x = (component_width) / 2 + (wire_diameter /5) + component_side_offset;
        translate([hole_right_x, mid_y, -.1]) {
            linear_extrude(height = chassis_depth_main + .2) {circle(d=wire_diameter, $fn = 20);}
            }
    }
}

// cuts out the whole top part of the component body
module cut_top(component_width, component_height, component_depth, component_side_offset, component_up_offset){
  no_front_cutout = front_plate_hole ? 0 : front_plate_thickness + tolerance;
  translate([component_side_offset, - component_height/2 - component_up_offset - e, (component_depth + zip_tie_cutout_depth +  no_front_cutout)/2])
    cube([component_width + (tolerance*2) ,case_thickness*2,component_depth + zip_tie_cutout_depth +  no_front_cutout], center = true);
}

//Cuts out the sides of the component.
module cut_side_windows(component_width, component_height, component_depth, component_side_offset, component_up_offset, component_side_windows){
  if(component_side_windows){
    frame_offset = 8;
    translate([component_side_offset, - component_up_offset, component_depth/2])
      cube(([component_width + case_thickness*2 + e*2,component_height - frame_offset,component_depth - zip_tie_cutout_depth - frame_offset]), center = true);
  }
}
}
{// Drawer Modules
//Builds tray like rectangle body with  handle cutout.
module build_drawer_body(component_width, component_height, component_depth, component_side_offset, component_up_offset){
  {//Varibles
  no_front_cutout = front_plate_hole ? 0 : front_plate_thickness + tolerance;
  drawer_wall_thickness = 2;
  check_fillet = handle_height - handle_bottom_fillet;
  handle_top_fillet = check_fillet > limit_fillet ? limit_fillet : check_fillet;
  }
  //used to make a cube to be cut up.
  module build_body(){
    translate([component_side_offset,- component_up_offset, (component_depth + lip_offset)/2])
      cuboid([component_width - (tolerance*2), component_height - (tolerance*2), component_depth + lip_offset], chamfer = 2, edges=[TOP+BACK], $fn = 20);
  }
  // used to create cutout for the drawer
  module cut_drawer_cutout(){
    translate([component_side_offset, - component_up_offset - drawer_wall_thickness,(component_depth + lip_offset)/2]) 
    cuboid([component_width - (2 * tolerance) - (drawer_wall_thickness*2), component_height - (2 * tolerance), component_depth - lip_offset - (drawer_wall_thickness*2)], rounding = component_height*.3, edges=[TOP+BACK], $fn = 20);
    translate([0,-(component_height/2)+((component_height*.2)/2) + tolerance-e, component_depth/2 + (component_depth*.3)/2-drawer_wall_thickness])
      cuboid([component_width,(component_height*.2),(component_depth*.7)], chamfer = (component_height*.2), edges=[BOTTOM+BACK]);
  }
  //used to make a cut in the drawer main body to be used as a handle.
  module cut_drawer_handle(){
    translate([0,-(component_height/2)+(handle_height/2) + tolerance-e, (drawer_wall_thickness + lip_offset)/2 ])
      cuboid([handle_width, handle_height, drawer_wall_thickness + lip_offset+e], rounding = handle_bottom_fillet, edges=[LEFT+BACK, RIGHT+BACK], $fn = 40);
    translate([handle_width/2,-(component_height/2) + tolerance-e, (drawer_wall_thickness + lip_offset)/2])
      fillet(l=drawer_wall_thickness + lip_offset+e, r=handle_top_fillet, ang=90, $fn = 40);
    translate([-handle_width/2,-(component_height/2) + tolerance-e, (drawer_wall_thickness + lip_offset)/2])
    rotate([0,180,0])
      fillet(l=drawer_wall_thickness + lip_offset+e, r=handle_top_fillet, ang=90, $fn = 40);
  }
  difference(){
    build_body();
    cut_drawer_cutout();
    cut_drawer_handle();
  }
}

//Builds a stops into the component mount ment to stop the drawer from pulling out.
module build_drawer_stops(component_width, component_height, component_depth, component_side_offset, component_up_offset){
  size_check = component_height*.20;
  stop_size = size_check >= 4 ? 4 : component_height*.20;
  
  translate([((component_width + tolerance*2)/2)-(stop_size/2), -((component_height + tolerance*2)/2)+(stop_size/2), (component_depth*.3) + (stop_size*.4)])
    cuboid([ stop_size, stop_size, stop_size*2], chamfer = stop_size, edges=[BOTTOM+BACK]);
  translate([-((component_width + tolerance*2)/2)+(stop_size/2), -((component_height + tolerance*2)/2)+(stop_size/2), (component_depth*.3) + (stop_size*.4)])
    cuboid([ stop_size, stop_size, stop_size*2], chamfer = stop_size, edges=[BOTTOM+BACK]);
}
}
{// Future Work
//######################################################################//
//Code for later features
module add_standoffs(){

    out_d = 5.5;
    in_d = 2.9;
    h =  4;
    if(PCB_mount){
      rotate([90,0,0]){
        translate([14, 67, 0])
          difference(){
            cylinder(h=h, d=out_d, center=true); 
            cylinder(h=h+.1, d=in_d, center=true);
          }
       translate([-14, 74, 0])
          difference(){
            cylinder(h=h, d=out_d, center=true); 
            cylinder(h=h+.1, d=in_d, center=true);
          }
        translate([14, -73.5, 0])
          difference(){
            cylinder(h=h, d=out_d, center=true); 
            cylinder(h=h+.1, d=in_d, center=true);
          }
        translate([-14, -73.5, 0])
          difference(){
            cylinder(h=h, d=out_d, center=true); 
            cylinder(h=h+.1, d=in_d, center=true);
          }
      }
    }
}
module gpu_sheild_cutout(){
  if(PCB_mount){
    translate([0, 0, -85.5])
      cube([40, 40 , 5], center = true);
      }
}
//######################################################################//
}
//**************************************Helper Modules************************************//
//***********************************Main Building Modules*********************************//
// front_panel: used to create Rack panel with mounting holes
module front_panel(){
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
        
        translate([-rack_width/2, -height/2, 0]){
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
                                cuboid([slot_len, slot_height, front_plate_thickness + e*2],rounding=slot_height/2,edges=["Z"], $fn = 40);
                            }
                        }
                    }
                }
            }
        }
    }
    // Punch the full keystone footprint through the front face plate
    module keystone_front_cutout(keystone_jack_group, keystone_jack_side_offset, keystone_jack_up_offset, keystone_jack_num, keystone_jack_I_rotate, keystone_jack_spaceing, keystone_jack_vertical) {
        
        // checks if keystones should be made vertically or horazontally
        keystone_x_spacing = (keystone_jack_vertical) ? 0 : keystone_width + keystone_jack_spaceing;
        keystone_y_spacing = (keystone_jack_vertical) ? keystone_width + keystone_jack_spaceing : 0;
        
        if (keystone_jack_group) { //check if Keystone group enabled
            translate([0, 0, front_plate_thickness/2]) {
                for (i = [0:keystone_jack_num-1]) { // loop for making multible jacks
                        translate([keystone_jack_side_offset + i*(keystone_x_spacing), -keystone_jack_up_offset + i*(keystone_y_spacing), 0])
                            rotate([0,0,keystone_jack_I_rotate]) // rotate cuts for jacks individually
                                cube([keystone_width, keystone_height, front_plate_thickness + 2 * tolerance], center=true);
                }
            }
        }
    }
    module component_front_cutout(component, component_width, component_height, component_depth, component_side_offset, component_up_offset, component_wire_holes, component_wire_diameter, component_90 ){
        
        turn90 = component_90 ? 90 : 0;
        
        no_front_cutout = front_plate_hole ? 0 : front_plate_thickness/2;
        if (component < 4) {           
            rotate([0,0,turn90])translate([component_side_offset, - component_up_offset, front_plate_thickness/2 + no_front_cutout])
                cuboid([component_width + tolerance*2, component_height + tolerance*2, front_plate_thickness+1], $fn = 10);
            if (component_wire_holes < 4){
                rotate([0,0,turn90])
                cut_power_wire_holes(component_width, component_height, component_depth, component_side_offset, component_up_offset, component_wire_holes,component_wire_diameter, component_90); 
            }
        }
    }
    // Making the plate
    //====================================================================================
    difference(){
        translate([0, 0, front_plate_thickness/2])
        
        cuboid([rack_width, height, front_plate_thickness], rounding=4, edges=["Z"], $fn = 20); 
        all_rack_holes(); 
        keystone_front_cutout(keystones1,keystones1_side_offset,keystones1_up_offset,keystones1_num,keystones1_I_rotate,keystones1_spaceing, keystones1_vertical);
        keystone_front_cutout(keystones2,keystones2_side_offset,keystones2_up_offset,keystones2_num,keystones2_I_rotate,keystones2_spaceing, keystones2_vertical);

        //Cutout window in rack panel for componets. will need to change translates later Translate Mark
        component_front_cutout(component1, component1_width, component1_height, component1_depth, component1_side_offset, component1_up_offset, component1_wire_holes, component1_wire_diameter, component1_90 );
        component_front_cutout(component2, component2_width, component2_height, component2_depth, component2_side_offset, component2_up_offset, component2_wire_holes, component2_wire_diameter, component2_90 );
        component_front_cutout(component3, component3_width, component3_height, component3_depth, component3_side_offset, component3_up_offset, component3_wire_holes, component3_wire_diameter, component3_90 );
    }
}
{// Mounts
//  Builds insert typr mount.
module insert_mount(component_width, component_height, component_depth, component_side_offset, component_up_offset, front_wire_holes, component_wire_diameter, air_holes, component_side_windows) {
  
  difference(){
    union(){
      build_component_body(component_width, component_height, component_depth, component_side_offset, component_up_offset);
      build_ext_component_body(component_width, component_height, component_depth, component_side_offset, component_up_offset, zip_tie_cutout_depth);
      build_lip(component_width, component_height, component_depth, component_side_offset, component_up_offset);
      }
    cut_zip_tie_holes(component_width, component_height, component_depth, component_side_offset, component_up_offset);
    cut_air_holes(component_width, component_height, component_depth, component_side_offset, component_up_offset, air_holes);
    cut_side_windows(component_width, component_height, component_depth, component_side_offset, component_up_offset, component_side_windows);
    cut_power_wire_holes(component_width, component_height, component_depth, component_side_offset, component_up_offset, front_wire_holes, component_wire_diameter);
  }
}

// Builds a shelf type mount.
module shelf_mount(component_width, component_height, component_depth, component_side_offset, component_up_offset, front_wire_holes, component_wire_diameter, air_holes, component_side_windows) {

  difference(){
    union(){
      build_component_body(component_width, component_height, component_depth, component_side_offset, component_up_offset);
      build_ext_component_body(component_width, component_height, component_depth, component_side_offset, component_up_offset, 3.4);
      build_stopper(component_width, component_height, component_depth, component_side_offset, component_up_offset);
    }
    cut_top(component_width, component_height, component_depth, component_side_offset, component_up_offset);
    cut_air_holes(component_width, component_height, component_depth, component_side_offset, component_up_offset, air_holes);
    cut_side_windows(component_width, component_height, component_depth, component_side_offset, component_up_offset, component_side_windows);
    cut_power_wire_holes(component_width, component_height, component_depth, component_side_offset, component_up_offset, front_wire_holes, component_wire_diameter);
  }
}

// Builds a mount with a drawer in it.
module drawer_mount(component_width, component_height, component_depth, component_side_offset, component_up_offset, air_holes, component_side_windows) {
  
  difference(){
    union(){
      //build_component_body(component_width, component_height, component_depth, component_side_offset, component_up_offset);
      build_ext_component_body(component_width, component_height, component_depth, component_side_offset, component_up_offset, 3.4);
      build_drawer_stops(component_width, component_height, component_depth, component_side_offset, component_up_offset);
      build_stopper(component_width, component_height, component_depth, component_side_offset, component_up_offset);
      }
    cut_air_holes(component_width, component_height, component_depth, component_side_offset, component_up_offset, air_holes);
    cut_side_windows(component_width, component_height, component_depth, component_side_offset, component_up_offset, component_side_windows);
  }
  build_drawer_body(component_width, component_height, component_depth, component_side_offset, component_up_offset);
}
}
// Keystone_jack_group: used to make the ports used to hold keystone jacks. lets you put up to 10 jacks per group.
module keystone_jack_group(keystone_jack_group, keystone_jack_side_offset, keystone_jack_up_offset, keystone_jack_num, keystone_jack_I_rotate, keystone_jack_spaceing, keystone_jack_vertical){
    
    // checks if keystones should be made vertically or horazontally
    keystone_x_spacing = (keystone_jack_vertical) ? 0 : keystone_width + keystone_jack_spaceing;
    keystone_y_spacing = (keystone_jack_vertical) ? keystone_width + keystone_jack_spaceing : 0;
    
    if (keystone_jack_group){   //check if Keystone group enabled
      for (i = [0:keystone_jack_num-1]) { // loop for making multible jacks
        translate([keystone_jack_side_offset + i*(keystone_x_spacing), -keystone_jack_up_offset + i*(keystone_y_spacing), 0]) 
        rotate([0,0,keystone_jack_I_rotate]){// rotate jacks individually
          build_keystone();  
            }    
        }      
    }
}

// This module is used to switch between the diffrenet types of mounts 
module build_mount(component, component_width, component_height, component_depth, component_side_offset, component_up_offset, front_wire_holes, component_wire_diameter, air_holes,component_90, component_side_windows) {

  turn90 = component_90 ? 90 : 0;
  
  if(component==1){
    rotate([0,0,turn90])
    insert_mount(component_width, component_height, component_depth, component_side_offset, component_up_offset, front_wire_holes, component_wire_diameter, air_holes, component_side_windows);
  }
  if(component==2){
    rotate([0,0,turn90])
    shelf_mount(component_width, component_height, component_depth, component_side_offset, component_up_offset, front_wire_holes, component_wire_diameter, air_holes, component_side_windows);
  }
  if(component==3){
    rotate([0,0,turn90])
    drawer_mount(component_width, component_height, component_depth, component_side_offset, component_up_offset, air_holes, component_side_windows);
  }
}
//***********************************Main Building Modules*********************************//
//***********************************Final Building Modules*********************************//
// Main assembly - boolean structure
module make_rack(){
  union(){
    front_panel();
      build_mount(component1, component1_width, component1_height, component1_depth, component1_side_offset, component1_up_offset, component1_wire_holes, component1_wire_diameter, component1_air_holes, component1_90, component1_side_windows); 
      build_mount(component2, component2_width, component2_height, component2_depth, component2_side_offset, component2_up_offset, component2_wire_holes, component2_wire_diameter, component2_air_holes, component2_90, component2_side_windows);
      build_mount(component3, component3_width, component3_height, component3_depth, component3_side_offset, component3_up_offset, component3_wire_holes, component3_wire_diameter, component3_air_holes, component3_90, component1_side_windows);
      keystone_jack_group(keystones1,keystones1_side_offset,keystones1_up_offset,keystones1_num,keystones1_I_rotate,keystones1_spaceing, keystones1_vertical);
      keystone_jack_group(keystones2,keystones2_side_offset,keystones2_up_offset,keystones2_num,keystones2_I_rotate,keystones2_spaceing, keystones2_vertical);
      }
  if($preview && guide_rails_on){
      guide_rails();
  }
}
// Call the module
if ($preview) {
  rotate([-90,0,0])
    translate([0, -height/2, -component1_depth/2]){
      difference(){
        make_rack();
        //translate([0, -50, -50])
          //cube([200, 100, 200]);
      }
    }
} else {
    difference(){
      make_rack();
      //translate([0, -50, -50])
        //cube([200, 100, 200]);
      //translate([-120, -25, 20])
        //cube([150, 100, 50]);
    }
}
