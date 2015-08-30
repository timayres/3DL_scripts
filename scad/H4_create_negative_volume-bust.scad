//do_h3_neg_vol function

//variables set via calling script

model_stl="../test_models/TEST_MESH_BUST-simplified25K_H2-offset.-10.Z.NC.S.stl";

thickness=-3;

orig_xmin=-24.343935;
orig_xmax=24.373457;
orig_ymin=-16.012501;
orig_ymax=13.160800;
orig_zmin=-0.672300;
orig_zmax=43.146698;
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
