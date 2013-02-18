// Panelolu2 housing v0.1
//
// based on the Panelolu housing:
// thingiverse:http://www.thingiverse.com/thing:25617
//
// For more information:
// http://blog.think3dprint3d.com/2013/02/panelolu2.html
//
// by Tony Lock
// GNU GPL v3
// Feb 2013

/*
@todo:
- Integrate the knob code
- colour the assembly + provide exploded view
*/

//tony Busers bitmap letters, changed to (almost) 32 bit
include <bitmap_32.scad>;

///////////////////////////////////////////////////////////
//front, back or legs
///////////////////////////////////////////////////////////
side=-1; //1 = front, -1 = back  2= legs  0=assembly model
///////////////////////////////////////////////////////////

// Bed cube for layout
//translate([0,0,-0.5])
//cube([195,195,1], center=true);

////////////////////////////////////////////////////////////////////
//originally from Prusa configuration.scad
//https://github.com/prusajr/PrusaMendel
////////////////////////////////////////////////////////////////////
m3_diameter = 3.6;
m3_nut_diameter = 5.3;
m3_nut_diameter_bigger=((m3_nut_diameter / 2) / cos (180 / 6))*2;
////////////////////////////////////////////////////////////////////
clearance=1.2;
wall_width=1.6; //minimum wall width //should be a multiple of your extruded dia
layer_height=0.2;
//LCD screen
lcd_scrn_w=98+clearance;
lcd_scrn_h=39.8+clearance;
lcd_scrn_z=9.4;

lcd_board_w=98.5 + clearance;
lcd_board_h=60.5 + clearance/2;
lcd_board_z=1.6; //does not include metal tabs on base

lcd_hole_d=3.4;
lcd_hole_offset=(lcd_hole_d/2)+1;

//board edge to center of first connector hole
lcd_connect_x=9.8;  
lcd_connect_y=2.6;

//Panelolu2 circuit board

p2_w=lcd_board_w;
p2_h=25 + clearance/2;
p2_z=4; //excluding LEDs, click Encoder, reset switch and headers
p2_mounting_hole_dia=2.5;
p2_mounting_hole1_x=10;
p2_mounting_hole2_x=66;
p2_mounting_hole_y=2;

//rotary encoder
click_encoder_w=13.2;
click_encoder_h=12.6;
click_encoder_z=6;
click_encoder_shaft_dia=6.9+clearance;
click_encoder_shaft_h=14.2;
click_encoder_knob_dia=28.6;
click_encoder_knob_t=8;
click_encoder_offset_x=61.8;
click_encoder_offset_y=11;

//buzzer
bz_dia=12;
bz_offset_x=13.7;
bz_offset_y=10.6;

//LEDs
led_dia=5; //3 on production boards
led_z=12.5;
led_offset_y=3.5;
led1_offset_x=20.6;
led2_offset_x=33.5;
led3_offset_x=46.4;

//reset switch
reset_z=17.1;
reset_dia=4+clearance; //at point switch goes through case
reset_offset_x=24.9;
reset_offset_y=11.1;

//contrast and brightness holes
cb_dia=4;
con_x=66.7;
con_y=17.4;
bri_x=56.6;
bri_y=17.4;
//headers
//lcd connection header
lcd_h_w=(16*2.54)+2.54;
lcd_h_h=2.54;
lcd_h_z=3; //2.5 on production model, this is the gap between the circuit board caused by the plastic spaces on 2.54mm headers
lcd_h_offset_x=lcd_connect_x;  //unlike other measurements this is to first hole not center of object
lcd_h_offset_y=lcd_connect_y;

//IDC header, use the clearance required for the plug
idc_h_w=8;
idc_h_h=22;
idc_h_z=18.3; //not all will be within case
idc_offset_x=1.5; //to edge not to center
idc_offset_y=1;  

//SD card slot
SD_slot_h=15;
SD_slot_z=4;
SD_slot_offset_y=6;

//case closing lugs
lug_dia = lcd_hole_d+lcd_hole_offset+wall_width*1.8;

//letters variables
char_block_size = 0.3; //20 blocks wide by 32 high
char_height = 3.5;

//for legs
LCD_incline_angle=45;

