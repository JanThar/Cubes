use <Getriebe.scad>

// Nur 1 Schlüsselschalter, 1 Einschalter, 2-4 Motoren!!

// ToDo 
// Türschalter: druck ausreichend??? - Position (Überlappung Neutrix)
// Tür breiter Türrahmen dünner,aussen????, scharnier durchgehend, M3
// da achse vor schlitz eventuell doch aussenrahmen (Griff/Scharnier Combo?????)

// 5 wg iMac, 3 oder 6 wegen Basisform (gelb,rot,blau,grün,lila)
// Printe/Holzmagnet:          120*4*1,5       (Laser) (Printen)
// Businesscard/Stroopwaffel:    85x55x3         (Mill) 
// Keks/Legofliese/Tattoofolie: 15.8x15.8x3.2   (Plotter)
// Marzipan                         (3D Printer)
// Sticker:                         (Cutter)
// Peppers Ghost,Waffel, Schokolade (Tiefziehen) (+Schokoladenbrunnen)
//                                  (Sticken)
// Ringegravierer??
//
// -> Aachen,Holland, Belgien als 3Eck 
//      -> !Printe,Brezel
//      -> !Belgische Waffel, Butter Crisps Blätterteigpastetchen,Pralinen,Spekulatius, Snowball
//      -> !Stroopwafels,Poffertjes

// change connector postion holes top/bottom - nuts to close to axis. add 2 instead 1

// 3D-printed stuff

// move Platform (x-Axis) [-37:37] 
positionX = -37+6;//37-25; //37-24-50
// move Tool (x-Axis) [-37:37]
positionY = 30;
// move Tool (x-Axis) [-15:15] 
positionZ = -15;//11;

// open Door [0:47]
doorAngle = 0;

// Toolhead: 0 unused, 1 Laser, 2 Mill, 3 PrintHead, 4 Pen
useTool = 4; 

toolLaser = 1;
toolMill = 2;
toolPrinter = 3;
toolPen = 4;

//gear inlay laser offset
gearAxisX = 0.12;
gearAxisY = 0.15;
gearLin   = 0.5;

//--------------------------------

positionPiOffsetX = 41;
positionPiOffsetY = 15;

// Flatten for lasercutting [0,1]
flatten = 0;
//projection(cut = false) mechanics();
//projection(cut = false) walls();

// 3D-printed 
//ledholder();
//cableClip(8);
//millInlay();
//millHolder();
//screwHead(1);
penHolder();
//cover();
//bumper();
//hingeTPU(0);
//hingePLA(0);
//doorhandle();
//screenholder(0);
//connector(0);
//vent(0);
//usbA(0);
//usbBack(0);
//keySwitch(0);
//switch(0);
//laserholder();
//wallXside(1,-1,12);

// not used anymore
//led(0);
//frameScreen(); 
//ledFrame(); 

simplifyVent=1;

explodeModules = 0;
explodeAxis = 0;
explodeHousing = 0;

printOffset = 1;//rechter Dremel : Scale 103% printOffset 1.1 (etwas zu gross) 1.05 ok

//animate
//explodeModules = 30*(1-checkA($t*3));
//explodeAxis = 150*(1-checkA($t*3-1));
//explodeHousing = 250*(1-checkA($t*3-1.8));

// Show lasercutted housing [0,1]
showWall = 0;
// Show lasercutted mechanics [0,1]
showMechanics = 0;
// Show 3D-printed parts [0,1]
showPrint = 0;
// Show axis and motors [0,1]
showDrive = 0;
// Show electronics [0,1]
showElectronic = 0;

//--------------------------------

// Dimension y
width = 144;
// Dimension x
length = 144;
// Dimension z
height = 144;
// Height z-Axis
zHeight = 75; //old: 66, new 72 bzw. 75
// Width x-Axis
xWidth = length;

// outer hull - measure for real values
hullWidth  = 150;
hullLength = 150;
hullHeight = 150;

// 139 - 139 - 67

// material thickness for lasercutted parts
materialThickness = 3;
housingThickness = 3;

penWidth = 14; // can be reduced to 12

// distance motor to border
motorDistance = 10;
// distance connectors to border
conDistance = 6;

// screw parameter
screwDiameter = 3;
screwNutDiameter = 6.3;
screwNutHeight = 2.6;
screwLength = 10;

// axis and Bearings
axisHeight = 6; //16;
axisDiameter = 4;
axisShorting = 4;
bearingDiameter = 8;
bearingLength = 8;
offsetBearing = 2.5;

// Connectors 3D-printed
conWidth = 8;
conLength = 17;
conHeight = axisHeight+axisDiameter/2;
conScrewHeight = 10;
conScrewDistance = 5;

// positions
distanceXtoBottom = 20-explodeAxis;
distanceXtoBack = 0;
distanceYtoBottom = -zHeight/2+height-conHeight*2;
distanceYtoBack = -(width/2-20)+explodeAxis;
distanceZtoBottom = distanceYtoBottom+explodeAxis;
distanceZtoBack = distanceYtoBack+32-explodeAxis;

// door parameter
doorRounding = 10;
doorOverlap = 3;
doorHeight = height-conHeight*2-distanceXtoBottom+materialThickness-15;
doorWidth = 124;
doorExtensionX = 0;
doorDistanceToBottom = distanceXtoBottom+conHeight+materialThickness+3;

//define variables to identfy axis
x=0;
y=1;
z=2;

//Animation
function checkA(a)=(checkB((a>1)?1:a));
function checkB(a)=((a<0)?0:a);

//--------------------------------

//                translate([0,-130,10]) //screen
//rotate([-70,0,0])
//                    cube([85.5,20,55],true);

//electronic
if(showElectronic) {
//    translate([length/2-positionPiOffsetX,-width/2+positionPiOffsetY,18.5]) rotate([0,180,180]) piZero(0);
    //color("green") translate([-29-8,0,10]) cube([76,121,10],center=true); // 5 inch display
}

//toolhead
if(showDrive) translate([-positionY,0,positionZ+explodeAxis]) {
    if (useTool==toolLaser) 
        translate([0,3,86-3]) {
            laser(0); // 10-100 mm Focus
            laserholder();
        }
    if (useTool==toolPen) 
        translate([0,0,86-3]) {
            //laser(0); // 10-100 mm Focus
            penHolder();
        }
    if (useTool==toolMill) 
        translate([0,-3.7,distanceZtoBottom+5]) 
        mill(); 
    if (useTool==toolPrinter) 
        translate([-6,-13-5,73+45.5-6]) 
        printhead(); 
}

//walls
if (showWall) walls();
    
//mechanic
if (showMechanics)  mechanics();
    
module cableClip(clipLength) {
    difference() {
        hull() {
            translate([0,conHeight/2-0.4,0])
                cube([conHeight-2,0.8,clipLength],true);
            translate([conHeight/2-0.4,0,0])
                cube([0.8,conHeight-2,clipLength],true);
        }
        hull() {
            translate([0.4,conHeight/2-0.4-0.4,0])
                cube([conHeight-3.4,0.4,clipLength*2],true);
            translate([conHeight/2-0.4-0.4,0.4,0])
                cube([0.4,conHeight-3.4,clipLength*2],true);
        }
        translate([3,3,0])
            rotate([0,0,-45])
            cube([0.9,conHeight-3.4,clipLength*2],true);
    }
}
    
module bumpers() {
    for(i=[0:3])
        rotate([0,0,90*i])
        bumper();
    
    for(i=[0:3])
        translate([0,0,height])
        rotate([180,0,90*i])
        bumper();
}    
module covers() {
for(i=[0:4])
    rotate([0,0,90*i])
    translate([0,0,(hullWidth-6)/2])
    rotate([0,90,0])
    cover();
translate([0,0,(hullWidth-6)/2])
    for(i=[0:4])
    rotate([90*i,0,0])
    cover();
translate([0,0,(hullWidth-6)/2])
    for(i=[0:4])
    rotate([90*i,0,90])
    cover();
}

