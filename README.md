# 10 Inch Rack Generator

OpenSCAD file to generate a 10 inch rack for 3d printing

[https://makerworld.com/models/1765102](https://makerworld.com/en/models/1765102-10-inch-mini-rack-generator)

![10 Inch Mini-Rack v4](https://github.com/user-attachments/assets/5946932a-b365-4e06-b929-32ac15681922)


## Testing

### Manual Testing
1. Open OpenScad
2. Modify variables
3. Click 'Render' button (f6)


### CLI Testing
1. `openscad -o foobar.stl 10InchRackGenerator.scad`


### Automated Tests

Requires [bats-core](https://github.com/bats-core/bats-core) and `openscad` on your `PATH`.

```bash
# Fast preview tests — renders PNG images, ~1s per case
make test

# Full geometry validation — renders STL files via CGAL, ~35s per case
make test-stl

# Run a single test by name
make test TEST=missing_air_holes
```

Output files land in `tests/renders/`. Each test case produces up to five PNG previews:

```
tests/renders/
  default_corner.png
  default_front.png
  default_side.png
  default_top.png
  default_bottom.png
  default.stl          ← only present after make test-stl
```

To run a specific named case and also get its STL alongside the PNGs:

```bash
make test TEST=dell_optiplex_7020
# → tests/renders/dell_optiplex_7020_{corner,front,side,top,bottom}.png
# → tests/renders/dell_optiplex_7020.stl
```