//////////////////////////////////////////////////////////////////////////////////////////
// front
if (side==1)
{
	panelolu2_front();
}

// back
else if(side==-1)
{
	panelolu2_back();
}
//legs
else if(side==2)
{
	//rotate([-90-LCD_incline_angle,0,0])
	//leg_back(angle= LCD_incline_angle,standoff_height=9);
	front_standoff(standoff_height=9);
}
//assembly
else
{
  //whatever we want to test
  panelolu2_back();
  translate([0,0,(p2_z+lcd_h_z+wall_width+1.6)+(led_z-lcd_h_z-lcd_board_z)])
	rotate([0,180,0])
		panelolu2_front();
  translate([0,(p2_h-2*lcd_connect_y)/2,wall_width])
	#internal_assembly();
  //alignment still to be done
  /*
    translate([0,(lcd_board_h)/2,-(p2_z+lcd_h_z+wall_width+1.6)-(led_z-lcd_h_z-lcd_board_z)])
	rotate([LCD_incline_angle-90,0,180])
		leg_back(angle=LCD_incline_angle,standoff_height=9);
	*/
}
//////////////////////////////////////////////////////////////////////////////////////////

module panelolu2_front() {
	front_t=led_z-lcd_h_z-lcd_board_z; //the top of the front is flush with the top of the LEDs
	tabs_z=front_t-layer_height*2; //the LCD circuit board support tabs 
	difference() {
		union() {
			difference() {
				union(){
					//LCD board +P2 circuit board area 
					translate([0, 0, 0])
						roundedRect([lcd_board_w+wall_width,lcd_board_h+p2_h+wall_width-(2*lcd_connect_y),front_t], wall_width+1);
					//mounting lugs
					for(i=[1,-1]) {
					translate([i*((lcd_board_w-lug_dia-0.7)/2+wall_width),lcd_connect_y-(lcd_board_h+p2_h)/2-2*lug_dia/3,front_t/2])
						cylinder(r=(lug_dia+1.4)/2,h=front_t,$fn=12,center=true);
					translate([i*((lcd_board_w-lug_dia-0.7)/2+wall_width),lcd_connect_y-(lcd_board_h+p2_h)/2-lug_dia/6,front_t/2])
						cube([lug_dia+1.4,lug_dia, front_t], center=true);
					}
				}
				//lcd and Panelolu2 board cutouts
				translate([0,0,front_t/2+wall_width])
					cube([lcd_board_w,lcd_board_h+p2_h-2*lcd_connect_y, front_t], center=true);

				//Screen cutout
				translate([0,(p2_h-2*lcd_connect_y)/2,-wall_width]) 
					cube([lcd_scrn_w,lcd_scrn_h,lcd_scrn_z], center=true);
			}
			//LCD supports
			lcd_screw_support(tabs_z,18);		
		}

		//cut outs Encoder, reset, LED holes and buzzer //mirrored on X as top is inverter for mounting
		mirror([1,0,0]) {
			translate([click_encoder_offset_x-(lcd_board_w)/2,click_encoder_offset_y-(lcd_board_h+p2_h-lcd_connect_y*2)/2,-wall_width/2])
				cylinder(r=click_encoder_shaft_dia/2,h=wall_width*2,$fn=12);
			translate([reset_offset_x-(lcd_board_w)/2,reset_offset_y-(lcd_board_h+p2_h-lcd_connect_y*2)/2,-wall_width/2])
				cylinder(r=reset_dia/2,h=wall_width*2,$fn=12);
			translate([led1_offset_x-(lcd_board_w)/2,led_offset_y-(lcd_board_h+p2_h-lcd_connect_y*2)/2,-wall_width/2])
				cylinder(r=led_dia/2,h=wall_width*2,$fn=12);
			translate([led2_offset_x-(lcd_board_w)/2,led_offset_y-(lcd_board_h+p2_h-lcd_connect_y*2)/2,-wall_width/2])
				cylinder(r=led_dia/2,h=wall_width*2,$fn=12);
			translate([led3_offset_x-(lcd_board_w)/2,led_offset_y-(lcd_board_h+p2_h-lcd_connect_y*2)/2,-wall_width/2])
				cylinder(r=led_dia/2,h=wall_width*2,$fn=12);
			translate([bz_offset_x-(lcd_board_w)/2,bz_offset_y-(lcd_board_h+p2_h-lcd_connect_y*2)/2+3,-wall_width/2])
				buzzer_grid();
			//labels
			translate([reset_offset_x-(lcd_board_w)/2+1.5,reset_offset_y-(lcd_board_h+p2_h-lcd_connect_y*2)/2+7,-char_height+wall_width-layer_height*2])
				rotate([0,0,270])
						32bit_str("R", 1, char_block_size, char_height);
			translate([led1_offset_x-(lcd_board_w)/2-6,led_offset_y-(lcd_board_h+p2_h-lcd_connect_y*2)/2,-char_height+wall_width-layer_height*2])
				rotate([0,0,270])
						32bit_str("H", 1, char_block_size, char_height);
			translate([led2_offset_x-(lcd_board_w)/2-6,led_offset_y-(lcd_board_h+p2_h-lcd_connect_y*2)/2,-char_height+wall_width-layer_height*2])
				rotate([0,0,270])
						32bit_str("E", 1, char_block_size, char_height);
			translate([led3_offset_x-(lcd_board_w)/2-6,led_offset_y-(lcd_board_h+p2_h-lcd_connect_y*2)/2,-char_height+wall_width-layer_height*2])
				rotate([0,0,270])
						32bit_str("F", 1, char_block_size, char_height);
			}
			
		//mounting screw holes
		translate([0,-lug_dia/2,19])
			rotate([0,180,0])
				lcd_screw_holes(nut_trap=false,fn=8, dia=lcd_hole_d+0.2,extension_hole=true);
	}

}

