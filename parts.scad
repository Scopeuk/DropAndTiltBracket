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
	//interface to rot arm
    translate([supportWidth,standardDepth/2,rotArmDepth/2]) rotate([0,90,0]) pinMate();
    //track, simple pin
    translate([supportWidth-trackDepth,standardDepth/2-trackWidth/2,rotArmDepth]) cube([trackDepth,trackWidth,screenHeight]);
    }
    
    

}

module arm(){
    translate([rotArmWidth,standardDepth/2,rotArmDepth/2]) rotate([0,-90,0]) difference() 
    {
        hull(){
            cylinder(h=rotArmWidth,d=rotArmDepth);
            translate([rotArmPivotSep,0,0]) cylinder(h=rotArmWidth,d=rotArmDepth);
        }
        
        translate([0,0,0]) rotate([0,-180,0]) pinClearence();
        translate([rotArmPivotSep,0,rotArmWidth]) pinClearence();
    }
}

module slidingComponent(){
    PartDepth = 10-rotArmWidth;
    translate([supportWidth+PartDepth+rotArmWidth+clearence*2,standardDepth/2,rotArmDepth/2]) rotate([0,-90,0]){
    //for now this is a place holder, on something proper this would be a singel part fo the screen
	difference(){
		hull(){
			cylinder(d=standardDepth,h=PartDepth);
			translate([screenHeight,0,0]) cylinder(d=standardDepth,h=PartDepth);
		}
        translate([screenHeight/2,0,PartDepth]) pinMate();
	}
    //slidePin, two parts, wide sliding, narrow into slot
    translate([screenHeight,0,0]) {
		cylinder(d=trackWidth-clearence, h = trackDepth+PartDepth+rotArmWidth);
		cylinder(d=standardDepth,h=PartDepth+rotArmWidth);
	}
    }
}

module assembly(){
base();
color("green") translate([supportWidth + clearence ,0,0]) arm();
color("blue") slidingComponent();
color("red") translate([supportWidth+clearence+rotArmWidth,standardDepth/2+clearence ,rotArmDepth/2]) rotate([0,90,0]) pin();
color("red") translate([supportWidth + clearence,standardDepth/2+clearence,rotArmDepth/2+rotArmPivotSep])rotate([0,-90,0]) pin();

}

module exploded(){
base();
translate([40,0,0]) color("green") arm();
translate([45,0,0])color("blue") slidingComponent();
translate([25,0,0]) color("red") translate([0,standardDepth/2+clearence,rotArmDepth/2+rotArmPivotSep])rotate([0,-90,0]) pin();
translate([60,0,0]) color("red") translate([0,standardDepth/2+clearence,rotArmDepth/2]) rotate([0,90,0]) pin();
}

//assembly();
exploded();