module cover() {
    translate([0,0,-(hullWidth-6)/2])
    color("LightBlue") {
        translate([0,hullWidth/2+0.5,-1])
            cube([hullWidth-conLength*1.7,1,2*housingThickness],true);
        translate([0,hullWidth/2-2,-3.5])
            cube([hullWidth-conLength*1.7,2*housingThickness,1],true);
        difference() {
            hull() {
                hull() {
                    translate([0,hullWidth/2+0.5,-1])
                        cube([hullWidth-conLength*2.4,1,2*housingThickness],true);
                    translate([0,hullWidth/2+1,-1.5])
                        cube([hullWidth-conLength*2.4-2,2,2*housingThickness-1],true);
                }
                hull() {
                    translate([0,hullWidth/2-2,-3.5])
                        cube([hullWidth-conLength*2.4,2*housingThickness,1],true);
                    translate([0,hullWidth/2-1.5,-4])
                        cube([hullWidth-conLength*2.4-2,2*housingThickness-1,2],true);
                    
                }
            }
            translate([0,hullWidth/2-housingThickness,0])
                cube([hullWidth,2*housingThickness,2*housingThickness],true);
        }
    }
}
sideCover=10;
module bumper() {
    difference() {
    color("LightBlue")
    translate([0,0,hullHeight/2-3])
    difference() {
        translate([(hullHeight-conLength*1.059)/2,(hullHeight-conLength*1.059)/2,(hullHeight-conLength*1.059)/2])
        hull() {
            cube([conLength*1.059+4,conLength*1.059+2,conLength*1.059+2],true);
            cube([conLength*1.059+2,conLength*1.059+4,conLength*1.059+2],true);
            cube([conLength*1.055+2,conLength*1.059+2,conLength*1.059+4],true);
        }
        cube([hullWidth,hullLength,hullHeight],true);
        
        bumperInlay();
        rotate([0,0,90]) bumperInlay();
        rotate([0,90,0]) bumperInlay(); 
        hull() {
            hull(){
                translate([height/2-4,height/2-8.5,height/2+5-1.8])
                    cylinder(d=3,h=10,$fn=36);
                translate([height/2-4,height/2-8.5,height/2+5-0.4])
                    cylinder(d=6,h=10,$fn=36);
            }        
            hull(){
                translate([height/2-4-0.5,height/2-8.5-0.5,height/2+5-1.8])
                    cylinder(d=3,h=10,$fn=36);
                translate([height/2-4-0.5,height/2-8.5-0.5,height/2+5-0.4])
                    cylinder(d=6,h=10,$fn=36);
            }   
        }
        hull() {
            translate([height/2-4,height/2-8.5,height/2+5-1.8])
                cylinder(d=3,h=100,$fn=36,center=true);
            translate([height/2-4-0.5,height/2-8.5-0.5,height/2+5-1.8])
                cylinder(d=3,h=100,$fn=36,center=true);
        }
        hull(){
            hull(){
                translate([height/2-8.5,height/2-4,height/2+5-1.8])
                    cylinder(d=3,h=10,$fn=36);
                translate([height/2-8.5,height/2-4,height/2+5-0.4])
                    cylinder(d=6,h=10,$fn=36);
            }
            hull(){
                translate([height/2-8.5-0.5,height/2-4-0.5,height/2+5-1.8])
                    cylinder(d=3,h=10,$fn=36);
                translate([height/2-8.5-0.5,height/2-4-0.5,height/2+5-0.4])
                    cylinder(d=6,h=10,$fn=36);
            }
        }
        hull(){
            translate([height/2-8.5-0.5,height/2-4-0.5,height/2+5-1.8])
                cylinder(d=3,h=100,$fn=36);
            translate([height/2-8.5,height/2-4,height/2+5-0.4])
                cylinder(d=3,h=100,$fn=36,center=true);
        }
        

//        translate([0,0,height+housingThickness+explodeHousing/2-hullHeight/2+3]) 
//        rotate([180,0,0])
//        #connectors(width, length, 1);
        
    }
    covers();
    }
}
bumperEdge=30;
module bumperInlay() {
    for(i=[-1,1]) {
        translate([(hullWidth+2)/2*i,0,0]) hull() {
                cube([4,hullLength-sideCover-bumperEdge,hullHeight-sideCover],true);
                cube([4,hullLength-sideCover,hullHeight-sideCover-bumperEdge],true);
            }
            hull() {
            translate([(hullWidth+3)/2*i,0,0]) hull() {
                    cube([1,hullLength-sideCover-bumperEdge,hullHeight-sideCover],true);
                    cube([1,hullLength-sideCover,hullHeight-sideCover-bumperEdge],true);
                }
            translate([(hullWidth+5)/2*i,0,0]) hull() {
                    cube([1,hullLength-sideCover+2-bumperEdge,hullHeight-sideCover+2],true);
                    cube([1,hullLength-sideCover+2,hullHeight-sideCover+2-bumperEdge],true);
                }
            }
    }
}

module walls() {
    wallX();
    wallY();
    wallZ();
    //connectors bottom
    if(flatten==0 && showPrint) {
        color("LIGHTBLUE")  
        translate([0,0,-housingThickness-explodeHousing/2]) 
        rotate([0,0,0])
        connectors(width, length, 0);
    //connectors top
        color("LIGHTBLUE")  
        translate([0,0,height+housingThickness+explodeHousing/2]) 
        rotate([180,0,0])
        connectors(width, length, 0);
        // edge cover
        bumpers();
        covers();
    }
}
  
module mechanics() {
    if(flatten) 
        for(i=[-1:1]) 
            translate([40*i,length*0.7,0]) 
            gear();
        //z-axis
    if(useTool != 1)
        translate([-positionY*(1-flatten)-length*flatten,-distanceZtoBack*(1-flatten),distanceZtoBottom*(1-flatten)]) 
        rotate([90*(-flatten+1),0,0]) 
        cncaxis(length/2, zHeight-materialThickness, -positionZ*(flatten-1),z);
        //y-axis
    translate([length*flatten,-distanceYtoBack*(1-flatten),distanceYtoBottom*(1-flatten)]) 
        rotate([0,90*(flatten-1),90*(1-flatten)]) 
        cncaxis(zHeight, length, -positionY*(flatten-1),y);
        //x-axis
    translate([distanceXtoBack,0,distanceXtoBottom]) 
        cncaxis(width, width, positionX*(1-flatten),x);
}

module doorHole(extension,magnets) {
    translate([0,0,doorHeight/2])
        rotate([90,0,0]) 
        hull() {
            for(i=[-1,1])
                translate([(doorWidth/2-doorRounding)*i,(doorHeight/2-doorRounding)*(-1),0])
                cylinder(d=(doorRounding+extension)*2,h=housingThickness,$fn=36,center=true);
            for(i=[-1,1])
                translate([(doorWidth/2-doorRounding-magnets)*i,(doorHeight/2-doorRounding-magnets)*1,0])
                cylinder(d=(doorRounding+extension)*2+magnets*2,h=housingThickness,$fn=36,center=true);
    }
}

module wallZ() {
    for(l=[-1,1]) 
    translate([flatten*(length+10)*l,flatten*(width+20),explodeHousing*l-(height/2*(1+l)+housingThickness/2*l)*flatten]) 
    difference() {
        translate([0,0,height/2*(1+l)+housingThickness/2*l]) 
            cube([length+housingThickness*2,width+housingThickness*2,housingThickness],true);      
        //connectors bottom
        translate([0,0,-housingThickness]) 
            rotate([0,0,0])
            connectors(width,length,1); 
        //connectors top
        for(k=[-1,1])
            translate([0,0,height+housingThickness]) 
            rotate([180,0,0])
            connectors(width,length,1); 
        translate([0,-48+8+4,height+0])
            rotate([0,180,-90])
            screenholder(1);
        // hole for pens
        if(useTool == toolPen) {
            hull() {
                for(i=[-1,1])
                translate([i*width/4,0,height/2])
                cylinder(d=penWidth,h=height,$fn=36);
            }
        }
    } 
    if ((showPrint==1) && (flatten==0)) {
        color("LightBlue")
        translate([0,-48+8+4,height+3.5])
        rotate([0,0,-90])
        screenholder(0);
    }
    if ((showElectronic==1) && (flatten==0)) 
        {
            color("Green")
                translate([0,54/2-length/2+materialThickness*4+10,height-6])
        cube([84,54.5,20],true);
            color("Green")
                translate([13,54.5/2-length/2+materialThickness*4+10,height-6-3])
        cube([84,54.5,14],true);
    }
}