module panelolu2_back() {
	back_t=p2_z+lcd_h_z+wall_width+1.6; //1.6 is the thickness of the LCD pcb excluding all the stuff at the back
	tabs_z=back_t-1.6-layer_height*2; //the LCD circuit board support tabs 
	difference() {
		union() {
			difference() {
				union(){
					//LCD board +P2 circuit board area 
					translate([0, 0, 0])
						roundedRect([lcd_board_w+wall_width,lcd_board_h+p2_h+wall_width-(2*lcd_connect_y),back_t], wall_width+1);
					//mounting lugs
					for(i=[1,-1]) {
					translate([i*((lcd_board_w-lug_dia-0.7)/2+wall_width),lcd_connect_y-(lcd_board_h+p2_h)/2-2*lug_dia/3,back_t/2])
						cylinder(r=(lug_dia+1.4)/2,h=back_t,$fn=12,center=true);
					translate([i*((lcd_board_w-lug_dia-0.7)/2+wall_width),lcd_connect_y-(lcd_board_h+p2_h)/2-lug_dia/6,back_t/2])
						cube([lug_dia+1.4,lug_dia, back_t], center=true);
					}
				}
				//lcd and Panelolu2 board cutouts
				translate([0,0,back_t/2+wall_width])
					cube([lcd_board_w,lcd_board_h+p2_h-2*lcd_connect_y, back_t], center=true);

				//SD cutout //
				translate([lcd_board_w/2-wall_width,SD_slot_offset_y-(lcd_board_h+p2_h-lcd_connect_y)/2,p2_z-SD_slot_z-0.1]) 
					cube([4*wall_width,SD_slot_h,SD_slot_z+wall_width]);
				
				//idc cutout
				translate([idc_offset_x-(lcd_board_w)/2,idc_offset_y-(lcd_board_h+p2_h-lcd_connect_y*2)/2,2*wall_width-idc_h_z/2])
					cube([idc_h_w,idc_h_h,idc_h_z]);
			}
			//LCD supports
			lcd_screw_support(tabs_z,18);
  			translate([0,(p2_h-lcd_board_h+wall_width+2)/2+lcd_connect_y,tabs_z/2])
				cube([lcd_board_w, wall_width, tabs_z], center=true);		
		}
		//cut outs for brightness and contrast holes
		translate([con_x-(lcd_board_w)/2,con_y-(lcd_board_h+p2_h-lcd_connect_y*2)/2,-wall_width/2])
			cylinder(r=cb_dia/2,h=wall_width*2,$fn=12);
		translate([bri_x-(lcd_board_w)/2,bri_y-(lcd_board_h+p2_h-lcd_connect_y*2)/2,-wall_width/2])
			cylinder(r=cb_dia/2,h=wall_width*2,$fn=12);
	    //labels for holes
		translate([con_x-(lcd_board_w)/2,con_y-(lcd_board_h+p2_h-lcd_connect_y*2)/2 +7,-char_height+wall_width-layer_height*2])
			rotate([0,0,90])
			mirror(1,0,0)
			32bit_str("C", 1, char_block_size, char_height);
		translate([bri_x-(lcd_board_w)/2-2,bri_y-(lcd_board_h+p2_h-lcd_connect_y*2)/2 +7,-char_height+wall_width-layer_height*2])
			rotate([0,0,90])
			mirror(1,0,0)
			32bit_str("B", 1, char_block_size, char_height);
		//label for IDC orientation
		translate([idc_offset_x-(lcd_board_w)/2+15,idc_offset_y-(lcd_board_h+p2_h-lcd_connect_y*2)/2+19,-char_height+wall_width-layer_height*2])
			//rotate([0,0,0])
			32bit_str("^", 1, char_block_size+0.1, char_height);
		//mounting screw holes
		translate([0,-lug_dia/2,19])
			rotate([0,180,0])
				lcd_screw_holes(nut_trap=true,fn=8, dia=lcd_hole_d+0.2,extension_hole=true);
	}

}

