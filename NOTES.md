v4
    jack_length=16.5,
    jack_width=15,
    wall_height=10,
    wall_thickness=4,
    catch_overhang=2.4,
    small_clip_depth=2,
    big_clip_clearance=4,
    small_clip_clearance=6.5

too stiff

v5
    jack_length=16.5,
    jack_width=15,
    wall_height=10,
    wall_thickness=4,
    catch_overhang=1.9,
    small_clip_depth=2.1,
    big_clip_clearance=4,
    small_clip_clearance=6.5

too stiff

v6
changed jack_start to make it soe small_clip_depth doesn't change hole size

    jack_length=16.5,
    jack_width=15,
    wall_height=10,
    wall_thickness=4,
    catch_overhang=2.2,
    small_clip_depth=2.0,
    big_clip_clearance=4,
    small_clip_clearance=6.5


waay too stiff

v7

    jack_length=16.7, <---------
    jack_width=15,
    wall_height=10,
    wall_thickness=4,
    catch_overhang=1.9, <------------
    small_clip_depth=2, <---------------
    big_clip_clearance=4,
    small_clip_clearance=6.5


still way too stiff

v8

    jack_length=16.9, <---
    jack_width=15,
    wall_height=10,
    wall_thickness=4,
    catch_overhang=2.1, <---
    small_clip_depth=2,
    big_clip_clearance=4,
    small_clip_clearance=6.5

still kind of stiff

v9

    jack_length=17.1, <-----
    jack_width=15,
    wall_height=10,
    wall_thickness=4,
    catch_overhang=2.3, <-----
    small_clip_depth=2,
    big_clip_clearance=4,
    small_clip_clearance=6.5

little snug on plastic, littlel loose on plastic
Kind of large gap beneith front of jack. 
Top chamfer is a little loose


v10

    jack_length=17.0, <-----
    jack_width=15,
    wall_height=10,
    wall_thickness=4,
    catch_overhang=2.3,
    small_clip_depth=2,
    big_clip_clearance=4,
    small_clip_clearance=7.5
    ) {
    big_clip_depth = catch_overhang + 2.4; <----

very clean and crispy on plastic
little loose on metal

v11

    jack_length=16.5, <----
    jack_width=15,
    wall_height=10,
    wall_thickness=4,
    catch_overhang=2.3,
    small_clip_depth=2,
    big_clip_clearance=5,
    small_clip_clearance=7.5
) {
    big_clip_depth = catch_overhang + 2.8; <----

perfect for metal keystones
front hole too small for plastic

v12

module keystone(
    jack_length=16.8, <---
    jack_width=15,
    wall_height=10,
    wall_thickness=4,
    catch_overhang=2.3,
    small_clip_depth=2,
    big_clip_clearance=5,
    small_clip_clearance=7.5
) {
    big_clip_depth = catch_overhang + 2.7; <---

too small for hdmi and metal, unable to rotate in because front hole too small
almost perfect for plastic

v13

    jack_length=17, <---
    jack_width=15,
    wall_height=9.5,
    wall_thickness=4,
    catch_overhang=2.3,
    small_clip_depth=2,
    big_clip_clearance=5,
    small_clip_clearance=7.5
) {
    big_clip_depth = catch_overhang + 2.7;

white rj45 - pretty good, small clip slides a littel too much, maybe increase from 45 degrees to 55 degrees
white hdmi - small clip doesn't stay in

v14
```
    jack_length=17,
    jack_width=15,
    wall_height=9.5,
    wall_thickness=4,
    catch_overhang=2.3,
    small_clip_depth=2,
    big_clip_clearance=5,
    small_clip_clearance=6.0
) {
    big_clip_depth = catch_overhang + 2.7;
    step_base      = 2;                           // fixed opening start offset
    jack_start     = wall_thickness + step_base;   // where the jack opening always begins
    outer_length   = jack_length + step_base + big_clip_depth + (wall_thickness * 2);
    outer_width    = jack_width + (wall_thickness * 2);
    chamfer_lead   = 2;                              // horizontal run of the insertion chamfers
    chamfer_angle  = 45;                             // slope angle from horizontal (deg); 45 = symmetric wedge
    chamfer_drop   = chamfer_lead * tan(chamfer_angle); // vertical drop derived from run + angle
    chamfer_depth  = 2;
    catch_z        = wall_height - catch_overhang;  // Z height of catch clips

    // Catch-clip ramp angle (the RED sloped faces of the snap clips), in degrees.
    // Lower = shallower/longer ramp (easier insertion); higher = steeper. ~53.5 = original ramp.
    catch_angle    = 42;
    catch_run      = catch_overhang / tan(catch_angle);  // horizontal run, derived from catch_angle
```

way too tight


v15

```
jack_length=17.2,
    jack_width=15,
    wall_height=9.5,
    wall_thickness=4.1,
    catch_overhang=2.3,
    small_clip_depth=2,
    big_clip_clearance=4.8,
    small_clip_clearance=6.0
) {
    big_clip_depth = catch_overhang + 2.9;
    step_base      = 2;                           // fixed opening start offset
    jack_start     = wall_thickness + step_base;   // where the jack opening always begins
    outer_length   = jack_length + step_base + big_clip_depth + (wall_thickness * 2);
    outer_width    = jack_width + (wall_thickness * 2);
    chamfer_lead   = 2;                              // horizontal run of the insertion chamfers
    chamfer_angle  = 45;                             // slope angle from horizontal (deg); 45 = symmetric wedge
    chamfer_drop   = chamfer_lead * tan(chamfer_angle); // vertical drop derived from run + angle
    chamfer_depth  = 3;
    catch_z        = wall_height - catch_overhang;  // Z height of catch clips

    // Catch-clip ramp angle (the RED sloped faces of the snap clips), in degrees.
    // Lower = shallower/longer ramp (easier insertion); higher = steeper. ~53.5 = original ramp.
    catch_angle    = 42;
    catch_run      = catch_overhang / tan(catch_angle);  // horizontal run, derived from catch_angle
```

worse in every way, too small to fit in
too loose for metal, too tight for plastic

v16
```
    jack_length=17.3,
    jack_width=15,
    wall_height=9.4,
    wall_thickness=4.0,
    catch_overhang=2.2,
    small_clip_depth=2,
    big_clip_clearance=4.8,
    small_clip_clearance=6.0
) {
    big_clip_depth = catch_overhang + 3;
    step_base      = 2;                           // fixed opening start offset
    jack_start     = wall_thickness + step_base;   // where the jack opening always begins
    outer_length   = jack_length + step_base + big_clip_depth + (wall_thickness * 2);
    outer_width    = jack_width + (wall_thickness * 2);
    chamfer_lead   = 2.5;                              // horizontal run of the insertion chamfers
    chamfer_angle  = 55;                             // slope angle from horizontal (deg); 45 = symmetric wedge
    chamfer_drop   = chamfer_lead * tan(chamfer_angle); // vertical drop derived from run + angle
    chamfer_depth  = 3;
    catch_z        = wall_height - catch_overhang;  // Z height of catch clips

    // Catch-clip ramp angle (the RED sloped faces of the snap clips), in degrees.
    // Lower = shallower/longer ramp (easier insertion); higher = steeper. ~53.5 = original ramp.
    catch_angle    = 42;
    catch_run      = catch_overhang / tan(catch_angle);  // horizontal run, derived from catch_angle

    // How far the RIGHT catch clip is pushed deeper into the cavity (−X), in mm.
    // 0 = original position flush at the right wall; larger = clip reaches further over the jack.
    catch_inset    = 1;
```