module wallY() {   
    for(l=[1,-1]) 
    translate([flatten*(length+15)/2*l-explodeHousing*l,0,-flatten*(height+housingThickness)/2]) 
    rotate([0,90*flatten*l,]) 
    difference() {
        translate([(-length-housingThickness)/2*l,0,height/2])
            cube([housingThickness,width+2*housingThickness,height],true);
        
        // connectors x-Axis
        translate([0,distanceXtoBack,distanceXtoBottom]) 
            connectors(width, length, 1);
        // connectors y-axis
        translate([0,-distanceYtoBack,distanceYtoBottom]) 
            rotate([90,0,0]) 
            connectors(zHeight, length, 1); 
        //connectors bottom
        translate([0,0,-housingThickness]) 
            rotate([0,0,0])
            connectors(width, length, 1); 
        //connectors top
        translate([0,0,height+housingThickness]) 
            rotate([180,0,0])
            connectors(width, length, 1); 
    } 
}

module wallX() {
    for(l=[-1,1]) 
        rotate([180*flatten,0,0]) 
        translate([0,flatten*(width*3/2+20)*l-explodeHousing*l,flatten*(height-housingThickness)/2])
        rotate([90*flatten*l,0,0]) 
            wallXside(l,0,0);
        rotate([90*flatten,0,0]) 
        translate([0,housingThickness,flatten*1.5*width])
    color("LightBlue")
            wallXside(1,-1,12);
    door();
    if ((showPrint==1) && (flatten==0)) {
    translate([0,(width/2+10)*flatten,0])
        color("LightBlue")
        doorhandle(); 
    }
}

module door() {
    //door
    translate([0,flatten*100,0])
        //translate([0,-explodeHousing*2.5,flatten*(height/2+housingThickness/2)]) 
        translate([0,-explodeHousing*2.5-1/2*housingThickness-width/2-2.5,flatten*(height/2+housingThickness/2)+doorDistanceToBottom+0]) 
        rotate([90*flatten+doorAngle*(1-flatten),0,0]) 
        translate([0,2.5,0])
        //translate([0,-1/2*housingThickness-width/2,doorDistanceToBottom])
        difference() {
            union() {
            doorHole(0,0);
                            for(i=[-1,1])
                translate([((doorWidth)/2-doorOverlap-25)*i,-materialThickness/2,0])
                rotate([90,90,0])
                hingePLA(0);
            }
            for(i=[-1,1])
                translate([((doorWidth)/2-doorOverlap-25)*i,-materialThickness/2,0])
                rotate([90,90,0])
                hingePLA(1);
            
            for(i=[-1,1]) //holes handle
                translate([i*10,0,doorHeight-7])
                rotate([90,0,0])
                cylinder(d=screwDiameter,h=2*housingThickness,center=true,$fn=36);
            for(i=[-1,1]) //holes magnet (!! only engrave)
                translate([i*((doorWidth)/2-3-doorOverlap),0,doorHeight-3-doorOverlap])
                rotate([90,0,0])
                cylinder(d=6,h=2*housingThickness,center=true,$fn=36);
        }
}

module doorhandle() {
     //doorhandle
    translate([0,-housingThickness-1/2*housingThickness-width/2,doorDistanceToBottom])
        //translate([0,-housingThickness,doorAngle*(1-flatten)])
        translate([0,flatten*(width/2)-explodeHousing*3,flatten*(height/2+3*housingThickness/2)])
        rotate([90*flatten+doorAngle*(1-flatten),0,0]) 
//translate([0,-1/2*housingThickness-width/2,doorDistanceToBottom+doorHeight-7])
        translate([0,0,doorHeight-7])
        difference() {
            hull() {
            hull() {
                for(i=[-1,1])
                translate([i*10,0.5,0])
                rotate([90,0,0])
                cylinder(d=screwDiameter+4,h=2,center=true,$fn=36);
                for(i=[-1,1])
                translate([i*5,0.5,5])
                rotate([90,0,0])
                cylinder(d=screwDiameter+4.4,h=2,center=true,$fn=36);
            }
            hull() {
                for(i=[-1,1])
                translate([i*10,1,0])
                rotate([90,0,0])
                cylinder(d=screwDiameter+6,h=1,center=true,$fn=36);
                for(i=[-1,1])
                translate([i*5,0.5,5])
                rotate([90,0,0])
                cylinder(d=screwDiameter+6,h=0.2,center=true,$fn=36);
            }
        }
            for(i=[-1,1])
            translate([i*10,0,0])
            rotate([90,0,0])
            hull() {
                translate([0,0,-0.6])
                cylinder(d=screwDiameter,h=1,center=true,$fn=36);
                translate([0,0,0.8])
                cylinder(d=screwDiameter+3,h=1,center=true,$fn=36);
            }
            for(i=[-1,1])
                translate([i*10,0,0])
                rotate([90,0,0])
                cylinder(d=screwDiameter,h=4,center=true,$fn=36);
        }
}
    
module wallXside(l, openingDoor,magnets) {
    union() {
        difference() {
            if(openingDoor==0)
                translate ([0,(-width-housingThickness)/2*l,height/2])
                    cube([length,housingThickness,height],true);
            else
                translate([0,-width/2-housingThickness/2-0.5,doorDistanceToBottom])
                scale([1,2/housingThickness,1])
                doorHole(doorOverlap,0);
            // connectors x-Axis
            translate([0,0,distanceXtoBottom]) 
                connectors(width, xWidth, 1);   
            //connectors top/bottom
                translate([0,0,(height/2-height/2-housingThickness)]) 
                    rotate([0,0,0])
                    connectors(width, length, 1);
            //connectors top
            translate([0,housingThickness,height+housingThickness]) 
                rotate([180,0,0])
                connectors(width-2*housingThickness, length, 1); 
            if (l==-1)
                translate([0,0,height/2+height/2+housingThickness]) 
                rotate([180,0,0])
                connectors(width, length, 1);
            // door opening
            if (l==1)
                translate([0,-width/2-housingThickness/2,doorDistanceToBottom])
                scale([1,10,1])
                doorHole(openingDoor*(doorOverlap-0.5),magnets);
            // Connector stuff @back
            if (l==-1)
                connectorBack(1);
            if (l==1)
                connectorFront(1);

        // Screws for door
        if (l==1) 
            for(i=[-1,1])
                translate([((doorWidth)/2-doorOverlap-25)*i,-(length/2)-materialThickness-magnets*housingThickness,doorDistanceToBottom])
                rotate([90,90,0])
                hingePLA(1);
            for(i=[-1,1]) //holes magnet (!! only engrave)
                translate([i*((doorWidth)/2-3-doorOverlap),-length/2-5*housingThickness-2,doorHeight-3-doorOverlap+doorDistanceToBottom])
                rotate([90,0,0])
                cylinder(d=6.1,h=10*housingThickness,center=true,$fn=36);
        }
        // Connector stuff @back
        if (l==-1 && flatten==0 && showPrint && magnets==0)
           connectorBack(0);
        // Connector stuff @front
        if (l==1 && flatten==0 && showPrint && magnets==0)
           connectorFront(0);

    }
}

