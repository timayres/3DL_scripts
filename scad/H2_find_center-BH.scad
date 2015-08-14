// do_h2_to_offset function

//$fn=100;

//union() {
//difference() {
////translate ([0,20,0])
//   import (file="Diamond_bust3-BH.-4.Z.NC.S.stl", convexity=10);
//rotate ([10,0,0]) translate ([0,0,-40]) cube([150,150,80], center=true);
//}
//intersection() {
//    rotate ([10,0,0]) translate ([0,0,-39.99]) cube([150,150,80], center=true);
//translate ([0,0,-10]) linear_extrude(height = 20) {
//NOTE: importing a 3D dxf in OpenSCAD projects it down onto the xy plane, i.e. the z coordinates are ignored


//find width of cross section (stl & admesh), use half that as max offset, go 5% less?
linear_extrude(height = 10) offset (delta = -11.3) import (file="bobble_test_1_bottom.dxf");
//export this, then find its center (measure stl with admesh)
//}
//}
//}
//minkowski() {
    //linear_extrude(height = 2) projection() rotate ([-10,0,0]) import (file="bobble_test_1_bottom.stl");
    //offset (-11) projection() rotate ([-10,0,0]) import (file="bobble_test_1_bottom.stl");
    //sphere (2);
//}

//top knob for Neil Enterprises Photo Bobble Heads

//translte this in x & y per the offset test above
//translate ([0,0,42]) translate ([0,0,6.445798]) translate ([0,0,4.5]) union() {
//    sphere(d=9);
//    cylinder (h=8,d1=9, d2=9.5);
//    translate ([0,0,8]) cylinder (h=20, d=12.5);
//}

//draw edge with bevel instead in 2d, then rotate

//measure higest z point of bottom.stl (6.445798), transltate knob up by this amount at minimum, then add spring length

//default spring length: 42mm

//import (file="bobble_test_1_offset.stl");
