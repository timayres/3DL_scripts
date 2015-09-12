//h4_neg_vol function

//variables set via calling script

model_stl="../test_models/TEST_BUST-simp20K-BH(-4Z).stl";
model_offset_stl="../test_models/TEMP3DL_TEST_BUST-simp20K-BH_H3-offset(-4Z).stl";
model_bottom_section_stl="../test_models/TEMP3DL_TEST_BUST-simp20K-BH_H2-simp_bottom_section(-4Z).stl";
model_offset_section_stl="../test_models/TEMP3DL_TEST_BUST-simp20K-BH_H4-offset_section(-4Z).stl";

bottom_fillet_rad=1;
thickness=3;
BH_angle=10;
bottom_section_height=2.209493;
bottom_section_width=31.365492;

m_scale=-4;
scale=.2500000000;

xcenter=.7527150000;
ycenter=-5.7633450000;
center_height=54.478794;

orig_xmin=-59.129002;
orig_xmax=62.650455;
orig_ymin=-41.269344;
orig_ymax=31.448877;
orig_zmin=-51.654224;
orig_zmax=57.804222;

/**********CUT LINE**********/
// Everything above this line will be replaced by calling script

// License: LGPLv2.1

//embedded variables
eps=0.00001; //overlap amount for correct booleans
//function pi()=3.14159265358979323846;

//top post for spring

//Spring dimensions:
// Free length=1.5"
// OD=0.48"
// Wire OD=0.035"

// inner post and spring guide - 1:4 scale
spring_length=40.5; //1.57" Includes bit of bottom post too
fn_post=32; //number of segments in post
post_r=14/2;//12.5/2;
post_h=orig_zmax;
spring_guide_top_dia=9.5;
spring_guide_bottom_dia=9;
spring_guide_height=8;

// inner post and spring guide - 1:7 scale

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