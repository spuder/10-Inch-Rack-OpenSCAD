# 10 Inch Rack Generator

OpenSCAD file to generate a 10 inch rack for 3d printing

[https://makerworld.com/models/1765102](https://makerworld.com/en/models/1765102-10-inch-mini-rack-generator)

![10 Inch Mini-Rack v4](https://github.com/user-attachments/assets/5946932a-b365-4e06-b929-32ac15681922)


## My Presets

My personal model configurations are saved as Customizer presets in
[`10InchRackGenerator.json`](10InchRackGenerator.json). OpenSCAD auto-loads this
file (it shares the `.scad` basename), so each saved model appears in the
Customizer's preset dropdown — pick one, Render (f6), then export the STL.

To build a preset from the command line:

```bash
openscad -p 10InchRackGenerator.json -P "Xyber Hydra" -o out.stl 10InchRackGenerator.scad
```

Every saved preset is also covered by the test suite (see the
`customizer presets render` case below), so presets added via the Customizer get
rendered automatically with no test edits.


## Testing

### Manual Testing
1. Open OpenScad
2. Modify variables
3. Click 'Render' button (f6)


### CLI Testing
1. `openscad -o foobar.stl 10InchRackGenerator.scad`


### Automated Tests

Requires [bats-core](https://github.com/bats-core/bats-core), `openscad`, and
`jq` (used to read presets) on your `PATH`.

```bash
# Fast preview tests — renders PNG images, ~1s per case
make test

# Full geometry validation — renders STL files via CGAL, ~35s per case
make test-stl

# Run a single test by name
make test TEST=missing_air_holes

# Run a single test with stl
RENDER_STL=1 make test TEST=missing_air_holes

# Render every model saved in 10InchRackGenerator.json
make test TEST="customizer presets render"
```

The `customizer presets render` case reads
[`10InchRackGenerator.json`](10InchRackGenerator.json) at runtime, so any model
you save from the GUI Customizer is tested automatically — no test edits needed.

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
