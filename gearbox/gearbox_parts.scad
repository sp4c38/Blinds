include <variables.scad>

use <gears/Getriebe.scad>

// MOTOR
module esports_mjj775_motor() {
	translate([0, 0, -66.7])
	rotate([-90, 0, 0])
		import("EsportsMJJ775.stl");
}

module motor_bar(height=15) {
	cylinder(h=height, d=5);
}

module motor_mount_case(motor_diameter=42, motor_overlap=2.5, plate_height=3, cover_height=30, bearing_diameter=17.5, screw_hole_offset=14, screw_hole_diameter=3.3) {
	total_diameter = motor_diameter+2*motor_overlap+0.01;

	// Plate
	color("lightblue") {
		difference() {
			translate([0, 0, -0.01])
				cylinder(d=total_diameter+0.01, h=plate_height+0.02);
			translate([0, 0, -0.1])
				cylinder(d=bearing_diameter, h=plate_height+0.2);
			
			for (i=[-1:2:1]) {
				translate([i*screw_hole_offset, 0, -0.1])
					cylinder(d=screw_hole_diameter, h=plate_height+0.2);
			}
		}
	}
	
	// Motor cover
	color("gray") {
		translate([0, 0, plate_height])
		difference() {
			cylinder(d=total_diameter, h=cover_height);
		
			translate([0, 0, -0.1])
				cylinder(d=motor_diameter+0.6, h=cover_height+0.2);
		}
	}
}

module motor_mount_connector_plate(diameter=65.3, motor_case_diameter=47, height=3, case_cover_height=30, case_plate_height=2) {
	plate_width = (diameter-motor_case_diameter)/2;
	difference() {
		union() {
			// Plate
			difference() {
				cylinder(d=diameter-0.01, h=height);
				translate([0, 0, -0.1])
					cylinder(d=motor_case_diameter, h=height+0.2);
			}
			
			// Cone-like surrounding
			translate([0, 0, height])
			rotate_extrude() {
				translate([(motor_case_diameter-0.01)/2, 0, 0])
					polygon([[0, 0], [plate_width, 0], [0, case_cover_height-(height-case_plate_height)]]);
			}
		}
	}
}

module motor_mount(motor_diameter=MOTOR_MOUNT_MOTOR_DIAMETER, motor_overlap=MOTOR_MOUNT_CASE_OVERLAP, case_plate_height=MOTOR_MOUNT_CASE_PLATE_HEIGHT, case_cover_height=30, motor_bearing_diameter=17.5, diameter=MOTOR_MOUNT_DIAMETER, connector_plate_height=MOTOR_MOUNT_CONNECTOR_PLATE_HEIGHT, case_screw_hole_offset=14.5, case_screw_hole_diameter=4) {
	bolt_slots(length=MOTOR_SPACER_HEIGHT, stage_no=1, with_head_connectors=false) {
		rotate([180]) {
			motor_mount_case(motor_diameter=motor_diameter, motor_overlap=motor_overlap, plate_height=case_plate_height, cover_height=case_cover_height, bearing_diameter=motor_bearing_diameter, screw_hole_offset=case_screw_hole_offset, screw_hole_diameter=case_screw_hole_diameter);
			
			motor_case_diameter = motor_diameter+2*motor_overlap;
			motor_mount_connector_plate(diameter=diameter, motor_case_diameter=motor_case_diameter, height=connector_plate_height, case_cover_height=case_cover_height, case_plate_height=case_plate_height);
		}
		
		translate([0, 0, -0.01])
			children(0);
	}
}

// SPACER
module spacer(diameter=80, inner_diameter=60, height=3) {
	color("lightgreen") {
		difference() {
			cylinder(d=diameter, h=height);
			translate([0, 0, -0.01])
				cylinder(d=inner_diameter, h=height+0.02);
		}
	}
}

// MOTOR GEAR
module motor_gear(base_diameter=MOTOR_GEAR_BASE_DIAMETER, base_height=MOTOR_GEAR_BASE_HEIGHT, gear_module=MOTOR_GEAR_MODULE, number_teeth=MOTOR_GEAR_TEETH, gear_helix_angle=MOTOR_GEAR_HELIX_ANGLE, gear_height=MOTOR_GEAR_HEIGHT, hole_diameter=5, hole_tolerance=0.05,hole_height=MOTOR_GEAR_HOLE_HEIGHT) {
	total_height = base_height+gear_height;

	difference() {
		union() {
			cylinder(h=base_height, d=base_diameter);

			color("lightblue") {
				translate([0, 0, base_height-0.001])
					pfeilrad(modul=gear_module, zahnzahl=number_teeth, breite=gear_height, bohrung=0, eingriffswinkel=20, schraegungswinkel=gear_helix_angle, optimiert=false);
			}	
		}
		
		translate([0, 0, -0.1])
		difference() {
			cylinder(d=hole_diameter+2*hole_tolerance, h=hole_height+0.1);
			
			cube_width = hole_diameter-2.8;
			translate([hole_diameter/2-cube_width+hole_tolerance, -(hole_diameter)/2-hole_tolerance, -0.1])
				cube([cube_width, hole_diameter+2*hole_tolerance, hole_height+0.3]);
		}
		}
}

