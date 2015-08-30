//do_half_bust_FFF function

//variables set via calling script

model_stl="Kabbie_eyes_magnet(repaired1)simp100K(-6Y).stl";

magnet_z_pos=13.0376008;
thickness=3;

center_of_mass_x=-2.178563;
center_of_mass_y=-2.861163;
center_of_mass_z=22.565252;

barycenter_x=-2.002550;
barycenter_y=-3.993661;
barycenter_z=20.588537;

xmin=-42.608002;
xmax=41.578003;
ymin=-25.411917;
ymax=17.254002;
zmin=-0.096819;
zmax=65.188004;
/**********CUT LINE**********/
// Everything above this line will be replaced by calling script
// License: LGPLv2.1

//embedded variables
eps=0.00001; //overlap amount for correct booleans

//post 
$fn=50;

//disc magnet dimensions
magnet_d=12; //magnet diameter
magnet_t=3; //magnet thickness

//clearances
r_gap=.2; //clearance around radius
t_gap=.1; //clearance on thickness

//top hanger dimensions
slot_dia=2.5; //diameter of the slot & cylinder
slot_height=6; //height from the bottom of the hanger to the center of the slot cylinder
hanger_height=12; //height from inside of bust; does not include thickness. Must be > slot_height+slot_dia/2
keyhole_dia=5; //diameter of larger keyhole

//Calculations

//Since we are rotating model -90deg about x, y & z swap
mag_ymin=zmin;
mag_ymax=zmax;
mag_zmin=-ymax;
mag_zmax=-ymin;

//echo (mag_zmin=mag_zmin);

mag_xsize=xmax-xmin;
mag_ysize=mag_ymax-mag_ymin;
mag_zsize=mag_zmax-mag_zmin;

cut_box_xsize=1.10*mag_xsize;
cut_box_xtrans=(xmin + xmax)/2;

z_cut_box_ysize=1.10*mag_ysize;
z_cut_box_ytrans=(mag_ymin + mag_ymax)/2;
z_cut_box_zsize= (-1.10*mag_zmin) < (2*thickness) ? 2*thickness : -1.10*mag_zmin;

y_cut_box_ysize=z_cut_box_ysize/2-z_cut_box_ytrans;
y_cut_box_zsize=1.10*mag_zsize;
y_cut_box_ztrans=y_cut_box_zsize/2-z_cut_box_zsize;

//echo (y_cut_box_ysize=y_cut_box_ysize);
//echo (y_cut_box_zsize=y_cut_box_zsize);

//Main program

//difference() { // takes way to long to do boolean with model in OpenSCAD; do this in Blender instead
%    import (file=model_stl, convexity=10);

rotate ([90,0,0]) {
        
    //Top hanger
    translate([barycenter_x,mag_ymax-thickness-hanger_height,0]) {
        
       translate([0,0,-.1*thickness]) cylinder(d=keyhole_dia,h=2.1*thickness); //bottom hole
    translate([-keyhole_dia/2,0,1*thickness]) cube([keyhole_dia,1.2*slot_height,1*thickness]); //inside slot
    translate([0,1.2*slot_height,1*thickness]) rotate([0,0,22.5]) cylinder(d=keyhole_dia/cos(22.5),h=1*thickness,$fn=8); //top inside of slot, octagon
        
        
        translate([0,slot_height,-.1*thickness]) rotate([0,0,22.5]) cylinder(d=slot_dia/cos(22.5),h=1.2*thickness,$fn=8); //(-vol) top of slot, octagon
        translate([-slot_dia/2,-.1*slot_height,-.1*thickness]) cube([slot_dia,1.1*slot_height,1.2*thickness]); //(-vol) slot
        
    } //translate
    
    
    
    
    //cut boxes
    union() {
    translate ([cut_box_xtrans,z_cut_box_ytrans,-z_cut_box_zsize/2]) cube([cut_box_xsize,z_cut_box_ysize,z_cut_box_zsize], center=true); // (-vol) z_cut_box
    translate ([cut_box_xtrans,-y_cut_box_ysize/2,y_cut_box_ztrans]) cube([cut_box_xsize,y_cut_box_ysize,y_cut_box_zsize], center=true); //(-vol) y_cut_box
    }
    
    //magnet hole
    translate([barycenter_x,magnet_z_pos,-0.9*thickness]) cylinder(r=magnet_d/2+r_gap,h=magnet_t+t_gap+0.9*thickness); //(-vol) magnet with gap

} //rotate
//} //difference