//back "U" shaped leg option. The Angle is what angle the screen should sit at 90 being vertical
//values between 20 and 80 are worth exploring
module leg_back(angle=45, standoff_height =9) {
 leg_t =standoff_height;
 leg_C = lcd_board_h+p2_h-lcd_connect_y*2+2*lug_dia/3;
 angle_A=90-angle;
 angle_B=90-angle_A;
 leg_A = sin(angle_A)*leg_C;
 leg_B = cos(angle_A)*leg_C;
	 difference() {
		translate([0,0,leg_A/2+lug_dia/2+wall_width*2]){
			rotate([-90-angle_B,0,0]) {
				difference() {
					union() {
					//all lined up with the LCD mounting holes
					//Top hole supports
					translate([((lcd_board_w/2)-lcd_hole_offset-clearance/2),(lcd_board_h+p2_h)/2,0])
						roundedRect([lug_dia-wall_width,lug_dia-wall_width,leg_t], wall_width+1);
					translate([-((lcd_board_w/2)-lcd_hole_offset-clearance/2),(lcd_board_h+p2_h)/2,0])
						roundedRect([lug_dia-wall_width,lug_dia-wall_width,leg_t], wall_width+1);
					//sides
					translate([((lcd_board_w/2)-lcd_hole_offset-clearance/2),(leg_A/2)*cos(angle_B)+(leg_B/2)*cos(angle_A),lug_dia/2])
						rotate([angle_B,0,0])
							roundedRect([lug_dia-wall_width,lug_dia-wall_width,leg_B], wall_width+1);
					translate([-((lcd_board_w/2)-lcd_hole_offset-clearance/2),(leg_A/2)*cos(angle_B)+(leg_B/2)*cos(angle_A),lug_dia/2])
						rotate([angle_B,0,0])
							roundedRect([lug_dia-wall_width,lug_dia-wall_width,leg_B], wall_width+1);
					//cross cylinders
					translate([0, -(lcd_connect_y-(lcd_board_h+p2_h)/2-lug_dia/3)-(leg_C*cos(angle_A)*cos(angle_A)),leg_C*cos(angle_A)*sin(angle_A)+leg_t/2])
						rotate([0,90,0])
						   cylinder(r=(lug_dia+wall_width)/2,lcd_board_w+wall_width*2,$fn=12,center=true);
					//cross leg
					translate([0, (lug_dia-0.7)/4-(lcd_connect_y-(lcd_board_h+p2_h)/2-lug_dia/3)-(leg_C*cos(angle_A)*cos(angle_A)),leg_C*cos(angle_A)*sin(angle_A)+leg_t/2+(lug_dia-3)/4])
						rotate([0,90,0])
							rotate([0,0,angle_B])
								cube([(lug_dia+1),(lug_dia+1)/2,lcd_board_w+wall_width*2], center=true);
					}
					//LCD screw holes to align legs to
					translate([0,0,-leg_t])
					lcd_screw_holes(nut_trap=true,fn=8, dia=lcd_hole_d+0.2,extension_hole=true);
				}
			}
		}
		//cube to ensure part prints flat
		translate([0,0,-5/2])
			cube([lcd_board_w+20,lcd_board_w+20,5], center=true);
	}				
}

