#!/usr/bin/env bats
load common

setup_file() {
    mkdir -p "$RENDERS"
}

# ── Parameter contract ────────────────────────────────────────────────────────

@test "all documented parameters exist in SCAD file" {
    local params=(
        rack_width rack_height
        switch_width switch_depth switch_height
        front_wire_holes wire_diameter air_holes
        half_height_holes case_thickness front_plate_thickness
        front_plate_hole print_orientation front_lip tolerance
    )
    for p in "${params[@]}"; do
        param_defined "$p" || { echo "Missing parameter: $p"; return 1; }
    done
}

@test "unknown parameter name is caught before rendering" {
    run render_views "should_not_exist" -D 'swith_height=30'
    [ "$status" -ne 0 ]
}

# ── General previews ──────────────────────────────────────────────────────────

@test "default" {
    render_views "default"
    assert_views_exist "default"
}

@test "6-inch rack" {
    render_views "6inch" -D 'rack_width=152.4'
    assert_views_exist "6inch"
}

@test "2U" {
    render_views "2u" -D 'rack_height=2'
    assert_views_exist "2u"
}

@test "0.5U" {
    render_views "half_u" -D 'rack_height=0.5'
    assert_views_exist "half_u"
}

@test "solid front plate" {
    render_views "solid_front" -D 'front_plate_hole=false'
    assert_views_exist "solid_front"
}

@test "air holes disabled" {
    render_views "no_air" -D 'air_holes=false'
    assert_views_exist "no_air"
}

@test "front wire holes" {
    render_views "wire_holes" -D 'front_wire_holes=true'
    assert_views_exist "wire_holes"
}

@test "thick case walls" {
    render_views "thick_walls" -D 'case_thickness=10'
    assert_views_exist "thick_walls"
}

# ── Networking devices ────────────────────────────────────────────────────────

@test "Firewalla Gold (120x120x30)" {
    render_views "firewalla_gold" \
        -D 'switch_width=120' -D 'switch_depth=120' -D 'switch_height=30'
    assert_views_exist "firewalla_gold"
}

@test "Firewalla Purple Ethernet (130x110x34)" {
    render_views "firewalla_purple_ethernet" \
        -D 'switch_width=130' -D 'switch_depth=110' -D 'switch_height=34'
    assert_views_exist "firewalla_purple_ethernet"
}

@test "Firewalla Purple SE (90x60x30)" {
    render_views "firewalla_purple_se" \
        -D 'switch_width=90' -D 'switch_depth=60' -D 'switch_height=30'
    assert_views_exist "firewalla_purple_se"
}

@test "UniFi Security Gateway (135x135x28.3)" {
    render_views "unifi_security_gateway" \
        -D 'switch_width=135' -D 'switch_depth=135' -D 'switch_height=28.3'
    assert_views_exist "unifi_security_gateway"
}

@test "UniFi Cloud Key G2+ (131.2x27.1x134.2) 4U" {
    render_views "unifi_cloud_key_g2plus" \
        -D 'switch_width=131.2' -D 'switch_depth=27.1' -D 'switch_height=134.2' \
        -D 'rack_height=4'
    assert_views_exist "unifi_cloud_key_g2plus"
}

@test "UniFi Flex Mini (107x70x21)" {
    render_views "unifi_flex_mini" \
        -D 'switch_width=107' -D 'switch_depth=70' -D 'switch_height=21'
    assert_views_exist "unifi_flex_mini"
}

@test "UniFi Flex Mini 2.5G (117.1x90x21.2)" {
    render_views "unifi_flex_mini_2_5g" \
        -D 'switch_width=117.1' -D 'switch_depth=90' -D 'switch_height=21.2'
    assert_views_exist "unifi_flex_mini_2_5g"
}

@test "UniFi Flex 2.5 (212.9x76x33.5)" {
    render_views "unifi_flex_2_5" \
        -D 'switch_width=212.9' -D 'switch_depth=76' -D 'switch_height=33.5'
    assert_views_exist "unifi_flex_2_5"
}

@test "UniFi Lite 8 POE (99.6x163.7x31.7)" {
    render_views "unifi_lite_8_poe" \
        -D 'switch_width=99.6' -D 'switch_depth=163.7' -D 'switch_height=31.7'
    assert_views_exist "unifi_lite_8_poe"
}

