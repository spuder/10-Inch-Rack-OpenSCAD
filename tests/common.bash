#!/usr/bin/env bash
# Shared helpers loaded by all .bats files via: load common

SCAD="$BATS_TEST_DIRNAME/../10InchRackGenerator.scad"
RENDERS="$BATS_TEST_DIRNAME/renders"
OPENSCAD="${OPENSCAD:-openscad}"
IMGSIZE="${IMGSIZE:-2560,1440}"
RENDER_STL="${RENDER_STL:-0}"

# Standard camera rotations (tx,ty,tz,rx,ry,rz,dist).
# --autocenter and --viewall override tx/ty/tz and dist automatically.
CAMERA_CORNER="0,0,0,55,0,25,1"
CAMERA_FRONT="0,0,0,90,0,0,1"
CAMERA_SIDE="0,0,0,90,0,-90,1"
CAMERA_TOP="0,0,0,0,0,0,1"
CAMERA_BOTTOM="0,0,0,180,0,0,1"

# param_defined <name>
# True if name is a top-level variable in the SCAD file.
param_defined() {
    grep -qE "^$1[[:space:]]*=" "$SCAD"
}

# _validate_params [-D name=val ...]
# Errors if any -D parameter name is not defined in the SCAD file.
_validate_params() {
    local next_is_val=false
    for arg in "$@"; do
        if $next_is_val; then
            local name="${arg%%=*}"
            param_defined "$name" || { echo "Unknown parameter: $name"; return 1; }
            next_is_val=false
        elif [ "$arg" = "-D" ]; then
            next_is_val=true
        elif [[ "$arg" == -D* ]]; then
            local name="${arg#-D}"; name="${name%%=*}"
            param_defined "$name" || { echo "Unknown parameter: $name"; return 1; }
        fi
    done
}

# render_views <stem> [-D name=val ...]
# Renders front, side, top, and corner PNG previews to tests/renders/<stem>_<view>.png.
# Validates all -D parameter names before rendering.
render_views() {
    local stem="$1"; shift
    _validate_params "$@" || return 1

    local cameras=("$CAMERA_CORNER" "$CAMERA_FRONT" "$CAMERA_SIDE" "$CAMERA_TOP" "$CAMERA_BOTTOM")
    local views=("corner"          "front"          "side"          "top"          "bottom")

    for i in "${!views[@]}"; do
        "$OPENSCAD" \
            -o "$RENDERS/${stem}_${views[$i]}.png" \
            --imgsize="$IMGSIZE" \
            --camera="${cameras[$i]}" \
            --autocenter --viewall \
            --colorscheme="Tomorrow Night" \
            "$@" "$SCAD" 2>/dev/null || return 1
    done

    if [ "$RENDER_STL" = "1" ]; then
        render_stl "$stem" "$@"
    fi
}

# render_stl <stem> [-D name=val ...]
# Full CGAL geometry render to STL. Slow (~35s each).
render_stl() {
    local stem="$1"; shift
    _validate_params "$@" || return 1
    "$OPENSCAD" -o "$RENDERS/${stem}.stl" "$@" "$SCAD" 2>/dev/null
}

# assert_views_exist <stem>
# Checks all 4 view PNGs are non-empty files.
assert_views_exist() {
    local stem="$1"
    [ -s "$RENDERS/${stem}_corner.png" ] || { echo "Missing: ${stem}_corner.png"; return 1; }
    [ -s "$RENDERS/${stem}_front.png"  ] || { echo "Missing: ${stem}_front.png";  return 1; }
    [ -s "$RENDERS/${stem}_side.png"   ] || { echo "Missing: ${stem}_side.png";   return 1; }
    [ -s "$RENDERS/${stem}_top.png"    ] || { echo "Missing: ${stem}_top.png";    return 1; }
    [ -s "$RENDERS/${stem}_bottom.png" ] || { echo "Missing: ${stem}_bottom.png"; return 1; }
}