//front standoffs to complement "U" shaped back legs
module front_standoff(standoff_height=9) {
leg_t =standoff_height;
//lugs
	difference() {
		union() {
		//((lcd_board_h+p2_h-2*lcd_connect_y)/2-lcd_hole_offset+lug_dia/2)
			translate([((lcd_board_w-lug_dia)/2+wall_width),lcd_connect_y-(lcd_board_h+p2_h)/2-lug_dia/2,leg_t/2])
				cylinder(r=(lug_dia+1.4)/2,h=leg_t,$fn=12,center=true);
			translate([((lcd_board_w-lug_dia)/2+wall_width),lcd_connect_y-(lcd_board_h+p2_h)/2-(lug_dia-1.4)/4,leg_t/2])
				cube([lug_dia+1.4,(lug_dia+1.4)/2, leg_t], center=true);
		}
		//LCD screw holes to align legs to
		translate([0,-lug_dia/4,-leg_t])
		lcd_screw_holes(nut_trap=true,fn=8, dia=lcd_hole_d+0.2,extension_hole=true);
	}
}

//triangle based leg option, currently interfere with IDC connection so need work
module leg_triangle(angle=45) {
 leg_t =9;
 leg_C = lcd_board_h+p2_h-lcd_connect_y*2+2*lug_dia/3;
 angle_A=angle;
 angle_B=90-angle_A;
 leg_A = sin(angle_A)*leg_C;
 leg_B = cos(angle_A)*leg_C;
	difference() {
		union() {
		//lugs
		translate([((lcd_board_w-lug_dia)/2+wall_width),lcd_connect_y-(lcd_board_h+p2_h)/2-2*lug_dia/3,leg_t/2])
			cylinder(r=(lug_dia+0.7)/2,h=leg_t,$fn=12,center=true);
		translate([((lcd_board_w-lug_dia)/2+wall_width),lcd_connect_y-(lcd_board_h+p2_h)/2-lug_dia/6,leg_t/2])
			cube([lug_dia+0.7,lug_dia, leg_t], center=true);
	    //Top hole supports
		translate([((lcd_board_w-lug_dia)/2+wall_width),(lcd_board_h+p2_h)/2,leg_t/2])
			cube([lug_dia+0.7,lug_dia, leg_t], center=true);
		//sides
		translate([((lcd_board_w-lug_dia)/2+wall_width),(leg_A/2)*cos(angle_B),(leg_A/2)*sin(angle_B)+lug_dia/2])
			rotate([angle_B,0,0])
				cube([lug_dia+0.7,lug_dia, leg_B], center=true);
		translate([((lcd_board_w-lug_dia)/2+wall_width), -(leg_B/2)*cos(angle_A),(leg_B/2)*sin(angle_A)+lug_dia/2])
			rotate([-angle_A,0,0])
				cube([lug_dia+0.7,lug_dia, leg_A], center=true);
		//smoothing cylinders
		//translate([((lcd_board_w-lug_dia)/2+wall_width), lcd_connect_y-(lcd_board_h+p2_h)/2-lug_dia/6,leg_t])
		//	rotate([0,90,0])
		//	   cylinder(r=(lug_dia+0.7)/2,h=lug_dia+0.7,$fn=12,center=true); //
		translate([((lcd_board_w-lug_dia)/2+wall_width), -(lcd_connect_y-(lcd_board_h+p2_h)/2-lug_dia/3)-(leg_C*cos(angle_A)*cos(angle_A)),leg_C*cos(angle_A)*sin(angle_A)+leg_t/2])
			rotate([0,90,0])
			   cylinder(r=(lug_dia+1)/2,h=lug_dia+0.7,$fn=12,center=true);
		}
	    translate([0.45,0,-leg_t])
	    //rotate([0,180,0])
		lcd_screw_holes(nut_trap=true,fn=8, dia=lcd_hole_d+0.2,extension_hole=true);
	}
}