module screenholder(holes) {
    difference() {
        union() {
//        for(i=[-1,1])
//        #translate([i*56/2,0,0])
//            cube([5,102-2,1],true);  
//        for(i=[-1,1])
//        #translate([0,i*92/2,0])
//            cube([61-2,10,1],true);
          hull() {
              hull() {  
                translate([0,0,0])
                    cube([61-3,104-2,1],true);  
                translate([0,0,0])
                    cube([61-2-3,104,1],true);  
              }
              hull() {  
                translate([0,0,0.5])
                    cube([61-2-3,104-4,2],true);  
                translate([0,0,0.5])
                    cube([61-4-3,104-2,2],true);  
              }
          }
        }
        
      hull() {  
        translate([0,0,0])
            cube([51,82-2,10],true);  
        translate([0,0,0])
            cube([51-2,82,10],true);  
      }
        hull() {
              hull() {  
                translate([0,0,1.5])
                    cube([51,82-2,1],true);  
                translate([0,0,1.5])
                    cube([51-2,82,1],true);  
              }
              hull() {  
                translate([0,0,2])
                    cube([51+1,82-1,1],true);  
                translate([0,0,2])
                    cube([51-1,82+1,1],true);  
              }
        }
        for(i=[-1,1])for(j=[-1,1])
            translate([j*48/2,i*94/2,0])
            cylinder(d=3,h=100,$fn=36,center=true);
        
        for(i=[-1,1])for(j=[-1,1])
            hull() {
                translate([j*48/2,i*94/2,0.9])
                cylinder(d=3,h=2,$fn=36,center=true);
                translate([j*48/2,i*94/2,1.8])
                cylinder(d=6,h=1,$fn=36,center=true);
            }
            translate([48/2-8.5,-94/2+0.5,0.5-0.4])
                cylinder(d=4,h=10,$fn=36,center=true);
            hull() {
                translate([48/2-8.5,-94/2+0.5,0.9])
                cylinder(d=4,h=2,$fn=36,center=true);
                translate([48/2-8.5,-94/2+0.5,1.8])
                cylinder(d=6,h=1,$fn=36,center=true);
            }
//            intersection() {
//                translate([48/2-8.5,-94/2+0.5,1])
//                cylinder(d=4,h=2,$fn=36,center=true);
//                translate([48/2-8.5,-94/2+0.5,1])
//                for(j=[-4:4])for(k=[-4:4])
//                    translate([j*0.4,k*0.4,0])
//                    cube([0.2,0.2,10],true);    
//            }
            translate([0,0,0]) // screen
                cube([56,87,1.8],true);
    }
    if(holes==1) {
            for(i=[-1,1])for(j=[-1,1])
            translate([j*48/2,i*94/2,0])
                cylinder(d=4,h=100,$fn=36,center=true);
            for(i=[-1,1])
            translate([i*(48/2-8.5),(-94/2+0.5),0])
                cube([9,6,100],true);
            translate([0,0,0]) // screen
                cube([55,86,100],true);
    }
}

module ledholder(holes) {
    difference() {
        union() {
            hull() {
                translate([-18,0,0])
                    cube([19-4,101,2],true); 
                translate([-18,0,0])
                    cube([19,101-4,2],true); 
            }
        }
        translate([-21.5+9,-47.5,-1])
            cube([12,6,5],true); 
        translate([-14.5+8,36.5,-0.5])
            cube([10,28,2],true); 
        translate([0,101/2-14,-1])
            cube([60,5,2],true); 
        translate([-20.5+8,-101/2,-0.5])
            cube([10,28*2,2],true); 
        hull() {
            translate([-23,0,2])
                cube([9,101,2],true); 
            translate([-23-1.6,0,0.4])
                cube([9,101,2],true); 
        }
        hull() {
            translate([-23-9,0,0])
                cube([9,101-10,10],true);  
            translate([-23,0,0])
                cube([9,101-16-10,10],true); 
        }
        for(i=[-1,1])for(j=[-1,1])
            translate([j*48/2,i*94/2,0])
            cylinder(d=3,h=100,$fn=36,center=true);
    }
}

module ledFrame() {
    translate([0,6/2,-50/2])
    for(i=[-1,1])
        difference() {
            union() {
            translate([i*(width/2-20),0,conHeight/2])
                cube([conWidth,5.5,50-conHeight],true);
            translate([0,2.75,16.7-0.8])
                rotate([15,0,0])
                translate([0,-1.5,-1.5])
                cube([width-2,10,3],true);
            }
            translate([i*(width/2-20),0,25-4])
                rotate([90,0,0])
                cylinder(d=3,h=100,$fn=36,center=true);
            translate([0,2.75,17.1-2-0.8])
                rotate([15,0,0])
                translate([0,0,-50-3])
                cube([width,110,103],true);
            translate([0,0,-25-14])
                cube([width-2,110,100],true);
            translate([0,-110/2-5.5/2,0])
                cube([width,110,100],true);
        }
}

module emergencyStop() {
    color("RED")  
    translate([0,0,1])
        cylinder(d=22,h=25.5+45,$fn=36);
    color("RED")  
    hull() {
        translate([0,0,68.5])
            cylinder(d=24,h=5,$fn=36);
        translate([0,0,65])
            cylinder(d=40,h=5,$fn=36);
    }
    color("YELLOW")  
    translate([0,0,48])
        cylinder(d=40,h=1,$fn=36);
    color("YELLOW")  
    translate([0,0,48])
        cylinder(d=30,h=10,$fn=36);
    color("DARKGREY")  
    cylinder(d=30,h=45,$fn=36);
    color("DARKGREY")  
    translate([0,0,35/2])
        cube([37,37,35],true);//0.5-5 mm size
}

module connectorBack(holes) {
    // USB B for power
    color("LIGHTBLUE")  
        translate([31,length/2-housingThickness-2,15])
        rotate([90,0,180])
        usbA(holes);
    color("LIGHTBLUE") 
        translate([31,length/2-housingThickness-2,15])
        rotate([90,0,0])
        usbBack(0);
    // Key switch
    color("LIGHTBLUE") 
        translate([-31,length/2-housingThickness-2,15])
        rotate([90,0,180])
        keySwitch(holes);
}

module connectorFront(holes) {
    // Swich
    color("LIGHTBLUE") 
        translate([31,-length/2+housingThickness-0.5,15])
        rotate([90,0,0])
        switch(holes);
    
        // LED
    color("LIGHTBLUE") 
        translate([-31,-length/2+housingThickness-0.5,15])
        rotate([90,0,0])
        vent(holes);
        //empty(holes);
}

module connectorSide(holes) {
    // Vents
    color("LIGHTBLUE") 
        for(i=[-1,1])
        translate([-width/2+2.5,33*i,15])
        rotate([-90,0,90])
        vent(holes);
}

module cncaxis(axisLength, axisWidth, position, modificator) {
    if(showDrive) 
        for(i=[-1,1]) 
            translate([(axisLength-conDistance*2-conLength+explodeModules)/2*i,0,axisHeight+materialThickness]) 
            rotate([270,0,0]) 
            axis(axisWidth,position);
    translate([0,-flatten*length*1,explodeModules]) 
        plate(axisWidth/2, axisLength, position, modificator);
    if(showPrint) 
        color("LIGHTBLUE")  
        connectors(axisWidth,axisLength,0);
    mount(axisLength, axisWidth, modificator);
    
    color("Gainsboro")
    if (modificator == z) {
        for (i=[0,-1])
            translate([0,-length*flatten*(1-i*0.2)*1.4,explodeModules*2/3+i*materialThickness]) 
            rotate([0,0,flatten*90])
            difference() {
                linearGear(axisWidth/2+conHeight, axisLength, position);
                translate([-7,position+7-conHeight/2,axisHeight+1*materialThickness])
                cube(conHeight,true);
            }
    } else {
        for (i=[0,-1])
            translate([0,-length*flatten*(1-i*0.2)*1.4,explodeModules*2/3+i*materialThickness]) 
            rotate([0,0,flatten*90])
            linearGear(axisWidth/2, axisLength, position);
    }
}

module usbBack(holes) {
    difference() {
        union() {
            hull() for(i=[-1,1]) for(j=[-1,1]) 
                translate([(31-5)/2*i,(26-5)/2*j,0])
                cylinder(d=5,h=8,$fn=18);
        }
        for(i=[-1,1])
            translate([-24/2*i,19/2*i,0]) 
            cylinder(d=4,h=30,$fn=36,center=true);
        cube([100,11.5,12],true); //6mm
        cube([22,15,20],true); //6mm
        
        for(i=[-1,1])
            translate([-24/2*i,19/2*i,2]) 
            rotate([0,0,50])
            cylinder(d=screwNutDiameter+0.2,h=10,$fn=6);
    }
    if (holes==1) {
        for(i=[-1,1])
        translate([-24/2*i,19/2*i,0]) 
        cylinder(d=3.4,h=30,$fn=36,center=true);
        translate([0,0,5])cylinder(d=23.5,h=20);//h 2.5
    }
}

module frameScreen() {
    difference() {
    cube([58+2,87+2,1.2],true);
    cube([55,84,100],true);
    }
}

module usbB(holes) {
    difference() {
        union() {
            hull() for(i=[-1,1]) for(j=[-1,1]) 
                translate([(31-5)/2*i,(26-5)/2*j,-2])
                cylinder(d=5,h=7,$fn=18);
            translate([0,0,5])cylinder(d=23.5,h=4);//h 2.5
        }
        for(i=[-1,1])
            translate([24/2*i,19/2*i,0]) 
            cylinder(d=4,h=30,$fn=36,center=true);
        if (holes==0)
            translate([0,0,0]) cube([11,12.5,30],true);
    }
    if (holes==1) {
        for(i=[-1,1])
        translate([24/2*i,19/2*i,0]) 
        cylinder(d=3.4,h=30,$fn=36,center=true);
        translate([0,0,5])cylinder(d=23.5,h=20);//h 2.5
    }
}

