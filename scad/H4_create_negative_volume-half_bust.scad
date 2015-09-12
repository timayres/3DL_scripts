//h4_neg_vol function

//variables set via calling script

model_stl="../test_models/TEST_BUST-simp20K(-8Y).stl";
model_offset_stl="../test_models/TEMP3DL_TEST_BUST-simp20K_H3-offset(-8Y).stl";

thickness=3;
magnet_z_pos=10.7804222;
magnet_center_height=6.744958;

orig_xmin=-29.564501;
orig_xmax=31.325228;
orig_ymin=-20.634674;
orig_ymax=15.724438;
orig_zmin=-0.827112;
orig_zmax=53.902111;

orig_center_of_mass_x=0.690921;
orig_center_of_mass_y=-1.400397;
orig_center_of_mass_z=18.289526;

orig_barycenter_x=0.681426;
orig_barycenter_y=-1.816130;
orig_barycenter_z=16.964798;

/**********CUT LINE**********/
// Everything above this line will be replaced by calling script
// License: LGPLv2.1

magnet_x_pos=orig_barycenter_x;//-2.5; // TWEAK THIS to center magnet if needed
top_slot_x_pos=orig_barycenter_x;//-2.5; // TWEAK THIS to center top hanging slot if needed

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

//post dimensions
rim_t=2; //thickness of rim around magnet
wall_t=4; //wall thickness of post
fillet_r=4; //fillet radius

//top hanger dimensions
slot_dia=2.5; //diameter of the slot & cylinder
slot_height=4; //height from the bottom of the hanger to the center of the slot cylinder
hanger_height=10; //height from inside of bust; does not include thickness. Must be > slot_height+slot_dia/2

//Calculations

//Since we are rotating model -90deg about x, y & z swap
mag_ymin=orig_zmin;
mag_ymax=orig_zmax;
mag_zmin=-orig_ymax;
mag_zmax=-orig_ymin;

//echo (mag_zmin=mag_zmin);

mag_xsize=orig_xmax-orig_xmin;
mag_ysize=mag_ymax-mag_ymin;
mag_zsize=mag_zmax-mag_zmin;

cut_box_xsize=1.10*mag_xsize;
cut_box_xtrans=(orig_xmin + orig_xmax)/2;

z_cut_box_ysize=1.10*mag_ysize;
z_cut_box_ytrans=(mag_ymin + mag_ymax)/2;
z_cut_box_zsize= (-1.10*mag_zmin) < (2*thickness) ? 2*thickness : -1.10*mag_zmin;

y_cut_box_ysize=z_cut_box_ysize/2-z_cut_box_ytrans;
y_cut_box_zsize=1.10*mag_zsize;
y_cut_box_ztrans=y_cut_box_zsize/2-z_cut_box_zsize;

//echo (y_cut_box_ysize=y_cut_box_ysize);
//echo (y_cut_box_zsize=y_cut_box_zsize);

post_r=(magnet_d/2+r_gap+rim_t); //radius of post
body_h=mag_zmax; //height of body

module torus(radius, cir_radius, fn=16) {
    //radius = radius of torus to the center of the circle
    //cir_radius = radius of the base circle
    //fn = number of fragments
    rotate_extrude(convexity = 10, $fn=fn) translate ([radius,0,0]) circle(r=cir_radius, $fn=fn);
}

//Main program

//* difference() {
//%rotate ([-90,0,0]) import (file=model_stl, convexity=10); //original simplified file/*/

rotate ([90,0,0]) {
    difference() {
        import (file=model_offset_stl, convexity=10); //(-vol) offset model
        translate ([magnet_x_pos,magnet_z_pos,-eps]) cylinder(r=post_r,h=2*body_h,$fn=50); //(+vol) post main body NOTE: had some CGAL errors with this step on Rashida before centering x. Reducing $fn of this cylinder helped, but not if magnet_x_pos was != 0.
        
    //Top hanger
    translate([top_slot_x_pos,mag_ymax-thickness-hanger_height,0]) difference() {
        translate([-mag_xsize/2,0,-eps]) cube([mag_xsize,hanger_height+thickness,thickness+eps]); //(+vol) main body
        translate([0,slot_height,-.1*thickness]) cylinder(d=slot_dia,h=1.2*thickness); //(-vol) top of slot
        translate([-slot_dia/2,-.1*slot_height,-.1*thickness]) cube([slot_dia,1.1*slot_height,1.2*thickness]); //(-vol) slot
    } //translate
    } //difference

    
    union() {
    translate ([cut_box_xtrans,z_cut_box_ytrans,-z_cut_box_zsize/2]) cube([cut_box_xsize,z_cut_box_ysize,z_cut_box_zsize], center=true); // (-vol) z_cut_box
    translate ([cut_box_xtrans,-y_cut_box_ysize/2,y_cut_box_ztrans]) cube([cut_box_xsize,y_cut_box_ysize,y_cut_box_zsize], center=true); //(-vol) y_cut_box
    }
             
    //} //(-vol)

    //post
    //top fillet
    //      %  translate ([0,0,mag_zmax+offset-3*post_r]) cylinder(h=3*post_r,r1=0,r2=3*post_r); //cone for chamfer
            
            //round fillet use torus
     //%       translate([0,0,body_h-fillet_r]) difference(){
     //           cylinder(r=post_r+fillet_r,h=fillet_r);
     //           torus (post_r+fillet_r,fillet_r,$fn);
     //       }
            
            //TODO: attach 4 supporting fins instead?
        //}
   
    translate([magnet_x_pos,magnet_z_pos,-0.9*thickness]) cylinder(r=magnet_d/2+r_gap,h=magnet_t+t_gap+0.9*thickness); //(-vol) magnet with gap
            //}
    translate ([magnet_x_pos,magnet_z_pos,magnet_center_height]) {
        translate([0,0,-magnet_center_height-(post_r-wall_t)]) cylinder(r=post_r-wall_t,h=magnet_center_height);//(-vol) center hole cylinder
        translate([0,0,-(post_r-wall_t)]) sphere(r=post_r-wall_t);//(-vol) center hole top sphere
    } //translate
    //(+vol)


} //rotate