module internal_assembly() {
	translate([0,0,p2_z+lcd_h_z])
		lcd();
	translate([-p2_w/2,-p2_h-lcd_board_h/2+2*lcd_h_offset_y,0])
		p2_board();
   //joining header
	translate([lcd_h_offset_x-(p2_w-lcd_h_w)/2,lcd_h_offset_y-(lcd_board_h)/2,p2_z+lcd_h_z/2])
		cube([lcd_h_w,lcd_h_h,lcd_h_z],center=true);
   //IDC header 
	translate([idc_offset_x-(lcd_board_w)/2,idc_offset_y-(lcd_board_h+p2_h+idc_h_h-lcd_connect_y*2)/2,-idc_h_z+wall_width])
		cube([idc_h_w,idc_h_h,idc_h_z]);
}

//grid for buzzer
module buzzer_grid() {
	gf =3; //gf = grid fractor is the ratio of grid material to space 2 = hslf, 3 = 1 third
	difference() {
		cylinder(r=(bz_dia)/2,h=wall_width*2,$fn=12);
		for (i=[-bz_dia/2:bz_dia/2]){
			translate([-bz_dia/2,round(i/gf)*gf,0])
				cube([bz_dia,1,wall_width*2]);
			translate([round(i/gf)*gf,-bz_dia/2,0])
				cube([1,bz_dia,wall_width*2]);
		/* //fancy grid - too fine to print
		for (i=[-bz_dia/2:bz_dia/2])
			for (j=[-bz_dia/2:bz_dia/2])
			translate([i,j,0])
			cylinder(r=0.65,h=wall_width*2,$fn=4);
			*/
		}
	}
}

//LCD screen
module lcd() {
	difference(){
		union(){
			translate([0,0,lcd_board_z/2])
				cube([lcd_board_w,lcd_board_h,lcd_board_z],center=true);
			translate([0,0,(lcd_scrn_z+lcd_board_z)/2])
				cube([lcd_scrn_w,lcd_scrn_h,lcd_scrn_z],center=true);
		}
		for(i=[-1,1]){			for(j=[-1,1]){
				translate([i*((lcd_board_w/2)-lcd_hole_offset),j*((lcd_board_h/2)-lcd_hole_offset),(lcd_board_z)/2])
					cylinder(r=lcd_hole_d/2,h=lcd_board_z+3,$fn=12,center=true);
			}
		}
	}
}

//Panelolu2 circuit board
module p2_board() {
	difference(){
		union(){
			translate([0,0,0])
			cube([p2_w,p2_h,p2_z]);
			//click encoder
			translate([click_encoder_offset_x,click_encoder_offset_y,p2_z+(click_encoder_z)/2])
				cube([click_encoder_w,click_encoder_h,click_encoder_z],center=true);
			translate([click_encoder_offset_x,click_encoder_offset_y,p2_z+click_encoder_z+(click_encoder_shaft_h)/2])
				cylinder(r=click_encoder_shaft_dia/2,h=click_encoder_shaft_h,center=true);
			//buzzer
			translate([bz_offset_x,bz_offset_y,p2_z+(4)/2])
				cylinder(r=bz_dia/2,h=4,center=true);
			//LEDS
			translate([led1_offset_x,led_offset_y,p2_z+(led_z)/2])
				cylinder(r=led_dia/2,h=led_z,center=true);
			translate([led2_offset_x,led_offset_y,p2_z+(led_z)/2])
				cylinder(r=led_dia/2,h=led_z,center=true);
			translate([led3_offset_x,led_offset_y,p2_z+(led_z)/2])
				cylinder(r=led_dia/2,h=led_z,center=true);
			//reset switch
			translate([reset_offset_x,reset_offset_y,p2_z+(reset_z)/2])
				cylinder(r=reset_dia/2,h=reset_z,center=true);
		}
		//mounting holes
		translate([p2_mounting_hole1_x,p2_mounting_hole_y,(p2_z+3)/2])
			cylinder(r=p2_mounting_hole_dia/2,h=p2_z+3,center=true);
		translate([p2_mounting_hole2_x,p2_mounting_hole_y,(p2_z+3)/2])
			cylinder(r=p2_mounting_hole_dia/2,h=p2_z+3,center=true);
	}
}