module led(holes) {
    difference() {
        union() {
            hull() for(i=[-1,1]) for(j=[-1,1]) 
                translate([(31-5)/2*i,(26-5)/2*j,-2])
                cylinder(d=5,h=7,$fn=18);
            translate([0,0,5])cylinder(d=23.5,h=4);//h 2.5
        }
        if (holes==0) {
            for(i=[-1,1])
                translate([24/2*i,19/2*i,0]) 
                cylinder(d=4,h=30,$fn=36,center=true);
            cylinder(d=5,h=100,$fn=36,center=true);
            translate([0,0,11.5-3])
                cylinder(d=20,h=5,$fn=36,center=true);
            hull() {
                translate([0,0,11.5-3])
                    cylinder(d=18,h=5,$fn=36,center=true);
                translate([0,0,4])
                    cylinder(d=5,h=5,$fn=36,center=true);
            }
        }
//        if (holes==0)
//            translate([0,0,0]) cube([11,12.5,30],true);
    }
    if (holes==1) {
        for(i=[-1,1])
        translate([24/2*i,19/2*i,0]) 
        cylinder(d=3.4,h=30,$fn=36,center=true);
        translate([0,0,5])cylinder(d=23.5,h=100, center=true);//h 2.5
    }
}

module usbA(holes) {
    difference() {
        union() {
            hull() for(i=[-1,1]) for(j=[-1,1]) 
                translate([(31-5)/2*i,(26-5)/2*j,0])
                cylinder(d=5,h=5,$fn=18);
            translate([0,0,5])cylinder(d=23.5,h=4);
        }
        for(i=[-1,1])
            translate([24/2*i,19/2*i,0]) 
            cylinder(d=4,h=30,$fn=36,center=true);
        if (holes==0)
            for(i=[-1,1])
            translate([i*5,0,0]) 
            translate([0,0,0]) cube([6.8,14.4,30],true);
    }
    if (holes==1) {
        for(i=[-1,1])
        translate([24/2*i,19/2*i,0]) 
        cylinder(d=3.4,h=30,$fn=36,center=true);
        translate([0,0,5])cylinder(d=23.5,h=20);//h 2.5
    }
}

module empty(holes) {
    difference() {
        union() {
            hull() for(i=[-1,1]) for(j=[-1,1]) 
                translate([(31-5)/2*i,(26-5)/2*j,1])
                cylinder(d=5,h=1,$fn=18);
            translate([0,0,2])cylinder(d=23.5,h=4);
        }
        for(i=[-1,1])
            translate([24/2*i,19/2*i,0]) 
            cylinder(d=4,h=30,$fn=36,center=true);
    }
    if (holes==1) {
        for(i=[-1,1])
        translate([24/2*i,19/2*i,0]) 
            cylinder(d=3.4,h=30,$fn=36,center=true);
        translate([0,0,5])
            cylinder(d=23.5,h=30,center=true);//h 2.5
    }
}

module vent(holes) {
    difference() {
        union() {
            hull() for(i=[-1,1]) for(j=[-1,1]) 
                translate([(31-5)/2*i,(26-5)/2*j,0])
                cylinder(d=5,h=2.5,$fn=18);
            //translate([0,0,-10])cylinder(d=23.5,h=10);
            translate([0,0,2.5])cylinder(d=23.5,h=4,$fn=36);//h 2.5
//        translate([0,0,-3])
//            rotate([0,0,-5])
//            difference() {
//                cube([25,25,7],true);
//                for(i=[-1,1]) for(j=[-1,1])
//                    translate([i*10,j*10,0])
//                    cylinder(d=3,h=100,$fn=36,center=true);
//            }

        }
        if (holes==0)
            translate([0,0,2.5])cylinder(d=23.5-4,h=100,$fn=36,center=true);//h 2.5
        for(i=[-1,1])
            translate([24/2*i,19/2*i,0]) 
            cylinder(d=4,h=30,$fn=36,center=true);
    }
    if (holes==1)
        for(i=[-1,1])
        translate([24/2*i,19/2*i,0]) 
        cylinder(d=3.4,h=30,$fn=36,center=true);
    //if (simplifyVent==0) 
        intersection() {
            translate([0,0,0])cylinder(d=23.5,h=3,$fn=36);
            for(i=[-10:10])
                translate([0,i*3+1,0]) rotate([45,0,0]) cube([100,0.5,20],center=true);
        }
    //if (simplifyVent==0) 
        intersection() {
            translate([0,0,3])cylinder(d=23.5,h=3,$fn=36);
            for(i=[-10:10])
                translate([0,i*3+1,0]) rotate([-45,0,0]) cube([100,0.5,20],center=true);
        }
}

module keySwitch(holes) {
    difference() {
        union() {
            hull() for(i=[-1,1]) for(j=[-1,1]) 
                translate([(31-5)/2*i,(26-5)/2*j,-3])
                cylinder(d=5,h=5.5,$fn=18);
            translate([0,0,2.5])cylinder(d=23.5,h=4,$fn=36);//h 2.5

        }
        if (holes==0) {
            translate([0,0,2.5])cylinder(d=12,h=100,$fn=36,center=true);
            translate([0,0,2])cylinder(d=16,h=5,$fn=36);
        }
        for(i=[-1,1])
            translate([24/2*i,19/2*i,0]) 
            cylinder(d=4,h=30,$fn=36,center=true);
    }
    if (holes==1) {
        for(i=[-1,1])
        translate([24/2*i,19/2*i,0]) 
        cylinder(d=3.4,h=30,$fn=36,center=true);
        translate([0,0,5])cylinder(d=23.5,h=10);//h 2.5
    }
}

module switch(holes) {
    difference() {
        union() {
            hull() for(i=[-1,1]) for(j=[-1,1]) 
                translate([(31-5)/2*i,(26-5)/2*j,0])
                cylinder(d=5,h=2.5,$fn=18);
            //translate([0,0,2.5])cylinder(d=23.5,h=4,$fn=36);//h 2.5

        }
        if (holes==0) {
            translate([0,0,2.5])cylinder(d=19.5,h=100,$fn=36,center=true);
            cube([4,21,100],true);
            cube([22,2,100],true);
            translate([0,0,2])cylinder(d=23,h=5,$fn=36);
        }
        for(i=[-1,1])
            translate([24/2*i,19/2*i,0]) 
            cylinder(d=4,h=30,$fn=36,center=true);
    }
    if (holes==1) {
        for(i=[-1,1])
        translate([24/2*i,19/2*i,0]) 
        cylinder(d=3.4,h=30,$fn=36,center=true);
        translate([0,0,0])cylinder(d=23.5,h=20);//h 2.5
    }
}

module laser(holes) {
    translate([0,3.5,6])
    color("BLACK") cube([20,27,46],true);  //110: 30*30*20W, 7W, 3,5W 33*33*65, 30*30*80
    color("Goldenrod") cylinder(d=12,h=46,$fn=36,center=true);
    color("BLUE") translate([0,0,-53]) cylinder(d=1,h=60,$fn=36,center=true);
    if(holes)
    for(i=[-1,1])
        translate([i*5,0,29-15])
        rotate([-90,0,0])
        cylinder(d=3,h=100,$fn=36);
//    for(i=[-1,1])
//        translate([i*5,0,-17+15])
//        rotate([-90,0,0])
//        cylinder(d=3,h=100,$fn=36);
}

module laserholder() {
    color("LIGHTBLUE") 
        difference() {
            hull() {
                translate([0,22,6])
                    cube([20,10,46],true);
                translate([0,34,6-10])
                    cube([20,1,66],true);
            }
        for(i=[-1,1])
            translate([i*5,0,29-15])
            rotate([-90,0,0])
            cylinder(d=3,h=100,$fn=36);
    }
}

