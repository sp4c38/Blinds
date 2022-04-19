use <gearbox_parts.scad>

include <variables.scad>

// translate([0, 0, -MOTOR_MOUNT_CONNECTOR_PLATE_HEIGHT])
// 	cube([10, 10, SCREW_LENGTH+0.1]);

// PREVIEW
if (show_motor) {
	translate([0, 0, -MOTOR_MOUNT_CASE_PLATE_HEIGHT])
		esports_mjj775_motor();
}

if (show_motor_mount) {
	motor_mount(case_cover_height=15, motor_bearing_diameter=17.5+2*0.5, case_screw_hole_offset=14.5, case_screw_hole_diameter=3.90+2*0.4) {
		if (show_motor_mount_spacer) {
			spacer(diameter=RING_GEAR_CASE_DIAMETER, inner_diameter=RING_GEAR_CASE_COVER_INNER_DIAMETER, height=MOTOR_SPACER_HEIGHT);
		}
	};
}

difference() {
	for (stage = [0:number_stages-1]) {
		is_last_stage = stage == number_stages-1;
		
		start_height = stage == 0 ? MOTOR_GEAR_START_HEIGHT : MOTOR_GEAR_START_HEIGHT+MOTOR_GEAR_BASE_HEIGHT+RING_GEAR_HEIGHT+CARRIER_THICK_BAR_HEIGHT+CARRIER_BASE_HEIGHT+(stage-1)*(CARRIER_GEAR_BASE_HEIGHT+RING_GEAR_HEIGHT+CARRIER_THICK_BAR_HEIGHT+CARRIER_BASE_HEIGHT);
		
		// translate([0, 0, start_height]) color("red") cube([90, 90, 0.2], center=true);
		
		translate([0, 0, !ground_all ? start_height : 0]) {
			if (show_motor_gear && stage == 0) {
				motor_gear();	
			}
			
			translate([0, 0, !ground_all ? ((stage == 0) ? MOTOR_GEAR_BASE_HEIGHT : CARRIER_GEAR_BASE_HEIGHT) : 0])
			union() {
	
				if (show_planet_gears) {
					planet_gears(modul=PLANET_GEAR_MODULE, number_teeth=PLANET_GEAR_TEETH, center_offset=PLANET_CENTER_OFFSET, height=PLANET_GEAR_HEIGHT, hole_diameter=PLANET_GEAR_HOLE_DIAMETER, helix_angle=PLANET_GEAR_HELIX_ANGLE, number_gears=PLANET_NUMBER_GEARS);
				}
				
				if (show_ring_gear) {
					ring_gear(modul=RING_GEAR_MODULE, number_teeth=RING_GEAR_TEETH, height=RING_GEAR_HEIGHT, border_width=RING_GEAR_BORDER_WIDTH, helix_angle=RING_GEAR_HELIX_ANGLE, mount_diameter=RING_GEAR_MOUNT_DIAMETER, mount_amount=RING_GEAR_MOUNT_AMOUNT);
				}
				
				if (show_ring_gear_case) {
					ring_gear_case(stage_no=stage) {
						translate([0, 0, RING_GEAR_HEIGHT]) {
							if (!is_last_stage && show_ring_gear_case_spacer) {
								spacer(diameter=RING_GEAR_CASE_DIAMETER, inner_diameter=RING_GEAR_CASE_COVER_INNER_DIAMETER, height=RING_GEAR_CASE_SPACER_HEIGHT);
							} else if (show_ring_gear_case_cover) {
								cover();
							}
						}
					};
				}
				
				if (show_carrier) {
					carrier(
						planet_number_gears=PLANET_NUMBER_GEARS, base_height=CARRIER_BASE_HEIGHT, planet_gear_center_offset=PLANET_CENTER_OFFSET, thin_bar_height=PLANET_GEAR_HEIGHT, thick_bar_height=CARRIER_THICK_BAR_HEIGHT, thin_bar_diameter=CARRIER_THIN_BAR_DIAMETER, thick_bar_diameter=CARRIER_THICK_BAR_DIAMETER, show_thick_bar=true, // Carrier parameters
						show_gear=show_carrier_gear, gear_module=CARRIER_GEAR_MODULE, gear_number_teeth=CARRIER_GEAR_TEETH_NUMBER, gear_height=MOTOR_GEAR_HEIGHT, gear_helix_angle=MOTOR_GEAR_HELIX_ANGLE, gear_base_diameter=CARRIER_GEAR_BASE_DIAMETER, gear_base_height=CARRIER_GEAR_BASE_HEIGHT // Gear parameters
					);
				}
			}
		}
	}
}

// for (i=[0:0]) {
// 	rotate([0, 0, i%2 == 1 ? 360/(2*BOLT_NUMBER) : 0])
// 	translate([0, 0, i*(30+15)]) {
// 		difference() {
// 			difference() {
// 				cylinder(d=2*BOLT_OFFSET+3, h=30); // RING_GEAR_CASE_DIAMETER
// 				translate([0, 0, -0.1])
// 					cylinder(d=2*BOLT_OFFSET+3-5, h=30+0.2); // RING_GEAR_DIAMETER+2*RING_GEAR_CASE_SPACING
// 			}
// 			
// 			translate([0,0, -0.1])
// 				bolt_slots(no=BOLT_NUMBER, offset=BOLT_OFFSET, length=30+0.2, empty=true);
// 		}
// 		
// 		bolt_slots(no=BOLT_NUMBER, offset=BOLT_OFFSET, length=30+0.2);
// 	}
// }