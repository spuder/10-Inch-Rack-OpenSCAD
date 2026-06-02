CHANGELOG.md
## v1.11.1
- Add keystone jacks to PlateGenerator.scad

## v1.11.0
- Add optional keystone jack mounts (`keystones` parameter) — two mounts placed symmetrically at the maximum 210mm usable width limit, one per rack ear
- Overhauled KeystoneJack.scad to make easier to modify. Will be released as own makerworld file
- Add .json files to store presets
- Overhaul tests
- Remove `print_orientation` and replaced with builtin $preview variable


## v1.10.0
- Rename `switch_width/depth/height` parameters to `component_width/depth/height`
- Fix chassis overflowing rack panel when `component_height + 2*case_thickness` exceeds the rack unit height

## v1.9.0
- Adds testing
- Fix missing holes when `component_height` is within 6mm of `rack_height` [github #9](https://github.com/spuder/10-Inch-Rack-OpenSCAD/issues/9)

## v1.8.0
- Add `front_plate_hole` parameter to optionally keep the front panel solid
- Add `front_plate_thickness` parameter to control front panel depth
- Improved tabbed grouping of variables in UI

## v1.7.1
- Fix regression that hid vars

## v1.7.0
- Makes front lip configurable
- General improvments in parameter grouping

## v1.6.0
- Adds variable for wire_diameter

## v1.5.0
- Add variable to change case thickness (defaults to 6)

## v1.4.0
- Initial release of plate generator

## v1.3.1
- Change default values to USG dimensions
- Make tolerance a user changable parameter

## v1.3.0
- Reduce material usage above/below switch (now walls are 6mm)

## v1.2.1
- Allow air holes on smaller parts

## v1.2.0
- Improve hexagon spacing
- Support half height racks

## v1.1.1
- Increase front ear radius from 2 to 4mm

## v1.1.0
- Change squares to hexagons because hexagons are the bestagons
- Add side air holes
- Simplify logic for air holes