module penHolder() {
    translate([0,positionZ*(1-flatten)+flatten*50,34.5])
    difference() {
        union() {
            hull() {
                translate([0,0,13])
                    cube([31,44,3],true);
                translate([0,0,6])
                    rotate([90,0,0])
                    cylinder(d=14,h=44,$fn=36,center=true);//11.25
            }
            hull() plate(36, 72, 0, z);
            for(i=[-1,1])
                translate([i*21.5,0,17.5])
                hull() {
                    cube([8,12,8],true);
                    cube([6,12,10],true);
                }
                //rotate([90,0,0])
                //resize([8,8,21])
                //#bearing();
            for(i=[6,9]) 
                translate([0,0,i-0.5])
                linearGear (44, 0, 0);
//            for(j=[-1,1]) for(i=[-1,1])
//                translate([14*i,4+j*17-conHeight/2,13])
//                cylinder(d=4,h=3,center=true,$fn=36);
            for(j=[-1:1])
                translate([0,4+j*17-conHeight/2,16])
                cylinder(d=4,h=9,center=true,$fn=36);
        }
        for(i=[-1,1]) for(j=[-1,1])
            translate([i*21.5,j*9,17.5])
            cube([11,14.5,4],true);
        for(i=[-1,1]) for(j=[-1,1])
            translate([i*21.5,j*6,17.5])
            rotate([90,0,0])
            resize([8,8,8.5])
            hull() bearing();
        for(i=[-1,1])
            translate([i*21.5,0,17.5])
            rotate([90,0,0])
            cylinder(d=4,h=100,$fn=72,center=true);
        translate([-7,-1+4,18.5])
            cube(conHeight,true);
        translate([0,2,7])
            rotate([90,0,0])
            color("Goldenrod") 
            difference() {
                union() {
                    cylinder(d=11.8+2,h=46,$fn=36,center=true);//11.5
                    cylinder(d=9,h=46+11,$fn=36,center=true);//8
                    cylinder(d=7,h=46+11+15,$fn=36,center=true);//6
                    cylinder(d=1,h=46+47,$fn=36,center=true);//1
                }
                for(i=[-1:1])
                    rotate([0,0,i*110])
                    translate([0,7.31,0])
                    rotate([0,0,45])
                    cube([2,2,100],true);
            }
    }
}

module millInlay() {
    difference() {
        union() {
            cylinder(d=5.1,h=5.4,$fn=72);
            cylinder(d=7,h=0.4,$fn=72);
        }
        cylinder(d=3.4,h=100,$fn=72,center=true);
        hull(){
            cylinder(d=3.4,h=0.4,$fn=72,center=true);
            translate([0,0,-1])
            cylinder(d=4.6,h=1,$fn=72,center=true);
        }
    }
}

module millHolderOld() {
        translate([0,positionZ*(1-flatten)+flatten*50,34.5])
        difference() {
            hull() {
                cube([144/2-conWidth*5-1*materialThickness,75/2-materialThickness+conHeight,16],true);
                cube([144/2-conWidth*4-1*materialThickness,75/2-materialThickness-conWidth*1+conHeight,16],true);
                translate([0,-11-17,0])
                rotate([-90,0,0])
                cylinder(d=16,h=20,$fn=72,center=true);
            }
            translate([0,7-4,0])
                cube([21,37,100],true);
            for(i=[-1:1]) for(j=[-1,1])
                translate([14*i,4+j*17-conHeight/2,-8])
                cylinder(d=8,h=6,center=true,$fn=36);
            for(i=[-1,1]) for(j=[-1,1])
                translate([14*i,4+j*17-conHeight/2,0])
                cylinder(d=screwDiameter,h=100,center=true,$fn=36);
            rotate([90,0,0])
                cylinder(d=10,h=100,$fn=72);
            rotate([90,0,0])
                cylinder(d=14,h=32,$fn=72);
            translate([0,-33,0])
            rotate([90,0,0])
                cylinder(d=11,h=5,$fn=72);
        }
}

module millHolder() {
        translate([0,positionZ*(1-flatten)+flatten*50,34.5])
    difference() {
        union() {
            translate([0,0,3.5]) hull() {
                cube([144/2-conWidth*5-1*materialThickness,75/2-materialThickness+conHeight,16],true);
                cube([144/2-conWidth*4-1*materialThickness,75/2-materialThickness-conWidth*1+conHeight,16],true);
                translate([0,-11-17,0])
                    rotate([-90,0,0])
                    cylinder(d=16,h=20,$fn=72,center=true);
            }
            hull() {
                translate([0,0,3.5])
                    cube([144/2-conWidth*5-1*materialThickness,75/2-materialThickness+conHeight,16],true);
                translate([0,0,3.5])
                    cube([144/2-conWidth*4-1*materialThickness,75/2-materialThickness-conWidth*1+conHeight,16],true);
                plate(36, 72, 0, z);
            }
            for(i=[-1,1])
                translate([i*21.5,0,17.5])
                hull() {
                    cube([8,12,8],true);
                    cube([6,12,10],true);
                }
            for(i=[6,9]) 
                translate([0,0,i-0.5])
                linearGear (44, 0, 0);
            for(j=[-1:1])
                translate([0,4+j*17-conHeight/2,16])
                cylinder(d=4,h=9,center=true,$fn=36);
        }
        translate([0,7-conHeight/2,0])
            cube([12,21,29],true);
        for(j=[-1,1]) for(i=[-1,1])
            translate([14*i,4+j*17-conHeight/2,13])
            cylinder(d=3,h=10,center=true,$fn=36);   
        for(j=[-1,1]) for(i=[-1,1])
            translate([14*i,4+j*17-conHeight/2,14])
            hull() {
                cylinder(d=3,h=1+2*2,center=true,$fn=36);
                cylinder(d=6,h=1,center=true,$fn=36);
            }
        for(i=[-1,1]) for(j=[-1,1])
            translate([i*21.5,j*9,17.5])
            cube([11,14.5,4],true);
        for(i=[-1,1]) for(j=[-1,1])
            translate([i*21.5,j*6,17.5])
            rotate([90,0,0])
            resize([8,8,8.5])
            hull() bearing();
        for(i=[-1,1])
            translate([i*21.5,0,17.5])
            rotate([90,0,0])
            cylinder(d=4,h=100,$fn=72,center=true);
        translate([-7,-1+4,18.5])
            cube(conHeight,true);
        translate([0,7-4,-5.5-3])
            cube([21,38,40],true);
        for(i=[-1,1]) for(j=[-1,1])
            translate([14*i,4+j*17-conHeight/2,0])
            cylinder(d=screwDiameter,h=100,center=true,$fn=36);
        translate([0,0,3.5])
            rotate([90,0,0])
            cylinder(d=10,h=100,$fn=72);
        translate([0,0,3.5])
            rotate([90,0,0])
            cylinder(d=14,h=32,$fn=72);
        translate([0,-33,3.5])
            rotate([90,0,0])
            cylinder(d=11,h=5,$fn=72);
    }
}

module mill() {
    translate([0,0,2])
    color("BLACK") cylinder(d=22, h=21, center=true, $fb=36);  
    color("Goldenrod") translate([0,0,-54/2-5+7.5]) cylinder(d=10, h=20, center=true, $fb=36); 
    color("GREY") translate([0,0,-54/2-11+7.5]) cylinder(d=3, h=45, center=true, $fb=36);  
}

module printhead () {
    color("BLACK") cube([84,42,42],true); 
    color("BLACK") translate([-20,-5,15]) cube([10,50,10],true); 
    color("Orange") translate([-20,0,-40]) cube([30,30,40],true);
}

