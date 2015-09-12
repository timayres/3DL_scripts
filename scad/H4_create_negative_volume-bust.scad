//h4_neg_vol function

//variables set via calling script

model_stl="../test_models/TEMP3DL_TEST_BUST-simp20K_H3-offset(-8Z).stl";
    
thickness=3;

orig_xmin=-29.564501;
orig_xmax=31.325228;
orig_ymin=-20.634674;
orig_ymax=15.724438;
orig_zmin=-0.827112;
orig_zmax=53.902111;

/**********CUT LINE**********/
// Everything above this line will be replaced by calling script
// License: LGPLv2.1

//Calculations
orig_xsize=orig_xmax-orig_xmin;
orig_ysize=orig_ymax-orig_ymin;

cut_box_xsize=1.10*orig_xsize;
cut_box_ysize=1.10*orig_ysize;
cut_box_xtrans=(orig_xmin + orig_xmax)/2;
cut_box_ytrans=(orig_ymin + orig_ymax)/2;

cut_box_zsize= (-1.10*orig_zmin) < (2*thickness) ? 2*thickness : -1.10*orig_zmin;

//Main program
union() {
    import (file=model_stl, convexity=10);
    translate ([cut_box_xtrans,cut_box_ytrans,-cut_box_zsize/2]) cube([cut_box_xsize,cut_box_ysize,cut_box_zsize], center=true);
}