module lcd_screw_holes(nut_trap=false, fn=8, dia=lcd_hole_d,extension_hole=true) {
	for(i=[-1,1])
	for(j=[-1,1]){
		if (nut_trap) {
			translate([i*((lcd_board_w/2)-lcd_hole_offset-clearance/2),j*((lcd_board_h+p2_h-2*lcd_connect_y)/2-lcd_hole_offset+lug_dia/2),-15-layer_height])
				cylinder(r=dia/2, h=30, $fn=fn);
			translate([i*((lcd_board_w/2)-lcd_hole_offset-clearance/2),j*((lcd_board_h+p2_h-2*lcd_connect_y)/2-lcd_hole_offset+lug_dia/2),15])
				cylinder(r=m3_nut_diameter_bigger/2+layer_height*2, h=30, $fn=6);
		} else {
			translate([i*((lcd_board_w/2)-lcd_hole_offset-clearance/2),j*((lcd_board_h+p2_h-2*lcd_connect_y)/2-lcd_hole_offset+lug_dia/2),-15-layer_height])
				cylinder(r=dia/2, h=30, $fn=fn);
			//countersink holes
			translate([i*((lcd_board_w/2)-lcd_hole_offset-clearance/2),j*((lcd_board_h+p2_h-2*lcd_connect_y)/2-lcd_hole_offset+lug_dia/2),15])
			cylinder(r=m3_nut_diameter_bigger/2+layer_height*2, h=30, $fn=12);
		}
	}

}

module lcd_screw_support(thickness=2, fn=18) {
	for(i=[-1,1]) {
		translate([i*((lcd_board_w/2)-(lcd_hole_offset)-clearance/2),((lcd_board_h+p2_h-2*lcd_connect_y)/2-(lcd_hole_offset)),0])
			cylinder(r=lcd_hole_d/2+wall_width*1.8, h=thickness, $fn=fn);
	}

}


module roundedRect(size, radius) {
	x = size[0]; 
	y = size[1]; 
	z = size[2]; 
	
	radius_sharp=0.1;

	linear_extrude(height=z) 
	hull() { 
		// place 4 circles in the corners, with the given radius 
		translate([(-x/2)+(radius/2), (-y/2)+(radius/2), 0]) circle(r=radius); 
		translate([(x/2)-(radius/2), (-y/2)+(radius/2), 0]) circle(r=radius); 
		translate([(-x/2)+(radius/2), (y/2)-(radius/2), 0]) circle(r=radius); 
		translate([(x/2)-(radius/2), (y/2)-(radius/2), 0]) circle(r=radius); 
		translate([0,0,0]);
	} 
}

///////////////////////////////////////////////////////////////////////////////////////////
// The teardrop functions below are from "teardrop.scad" by nophead's Mendel90 design
//
// Mendel90
//
// GNU GPL v2
// nop.head@gmail.com
// hydraraptor.blogspot.com
//
// For making horizontal holes that don't need support material
// Small holes can get away without it but they print better with truncated teardrops
//
module teardrop_2D(r, truncate = true) {
    difference() {
        union() {
            circle(r = r, center = true);
            translate([0,r / sqrt(2),0])
                rotate([0,0,45])
                    square([r, r], center = true);
        }
        if(truncate)
            translate([0, r * 2, 0])
                square([2 * r, 2 * r], center = true);
    }
}

module teardrop(h, r, center, truncate = true)
    linear_extrude(height = h, convexity = 2, center = center)
        teardrop_2D(r, truncate);

module teardrop_plus(h, r, center, truncate = true)
    teardrop(h, r + layer_height / 4, center, truncate);


module tearslot(h, r, w, center)
    linear_extrude(height = h, convexity = 6, center = center)
        hull() {
            translate([-w/2,0,0]) teardrop_2D(r, true);
            translate([ w/2,0,0]) teardrop_2D(r, true);
        }

module vertical_tearslot(h, r, l, center = true)
    linear_extrude(height = h, convexity = 6, center = center)
        hull() {
            translate([0, l / 2]) teardrop_2D(r, true);
            translate([0, -l / 2, 0])
                circle(r = r, center = true);
        }

///////////////////////////////////////////////////////////////////////////////////////////////