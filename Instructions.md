# 10-inch Rack Mount Generator — Usage Guide

Parametric OpenSCAD generator for 10-inch (and 6-inch) mini-rack faceplates
holding one to four devices per unit. Supports keystone jacks, angled load
supports, and a library of preset device sizes.

## Requirements

- OpenSCAD 2021.01 or newer (customizer with dropdowns).
- A slicer capable of handling `.stl` output.

## Quick start

1. Open the `.scad` file in OpenSCAD.
2. Open the Customizer panel (`Window → Customizer`).
3. Pick a rack width (10-inch / 6-inch) and height (in U).
4. Set `section_count` to the number of devices on this faceplate.
5. For each section, either pick a device from `sectionN_device` or leave
   it on `Custom` and enter `width / height / depth` yourself.
6. Adjust `sectionN_x_offset` (and `y_offset` for tall racks) to position
   each opening.
7. Render (F6) and export STL.

## Parameters

### Rack

| Name | Values | Notes |
|---|---|---|
| `rack_width` | `254.0` (10") · `152.4` (6") | Determines usable width, mounting-slot spacing, and slot size. |
| `rack_height` | `0.5` – `5` in `0.5` steps | U count. Most single-device layouts fit 1U; Mac Mini, NAS, and tower-oriented devices need 2U+. |
| `half_height_holes` | `true` / `false` | When `true`, partial rack-rail slots at the edges of fractional-U mounts are rendered. |

### Section count

| Name | Values | Notes |
|---|---|---|
| `section_count` | `1` – `4` | Number of openings on the faceplate. Only the first N sections are rendered. |

### Per-section (Section 1 shown; Sections 2–4 follow the same pattern)

| Name | Values | Notes |
|---|---|---|
| `section1_device` | Dropdown | `Custom` to use manual `width/height/depth`; any other value pulls dimensions from the preset table (see below). |
| `section1_width` | mm | Device width. Ignored when a preset is selected. |
| `section1_height` | mm | Device height. Ignored when a preset is selected. |
| `section1_depth` | mm | Device depth (front to back). Ignored when a preset is selected. |
| `section1_x_offset` | mm | Horizontal offset of the opening from the **center** of the faceplate. Negative = left. |
| `section1_y_offset` | mm | Vertical offset from the center. Only useful in 2U+ layouts. |
| `section1_keystone` | `true` / `false` | Cut keystone jack holes in the faceplate next to this opening. |
| `section1_keystone_count` | `1` – `6` | Number of jacks in the row. |
| `section1_keystone_side` | `0` / `1` | `0` = left of opening, `1` = right of opening. |
| `section1_support` | `true` / `false` | Add angled support gussets on both outer sides of the sleeve. |

### Shared

| Name | Values | Notes |
|---|---|---|
| `case_thickness` | mm | Wall thickness of each sleeve. Default `6`. |
| `wire_diameter` | mm | Diameter of the optional front-panel wire pass-through holes. |
| `front_wire_holes` | `true` / `false` | If `true`, adds round wire-pass holes at the mid-height of each opening, flanking the device. |
| `air_holes` | `true` / `false` | Staggered hex vents on the top, bottom, and sides of each sleeve. |
| `print_orientation` | `true` / `false` | `true` = laid flat on the print bed (back-down). `false` = rotated face-forward for display or preview. |
| `tolerance` | mm | Extra space around cutouts for printer fitment. Default `0.42` suits most FDM printers. |

### Keystone jacks (globals)

| Name | Values | Notes |
|---|---|---|
| `keystone_width` | mm | Cutout width. Default `14.94` is the industry-standard snap-in size. |
| `keystone_height` | mm | Cutout height. Default `16.51`. |
| `keystone_spacing` | mm | Gap between adjacent jacks in a row. |
| `keystone_gap_from_section` | mm | Gap between the first jack and the opening edge. |

Behavior:
- Cutouts only go through the faceplate, not the sleeve behind it.
- If `front_wire_holes` is enabled, jacks are pushed outward by the wire-hole
  perimeter so bezels don't clip the circles.
- Any jack that would collide with the rack-rail slot column is silently
  dropped and an `echo` warning is printed to the console.

### Angled supports (globals)

| Name | Values | Notes |
|---|---|---|
| `support_depth_requested` | mm | How far back along the sleeve the gusset ramps. Longer = stiffer. |
| `support_width_requested` | mm | How far along the faceplate the gusset extends. Actual width is clamped per section to the available gutter. |
| `support_rail_margin` | mm | Safety clearance between a gusset and the nearest rack-rail slot. |
| `support_min_width` | mm | Minimum renderable gusset width. Below this, the support is skipped with an `echo` warning. |

Behavior:
- Gussets render on both outer walls of any section where
  `sectionN_support = true`.
- Each side is independently clamped: the requested width is reduced to
  fit between the chassis wall and the nearest obstacle (adjacent section's
  chassis or the rack-rail column, minus the rail margin).

## Device presets

Selecting any value other than `Custom` in `sectionN_device` overrides that
section's manual `width / height / depth`. Dimensions are listed as
**W × H × D** (width across the rack, height up, depth into the rack).

### Network gear

