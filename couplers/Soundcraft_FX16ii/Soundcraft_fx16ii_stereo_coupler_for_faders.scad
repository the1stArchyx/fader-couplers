//  Fader coupler – for coupling together individual channel faders of a stereo bus, or coupling together two mono channel faders to create a stereo channel pair.

//  I recommend making a "working copy" of the file for tinkering! See the license below if you're releasing any modified versions of your own.

//  Created by Lauri "Archyx" Lindholm in 2023 to solve a practical problem.
//  Released in 2023-05-29 under Creative Commons Attribution-ShareAlike 4.0 License.

//  https://creativecommons.org/licenses/by-sa/4.0/

//  The original default values provide a fit for Soundcraft fx16ii faders. There are two values for fader_distance to fit couplers on (narrower) bus faders and (wider) channel faders.

//  The two values below affect rendering quality in OpenSCAD. Refer to OpenSCAD manual if you wish to change them.
$fa = 3;
$fs = 0.25;

//  === source measurements =================================================

//  All source measurements are in millimeters.

//  fader knob size – these should be measured from the mixer's fader knobs accurately enough to make a snug fit but not too loose or tight!
fader_knob_width   = 11.4;
fader_knob_length  = 24.15;
fader_knob_height  = 10.3;  //  from the flat of the bottom to the highest points.
//  ^^^^^^^^^^^^^ This defines how deep the fader knob sinks into the coupler.

//  radius of a circle that makes the front/back curve of the fader knob – this was achieved experimentally. As long as there's enough room under the coupler to fit the fader knob, it'll be good.
fader_knob_fb_radius = 20;

//  radius of a circle that makes the dip for the finger on top of the fader knob – another experimental value. Once again, it doesn't matter if there's a little bit too much room left.
fader_knob_dip_radius = 12.2;
//  the depth of the dip – this is a rough measurement. As long as the coupler's dip is shallower than the actual fader knob, the knob can evenly bottom out under the coupler.
fader_knob_dip_depth  = 2.8;

//  space around fader knobs, ie. maximum allowed distance from the fader knob to avoid collisions to other controls
space_around       = 0.7;


////  fader distance between left and right bus faders:
////  (width of steel between fader cutouts + the width of _one_ fader track cutout)
//fader_distance     = 10.7 + 3.2;
////space_under        = 3.7 + 0.3;  // this gap is optional for the bus faders


//  fader distance between channel faders:
fader_distance     = 18.35 + 3.2;
//  height of buttons or other controls between faders, measured from face plate (can be left undefined if not needed):
space_under        = 3.7 + 0.3;  // max. height of buttons + additional tolerance

//  === end of source measurements ==========================================

//  The outer dimensions of a shell that fits over a _single_ fader knob. These may need to be modified if the target mixer dimensions are wildly different compared to the unit the couplers were originally developed for.

coupler_width = fader_knob_width + (2 * space_around);
coupler_length = fader_knob_length + (2 * space_around);
coupler_height = fader_knob_height + 1.5;


module fader_knob (fWidth, fLength, fHeight, fRadius, fDipRadius, fDipDepth) {
//  An approximation of a fader knob for the outside shape and the cavity inside the coupler
    difference() {
        intersection() {
            cube([fWidth, fLength, fHeight], center = true);
            translate([0, (fRadius - 1.1 * fLength), (fHeight - fRadius + PI / 2)])
                rotate([0, 90, 0])
                    cylinder(h = fWidth, r = fRadius, center = true);
            translate([0, (1.1 * fLength - fRadius), (fHeight - fRadius + PI / 2)])
                rotate([0, 90, 0])
                    cylinder(h = fWidth, r = fRadius, center = true);
        }
        translate([0, 0, (fDipRadius + fHeight / 2) - fDipDepth])
            rotate([0, 90, 0])
                cylinder(h = fWidth + 0.001, r = fDipRadius, center = true);
    }
 }

//  the main thing
difference() {
    union() {
        //  The fader coupler basic shape, this is basically a slightly upscaled and wider version of the fader knob.
        translate([0, 0, coupler_height / 2])
            resize([fader_distance + coupler_width, coupler_length, coupler_height])
                fader_knob(fader_knob_width, fader_knob_length, fader_knob_height, fader_knob_fb_radius, fader_knob_dip_radius, fader_knob_dip_depth);
        //  fader reference line in the middle with 0.5 mm protrusion
        translate([0, 0, (coupler_height - fader_knob_dip_depth) / 2])
            cube([fader_distance + coupler_width + 0.5, 0.5, coupler_height - fader_knob_dip_depth], center = true);
    }
    
    translate([0, 0, -0.001]) {  //  the hollow things on the underside
    //  left fader
    translate([-(fader_distance / 2), 0, fader_knob_height / 2])
        fader_knob(fader_knob_width, fader_knob_length, fader_knob_height, fader_knob_fb_radius, fader_knob_dip_radius, fader_knob_dip_depth);
    //  right fader
    translate([(fader_distance / 2), 0, fader_knob_height / 2])
        fader_knob(fader_knob_width, fader_knob_length, fader_knob_height, fader_knob_fb_radius, fader_knob_dip_radius, fader_knob_dip_depth);
    //  bridge over buttons, ignored if space_under is not defined
    if (!is_undef(space_under))
        translate([0, 0, space_under / 2 - 0.001])
            cube([fader_distance - fader_knob_width - 2 * space_around, coupler_length + 0.001, space_under], center = true);
    }
}

//  Uncomment the rest of the script to render the fader knob objects used to subtract the space under the coupler to fit the couplers onto the mixer fader knobs, for visual reference next to the coupler. There is no reason to include them in the final printed object!

////  the fader equivalents
//translate([0, 30, 0]) {
//    //  left fader
//    translate([-(fader_distance / 2), 0, fader_knob_height / 2])
//        fader_knob(fader_knob_width, fader_knob_length, fader_knob_height, fader_knob_fb_radius, fader_knob_dip_radius, fader_knob_dip_depth);
//    //  right fader
//    translate([(fader_distance / 2), 0, fader_knob_height / 2])
//        fader_knob(fader_knob_width, fader_knob_length, fader_knob_height, fader_knob_fb_radius, fader_knob_dip_radius, fader_knob_dip_depth);
//}