module piZero(holes) {
    translate([0,0,0.7]) union() {
        difference() {
            union() {
                color("green") 
                    translate([0,0,-0.8]) 
                    cube([65,30,1.6],center=true);
                color("grey") 
                    translate([65/2-54,23/2,2.7/2]) 
                    cube([7.5,10,2.7],center=true);//microUSB PWR
                color("grey") 
                    translate([65/2-41.4,23/2,2.7/2]) 
                    cube([7.5,10,2.7],center=true);//microUSB USB
                color("grey") 
                    translate([65/2-12.4,23/2,3.5/2]) 
                    cube([11.2,10,3.5],center=true);//microHDMI
            }
            for(i=[-1,1]) for(j=[-1,1]) 
                translate([29*i,23/2*j,0]) 
                cylinder(d=2.75,h=3,center=true, $fn=18);
        }
        translate([0,0,-9.5]) difference() {
            union() {
                color("green") 
                    translate([0,0,14]) 
                    cube([65,30,1.6],center=true);
                color("grey") 
                    for(i=[-1:1])
                    translate([20*i+5,0,13.5+14/2]) 
                    cube([15,20,14],center=true);
                color("grey") 
                    translate([-28,12,20.3]) 
                    cube([9,13,11],center=true);
            }
            for(i=[-1,1]) for(j=[-1,1]) 
                translate([29*i,23/2*j,10]) 
                cylinder(d=2.75,h=3,center=true, $fn=18);
        }
        if(holes) {
             color("grey") union() {
                translate([65/2-54,0,2.7/2]) 
                    cube([7.5+1,100,2.7+1],center=true);//microUSB PWR
                translate([65/2-41.4,0,2.7/2]) 
                    cube([7.5+1,100,2.7+1],center=true);//microUSB USB
                translate([65/2-12.4,0,2.7/2]) 
                    cube([11.2+1,100,3.5+1],center=true);//microHDMI
                translate([-28,0,20.3-9.5]) 
                    cube([9+1,100,11+1],center=true);
                for(i=[-1,1])
                    translate([29*i,23/2,10]) 
                    cylinder(d=2.75,h=50,center=true, $fn=18);
                for(i=[-1,1])
                    translate([29*i,-23/2,10]) 
                    cylinder(d=2.75,h=50,center=true, $fn=18);
            }
        }
    }
}


module endStop(housing,holes) {
    if(housing) color("Green") {
        difference() {
            translate([0,0,-6.5/2]) 
                cube([5.8,12.8,6.5],true);
            for(i=[-1,1]) 
                translate([0,6.5/2*i,-5.1]) 
                rotate([0,90,0])
                cylinder(d=2,h=100, center=true, $fn=18);
            }
        for(i=[-1:1]) 
            translate([0,5*i,-6.5-3.5/2]) 
            cylinder(d=0.9+0.1,h=3.5,center=true,$fn=18);
        translate([0,2.5,0]) 
            sphere(d=1.6, $fn=18);
    } else {
        for(i=[-1,1]) 
            translate([0,6.5/2*i,-5.1]) 
            rotate([0,90,0]) 
            cylinder(d=2,h=100, center=true, $fn=18);
        if(!holes)
        for(i=[-1,1]) translate([0,6.5/2*i,-6.5-3.5/2]) 
            rotate([0,90,0]) 
            cylinder(d=1.5,h=100, center=true, $fn=18);
    }
}

module linearGear (gearLength, positionBelt, position) {
    translate([0,position,axisHeight+1*materialThickness])  {
        difference() {
            intersection() {
                translate([4+gearLin,0,0]) 
                    rotate([0,0,-90]) 
                    zahnstange(modul=1, laenge=gearLength*PI, hoehe=7+gearLin, breite=materialThickness, eingriffswinkel=20, schraegungswinkel=0);
                cube([gearLength,gearLength,gearLength],true);
            }
            for(i=[-1:1]) 
                translate([0,(gearLength/2-5)*i,0]) 
                    cylinder(d=screwDiameter, h=materialThickness*2, center=true, $fn=36);
        }
        translate([-6,-19/2,materialThickness/2])
            cube([6,gearLength-19,materialThickness],true);//1mm gap
    }
}

module connector(showHoles) {
    translate([-conWidth/2,-conLength/2,0])
        connectorhalve(showHoles);
    rotate([0,0,-90])
        mirror([0,1,0])
        translate([-conWidth/2,-conLength/2,0])
        connectorhalve(showHoles);
}
    
module connectorhalve(showHoles) {
    union() {
        difference() {
            hull() {
                translate([0,0,conHeight/2]) 
                    cube([conWidth,axisDiameter*2,conHeight],true);
                translate([0,conLength/2-1,conHeight/2]) 
                    cube([conWidth,2,conHeight],true);
                translate([0,0,screwLength/2-4/2]) 
                    cube([conWidth,conLength,screwLength-4],true);
                translate([0,conWidth/2,conHeight/2]) 
                    cube([0.0000000001,conLength,conHeight],true);
            }
            // axis
            translate([axisShorting/2,2,axisHeight]) 
                rotate([0,90,0]) 
                cylinder(d=axisDiameter*printOffset,h=conWidth, center=true, $fn=18);
            translate([axisShorting/2,2,conHeight]) 
                cube([conWidth,axisDiameter*9/10*printOffset,axisDiameter*printOffset],true);
            //bottom screw
            translate([0,conScrewDistance+3,-materialThickness+1]) 
                cylinder(d=screwDiameter*printOffset,h=screwLength*2-materialThickness/2, center=true, $fn=18);
            // bottom nut
            translate([0,conScrewDistance+3,screwLength-3.2]) 
                rotate([0,0,15])
                cylinder(d=screwNutDiameter*printOffset,h=screwNutHeight, center=true, $fn=6);
            // side screw
            translate([0,-conScrewDistance+1,3.5]) 
                rotate([0,90,0]) 
                cylinder(d=screwDiameter*printOffset,h=conWidth*2, center=true, $fn=18);
            // side nut
            translate([conWidth,-conScrewDistance+1,3.5]) 
                rotate([90,0,90]) 
                cylinder(d=screwNutDiameter*printOffset,h=conWidth*2, center=true, $fn=6);
        }
        if(showHoles) {
            //bottom screw
            translate([0,conScrewDistance+3,0]) 
                cylinder(d=screwDiameter,h=conWidth*20, center=true, $fn=18);
            //side screw
            translate([0,-conScrewDistance+1,3.5]) 
                rotate([0,90,0]) 
                cylinder(d=screwDiameter,h=conWidth*20, center=true, $fn=18);
        }
    }
}

module plate(plateWidth, plateLength, position, modificator) {
    translate([0,position,axisHeight+conHeight-1]) difference() {
        union() {
            color("Gainsboro") difference() {
                hull() {
                    // z-axis: extension to top, second layer with inlay!
                    if(modificator == z)
                        union() {
                            cube([plateLength-conWidth*2-materialThickness,plateWidth+conHeight,materialThickness],true);
                            cube([plateLength-materialThickness,plateWidth-conWidth*2+conHeight,materialThickness],true);
                        }
                    cube([plateLength-conWidth*2-materialThickness,plateWidth,materialThickness],true);
                    cube([plateLength-materialThickness,plateWidth-conWidth*2,materialThickness],true);
                }
                if(modificator == y)
                    if (useTool == toolLaser)
                        translate([3.5,0,36])
                        rotate([-90,0,0])
                        rotate([0,90,0])
                        laser(1);
                    else 
                        translate([0,-10,10])
                            rotate([0,0,-90])
                            stepper28BYJ();
                        
                    
//                if(modificator == x) 
//                    translate([0,-62.5+5,0])
//                    cube([110,40,100],true);
                connectors(plateWidth,plateLength-materialThickness,1);
                if (modificator == z) {
                    // Mill: holes for motor, mountings
                    if (useTool == toolMill || useTool == toolPen) {
                        translate([0,7-conHeight/2,0])
                            cube([12,21,100],true);
//                        for(i=[-1,1]) for(j=[-1,1])
//                            translate([14*i,j*12,0])
////                            cube([2,4,materialThickness*2],true);
//                            cylinder(d=screwDiameter,h=100,center=true,$fn=36);
                        for(i=[-1,1]) for(j=[-1,1])
                            translate([14*i,4+j*17-conHeight/2,0])
                            cylinder(d=screwDiameter,h=100,center=true,$fn=36);
                    }
                    // Printhead:
                    if (useTool == toolPrinter) {
                    }
                }
            }
            
        }
        for(i=[-1,1]) for(j=[-1,1]) 
            translate([(plateLength-conDistance*2-conLength)/2*j,(plateWidth/2-conWidth-bearingLength/2)*i,0])      
            bearingGap(); 
        if (modificator == z) {
            for(i=[-1:1])
                translate([0,((plateWidth+conHeight)/2-5)*i+conHeight/2-conHeight/2,0]) 
                cylinder(d=screwDiameter, h=materialThickness*2, center=true, $fn=36);
        } else {
            for(i=[-1:1])
                translate([0,(plateWidth/2-5)*i,0]) 
                cylinder(d=screwDiameter, h=materialThickness*2, center=true, $fn=36);
        }    
    }
    color("Gainsboro") // holder for mill
    if ((modificator==z) && (useTool==toolMill)) {
        translate([0,positionZ*(1-flatten)+flatten*50,34.5])
        difference() {
            hull() {
                cube([plateLength-conWidth*5-materialThickness,plateWidth+conHeight,materialThickness],true);
                cube([plateLength-conWidth*4-materialThickness,plateWidth-conWidth*1+conHeight,materialThickness],true);
            }
            translate([0,7-4,0])
                cube([12,21,100],true);
            for(i=[-1,1]) for(j=[-1,1])
                translate([14*i,4+j*17-conHeight/2,0])
                cylinder(d=screwDiameter,h=100,center=true,$fn=36);
        }
    }
}