| Device | W × H × D (mm) | Fits in |
|---|---|---|
| Firewalla Gold | 130 × 34 × 110 | 1U |
| Firewalla Purple (wifi) | 90 × 30 × 60 | 1U |
| Firewalla Purple (Ethernet) | 130 × 34 × 110 | 1U |
| Firewalla Purple SE | 90 × 30 × 60 | 1U |
| UniFi Security Gateway | 135 × 28.3 × 135 | 1U |
| UniFi Cloud Key G2+ | 131.2 × 134.2 × 27.1 | 4U (tall orientation) |
| UniFi Flex Mini | 107 × 21 × 70 | 1U |
| UniFi Flex Mini 2.5G | 117.1 × 21.2 × 90 | 1U |
| UniFi Flex 2.5 | 212.9 × 33.5 × 76 | 1U |
| UniFi Lite 8 PoE | 99.6 × 31.7 × 163.7 | 1U |
| UniFi Lite 16 PoE | 192 × 44 × 185 | 1U |
| UniFi Express | 98 × 30 × 98 | 1U |
| UniFi Cloud Gateway Ultra/Max | 141.8 × 30 × 127.6 | 1U |

### Compute

| Device | W × H × D (mm) | Fits in |
|---|---|---|
| IBM M70q Gen 5 | 179 × 36.5 × 182.9 | 1U |
| IBM M70q Gen 4 | 179 × 34.5 × 183 | 1U |
| IBM M90q Gen 5 | 179 × 36.5 × 182.9 | 1U |
| Dell OptiPlex 7020 | 182 × 36 × 178 | 1U |
| HP Elite Mini 800 | 177.5 × 34.3 × 175.2 | 1U |
| M4 Mac Mini | 127 × 50 × 127 | 2U |
| BeeLink ME Mini | 99 × 99 × 99 | 3U |
| Xyber Hydra | 140 × 34.5 × 98.5 | 1U |

### Storage

| Device | W × H × D (mm) | Fits in |
|---|---|---|
| Synology DS223j | 165 × 225.5 × 100 | 6U |
| Synology DS223 | 165 × 232.7 × 108 | 6U |
| Synology DS124 | 166 × 224 × 71 | 6U |

> Preset dimensions marked "theoretical/untested" on the MakerWorld source
> are reproduced as-is. Measure your actual device before committing to a
> print for tight-fitting gear.

If a selected preset is taller than the current `rack_height`, OpenSCAD
prints a warning in the console. Increase `rack_height` or choose a preset
that fits.

## Recipes

### Single 1U switch (original behavior)
rack_height = 1.0
section_count = 1
section1_device = UniFi Security Gateway
section1_x_offset = 0

### Two small devices side-by-side (dual-sleeve)
section_count = 2
section1_device = Firewalla Purple SE ; section1_x_offset = -56
section2_device = UniFi Flex Mini ; section2_x_offset = 56

### Two devices with keystone jacks in the center gutter
section_count = 2
section1_keystone = true ; section1_keystone_side = 1 (right of §1)
section2_keystone = true ; section2_keystone_side = 0 (left of §2)

### Heavy single device with supports
rack_height = 2.0
section_count = 1
section1_device = M4 Mac Mini
section1_support = true
support_depth_requested = 25
support_width_requested = 12

### Three small devices across a 1U
section_count = 3
section1_device = Firewalla Purple SE ; section1_x_offset = -85
section2_device = UniFi Express ; section2_x_offset = 0
section3_device = Firewalla Purple SE ; section3_x_offset = 85

## Console warnings
The model emits `echo` messages during preview/render when it skips or
clamps geometry. Check the OpenSCAD console if something didn't render as
expected.
| Message | Meaning | Action |
|---|---|---|
| `section N height (X) exceeds rack_height (Y)` | Preset is too tall for current U count. | Increase `rack_height`. |
| `keystone skipped on section N index=K` | A jack would have cut into the rack-rail slot column. | Reduce `sectionN_keystone_count` or move the section with `x_offset`. |
| `support skipped on section N side S` | Not enough free gutter to render a gusset on that side. | Reduce `support_width_requested`, move the adjacent section, or disable the support. |
## Printing notes
- **Material**: PETG or ASA preferred for heavy loads (Mac Mini, NAS,
  micro-PCs). PLA works for light devices but creeps under sustained load.
- **Perimeters**: 4+ for heavy devices.
- **Infill**: 40%+ for heavy devices, 20% fine for network gear.
- **Orientation**: Print with `print_orientation = true` (default).
  The faceplate sits flat on the bed and the sleeves stand up — no
  supports needed in the slicer.
- **Tolerance**: Default `tolerance = 0.42` suits a well-tuned FDM printer.
  If devices slide in too loosely, drop to `0.30`; too tight, raise to `0.50`.
## Credits
- Original generator: base single-switch design.
- Dual-sleeve feature: [cjolivier01](https://github.com/cjolivier01),
  PR #20 "Added dual sleeved version".
- Keystone jack feature: PR #21.
- Device preset dimensions: compiled from the
  [MakerWorld 10-inch Mini Rack Generator project page](https://makerworld.com/en/models/1765102-10-inch-mini-rack-generator).
- Multi-section generalization, angled supports, collision clamping,
  preset dropdown: this revision.

