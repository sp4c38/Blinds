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
	rotate([0, 0, 9.5])
	motor_mount(show_spacer=show_motor_mount_spacer, case_cover_height=10, motor_bearing_diameter=17.5+2*0.5, case_screw_hole_offset=14.5, case_screw_hole_diameter=3.90+2*0.4);
}

difference() {
	for (stage = [0:number_stages-1]) {
		is_last_stage = stage == number_stages-1;
		
		start_height = stage == 0 ? MOTOR_GEAR_START_HEIGHT : MOTOR_GEAR_START_HEIGHT+MOTOR_GEAR_BASE_HEIGHT+RING_GEAR_HEIGHT+CARRIER_THICK_BAR_HEIGHT+CARRIER_BASE_HEIGHT+(stage-1)*(CARRIER_GEAR_BASE_HEIGHT+RING_GEAR_HEIGHT+CARRIER_THICK_BAR_HEIGHT+CARRIER_BASE_HEIGHT);
		
		// translate([0, 0, start_height]) color("red") cube([90, 90, 0.2], center=true);
		
		translate([0, 0, !ground_all ? start_height : 0]) {
			if (show_motor_gear && stage == 0) {
				rotate([0, 0, 11])
				motor_gear();	
			}
			
			translate([0, 0, !ground_all ? ((stage == 0) ? MOTOR_GEAR_BASE_HEIGHT : CARRIER_GEAR_BASE_HEIGHT) : 0])
			union() {
	
				if (show_planet_gears) {
					planet_gears(modul=PLANET_GEAR_MODULE, number_teeth=PLANET_GEAR_TEETH, center_offset=PLANET_CENTER_OFFSET, height=PLANET_GEAR_HEIGHT, hole_diameter=PLANET_GEAR_HOLE_DIAMETER, helix_angle=PLANET_GEAR_HELIX_ANGLE, number_gears=PLANET_NUMBER_GEARS);
				}
				
				if (show_ring_gear) {
					rotate([0, 0, 9.5])
					ring_gear(modul=RING_GEAR_MODULE, number_teeth=RING_GEAR_TEETH, height=RING_GEAR_HEIGHT, border_width=RING_GEAR_BORDER_WIDTH, helix_angle=RING_GEAR_HELIX_ANGLE, mount_diameter=RING_GEAR_MOUNT_DIAMETER, mount_amount=RING_GEAR_MOUNT_AMOUNT);
				}
				
				if (show_ring_gear_case) {
					rotate([0, 0, 9.5])
					ring_gear_case(stage_no=stage);
				}
				
				if (show_carrier) {
					carrier(is_last_stage=is_last_stage);
				}
			}
		}
	}
}

// use <../Gearbox Holder/gearbox_holder.scad>
// translate([0, 0, -MOTOR_MOUNT_CASE_PLATE_HEIGHT])
// 	gearbox_holder();