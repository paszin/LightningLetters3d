$fn=500;

use <transformlib2d.scad>

//Parameters
thickness = 1;
width = 33;
length = 33;
wall_thickness = 1;
height = 15;

letter_overhang = 1;

offset = 4;

stripe_height = 0.4;
stripe_width = 10;


component = "letter"; // or "box"
letter = "T";



module Letter(letter, size=30, thickness=1) {
                text(letter, 
                     size=size*0.8,
                     font="Zaio:style=Regular",
                     halign="center",
                     valign="center");
}



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
        //translate([0, 0, -height/2+stripe_height/2]) cube([width, stripe_width, stripe_height], center=true);
    }

}


//color("red", 1) translate([0, 0, thickness]) linear_extrude(thickness + letter_overhang) Letter(letter, size=width);


module printletter(letter) {

    translate([0, 0, thickness]) 
        cube([width-wall_thickness-offset, length-wall_thickness-offset, thickness], center=true);
    color("red", 1) translate([0, 0, thickness]) linear_extrude(thickness + letter_overhang) Letter(letter, size=width);
    
}





//connector

c_thickness = 1;
c_len_y = wall_thickness*2 + c_thickness*2;
c_len_x = stripe_width + 4;
c_height = height/3;

module connectorClip() {
    
difference() {
    union() {
        cube([c_len_x, c_len_y, c_thickness]); //ground
        cube([c_len_x, c_thickness ,c_height]); //side1
        translate([0, c_len_y-c_thickness, 0]) cube([c_len_x, c_thickness ,c_height]); //side2
    }
    translate([(c_len_x-stripe_width)/2, 0, c_thickness]) cube([stripe_width, c_len_y, c_height]);
}

}



module LetterBoxWithConnectors2(top, right, bottom, left) {
    rotate([180, 0, 0])
        difference() {
            printletterbox(letter);
            if (left) {
            translate([-width/2,0,c_thickness/2-height]) cube([c_len_y+0.3, c_len_x+0.3, c_thickness+1+stripe_height], center=true); //ground
            }
            if (right) {
            translate([width/2,0,c_thickness/2-height]) cube([c_len_y+0.3, c_len_x+0.3, c_thickness+1+stripe_height], center=true); //ground
            }
            if (top) {
            translate([0,width/2,c_thickness/2-height]) cube([c_len_x+0.3, c_len_y+0.3, c_thickness+1+stripe_height], center=true); //ground
            }
            if (bottom) {
            translate([0,-width/2,c_thickness/2-height]) cube([c_len_x+0.3, c_len_y+0.3, c_thickness+1+stripe_height], center=true); //ground
            }
    }
}


if (component == "box") {
    LetterBoxWithConnectors2(true, true, true, true);
}
else {
    printletter(letter);
}


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