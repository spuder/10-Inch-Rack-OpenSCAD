#!/usr/bin/env bats
# Slow tests (~35s per case) — full CGAL geometry validation.
# Run with: make test-stl
load common

setup_file() {
    mkdir -p "$RENDERS"
}

@test "default parameters produce valid STL" {
    render_stl "default"
    [ -s "$RENDERS/default.stl" ]
}

@test "6-inch rack produces valid STL" {
    render_stl "6inch" -D 'rack_width=152.4'
    [ -s "$RENDERS/6inch.stl" ]
}

@test "2U height produces valid STL" {
    render_stl "2u" -D 'rack_height=2'
    [ -s "$RENDERS/2u.stl" ]
}

@test "0.5U height produces valid STL" {
    render_stl "half_u" -D 'rack_height=0.5'
    [ -s "$RENDERS/half_u.stl" ]
}

@test "small component_height (air hole edge case) produces valid STL" {
    render_stl "small_component" -D 'component_height=18' -D 'rack_height=0.5'
    [ -s "$RENDERS/small_component.stl" ]
}

@test "large component filling rack unit produces valid STL" {
    render_stl "large_component" -D 'component_height=40'
    [ -s "$RENDERS/large_component.stl" ]
}

@test "solid front plate produces valid STL" {
    render_stl "solid_front" -D 'front_plate_hole=false'
    [ -s "$RENDERS/solid_front.stl" ]
}

@test "air holes disabled produces valid STL" {
    render_stl "no_air" -D 'air_holes=false'
    [ -s "$RENDERS/no_air.stl" ]
}

@test "front wire holes enabled produces valid STL" {
    render_stl "wire_holes" -D 'front_wire_holes=true'
    [ -s "$RENDERS/wire_holes.stl" ]
}

@test "thick case walls produce valid STL" {
    render_stl "thick_walls" -D 'case_thickness=10'
    [ -s "$RENDERS/thick_walls.stl" ]
}

# ── Regression tests ──────────────────────────────────────────────────────────

@test "missing_air_holes" {
    render_stl "missing_air_holes" \
        -D 'rack_height=1' \
        -D 'component_width=182' -D 'component_depth=178' -D 'component_height=36' \
        -D 'air_holes=true'
    [ -s "$RENDERS/missing_air_holes.stl" ]
}

@test "chassis height overflow clamped (component_height=36 case_thickness=12)" {
    render_stl "chassis_overflow_clamp" \
        -D 'component_width=182' -D 'component_depth=178' -D 'component_height=36' \
        -D 'case_thickness=12'
    [ -s "$RENDERS/chassis_overflow_clamp.stl" ]
}
