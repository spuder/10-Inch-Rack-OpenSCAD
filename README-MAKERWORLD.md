## MiniRack Generator

Do you have a 10 inch mini rack, but don't want to design the shelves yourself? 
Easily generate your own 10 inch rack shelves, no CAD required. 


### Customization

Click the Green "Customize" and enter the dimensions of your device.

![](https://makerworld.bblmw.com/makerworld/model/20260528/2023383446/7ab8ed871ffa306c.png)

A 0.42 mm tolerance is built in, which works well for most models. 

#### Available Parameters

Set `switch_width`, `switch_depth`, and `switch_height` to the width, depth, and height of the device you want to mount.

- **rack_width** (254.0) — 254 = 10 inch rack, 152.4 = 6 inch rack
- **rack_height** (1.0) — Height in U units (0.5–5U, each U = 44.45 mm)
- **switch_width** (135.0) — Width of the device, left to right (mm)
- **switch_depth** (135.0) — Depth of the device, front to back (mm)
- **switch_height** (28.3) — Height of the device (mm)
- **front_wire_holes** (false) — Adds small holes to route a USB or power cable through the front
- **wire_diameter** (7) — Diameter of front wire holes (mm)
- **air_holes** (true) — Hexagon cutouts on sides and back to reduce material and improve cooling
- **half_height_holes** (true) — Show partial rack mounting holes when rack_height is a fraction
- **case_thickness** (6) — Thickness of the shell walls (mm)
- **front_plate_thickness** (3.0) — Thickness of the front face plate (mm)
- **front_plate_hole** (true) — When false, front plate is solid — useful for devices that don't need front access
- **front_lip** (true) — Adds a small lip around the front opening to prevent the device from sliding out
- **tolerance** (0.42) — Gap added to each side between device and shell walls (mm)

#### Known Dimensions

##### Networking

- Firewalla Gold: `120 x 120 x 30 mm`*
- Firewalla Purple (Ethernet): `130 x 110 x 34 mm`*
- Firewalla Purple SE: `90 x 60 x 30 mm`*
- UniFi Security Gateway: `135 x 135 x 28.3 mm`*
- UniFi Cloud Key G2+: `131.2 x 27.1 x 134.2 mm`*
- UniFi Flex Mini: `107 x 70 x 21 mm`*
- UniFi Flex Mini 2.5G: `117.1 x 90 x 21.2 mm`*
- UniFi Flex 2.5: `212.9 x 76 x 33.5 mm`*
- UniFi Lite 8 POE: `99.6 x 163.7 x 31.7 mm`*
- UniFi Lite 16 POE: `192 x 185 x 44 mm`*
- UniFi Express: `98 x 98 x 30 mm`*
- UniFi Cloud Gateway Ultra/Max: `141.8 x 127.6 x 30 mm`*

##### Compute

- IBM M70q Gen 5: `179 x 182.9 x 36.5 mm`*
- IBM M70q Gen 4: `179 x 183 x 34.5 mm`*
- IBM M90q Gen 5: `179 x 182.9 x 36.5 mm`*
- Dell OptiPlex 7020: `182 x 178 x 36 mm`*
- HP Elite Mini 800: `177.5 x 175.2 x 34.3 mm`*
- M4 Mac Mini: `127 x 127 x 50 mm`*
- BeeLink ME Mini: `99 x 99 x 99 mm`*
- Xyber Hydra: `140 x 98.5 x 34.5 mm`*

##### Storage

- Synology DS223j: `165 x 100 x 225.5 mm`*
- Synology DS223: `165 x 108 x 232.7 mm`*
- Synology DS124: `166 x 71 x 224 mm`*

*\* Dimensions are Width × Depth × Height*

#### Related Projects

- [10 Inch parametric shelf generator](https://makerworld.com/en/models/1421393-parametric-10-inch-rack-shelf)
- [Alternative 10 inch rack generator with cage](https://github.com/WebMaka/ParametricRackCageGenerator)
- [OpenRack - A 19Inch modular system](https://makerworld.com/en/models/1032069-openrack-1u-a-modular-server-rack-system)

Source Code is [available on github](https://github.com/spuder/10-Inch-Rack-OpenSCAD)