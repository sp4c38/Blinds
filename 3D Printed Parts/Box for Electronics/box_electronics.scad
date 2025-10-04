$fa = 1;
$fs = 0.1;

WIDTH = 112 +2*0.3;
HEIGHT = 85 +2*0.3;
DEPTH = 37  +0.2;

BASE_BOTTOM_WALL_DEPTH = 1.4;
LID_DEPTH = 3;
LID_BORDER_WIDTH=2;
LID_BORDER_DEPTH=5;

// Needs to be at "Minimum wall width" show in console output.
BASE_WALL_WIDTH = LID_BORDER_WIDTH+1.5;

module base_outside(depth=DEPTH, wall_width=BASE_WALL_WIDTH, corner_radius=2) {
	delta_xy = sin(45)*corner_radius;
	corner_xy_increase = corner_radius-delta_xy;
	echo("Minimum wall width: ", corner_xy_increase);
	missing_wall_width = wall_width-corner_xy_increase > 0 ? wall_width-corner_xy_increase : 0;

	width = WIDTH + 2*missing_wall_width;
	height = HEIGHT + 2*missing_wall_width;

	points = [[0, 0], [width, 0], [width, height], [0, height]];

	translate([corner_xy_increase, corner_xy_increase, 0])
	hull() {
		translate([points[0][0]+delta_xy, points[0][1]+delta_xy, 0])	
			cylinder(r=corner_radius, h=depth);
		translate([points[1][0]-delta_xy, points[1][1]+delta_xy, 0])	
			cylinder(r=corner_radius, h=depth);
		translate([points[2][0]-delta_xy, points[2][1]-delta_xy, 0])	
			cylinder(r=corner_radius, h=depth);
		translate([points[3][0]+delta_xy, points[3][1]-delta_xy, 0])	
			cylinder(r=corner_radius, h=depth);
	}
}

module base() {
	total_depth=BASE_BOTTOM_WALL_DEPTH+DEPTH;
	
	difference() {
		base_outside(depth=total_depth-0.2);
		
		translate([BASE_WALL_WIDTH, BASE_WALL_WIDTH, BASE_BOTTOM_WALL_DEPTH])	
			cube([WIDTH, HEIGHT, DEPTH+0.01]);
		
		lid_border_z_tolerance = 2;
		translate([BASE_WALL_WIDTH-LID_BORDER_WIDTH, BASE_WALL_WIDTH-LID_BORDER_WIDTH, total_depth-LID_BORDER_DEPTH-lid_border_z_tolerance])
			cube([WIDTH+2*LID_BORDER_WIDTH, HEIGHT+2*LID_BORDER_WIDTH, LID_BORDER_DEPTH+lid_border_z_tolerance+0.01]);
	}
}

module lid(border_tolerance=0.13) {
	translate([0, 0, LID_BORDER_DEPTH])
		base_outside(depth=LID_DEPTH);

	color("orange")
	translate([BASE_WALL_WIDTH-LID_BORDER_WIDTH, BASE_WALL_WIDTH-LID_BORDER_WIDTH])
	difference() {
		translate([border_tolerance, border_tolerance, 0])
			cube([WIDTH+2*LID_BORDER_WIDTH-2*border_tolerance, HEIGHT+2*LID_BORDER_WIDTH-2*border_tolerance, LID_BORDER_DEPTH+0.01]);
		
		translate([LID_BORDER_WIDTH, LID_BORDER_WIDTH, -0.01])
			cube([WIDTH, HEIGHT, LID_BORDER_DEPTH+0.02]);
	}
}

module button_hole(thread_diameter=6.75+2*0.3, thread_depth=5, nut_max_diameter=11.2, nut_depth=2, nut_amount_corners=6, nut_max_diameter_tolerance=0.25) {
	translate([WIDTH+BASE_WALL_WIDTH-0.01, BASE_WALL_WIDTH+HEIGHT/2, (BASE_BOTTOM_WALL_DEPTH+DEPTH+LID_DEPTH)/2]) {
		rotate([0, 90, 0])
			cylinder(d=thread_diameter, h=thread_depth);

		nut_shape_maximum_diameter = nut_max_diameter+2*nut_max_diameter_tolerance;
		nut_shape_minimum_diameter = 2*(cos((360/nut_amount_corners)/2)*(nut_max_diameter/2+nut_max_diameter_tolerance));
		echo("Nut maximum diameter:", nut_max_diameter, "; Nut shape minimum diameter:", nut_shape_minimum_diameter, "; Difference", nut_max_diameter-nut_shape_minimum_diameter);
		
		if (nut_max_diameter-nut_shape_minimum_diameter <= 2*0.4) {
			echo("WARNING! Nut max diameter tolerance is too big.");
		}
		
		translate([thread_depth-nut_depth, 0, 0])
		rotate([0, 90, 0])
			cylinder(d=nut_shape_maximum_diameter, h=nut_depth, $fn=nut_amount_corners);
	}
}

module tolerance_hole_circle(diameter=10, depth=4, tolerance_left=2, tolerance_right=2, tolerance_top=2, tolerance_bottom=2) {
	hull() {	
		translate([-tolerance_left, -tolerance_bottom, 0])
			cylinder(d=diameter, h=depth);
			
		translate([tolerance_right, -tolerance_bottom, 0])
			cylinder(d=diameter, h=depth);
		
		translate([tolerance_right, tolerance_top, 0])
			cylinder(d=diameter, h=depth);
		
		translate([-tolerance_left, tolerance_top, 0])
			cylinder(d=diameter, h=depth);
	}
}

