
// License: LGPLv2.1

fillet_rad=3;
cyl_rad=2.5;
theta=45; //works up to about 55 degrees
$fn=100;
eps=.01; //overlap offset

//top plane, reference only
%translate (plane_center) rotate([theta,0,0]) translate ([0,0,1/2]) cube([30,30,1], center=true);

//center cylinder
%translate (plane_center+[0,0,-25]) cylinder(r=cyl_rad,h=50,$fn);



plane_center=([5,5,15]); // center point where the plane meets the cylinder

translate (plane_center) fillet_cyl2plane(fillet_rad,cyl_rad,theta,$fn);

module torus(tor_radius, XS_radius, fn_torus=16) {
    //tor_radius = radius of torus to the center of the cross section circle
    //XS_radius = radius of the cross section circle
    //fn_torus = number of fragments for both XS and torus
    rotate_extrude(convexity = 10, $fn=fn_torus) translate ([tor_radius,0,0]) circle(r=XS_radius, $fn=fn_torus);
}

module fillet_cyl2plane (fillet_rad, cyl_rad,theta=45, fn_fillet) {
    
    //Calculations
    torus_rad = (cyl_rad+fillet_rad)/cos(theta);
    torus_rad_scale = torus_rad/(cyl_rad+fillet_rad);
    torus_x_scale=cyl_rad/(torus_rad - fillet_rad);
    torus_z_offset = fillet_rad / cos(theta);//torus z offset from plane
    disc_offset = fillet_rad * sin (theta); //offset for positive disc
    height_1 = 2 * (cyl_rad+fillet_rad) * tan(theta);
    //cut_plane_theta1 = atan2 (height_1,2*cyl_rad);
    cut_plane_theta = atan ( (cyl_rad+fillet_rad)*tan(theta) / cyl_rad);

    difference() {
        //positive cyl  - to create positive volume
        translate ([0,-disc_offset,-torus_z_offset-height_1/2]) scale ([cos(theta),1,1]) cylinder(r = cyl_rad + fillet_rad, h=height_1+fillet_rad * cos(theta) + eps/sin(theta), $fn=fn_fillet);
    
        //torus for fillet
        //can cut in half for visualization
        translate ([0,0,-torus_z_offset])  rotate([theta,0,0]) scale ([torus_x_scale,1,1])
        //difference(){        
        torus (torus_rad,fillet_rad,fn_fillet);
        //translate ([10,0,0]) cube ([20,20,20],center=true);
        //}
        
        //cutting cube - to cut away bottom
        cut_plane_height=2*fillet_rad;
        translate ([0,0,-torus_z_offset]) rotate([cut_plane_theta,0,0]) translate ([0,0,-cut_plane_height/2]) cube([2*torus_rad,2*torus_rad,cut_plane_height], center=true);
        
        //top plane
        plane_height=height_1 * cos(theta)+eps;
        //plane (center==true ? -plane_height/2 : 0)
        rotate([theta,0,0]) translate ([0,-disc_offset,plane_height/2+eps]) cube([3*torus_rad,3*torus_rad,plane_height], center=true);
    }
}

