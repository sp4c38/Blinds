include <gears/Getriebe.scad>

$fa = 1;
$fs = 1.5;

// Show parts
show_motor = false;
show_motor_gear = true;

module esports_mjj775_motor() {
	translate([0, 0, -71])
	rotate([-90, 0, 0])
		import("EsportsMJJ775.stl");
}

module motor_gear(base_diameter=20, base_height=7, gear_module=2, gear_cylinder_overlap=7, gear_height=10, hole_diameter=5, top_hole_fill_height=4) {
	difference() {
		union() {
			cylinder(h=base_height, d=base_diameter);
			
			translate([0, 0, base_height-0.001])
				pfeilrad(modul=gear_module, zahnzahl=round((base_diameter+2.4*gear_module-gear_cylinder_overlap)/gear_module), breite=gear_height, bohrung=0, eingriffswinkel=20, schraegungswinkel=0, optimiert=false);	
		}
		
		cylinder(h=base_height+gear_height-top_hole_fill_height, d=hole_diameter);
	}
}

if (show_motor) {
	esports_mjj775_motor();
}

if (show_motor_gear) {
	if (show_motor) {
		translate([0, 0, 3])
			motor_gear();	
	} else {
		motor_gear();
	}
}