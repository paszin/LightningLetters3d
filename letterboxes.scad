// Copyright (c) 2013 Oskar Linde. All rights reserved.
// License: BSD
//
// This library contains basic 2D morphology operations
//
// outset(d=1)            - creates a polygon at an offset d outside a 2D shape
// inset(d=1)             - creates a polygon at an offset d inside a 2D shape
// fillet(r=1)            - adds fillets of radius r to all concave corners of a 2D shape
// rounding(r=1)          - adds rounding to all convex corners of a 2D shape
// shell(d,center=false)  - makes a shell of width d along the edge of a 2D shape
//                        - positive values of d places the shell on the outside
//                        - negative values of d places the shell on the inside
//                        - center=true and positive d places the shell centered on the edge

module outset(d=1) {
	// Bug workaround for older OpenSCAD versions
	if (version_num() < 20130424) render() outset_extruded(d) child();
	else minkowski() {
		circle(r=d);
		children();
	}
}

module outset_extruded(d=1) {
   projection(cut=true) minkowski() {
        cylinder(r=d);
        linear_extrude(center=true) child();
   }
}

module inset(d=1) {
	 render() inverse() outset(d=d) inverse() child();
}

module fillet(r=1) {
	inset(d=r) render() outset(d=r) child();
}

module rounding(r=1) {
	outset(d=r) inset(d=r) child();
}

module shell(d,center=false) {
	if (center && d > 0) {
		difference() {
			outset(d=d/2) child();
			inset(d=d/2) child();
		}
	}
	if (!center && d > 0) {
		difference() {
			outset(d=d) child();
			child();
		}
	}
	if (!center && d < 0) {
		difference() {
			child();
			inset(d=-d) child();
		}
	}
	if (d == 0) child();
}


// Below are for internal use only

module inverse() {
	difference() {
		square(1e5,center=true);
		child();
	}
}


// TEST CODE



module mirror_x() {
	union() {
		child();
		scale([-1,1,1]) child();
	}
}

module mirror_y() {
	union() {
		child();
		scale([1,-1,1]) child();
	}
}

module mirror_z() {
	union() {
		child();
		scale([1,1,-1]) child();
	}
}

module arrow(l=1,w=.6,t=0.15) {
	mirror_y() polygon([[0,0],[l,0],[l-w/2,w/2],[l-w/2-sqrt(2)*t,w/2],[l-t/2-sqrt(2)*t,t/2],[0,t/2]]);
}

module shape() {
	polygon([[0,0],[1,0],[1.5,1],[2.5,1],[2,-1],[0,-1]]);
}

if(0) assign($fn=32) {

	for (p = [0:10*3-1]) assign(o=floor(p/3)) {
		translate([(p%3)*2.5,-o*3]) {
			//%if (p % 3 == 1) translate([0,0,1]) shape();
			if (p % 3 == 0) shape();
			if (p % 3 == 1) translate([0.6,0]) arrow();
			if (p % 3 == 2) {
				if (o == 0) inset(d=0.3) shape();
				if (o == 1) outset(d=0.3) shape();
				if (o == 2) rounding(r=0.3) shape();
				if (o == 3) fillet(r=0.3) shape();
				if (o == 4) shell(d=0.3) shape();
				if (o == 5) shell(d=-0.3) shape();
				if (o == 6) shell(d=0.3,center=true) shape();
				if (o == 7) rounding(r=0.3) fillet(r=0.3) shape();
				if (o == 8) shell(d=0.3,center=true) fillet(r=0.3) rounding(r=0.3) shape();
				if (o == 9) shell(d=-0.3) fillet(r=0.3) rounding(r=0.3) shape();
			}
		}
	}
}


module Letter(letter, size=30, thickness=1) {
                text(letter, 
                     size=size*0.8,
                     font="Zaio:style=Regular",
                     halign="center",
                     valign="center");
}



thickness = 1;
width = 33;
length = 33;
wall_thickness = 1;
height = 15;

letter_overhang = 1;

offset = 1;

stripe_height = 0.5;
stripe_width = 5;

letter = "S";

module printletterbox(letter) {

    linear_extrude(thickness) difference() {
        square([width, length], center=true);
        outset(d=0.3) Letter(letter, size=width);
       }

    translate([0, 0, -height/2]) //before z=-2*wall_thickness
    difference() {
        cube([width, length, height], center=true);
        cube([width-2*wall_thickness, length-2*wall_thickness, height], center=true);
        //the led stripe
        translate([0, 0, -height/2+stripe_height/2]) cube([width, stripe_width, stripe_height], center=true);
    }

}


//color("red", 1) translate([0, 0, thickness]) linear_extrude(thickness + letter_overhang) Letter(letter, size=width);


module printletter(letter) {

translate([0, 0, thickness]) cube([width-wall_thickness-offset, length-wall_thickness-offset, thickness], center=true);
color("red", 1) translate([0, 0, thickness]) linear_extrude(thickness + letter_overhang) Letter(letter, size=width);
    
}


//connectors
module connector(r, shapeFactor) {
    //shape is 1 or -1
    //30 degree cylinder
    rotate([0, shapeFactor * 30, 0]) cylinder(r=r, h=height/2, center=true);
    }


//printletter(letter);


module LetterBoxWithConnectors() {
difference() {
    union() {
        rotate([180, 0, 0]) printletterbox(letter);
        translate([-width/2, width/3, height/2]) connector(r=1, shapeFactor=-1);
        translate([+width/2, -width/3, height/2]) connector(r=1, shapeFactor=1);
    }
    translate([-width/2, -width/3, height/2]) connector(r=1.1, shapeFactor=1);
    translate([+width/2, width/3, height/2]) connector(r=1.1, shapeFactor=-1);
    translate([0, 0, height/2]) #cube([width-2*wall_thickness, length-2*wall_thickness, height], center=true);
}

}

//translate([33, 0, 0]) LetterBoxWithConnectors();
translate([0, 0, 0]) LetterBoxWithConnectors();

$fn=500;
/*
text = ["P", "A", "S", "C", "A", "L"];
layout = [  ["A", "A", "S", "C", "A", "L"], 
            ["P", "A", "S", "C", "A", "L"], 
            ["P", "A", "S", "C", "A", "L"],
 ["P", "A", "S", "C", "A", "L"], 
            ["P", "A", "S", "C", "A", "L"], 
            ["P", "A", "S", "C", "A", "L"],

];

step = width;

for (r=[0:step:(6-1)*step]) {
    for (i =[0:step:(6-1)*step]) {
        translate([i, r, 0]) printletterbox(layout[r/33][i/33]);
    }
}*/