//do_h4_neg_vol function

//variables set via calling script

model_stl="TEMP3DP_Diamond_bust3-BH_H1-pre_processed.-4.Z.NC.S.stl";
model_offset_stl="TEMP3DP_Diamond_bust3-BH_H3-offset.-4.Z.NC.S.stl";
model_bottom_section_stl="TEMP3DP_Diamond_bust3-BH_H2-simp_bottom_section.-4.Z.NC.S.stl";
model_offset_section_stl="TEMP3DP_Diamond_bust3-BH_H4-offset_section.-4.Z.NC.S.stl";

bottom_fillet_rad=1;
thickness=3;
BH_angle=10;
bottom_section_height=6.446277;
bottom_section_width=25.051654;

xcenter=-.1938705000;
ycenter=24.4973510000;
center_height=64.222321;

orig_xmin=-49.142185;
orig_xmax=51.308571;
orig_ymin=-9.593199;
orig_ymax=56.820095;
orig_zmin=-49.550304;
orig_zmax=68.177139;
/**********CUT LINE**********/
// Everything above this line will be replaced by calling script
// License: LGPLv2.1

//embedded variables
eps=0.00001; //overlap amount for correct booleans
//function pi()=3.14159265358979323846;

//top knob for Neil Enterprises Photo Bobble Heads
//default spring length: ~42mm;

// inner post and spring guide
spring_length=40.5; //1.57" Includes bit of bottom post too
fn_post=32; //number of segments in post
post_r=14/2;//12.5/2;
post_h=orig_zmax;
spring_guide_top_dia=9.5;
spring_guide_bottom_dia=9;
spring_guide_height=8;

//Spring dimensions (NE)
//ID=11.3 mm .44"
//OD=13.5mm .53"
//wire diameter: 1 mm .04"
// No. turns: 5-7

//Calculations
orig_xsize=orig_xmax-orig_xmin;
orig_ysize=orig_ymax-orig_ymin;

cut_box_xsize=1.50*orig_xsize;
cut_box_ysize=1.50*orig_ysize;
cut_box_xtrans=(orig_xmin + orig_xmax)/2;
cut_box_ytrans=(orig_ymin + orig_ymax)/2;

cut_box_zsize= -1.50*orig_zmin;
cut_box_ztrans=-cut_box_zsize/2;

// Modules & functions
module bottom_offset_section_2D () {
    projection() rotate ([-BH_angle,0,0]) import (file=model_offset_section_stl, convexity=10);
}

function sphere_half_side(fn_sphere) = bottom_fillet_rad*sin (180/fn_sphere);

//Main program

//Bottom cut box
rotate ([BH_angle,0,0]) translate ([cut_box_xtrans,cut_box_ytrans,cut_box_ztrans]) cube([cut_box_xsize,cut_box_ysize,cut_box_zsize], center=true);

//bottom fillet
//eps was 0.1 below...
rotate ([BH_angle,0,0]) difference() {
    fn_bottom_fillet=16; //make this divisible by 4; powers of 2 work well
    
    translate ([0,0,-eps-sphere_half_side(fn_bottom_fillet)]) linear_extrude(height=bottom_fillet_rad+eps) offset (r=bottom_fillet_rad) bottom_offset_section_2D ();

    translate ([0,0,bottom_fillet_rad]) minkowski() {
        linear_extrude(height = bottom_fillet_rad ) offset (r=-bottom_fillet_rad+eps) bottom_offset_section_2D ();
        difference() {
            sphere (r=bottom_fillet_rad,$fn=fn_bottom_fillet);
            translate ([0,0,bottom_fillet_rad]) cube (size=2*bottom_fillet_rad, center = true);
        }
    }
}

//offset volume and center post
difference() {
    import (file=model_offset_stl, convexity=10);
       
    translate ([xcenter,ycenter,spring_length+bottom_section_height]) {
        cylinder (h=post_h, r=post_r, $fn=fn_post); //main post
        translate ([0,0,-spring_guide_height])cylinder (h=spring_guide_height,d1=spring_guide_bottom_dia, d2=spring_guide_top_dia,$fn=fn_post); //spring guide
        translate ([0,0,-spring_guide_height])sphere(d=spring_guide_bottom_dia,$fn=fn_post); //spring guide bottom
    }
    
    //top chamfer
    translate ([xcenter,ycenter,center_height-2*post_r]) 
        cylinder(h=3*post_r,r1=0,r2=3*post_r, $fn=fn_post);
}