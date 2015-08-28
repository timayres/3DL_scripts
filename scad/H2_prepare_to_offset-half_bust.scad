//do_h2_to_offset function

//variables set via calling script

bottom_open=true;

model_stl="TEMP3DP_Ethan_bust5_magnet_H1-pre_processed(-6Z).stl";
model_bottom_section_stl="TEMP3DP_Ethan_bust5_magnet_H2-Zsection(-6Z).dxf";
    
grow_offset=0;
thickness=3;

orig_xmin=-27.365154;
orig_xmax=30.706732;
orig_ymin=-19.909147;
orig_ymax=13.805316;
orig_zmin=-10.267079;
orig_zmax=57.251629;
/**********CUT LINE**********/

//embedded variables
eps=0.00001; //overlap amount for correct booleans

//Calculations

// model is rotated -90 deg compared to original

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

z0_cut_box_ysize=1.10*mag_ysize+grow_offset;
z0_cut_box_ytrans=(mag_ymin + mag_ymax)/2-grow_offset/2;
z0_cut_box_zsize= (-1.10*mag_zmin) < 2*(grow_offset+thickness) ? 2*(grow_offset+thickness) : -1.10*mag_zmin;

y0_cut_box_ysize=z0_cut_box_ysize/2-z0_cut_box_ytrans-grow_offset;
y0_cut_box_ytrans=-y0_cut_box_ysize/2-grow_offset;
y0_cut_box_zsize=1.10*mag_zsize;
y0_cut_box_ztrans=y0_cut_box_zsize/2-z0_cut_box_zsize;

//echo (y_cut_box_ysize=y_cut_box_ysize);
//echo (y_cut_box_zsize=y_cut_box_zsize);

//Main program

// Cut off back & bottom of bust
difference() {
    import (file=model_stl, convexity=10);
    translate ([cut_box_xtrans,y0_cut_box_ytrans,y0_cut_box_ztrans]) cube([cut_box_xsize,y0_cut_box_ysize,y0_cut_box_zsize], center=true); // Y=0 cut box MUST BE DIFFERENCED 1ST
    translate ([cut_box_xtrans,z0_cut_box_ytrans,-z0_cut_box_zsize/2]) cube([cut_box_xsize,z0_cut_box_ysize,z0_cut_box_zsize], center=true); // Z=0 cut box
}

// Extrude back of bust
difference() {
    translate ([0,0,-2*(grow_offset+thickness)]) linear_extrude(height = 2*(grow_offset+thickness)+eps) import (file=model_bottom_section_stl, convexity=10);
    translate ([cut_box_xtrans,y0_cut_box_ytrans,y0_cut_box_ztrans]) cube([cut_box_xsize,y0_cut_box_ysize,y0_cut_box_zsize], center=true); // Y=0 cut box
}
