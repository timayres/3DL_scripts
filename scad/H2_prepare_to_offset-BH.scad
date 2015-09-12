//h2_to_offset function

//variables set via calling script

model_stl="../test_models/TEST_BUST-simp20K-BH(-4Z).stl";
model_bottom_section_stl="../test_models/TEMP3DL_TEST_BUST-simp20K-BH_H2-simp_bottom_section(-4Z).stl";

bottom_fillet_rad=1;
thickness=3;
BH_angle=10;
bottom_section_height=2.209493;
bottom_section_width=31.365492;

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

//Calculations
orig_xsize=orig_xmax-orig_xmin;
orig_ysize=orig_ymax-orig_ymin;

cut_box_xsize=1.50*orig_xsize;
cut_box_ysize=1.50*orig_ysize;
cut_box_xtrans=(orig_xmin + orig_xmax)/2;
cut_box_ytrans=(orig_ymin + orig_ymax)/2;

cut_box_zsize= -1.50*orig_zmin;
cut_box_ztrans=-cut_box_zsize/2;

//Main program
 
difference() {
    import (file=model_stl, convexity=10);
    rotate ([BH_angle,0,0]) translate ([cut_box_xtrans,cut_box_ytrans,cut_box_ztrans]) cube([cut_box_xsize,cut_box_ysize,cut_box_zsize], center=true);
}
intersection() {
    rotate ([BH_angle,0,0]) translate ([cut_box_xtrans,cut_box_ytrans,cut_box_ztrans]) cube([cut_box_xsize,cut_box_ysize,cut_box_zsize+eps], center=true);
    translate ([0,0,-3*thickness]) linear_extrude(height = bottom_section_height+3*thickness+eps) projection() import (file=model_bottom_section_stl, convexity=10);
}

