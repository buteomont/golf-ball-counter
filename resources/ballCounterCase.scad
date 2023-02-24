//ballCounterCase.scad
//A case for the shag bag ball counter circuit

/* [board] */
boardLength=64.5;
boardWidth=38.5;
boardMaxHeight=10.8;

/* [box ] */
wallThickness=1.5;
cornerRadius=3;
lipHeight=3;
boxDimensionX=boardLength+wallThickness*2-cornerRadius;
boxDimensionY=boardWidth+wallThickness*2-cornerRadius;
boxDimensionZ=boardMaxHeight+wallThickness*2-1; //-1 is to compensate for minkowski cylinder
wireHoleLength=12;
wireHoleHeight=3.2;
wireHoleLocationY=boxDimensionY/2-wireHoleLength/2;
wireHoleLocationZ=wallThickness+4.6;
standoffHeight=3.5;  //holds up the board
standoffDiameter=4;

/* [lid] */
lidHeight=lipHeight+wallThickness;
displayWindowHeight=9;
displayWindowWidth=15;
displayWindowLocationX=boxDimensionX-(3+2.54*4+wallThickness+displayWindowWidth); //edge plus 5 holes
displayWindowLocationY=3+2.54*10-wallThickness; //edge plus 10 hole
buttonHoleDiameter=12;
buttonLocationX=boxDimensionX-46.5; //to center of button
buttonLocationY=11; //ditto


/* [Hidden] */
fudge=.02;  //mm, used to keep removal areas non-congruent
$fn=200;


module go()
  {
  translate([cornerRadius,cornerRadius,0]) //set the origin
    {
    //the main part of the box
    translate([0,0,0])
      boxLower();

    //the lid
    translate([0,boxDimensionY+10,0])
      lid();
    }
  }

module boxLower()
  {
  difference()
    {
    boxOutside();
    boxInside();
    translate([0-cornerRadius,0-cornerRadius,boxDimensionZ-lipHeight+1+fudge])
      innerLip();
    translate([0-cornerRadius-fudge/2,wireHoleLocationY,wireHoleLocationZ])
      wireHole();
    }
  translate([0,boxDimensionY,wallThickness])
    standoff(1);
  translate([0,0,wallThickness])
    standoff(2);
  translate([boxDimensionX,0,wallThickness])
    standoff(3);
  translate([boxDimensionX,boxDimensionY,wallThickness])
    standoff(4);
  }

module standoff(quadrant=1)
  {
  rotate([0,0,quadrant*90])
    {
    difference()
      {
      cylinder(d=standoffDiameter, h=standoffHeight*2);
      translate([-standoffDiameter/2,-standoffDiameter,standoffHeight])
      cube([standoffDiameter/2,standoffDiameter,standoffHeight+fudge]);
      }
    
    }
  }

module lid()
  {
  difference()
    {
    lidOuter();
    lidInner();
    translate([wallThickness/2,wallThickness/2,lidHeight-lipHeight+1+fudge])
      outerLip();
    translate([displayWindowLocationX,displayWindowLocationY,-fudge/2])
      displayHole();
    translate([buttonLocationX,buttonLocationY,-fudge/2])
      buttonHole();
    }
  }

module wireHole()
  {
  cube([wallThickness+fudge,wireHoleLength,wireHoleHeight]);
  }

module buttonHole()
  {
  cylinder(d=buttonHoleDiameter, h=wallThickness+fudge);
  }

module displayHole()
  {
  cube([displayWindowWidth,displayWindowHeight,wallThickness+fudge]);
  }
  
module boxOutside()
  {
  minkowski()
    {
    cube([boxDimensionX,boxDimensionY,boxDimensionZ]);
    cylinder(r=cornerRadius,h=1);
    }
  }

module lidOuter()
  {
  minkowski()
    {
    cube([boxDimensionX,boxDimensionY,lidHeight]);
    cylinder(r=cornerRadius,h=1);
    }
  }

module lidInner()
  {
  translate([wallThickness,wallThickness,wallThickness])
    {
    minkowski()
      {
      cube([boxDimensionX-wallThickness*2,boxDimensionY-wallThickness*2,lidHeight]);
      cylinder(r=cornerRadius,h=1);
      }
    }
  }

module displayBracket()
  {
  cube([displaySupportWidth,displaySupportLength-stickumThickness*2,displaySupportThickness]);
  }
  
module boxInside()//the box interior
  {
  translate([wallThickness,wallThickness,wallThickness+fudge])
    {
    minkowski()
      {
      cube([boardLength-cornerRadius,boardWidth-cornerRadius,boxDimensionZ]);
      cylinder(r=cornerRadius,h=1);
      }
    }
  }

module innerLip()//the inner lip fits inside the outer lip
  {
  difference()
    {
    cube([boxDimensionX+cornerRadius*2,boxDimensionY+cornerRadius*2,lipHeight]);
    translate([wallThickness/2+cornerRadius,wallThickness/2+cornerRadius,0])
    minkowski()
      {
      cube([boxDimensionX-wallThickness,boxDimensionY-wallThickness,lipHeight-1]);
      cylinder(r=cornerRadius,h=1);
      }
      
    }
  }

module outerLip()//the outer lip fits over the inner lip
  {
  minkowski()
    {
    cube([boardLength-cornerRadius+wallThickness,boardWidth-cornerRadius+wallThickness,lipHeight-1]);
    cylinder(r=cornerRadius,h=1);
    }
  }


go();
//boxLower();