// PLANET GEARS
module planet_gear(modul=2, number_teeth=10, height=5, hole_diameter=5, helix_angle=20) {
	pfeilrad(modul=modul, zahnzahl=number_teeth, breite=height, bohrung=hole_diameter, schraegungswinkel=helix_angle, optimiert=true);
}

function planet_gear_teeth(sun_gear_teeth, ring_gear_teeth) = ring_gear_teeth/2-sun_gear_teeth/2;
function planet_gears_center_offset(motor_gear_teeth, motor_gear_module, ring_gear_teeth, ring_gear_module) = ((motor_gear_teeth*motor_gear_module)/2)+(((ring_gear_teeth*ring_gear_module)-(motor_gear_teeth*motor_gear_module))/4);
function planet_gears_rotation_angles(number_gears) = [for (i=[1:number_gears]) (360/number_gears)*i];

module planet_gears(modul=2, number_teeth=8, center_offset=20, height=10, hole_diameter=5, helix_angle=-20, number_gears=3) {
	rotation_angles = planet_gears_rotation_angles(number_gears);
	
	for (a=rotation_angles) {
		rotate([0, 0, a])
		translate([center_offset, 0, 0])
			planet_gear(modul=modul, number_teeth=number_teeth, height=height, hole_diameter=hole_diameter, helix_angle=helix_angle);
	}
}

// RING GEAR
module ring_gear_case_mounts(diameter_ring_gear=30, amount=5, diameter=5, height=10) {
	rotate_angle = 360/amount;
	rotate_offset = rotate_angle/2;
	for (i = [0:amount-1]) {
	rotate([0, 0, i*rotate_angle+rotate_offset])
		difference() {
			translate([diameter_ring_gear/2, 0, 0])
				cylinder(d=diameter, h=height);
			
			translate([0, 0, -0.1])
				cylinder(d=diameter_ring_gear-0.002, h=height+0.2);
		}
	}
}

module ring_gear(modul=1, number_teeth=57, height=10, border_width=5, helix_angle=20,  mount_amount=6, mount_diameter=5) {
	pfeilhohlrad(modul=modul, zahnzahl=number_teeth, breite=height, randbreite=border_width, eingriffswinkel=20, schraegungswinkel=helix_angle, anzahl_auslassungen=1);
	
	d = modul * number_teeth;
	c = modul / 6;
	da = ((modul <1)? d + (modul+c) * 2.2 : d + (modul+c) * 2) + 2*border_width;
	ring_gear_case_mounts(diameter_ring_gear=da, amount=mount_amount, diameter=mount_diameter, height=height);
}

/* Parameters prefixed with r_ should match the appropriate parameters parsed to the ring_gear module. 
*/
module ring_gear_case(stage_no=0, diameter=RING_GEAR_CASE_DIAMETER, ring_gear_inner_diameter=RING_GEAR_DIAMETER, spacing=RING_GEAR_CASE_SPACING, cover_diameter=RING_GEAR_CASE_COVER_INNER_DIAMETER, r_mount_diameter=RING_GEAR_MOUNT_DIAMETER, r_mount_amount=RING_GEAR_MOUNT_AMOUNT, r_height=RING_GEAR_HEIGHT) {
	is_last_stage = stage_no == number_stages-1;
	total_inner_diameter = ring_gear_inner_diameter + 2*spacing;
	
	bolt_length = r_height+(is_last_stage ? TOP_COVER_HEIGHT : RING_GEAR_CASE_SPACER_HEIGHT);
	bolt_slots(length=bolt_length, stage_no=stage_no) {
		difference() {
			cylinder(d=diameter, h=r_height);
		
			translate([0, 0, -0.01]) {
				cylinder(d=total_inner_diameter, h=r_height+0.02);
				ring_gear_case_mounts(diameter_ring_gear=ring_gear_inner_diameter, amount=r_mount_amount, diameter=r_mount_diameter+2*spacing, height=r_height+0.02);
			}
		}
	
		translate([0, 0, -0.01])
			children(0);
	}
}

// CARRIER
module carrier_base(planet_number_gears=3, base_height=10, planet_gear_center_offset=20, thin_bar_height=10, thick_bar_height=5, thin_bar_diameter=5,  thick_bar_diameter=10, show_thick_bar=true) {
	rotation_angles = planet_gears_rotation_angles(planet_number_gears);
	
	// Bars
	for (a=rotation_angles) {
		rotate([0, 0, a])
		translate([planet_gear_center_offset, 0, 0]) {
			cylinder(d=thin_bar_diameter, h=show_thick_bar ? thin_bar_height : thin_bar_height+thick_bar_height);
			
			if (show_thick_bar) {
				translate([0, 0, thin_bar_height])
					cylinder(d=thick_bar_diameter, h=thick_bar_height);
			}
		}
	}
	
