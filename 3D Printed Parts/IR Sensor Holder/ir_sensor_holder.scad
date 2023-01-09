$fa = 0.1;
$fs = 0.1;

sensor_width = 49.5+0.5;
sensor_height = 14.3+0.5;
sensor_depth = 8.5+0.5;
min_border_width = 1.5;

cable_diameter = 7;
rise_degrees = 46;

sensor_case_width = sensor_width+min_border_width;
sensor_case_height = sensor_height+2*min_border_width;
sensor_case_depth = sensor_depth+2*min_border_width;
module sensor_case() {
	rotate([0, rise_degrees, 0])
	difference() {
		cube([sensor_case_depth, sensor_case_height, sensor_case_width]);
		
		translate([min_border_width, min_border_width, min_border_width])
			cube([sensor_depth, sensor_height, sensor_width+0.01]);
			
		translate([sensor_case_depth/2, sensor_case_height+0.01, cable_diameter/2+min_border_width])
		rotate([90, 0, 0])
			cylinder(d=cable_diameter, h=min_border_width+0.02);
	}
}

upper_shape_width = sensor_case_width * sin(rise_degrees);
upper_shape_height = sensor_case_width * cos(rise_degrees);

color("green")
translate([0, sensor_case_height, 0])
rotate([90, 0, 0])
linear_extrude(sensor_case_height)
	polygon([[0, -0.01], [upper_shape_width+0.01, upper_shape_height], [0, upper_shape_height]]);

lower_shape_width = sensor_case_depth * sin(90-rise_degrees);
lower_shape_height = sensor_case_depth * cos(90-rise_degrees);

color("green")
translate([0, sensor_case_height, 0])
rotate([90, 0, 0])
linear_extrude(sensor_case_height)
	polygon([[0, 0.01], [0, -lower_shape_height], [lower_shape_width+0.01, -lower_shape_height]]);

sensor_case();