@test "UniFi Lite 16 POE (192x185x44)" {
    render_views "unifi_lite_16_poe" \
        -D 'switch_width=192' -D 'switch_depth=185' -D 'switch_height=44'
    assert_views_exist "unifi_lite_16_poe"
}

@test "UniFi Express (98x98x30)" {
    render_views "unifi_express" \
        -D 'switch_width=98' -D 'switch_depth=98' -D 'switch_height=30'
    assert_views_exist "unifi_express"
}

@test "UniFi Cloud Gateway Ultra/Max (141.8x127.6x30)" {
    render_views "unifi_cloud_gateway_ultra" \
        -D 'switch_width=141.8' -D 'switch_depth=127.6' -D 'switch_height=30'
    assert_views_exist "unifi_cloud_gateway_ultra"
}

# ── Compute devices ───────────────────────────────────────────────────────────

@test "IBM M70q Gen 5 (179x182.9x36.5)" {
    render_views "ibm_m70q_gen5" \
        -D 'switch_width=179' -D 'switch_depth=182.9' -D 'switch_height=36.5'
    assert_views_exist "ibm_m70q_gen5"
}

@test "IBM M70q Gen 4 (179x183x34.5)" {
    render_views "ibm_m70q_gen4" \
        -D 'switch_width=179' -D 'switch_depth=183' -D 'switch_height=34.5'
    assert_views_exist "ibm_m70q_gen4"
}

@test "IBM M90q Gen 5 (179x182.9x36.5)" {
    render_views "ibm_m90q_gen5" \
        -D 'switch_width=179' -D 'switch_depth=182.9' -D 'switch_height=36.5'
    assert_views_exist "ibm_m90q_gen5"
}

@test "Dell OptiPlex 7020 (182x178x36)" {
    render_views "dell_optiplex_7020" \
        -D 'switch_width=182' -D 'switch_depth=178' -D 'switch_height=36'
    assert_views_exist "dell_optiplex_7020"
}

@test "HP Elite Mini 800 (177.5x175.2x34.3)" {
    render_views "hp_elite_mini_800" \
        -D 'switch_width=177.5' -D 'switch_depth=175.2' -D 'switch_height=34.3'
    assert_views_exist "hp_elite_mini_800"
}

@test "M4 Mac Mini (127x127x50) 2U" {
    render_views "m4_mac_mini" \
        -D 'switch_width=127' -D 'switch_depth=127' -D 'switch_height=50' \
        -D 'rack_height=2'
    assert_views_exist "m4_mac_mini"
}

@test "BeeLink ME Mini (99x99x99) 3U" {
    render_views "beelink_me_mini" \
        -D 'switch_width=99' -D 'switch_depth=99' -D 'switch_height=99' \
        -D 'rack_height=3'
    assert_views_exist "beelink_me_mini"
}

@test "Xyber Hydra (140x98.5x34.5)" {
    render_views "xyber_hydra" \
        -D 'switch_width=140' -D 'switch_depth=98.5' -D 'switch_height=34.5' -D 'front_plate_hole=true'
    assert_views_exist "xyber_hydra"
}

# ── Storage devices ───────────────────────────────────────────────────────────

@test "Synology DS223j (165x100x225.5) 5U" {
    render_views "synology_ds223j" \
        -D 'switch_width=165' -D 'switch_depth=100' -D 'switch_height=225.5' \
        -D 'rack_height=5'
    assert_views_exist "synology_ds223j"
}

@test "Synology DS223 (165x108x232.7) 5U" {
    render_views "synology_ds223" \
        -D 'switch_width=165' -D 'switch_depth=108' -D 'switch_height=232.7' \
        -D 'rack_height=5'
    assert_views_exist "synology_ds223"
}

@test "Synology DS124 (166x71x224) 5U" {
    render_views "synology_ds124" \
        -D 'switch_width=166' -D 'switch_depth=71' -D 'switch_height=224' \
        -D 'rack_height=5'
    assert_views_exist "synology_ds124"
}

# ── Regression tests ──────────────────────────────────────────────────────────

@test "missing_air_holes" {
    render_views "missing_air_holes" \
        -D 'rack_height=1' \
        -D 'switch_width=182' -D 'switch_depth=178' -D 'switch_height=36' \
        -D 'air_holes=true'
    assert_views_exist "missing_air_holes"
}