	// Base
	hull() {
		for (a=rotation_angles) {
			rotate([0, 0, a])
			translate([planet_gear_center_offset, 0, thin_bar_height+thick_bar_height])
				cylinder(d=thick_bar_diameter, h=base_height);
		}
	}
}

module carrier_gear(show_gear=true, modul=2, number_teeth=10, gear_height=10, helix_angle=20, base_diameter=4, base_height=6, planet_gear_number=3, planet_gear_center_offset=19, thick_bar_diameter=7) {
	// Base
	cylinder(d=base_diameter, h=base_height);

	// Gear
	if (show_gear) {
		translate([0, 0, base_height])
			pfeilrad(modul=modul, zahnzahl=number_teeth, breite=gear_height, bohrung=0, eingriffswinkel=20, schraegungswinkel=helix_angle, optimiert=false);
	}
}

module carrier(
	planet_number_gears=3, base_height=10, planet_gear_center_offset=20, bar_height=10, thin_bar_height=10, thick_bar_height=5, thin_bar_diameter=5, thick_bar_diameter=10, show_thick_bar=false, // Carrier parameters
	
	show_gear=true, gear_module=2, gear_number_teeth=10, gear_height=10, gear_helix_angle=20, gear_base_diameter=4, gear_base_height=10 // Gear parameters
) {
	carrier_base(planet_number_gears=planet_number_gears, base_height=base_height, planet_gear_center_offset=planet_gear_center_offset, thin_bar_height=thin_bar_height,  thick_bar_height=thick_bar_height, thin_bar_diameter=thin_bar_diameter, thick_bar_diameter=thick_bar_diameter, show_thick_bar=show_thick_bar);
	
	gear_start_height = thin_bar_height+thick_bar_height+base_height;
	translate([0, 0, gear_start_height-0.001])
		carrier_gear(show_gear=show_gear, modul=gear_module, number_teeth=gear_number_teeth, gear_height=gear_height, helix_angle=gear_helix_angle, base_diameter=gear_base_diameter, base_height=gear_base_height, planet_gear_number=planet_number_gears, planet_gear_center_offset=planet_gear_center_offset, thick_bar_diameter=thick_bar_diameter);
}

// COVER
module cover(diameter=RING_GEAR_CASE_DIAMETER, inner_diameter=RING_GEAR_CASE_COVER_INNER_DIAMETER, height=TOP_COVER_HEIGHT, plate_height=TOP_COVER_PLATE_HEIGHT, hole_diameter=RING_GEAR_CASE_HOLE_DIAMETER) {
	difference() {
		color("orange") {
			cylinder(d=diameter, h=height);
		}
		
		cutout_height = height-plate_height;
		translate([0, 0, -0.1])
			cylinder(d=inner_diameter, h=cutout_height+0.1);
		
		translate([0, 0, cutout_height-0.1])
			cylinder(d=hole_diameter, h=plate_height+0.2);
	}
}

// BOLTS
module bolt_slot(length=30, empty=false, with_head=true, thread_diameter=BOLT_THREAD_DIAMETER, head_length=BOLT_HEAD_LENGTH, head_diameter=BOLT_HEAD_DIAMETER, wall_width=BOLT_WALL_WIDTH) {
	total_diameter = head_diameter+2*wall_width;
	
	// color(with_head ? "purple" : "lightblue")
	translate([total_diameter/2, 0, 0])
	difference() {
		cylinder(d=total_diameter+(!empty ? 0.01 : 0), h=length);
	
		if (!empty) {
			translate([0, 0, -0.1])
				cylinder(d=thread_diameter, h=length+0.2);
		
			if (with_head) {
				translate([0, 0, length-head_length])
					cylinder(d=head_diameter, h=head_length+0.1);
			}
		}
	}
}

module bolt_slots(length=30, stage_no=0, no=BOLT_NUMBER, offset=BOLT_OFFSET, with_head_connectors=true) {
	angle = with_head_connectors ? 360/(2*no) : 360/no;
	number_slots = with_head_connectors ? 2*no : no;
	
	difference() {
		children();
		
		rotate([0, 0, stage_no%2 == 1 ? angle : 0])
		union() {
			for (i=[0:number_slots-1]) {
				rotate([0, 0, i*angle])
				translate([offset, 0, 0])
					bolt_slot(length=length, empty=true);
			}
		}
	}
	
	rotate([0, 0, stage_no%2 == 1 ? angle : 0])
	union() {	
		for (i=[0:number_slots-1]) {
			rotate([0, 0, i*angle])
			translate([offset, 0, 0])
				bolt_slot(length=length, with_head=with_head_connectors ? (i%2 == 0 ? true : false) : false);
		}
	}
}