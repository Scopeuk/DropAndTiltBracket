// create a pin to constrain the part
//should print sat on the wide end without difficulty
// should have a narrower "bearing surface" for the moveing part
//should end in a slightly wider profile to lock in
// use a wedge profile such that joint preload can be controlled by adjusting the insertion distance slightly

pinDia = 5;
pinClearence = 0.3;
//reduced tolerence for parts printed in ideal orientation
pinClearenceVert = 0.2;

$fs = 0.1;
$sa = 1;
//cone is part of the bearing
module pin(
matingLength = 5,
bearingLength = 5,
coneLength = 2,
coneOuterDia = 7,
pinDia = pinDia,
bearingDelta = pinClearence,
chamferLength = 1,
chamferStep = 1
){
assert(bearingLength>coneLength, "bearing length must be longer than cone length");
translate([0,0,-(matingLength+bearingLength)]) {
    //chamfer to make locating into hole easier
    cylinder(d1=pinDia-chamferStep,d2 = pinDia,h= chamferLength);
    //mating section is a fixed length plug
    translate([0,0,chamferLength-0.001]) cylinder(d=pinDia,h= matingLength-chamferLength);
    //bearing shaft is full length inside part
    translate([0,0,chamferLength]) cylinder(d=pinDia-bearingDelta,h= matingLength+bearingLength-chamferLength);
    //coneic mating surface
    translate([0,0,(matingLength+bearingLength)-coneLength]) cylinder(d1=pinDia-bearingDelta,d2 = coneOuterDia,h= coneLength);
    }
}

module pinClearence(
Length = 10,
pinDia = pinDia,
bearingDelta = pinClearence*1.5,
coneLength = 2,
coneOuterDia = 7,
overHead = 0.1
){
assert(Length>coneLength, "bearing length must be longer than cone length");
translate([0,0,-(Length)]) {
    //clear to the pin diamter throughout
    cylinder(d=pinDia+bearingDelta,h=Length);
    //coneic mating surface
    translate([0,0,(Length)-coneLength]) cylinder(d1=pinDia+bearingDelta,d2 = coneOuterDia,h= coneLength);
    translate([0,0,Length-0.01]) cylinder(d=coneOuterDia,h=overHead);
    }
}

module pinMate(Length = 10, pinClearence = pinClearence, overHead = 0.1){

    translate([0,0,-Length]) cylinder(d=pinDia+pinClearence,h=Length+overHead);

}
rotate([180,0,0]){
//translate([-10,0,0]) pinClearence();
translate([ 0,0,0]) pin();
//translate([ 10,0,0]) pinMate();
}