module bar_screwboard(width=40, height=15, depth=2, number_holes=2, top_diameter=10, bottom_diameter=4.8, diameter_change_depth=3.4) {
	color("lightblue") {
		top_radius = top_diameter / 2;
		bottom_radius = bottom_diameter / 2;
		
		translate([-width/2, 0, 0])
		rotate([90, 0, 0])
		difference() {
			cube([width, height, depth], center=false);
			
			x = (width-number_holes*2*top_radius) / (number_holes+1); // spacing between edge and screw hole and between two screw holes
			for (i=[1:number_holes]) {
				translate([(i*x+(2*i-1)*top_radius), height/2, 0]) {
					translate([0, 0, depth-diameter_change_depth])
					cylinder(r1=bottom_radius, r2=top_radius, h=diameter_change_depth, center=false);
					
					cylinder(r=bottom_radius, h=depth-diameter_change_depth, center=false);
				}
			}
		}
	}
}

module bar_holder(width=10, height=20, depth_before=10, depth_after=20, bar_diameter=10, screwboard_number_holes=2, screwboard_height=10, screwboard_depth=5, screwboard_top_diameter=10, screwboard_bottom_diameter=4.8, screwboard_diameter_change_depth=3.4) {	
	depth_sum = depth_before+bar_diameter+depth_after;
	
	difference() {
		translate([0, depth_sum/2-(depth_before+bar_diameter/2), 0])
			cube([width, depth_before+bar_diameter+depth_after, height], center=true);
		
		rotate([0, 90, 0])
			cylinder(d=bar_diameter, h=width, center=true);
	}
	
	translate([0, bar_diameter/2+depth_after, height/2])
		bar_screwboard(width=width, height=screwboard_height, depth=screwboard_depth, number_holes=screwboard_number_holes, top_diameter=screwboard_top_diameter, bottom_diameter=screwboard_bottom_diameter, diameter_change_depth=screwboard_diameter_change_depth);		
	
	mirror([0, 0, 1])
	translate([0, bar_diameter/2+depth_after, height/2])
		bar_screwboard(width=width, height=screwboard_height, depth=screwboard_depth, number_holes=screwboard_number_holes, top_diameter=screwboard_top_diameter, bottom_diameter=screwboard_bottom_diameter, diameter_change_depth=screwboard_diameter_change_depth);
}

$fa = 1;
$fs = 1;

bar_holder(width=40, height=45, depth_before=8, depth_after=28.5, bar_diameter=30, screwboard_number_holes=2, screwboard_height=20, screwboard_depth=10, screwboard_top_diameter=10, screwboard_bottom_diameter=5   , screwboard_diameter_change_depth=3.4);
// bar_screwboard(width=40, height=20, depth=10, number_holes=2, top_diameter=10, bottom_diameter=4.8, diameter_change_depth=3.4);