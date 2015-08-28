//do_h2_to_offset function

//variables set via calling script

bottom_open=true;

model_stl="../test_models/TEST_MESH_BUST-simplified25K.-10.Z.NC.S.stl";
model_bottom_section_stl="../test_models/TEST_MESH_BUST-simplified25K_H1-simpZ0section.-10.Z.NC.S.stl";

grow_offset=1;
thickness=3;

orig_xmin=-24.343349;
orig_xmax=24.381460;
orig_ymin=-16.021044;
orig_ymax=13.165529;
orig_zmin=-0.675376;
orig_zmax=43.144764;
/**********CUT LINE**********/

//embedded variables
eps=0.00001; //overlap amount for correct booleans

//Calculations
orig_xsize=orig_xmax-orig_xmin;
orig_ysize=orig_ymax-orig_ymin;

cut_box_xsize=1.10*orig_xsize;
cut_box_ysize=1.10*orig_ysize;
cut_box_xtrans=(orig_xmin + orig_xmax)/2;
cut_box_ytrans=(orig_ymin + orig_ymax)/2;

cut_box_zsize= (-1.10*orig_zmin) < 2*(grow_offset+thickness) ? 2*(grow_offset+thickness) : -1.10*orig_zmin;
cut_box_ztrans=-cut_box_zsize/2-grow_offset;

//Main program

module flat_bottom() {
    difference() {
        import (file=model_stl, convexity=10);
        translate ([cut_box_xtrans,cut_box_ytrans,cut_box_ztrans]) cube([cut_box_xsize,cut_box_ysize,cut_box_zsize], center=true);
    }
}

if (bottom_open) {
    union() {
        flat_bottom();
        translate ([0,0,-2*(grow_offset+thickness)-grow_offset]) linear_extrude(height = 2*(grow_offset+thickness)+eps) import (file=model_bottom_section_stl);
    }
} else {
    flat_bottom();
}

