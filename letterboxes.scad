$fn=50;

use <transformlib2d.scad>

//Parameters
thickness = 5;
width = 50; //33
length = 50; //33
wall_thickness = 1;
height = 25;//15;

letter_overhang = 1;

offset = 4;

stripe_height = 0.6; //0.4;
stripe_width = 12;//60;//10;


component = "nix";// "box"; // or "box" or "connector"
letter = "S";



module Letter(letter, size=30, thickness=1) {
                text(letter, 
                     size=size*0.8,
                     font="Arial Rounded MT Bold:style=Regular", //font="Zaio:style=Regular",
                     halign="center",
                     valign="center");
}



module printletterbox(letter) {

    linear_extrude(thickness) difference() {
        square([width, length], center=true);
        outset(d=0.4) Letter(letter, size=width); //outset before was 0.3
       }

    translate([0, 0, -height/2]) //before z=-2*wall_thickness
    difference() {
        cube([width, length, height], center=true);
        cube([width-2*wall_thickness, length-2*wall_thickness, height], center=true);
    }

}


//color("red", 1) translate([0, 0, thickness]) linear_extrude(thickness + letter_overhang) Letter(letter, size=width);


module printletter(letter) {
    
    thickness_letter_plate = 1;

    translate([0, 0, thickness_letter_plate]) 
        cube([width-wall_thickness-offset, length-wall_thickness-offset, thickness_letter_plate], center=true);
    color("red", 1) translate([0, 0, thickness_letter_plate]) linear_extrude(thickness + letter_overhang) Letter(letter, size=width);
    
}





//connector

c_thickness = 1;
c_len_y = wall_thickness*2 + c_thickness*2;
c_len_x = stripe_width + 4;
c_height = height/3;


//new robust configuration

c_thickness = 1;
c_len_y = wall_thickness*2 + c_thickness*2 + 0.5;
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



module LetterBoxWithConnectors2(letter, top, right, bottom, left) {
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
    LetterBoxWithConnectors2(letter, true, true, true, true);
}
if (component == "letter") {
    printletter(letter);
}


//connectorClip();

//%translate([length/2, height, width/2 + 5]) rotate([90, 0, 0]) LetterBoxWithConnectors2(true, true, true, true);

module frame(units) {
    thickness = 5; 
    
    //connection from the other side
    module dif() {
        for(i = [length/2 : length : units * length]) {
            translate([i-c_len_x/2, 0, 0]) cube([c_len_x, 1, thickness]);
        }
    }
    
    difference() {
        cube([length*units, height + wall_thickness + 1, thickness]);
        dif();
        }
    
    //tiny overhang for the front
    translate([0, height + wall_thickness, thickness]) cube([length*units,1,1]);
    
    
    
}



module connectorClipStand() {
    
    c_height = 25;
    c_thickness = 3;
    c_len_y = wall_thickness*2 + c_thickness*2 + 0.5;
    
difference() {
    union() {
        cube([c_len_x+30, c_len_y, c_thickness]); //ground
        cube([c_len_x, c_thickness ,c_height]); //side1
        translate([0, c_len_y-c_thickness, 0]) cube([c_len_x, c_thickness ,c_height]); //side2
    }
    #translate([(c_len_x-stripe_width)/2, 0, c_thickness]) cube([stripe_width+100, c_len_y, c_height]);
}

}

//connectorClipStand();


//frame(3);
//►
text = [["S", "A", "P", "s", "v"], ["D", "S", "H", "O", "P"]];


frame_width = 2;
difference() {
for (j = [0 : length : 1*length]) {
    for(i = [0 : length : 4*length]) {
            translate([i, j, 0]) LetterBoxWithConnectors2(text[j/length][i/length], false, false, false, false);
        }
    }
     translate([-length/2+frame_width, -length/2+frame_width, height-6]) #cube([4*length-
    2*frame_width, 3*length-2*frame_width, 20]);
}
    
    
    
//for (j = [0 : length : 2*length]) {
//    for(i = [0 : length : 3*length]) {
//            translate([i, j, 0]) printletter(text[j/length][i/length]);
//        }
//    }
 