module tolerance_hole_rectangle(width=20, height=10, depth=5, tolerance_left=0, tolerance_right=0, tolerance_top=0, tolerance_bottom=1) {
	translate([-tolerance_left-width/2, -tolerance_bottom-height/2, 0])
		cube([width+tolerance_right+tolerance_left, height+tolerance_top+tolerance_bottom, depth]);
}

module power_supply_holes(main_right_padding=25.5+5.56, main_bottom_padding=8.7, main_diameter=9.3, mcu_width=12, mcu_height=8.05, mcu_padding_main=46, mcu_padding_bottom=6.25, motor_diameter=6.5+2*0.4) {
	main_x_position = -main_right_padding-main_diameter/2;
	
	translate([WIDTH+BASE_WALL_WIDTH, BASE_WALL_WIDTH, 0]) {
		// Added +20 to the tolerance_top in Oct/2025 because I'm reprinting this project. The +20 allows to easily insert wires without needing to resolder them (which would be needed to be able to put it through some closed cutout).
		translate([main_x_position, 0.01, BASE_BOTTOM_WALL_DEPTH+main_bottom_padding+main_diameter/2])
		rotate([90, 0, 0])
			tolerance_hole_circle(diameter=main_diameter, depth=BASE_WALL_WIDTH+0.02, tolerance_left=2, tolerance_right=2, tolerance_top=2+20, tolerance_bottom=2);
		
		mcu_z_position = BASE_BOTTOM_WALL_DEPTH+mcu_padding_bottom+mcu_height/2;
		mcu_tolerance_top = 2;
		mcu_tolerance_right = 2;
		mcu_tolerance_left = 2;
		mcu_x_position = main_x_position-main_diameter/2-mcu_padding_main-mcu_width/2;
		translate([mcu_x_position, 0.01, mcu_z_position])
		rotate([90, 0, 0])
			tolerance_hole_rectangle(width=mcu_width, height=mcu_height, depth=BASE_WALL_WIDTH+0.02, tolerance_left=mcu_tolerance_left, tolerance_right=mcu_tolerance_right, tolerance_top=mcu_tolerance_top, tolerance_bottom=2);
		
		motor_x_position = mcu_x_position+mcu_width/2+mcu_tolerance_right-((mcu_width+mcu_tolerance_left+mcu_tolerance_right)/2);
		translate([motor_x_position, 0.01, mcu_z_position+mcu_height/2+mcu_tolerance_top+motor_diameter/2+3])
		rotate([90, 0, 0])
			cylinder(d=motor_diameter, h=BASE_WALL_WIDTH+0.02);
	}
}

module ventilation_slots(no=3, depth=BASE_WALL_WIDTH, circle_diameter=5, extra_length=3, spacing=2) {
	rotate([90, 0, 0])
	translate([-(no*circle_diameter+(no-1)*spacing), circle_diameter/2+extra_length/2, 0]) {
		for(i=[0:no-1]) {
			translate([circle_diameter/2+i*(circle_diameter+spacing), 0, 0])
				tolerance_hole_circle(diameter=circle_diameter, depth=depth, tolerance_left=0, tolerance_right=0, tolerance_top=extra_length/2, tolerance_bottom=extra_length/2);
		}
	}
}

module ventilation(padding_right=3, padding_bottom=2) {
	no = 3;
	circle_diameter = 5.5;
	extra_length = 3.5;
	spacing = 1.5;
	slots_width = no*circle_diameter+(no-1)*spacing;
	
	translate([BASE_WALL_WIDTH+WIDTH-padding_right, BASE_WALL_WIDTH+0.01, BASE_BOTTOM_WALL_DEPTH+padding_bottom])
		ventilation_slots(no=no, depth=BASE_WALL_WIDTH+0.02, circle_diameter=circle_diameter, extra_length=extra_length, spacing=spacing);
	
	translate([BASE_WALL_WIDTH+0.01, BASE_WALL_WIDTH+padding_right, BASE_BOTTOM_WALL_DEPTH+padding_bottom])
	rotate([0, 0, -90])
		ventilation_slots(no=no, depth=BASE_WALL_WIDTH+0.02, circle_diameter=circle_diameter, extra_length=extra_length, spacing=spacing);
	
	translate([BASE_WALL_WIDTH+padding_right, BASE_WALL_WIDTH+HEIGHT-0.01, BASE_BOTTOM_WALL_DEPTH+padding_bottom])
	rotate([0, 0, 180])
		ventilation_slots(no=no, depth=BASE_WALL_WIDTH+0.02, circle_diameter=circle_diameter, extra_length=extra_length, spacing=spacing);
	
	translate([BASE_WALL_WIDTH+WIDTH-0.01, BASE_WALL_WIDTH+HEIGHT-padding_right, BASE_BOTTOM_WALL_DEPTH+padding_bottom])
	rotate([0, 0, 90])
		ventilation_slots(no=no, depth=BASE_WALL_WIDTH+0.02, circle_diameter=circle_diameter, extra_length=extra_length, spacing=spacing);
}

difference() {
	base();
	color("red")
		button_hole();
	color("orange")
		power_supply_holes();
	color("lightblue")
		ventilation();
}

translate([2*(WIDTH+2*BASE_WALL_WIDTH)+8, 0, LID_DEPTH+LID_BORDER_DEPTH])
rotate([0, 180, 0])
translate([0, 0, 0])
	lid();