module mount(mountLength, mountWidth, modificator) {
    color("Gainsboro") difference() {
        translate([0,0,materialThickness/2]) 
            hull() {
            cube([mountLength,mountWidth-conWidth*2,materialThickness],true);
            cube([mountLength-conWidth*2,mountWidth,materialThickness],true);
            }
        if(modificator == x) {
            translate([0,mountWidth/2,0])
                cube([mountLength-2*(conWidth+conLength),27,100],true);
            translate([0,-mountWidth/2,0])
                cube([mountLength-2*(conWidth+conLength),50,100],true);
        }
//        if(modificator == x)
//            for(i=[1]) for(j=[1])
//            translate([j*31.5,mountWidth/2*i,0])
//            cube([31,27+40,100],true);
//        if(modificator == x)
//            for(i=[-1,1]) for(j=[-1,1])
//            translate([mountLength/2*i,j*31.5,0])
//            cube([2*conHeight,31,100],true);
        translate([motorDistance,0,0]) 
            gearedStepper();
        translate([motorDistance,0,0]) 
            rotate([0,0,-45])
            gearedStepper();
        connectors(mountWidth,mountLength,1);
        translate([-10,mountWidth/2-20,5.5-2]) 
            rotate([0,90,-90]) 
            endStop(0,0); // axis
        if(modificator == z)
            for(i=[-1,1])
            translate([(mountWidth/2-5)*i,0,0]) 
            cylinder(d=screwDiameter, h=100,center=true, $fn=36);
    }
    if(showDrive)
        color("DIMGREY") 
        translate([motorDistance,0,-explodeModules*2/3]) 
        gearedStepper();
    if(showElectronic) {
        translate([-10,mountWidth/2-20,8-explodeModules/3-2]) 
            rotate([0,90,-90]) 
            endStop(1,1);
    }
}

module connectors(consWidth, consLength, showHoles) {
    for(j=[0,1])
        mirror([0,j,0])
    for(i=[0,1])
        mirror([i,0,0])
        translate([(-consLength-explodeModules/2)/2+conWidth,consWidth/2-conWidth,materialThickness]) 
        connector(showHoles);
}

module bearingGap() {
    cube([5.3,bearingLength,materialThickness*2],true);
    for(i=[-1,1]) 
        translate([5*i,0,0]) 
        cube([2,4,materialThickness*2],true);
}

module axis(distance, position) {
    color("Goldenrod") 
        for(i=[-1,1]) 
        translate([0,0,(distance/4-conWidth-bearingLength/2+explodeModules*0.7)*i+position]) 
        bearing();
    color("GREY") 
        shaft(distance);
}

module shaft(distance) {
    cylinder(d=axisDiameter,h=distance-axisShorting, center=true, $fn=36);
}

module bearing() {
    difference() {
        cylinder(d=bearingDiameter,h=bearingLength, center=true, $fn=36);
        cylinder(d=axisDiameter,h=bearingLength*2, center=true, $fn=36);
    }
}

module gearedStepper() {           
    stepper28BYJ();
    translate([0,0,7]) 
        gear();
}

module gear() {
    difference() {
        union() {
            stirnrad (modul=1, zahnzahl=12, breite=materialThickness, bohrung=0, eingriffswinkel=20, schraegungswinkel=0, optimiert=true);
            translate([0,0,materialThickness/2]) 
                cylinder(d=9, h=materialThickness, $fn=36, center=true);
        }
            translate([0,0,-5]) 
            stepper28BYJ();
        }
}

module stepper28BYJ() {
    rotate([0,0,90])
    translate([0,8,0])
    union() {
        for(i=[-1,1]) 
            translate([35/2*i,0,-7+materialThickness]) 
            cylinder(d=4,h=20,center=true, $fn=9);
        for(i=[-1,1])
            translate([35/2*i,0,2+materialThickness]) 
            cylinder(d=screwNutDiameter,h=2,center=true, $fn=6);
    
        difference() {
            union() {
                translate([0,0,-19/2])
                    cylinder(d=28,h=19,center=true, $fn=36); //d=27
                hull()
                    for(i=[-1,1]) 
                    translate([35/2*i,0,-1/2]) 
                    cylinder(d=7,h=1,center=true, $fn=18);
                translate([0,4,-19/2])
                    cube([18,30,19],true); //cube([15,27,19],true); 
                translate([0,-8,-19/2+2])
                    cylinder(d=9.5,h=19+3,center=true, $fn=36);
                intersection() {
                    translate([0,-8,-19/2+10])
                        cylinder(d=5-gearAxisY,h=19,center=true, $fn=36);
                    cube([2.9-gearAxisX,100,100],true);
                }         
            }
            for(i=[-1,1]) 
                translate([35/2*i,0,-7+materialThickness]) 
                cylinder(d=4,h=20,center=true, $fn=18);
        }
    }
}

module hingePLA(holes) {
    difference() {
        union() {
            translate([0,0,1])
                rotate([0,-doorAngle,0])
                translate([0,0,-1])
                hingeHalf(1,holes);
            rotate([0,0,180])
                hingeHalf(0,holes);
        }
        translate([0,0,0.8])
            cube([10,8,0.4],true);
    }
}

module hingeTPU(holes) {
    difference() {
        translate([0,0,0.8])
            cube([10,8,0.4],true);
        for(i=[-1,1]) for(j=[-1,1])
            translate([i*3,j*4.5/2,0])
            cylinder(d=2,h=100,$fn=72,center=true);
    }
}

module hingeHalf(divider,holes) {
    difference() {
        union() {
            color("LightBlue") hull() {
                hull() {
                    translate([12/4,0,1/2])
                        cube([11.5/2,11-2,1],true);
                    translate([11/4,0,1/2])
                        cube([12/2-2,11,1],true);
                }
                hull() {
                    translate([12/4,0,1/2+1])
                        cube([12/2-2,11-4,1],true);
                    translate([12/4,0,1/2+1])
                        cube([12/2-4,11-2,1],true);
                }
            }
            
        }
        for(i=[-1,1]) for(j=[-1,1])
            translate([i*3,j*4.5/2,0])
            cylinder(d=2,h=100,$fn=72,center=true);
        for(i=[-1,1]) for(j=[-1,1])
            hull() {
                translate([i*3,j*4.5/2,2-0.2])
                    cylinder(d=3.8,h=100,$fn=72);
                translate([i*3,j*4.5/2,1-0.2])
                    cylinder(d=2,h=100,$fn=72);
            }
    }
    if(holes) {
        for(i=[-1,1]) for(j=[-1,1])
            translate([i*3,j*4.5/2,0])
            cylinder(d=2,h=100,$fn=72,center=true);
        
        for(i=[-1,1]) for(j=[-1,1])
            translate([i*3,j*4.5/2,-50-housingThickness])
            rotate([0,0,90])
            cylinder(d=4.4,h=50,$fn=6);
    }
}

module screwHead(indent) {//6mm durchmesser, 1,7mm tief
    difference() {
        if(intent==0) {
            hull() {
                cylinder(d=8+0.5,h=1,$fn=72);
                cylinder(d=6+0.5,h=2,$fn=72);
            }
        } else {
            cylinder(d=6.2,h=2,$fn=72);
        }
        hull() {
            translate([0,0,2-0.2])
            cylinder(d=6,h=1,$fn=72);
            translate([0,0,0.1])
            cylinder(d=3,h=1,$fn=72);
        }
        cylinder(d=3,h=10,$fn=72, center=true);
//        if (indent==1) {
//            hull() {
//                translate([11.5,0,-10+1])
//                    cube(20,true);
//                translate([11.5+1,0,-10+1+1])
//                    cube(20,true);
//            }
//        }
    }
}

