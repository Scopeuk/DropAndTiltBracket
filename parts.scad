use <Pin.scad>
$fs=0.1;
$fa=1;


screenHeight = 100;

standardDepth = 20;
supportWidth = 20;
rotArmWidth = 5;
// full size cutout for now to allow on axis positioning
rotArmDepth = standardDepth;
rotArmPivotSep = screenHeight/2;
rotArmLength = rotArmPivotSep+rotArmDepth;
clearence = 0.5;

trackDepth = 5;
trackWidth = 10;

//size of the notch in the track for the center point to go home
notchHeight = 12;
//base assembly
module base(){
    partHeight = screenHeight+rotArmDepth;
    difference(){
    cube([supportWidth,standardDepth,partHeight]);
    //slot for support arm
    // this should be on the outside (towards the frame)
    cube([rotArmWidth+clearence,rotArmDepth,rotArmLength+clearence*4]);
    translate([rotArmWidth+clearence,standardDepth/2,rotArmDepth/2]) rotate([0,-90,0]) pinMate();
    //track, simple pin
    translate([supportWidth-trackDepth,standardDepth/2-trackWidth/2,0]) cube([trackDepth,trackWidth,partHeight]);
    //notch
    translate([rotArmWidth+clearence,0,partHeight/2-notchHeight/2]) cube([supportWidth,standardDepth*3/4,notchHeight]);
    }
    
    

}

module arm(){
    translate([rotArmWidth,standardDepth/2,rotArmDepth/2]) rotate([0,-90,0]) difference() 
    {
        hull(){
            cylinder(h=rotArmWidth,d=rotArmDepth);
            translate([rotArmPivotSep,0,0]) cylinder(h=rotArmWidth,d=rotArmDepth);
        }
        
        translate([0,0,rotArmWidth]) pinClearence();
        translate([rotArmPivotSep,0,rotArmWidth]) pinClearence();
    }
}

module slidingComponent(){
    PartDepth = 10;
    translate([supportWidth+PartDepth+clearence,standardDepth/2,rotArmDepth/2]) rotate([0,-90,0]){
    //for now this is a place holder, on something proper this would be a singel part fo the screen
    hull(){
        cylinder(d=standardDepth,h=PartDepth);
        translate([screenHeight,0,0]) cylinder(d=standardDepth,h=PartDepth);
    }
    //slidePin
    translate([screenHeight,0,0]) cylinder(d=trackWidth-clearence, h = trackDepth+PartDepth);
    //Pivot Mount
    mountHeight = supportWidth-rotArmWidth+PartDepth;
    difference(){
        translate([screenHeight/2,0,0]) cylinder(d=notchHeight-clearence*2, h = mountHeight);
        translate([screenHeight/2,0,mountHeight]) pinMate();
    }
    }
}

module assembly(){
base();
color("green") arm();
color("blue") slidingComponent();
color("red") translate([0,standardDepth/2+clearence,rotArmDepth/2]) rotate([0,-90,0]) pin();
color("red") translate([0,standardDepth/2+clearence,rotArmDepth/2+rotArmPivotSep])rotate([0,-90,0]) pin();

}

module exploded(){
translate([20,0,0])base();
translate([10,0,0]) color("green") arm();
translate([30,0,0])color("blue") slidingComponent();
color("red") translate([0,standardDepth/2+clearence,rotArmDepth/2]) rotate([0,-90,0]) pin();
color("red") translate([0,standardDepth/2+clearence,rotArmDepth/2+rotArmPivotSep])rotate([0,-90,0]) pin();
}

//assembly();
exploded();