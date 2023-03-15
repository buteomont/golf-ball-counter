width=10;
length=9;
magnetDiameter=5;
magnetThickness=0.9;

angle=atan(magnetDiameter/(length-magnetThickness));

$fn=50;

difference()
	{
	cube([length,width,magnetDiameter]);
  rotate([0,-angle,0])
    cube([length*1.25,width,magnetDiameter]);
//  translate([length-magnetThickness,magnetDiameter/2,magnetDiameter/2])
//    rotate([0,90,0])
//      cylinder(h=magnetThickness, d=magnetDiameter);
//  translate([length-magnetThickness,magnetDiameter*1.5,magnetDiameter/2])
//    rotate([0,90,0])
//      cylinder(h=magnetThickness, d=magnetDiameter);
	}
