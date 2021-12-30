#!/usr/bin/perl

$debugem = undef;

# $debugem = 1;

# This is SignSynth, a program for synthesizing American Sign Language
# Copyright (C) 1997 Angus B. Grieve-Smith
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or (at
# your option) any later version.
# 
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307,
# USA.
# 
# If you have any questions, please contact Angus B. Grieve-Smith,
# Linguistics Department, Humanities 526, University of New Mexico,
# Albuquerque, NM 87131, or by email at grvsmth@unm.edu
# 

push(@INC, '.');
require('httputil.pl');
require('signutil.pl');
require('ascsto2.pl');

$mimehtml = "Content-Type: text/html\n\n";

$mimevrml = "Content-Type: x-world/x-vrml\n\n";

if ($debugem) { print $mimehtml, "<pre>";}

push(@relinterval,1);

#
# Get CGI query
#
%blah = HTTPgetquery();
@blah_order = @formlist_order;

if ($blah{spelltext}) {$blah{length} = (length($blah{spelltext})+2)}

if ($blah{humanoid}) { $vrmlfile = $blah{humanoid} . ".wrl" }
	else { $vrmlfile = "genny3.wrl" }

if ($vrmlfile =~ /genny/) {$newdefaults = "G1"} else {$newdefaults = "2";}

getsto();

$length = $blah{length};

unless ($length) {$length = 2}

$finallength = $length;

if ($blah{astext}) {$finallength = astext()}

if ($blah{speed}) {$speed = ($finallength/$blah{speed})} else {$speed = ($finallength * 1.5)}

getdeefaults ();

if ($blah{spelltext}) {$finallength = fingerspell()} else {
    cnvstorot()
}

foreach $httpkey (@default_order) {
# 	print ($httpkey, $blah{$httpkey}, $default {$httpkey}, "\n");
	if ($blah {$httpkey} eq "") {
		$blah {$httpkey} = $default {$httpkey}
	}
#	$ugh .= $httpkey . $blah{$httpkey} . $default {$httpkey};
# 	print ($httpkey, $blah{$httpkey}, $default {$httpkey}, "\n");
}



# $vrmlfile = "bimos_001_ws.wrl";

$vrml = ();
open (VRML, $vrmlfile) || print $mimehtml, "Can't open $vrmlfile\n";
while (<VRML>) { $vrml .= $_ }
close(VRML) || print $mimehtml, "Can't close $vrmlfile\n";

$times = "0, ";

# $intfactor = (1 / ($finallength + 5));

foreach $i (1 .. scalar @relinterval) {
    $reallength += $relinterval[$i];
    $reallength += $holds[$i];
}

$avginterval = ($reallength / $finallength);

$intfactor = (1/($reallength));

$holdtime = (.5 * $intfactor);

$clock = ($relinterval[0] * 1.5 * $intfactor);

if ($debugem) { print "\$length is $length; \$finallength is $finallength; \$intfactor is $intfactor.<P>.";}

if ($debugem) {
  foreach $i ( 0 .. scalar @relinterval) {
    print ">..\$relinterval[$i] is $relinterval[$i]<br>";
  }
}

foreach $instance (1 .. ($finallength)) {
  $thisinterval = ($relinterval[$instance] * $intfactor);
  if ($debugem) {print "\$relinterval[$instance] is $relinterval[$instance]; \$thisinterval is $thisinterval<P>";}
  $clock = $clock2 + $thisinterval;
  $clock2 = ($clock + ($holds[$instance]*$intfactor));
  if ($debugem) {print "\$clock is $clock<br>\$clock2 is $clock2<P>";}
  $times .= "$clock, $clock2, \n";
}

$lasttime = ($clock2 + ($intfactor));
if ($debugem) {print "\$lastttime is $lasttime<P>";}

$times .= "$lasttime";

foreach $joint (@jointlist_order) {
#  print "\% $joint is ", %$joint, "<br>";
  $animvalue = ();
  foreach $time (1 .. ($finallength)) {
      if ($debugem) {print "\$ $joint {$time} is ${$joint}{$time}<br>";}
    $animvalue .= ${$joint}{$time} . ", " . ${$joint}{$time};
    unless ($time eq $finallength) {$animvalue .= ",\n "}
  }
  if (substr($joint,0,3) eq "lef") {
    $interpo = uc(substr($joint,0,1)) . substr($joint,1)
  } else {
    $interpo = uc(substr($joint,0,2)) . substr($joint,2)
  }

  if ($joint =~ /eyebrow|lid|line|lips/ ) { 
      $interptype = "CoordinateInterpolator"
  } elsif ($joint =~ /tongue/) {$interptype = "PositionInterpolator"
  } else { $interptype = "OrientationInterpolator" }

  $interp{$joint} = qq#
DEF $interpo $interptype {
  key [ $times ]
  keyValue [
    $default{$joint}, $animvalue, $default{$joint}
  ]
}

#;
  $animations .= $interp{$joint};
}

$timesensor = qq#
DEF TS TimeSensor {
	\# startTime 0
	cycleInterval $speed
	stopTime 10
	\# loop TRUE
}

#;


$routes = qq#
ROUTE hanim_BodyTouch.touchTime TO TS.set_startTime
ROUTE TS.fraction_changed TO RShoulder.set_fraction
ROUTE TS.fraction_changed TO RWrist.set_fraction
ROUTE TS.fraction_changed TO RElbow.set_fraction
ROUTE TS.fraction_changed TO RThumb1k.set_fraction
ROUTE TS.fraction_changed TO RThumb2k.set_fraction
ROUTE TS.fraction_changed TO RThumb3k.set_fraction
ROUTE TS.fraction_changed TO RIndex1k.set_fraction
ROUTE TS.fraction_changed TO RIndex2k.set_fraction
ROUTE TS.fraction_changed TO RIndex3k.set_fraction
ROUTE TS.fraction_changed TO RMiddle1k.set_fraction
ROUTE TS.fraction_changed TO RMiddle2k.set_fraction
ROUTE TS.fraction_changed TO RMiddle3k.set_fraction
ROUTE TS.fraction_changed TO RRing1k.set_fraction
ROUTE TS.fraction_changed TO RRing2k.set_fraction
ROUTE TS.fraction_changed TO RRing3k.set_fraction
ROUTE TS.fraction_changed TO RPinky1k.set_fraction
ROUTE TS.fraction_changed TO RPinky2k.set_fraction
ROUTE TS.fraction_changed TO RPinky3k.set_fraction
ROUTE TS.fraction_changed TO LShoulder.set_fraction
ROUTE TS.fraction_changed TO LWrist.set_fraction
ROUTE TS.fraction_changed TO LElbow.set_fraction
ROUTE TS.fraction_changed TO Lefthumb1k.set_fraction
ROUTE TS.fraction_changed TO Lefthumb2k.set_fraction
ROUTE TS.fraction_changed TO Lefthumb3k.set_fraction
ROUTE TS.fraction_changed TO LIndex1k.set_fraction
ROUTE TS.fraction_changed TO LIndex2k.set_fraction
ROUTE TS.fraction_changed TO LIndex3k.set_fraction
ROUTE TS.fraction_changed TO LMiddle1k.set_fraction
ROUTE TS.fraction_changed TO LMiddle2k.set_fraction
ROUTE TS.fraction_changed TO LMiddle3k.set_fraction
ROUTE TS.fraction_changed TO LRing1k.set_fraction
ROUTE TS.fraction_changed TO LRing2k.set_fraction
ROUTE TS.fraction_changed TO LRing3k.set_fraction
ROUTE TS.fraction_changed TO LPinky1k.set_fraction
ROUTE TS.fraction_changed TO LPinky2k.set_fraction
ROUTE TS.fraction_changed TO LPinky3k.set_fraction

ROUTE RWrist.value_changed TO hanim_r_wrist.set_rotation
ROUTE RThumb1k.value_changed TO hanim_r_thumb1.set_rotation
ROUTE RThumb2k.value_changed TO hanim_r_thumb2.set_rotation
ROUTE RThumb3k.value_changed TO hanim_r_thumb3.set_rotation
ROUTE RIndex1k.value_changed TO hanim_r_index1.set_rotation
ROUTE RIndex2k.value_changed TO hanim_r_index2.set_rotation
ROUTE RIndex3k.value_changed TO hanim_r_index3.set_rotation
ROUTE RMiddle1k.value_changed TO hanim_r_middle1.set_rotation
ROUTE RMiddle2k.value_changed TO hanim_r_middle2.set_rotation
ROUTE RMiddle3k.value_changed TO hanim_r_middle3.set_rotation
ROUTE RRing1k.value_changed TO hanim_r_ring1.set_rotation
ROUTE RRing2k.value_changed TO hanim_r_ring2.set_rotation
ROUTE RRing3k.value_changed TO hanim_r_ring3.set_rotation
ROUTE RPinky1k.value_changed TO hanim_r_pinky1.set_rotation
ROUTE RPinky2k.value_changed TO hanim_r_pinky2.set_rotation
ROUTE RPinky3k.value_changed TO hanim_r_pinky3.set_rotation
ROUTE RShoulder.value_changed TO hanim_r_shoulder.set_rotation
ROUTE RElbow.value_changed TO hanim_r_elbow.set_rotation

ROUTE LWrist.value_changed TO hanim_l_wrist.set_rotation
ROUTE Lefthumb1k.value_changed TO hanim_l_thumb1.set_rotation
ROUTE Lefthumb2k.value_changed TO hanim_l_thumb2.set_rotation
ROUTE Lefthumb3k.value_changed TO hanim_l_thumb3.set_rotation
ROUTE LIndex1k.value_changed TO hanim_l_index1.set_rotation
ROUTE LIndex2k.value_changed TO hanim_l_index2.set_rotation
ROUTE LIndex3k.value_changed TO hanim_l_index3.set_rotation
ROUTE LMiddle1k.value_changed TO hanim_l_middle1.set_rotation
ROUTE LMiddle2k.value_changed TO hanim_l_middle2.set_rotation
ROUTE LMiddle3k.value_changed TO hanim_l_middle3.set_rotation
ROUTE LRing1k.value_changed TO hanim_l_ring1.set_rotation
ROUTE LRing2k.value_changed TO hanim_l_ring2.set_rotation
ROUTE LRing3k.value_changed TO hanim_l_ring3.set_rotation
ROUTE LPinky1k.value_changed TO hanim_l_pinky1.set_rotation
ROUTE LPinky2k.value_changed TO hanim_l_pinky2.set_rotation
ROUTE LPinky3k.value_changed TO hanim_l_pinky3.set_rotation
ROUTE LShoulder.value_changed TO hanim_l_shoulder.set_rotation
ROUTE LElbow.value_changed TO hanim_l_elbow.set_rotation
#;

if (($vrmlfile eq "sarah1.wrl") or ($vrmlfile eq "genny3.wrl")) { 

    $faceroutes = qq#
ROUTE TS.fraction_changed TO REye.set_fraction
ROUTE TS.fraction_changed TO LEye.set_fraction
ROUTE TS.fraction_changed TO LEyebrow.set_fraction
ROUTE TS.fraction_changed TO LEyebrowwrinkle.set_fraction
ROUTE TS.fraction_changed TO REyebrow.set_fraction
ROUTE TS.fraction_changed TO REyebrowwrinkle.set_fraction
ROUTE TS.fraction_changed TO RToplid.set_fraction
ROUTE TS.fraction_changed TO RTopeyeline.set_fraction
ROUTE TS.fraction_changed TO RBottomlid.set_fraction
ROUTE TS.fraction_changed TO RBottomeyeline.set_fraction
ROUTE TS.fraction_changed TO LToplid.set_fraction
ROUTE TS.fraction_changed TO LTopeyeline.set_fraction
ROUTE TS.fraction_changed TO LBottomlid.set_fraction
ROUTE TS.fraction_changed TO LBottomeyeline.set_fraction
ROUTE TS.fraction_changed TO MLips.set_fraction
ROUTE TS.fraction_changed TO MOlips.set_fraction
ROUTE TS.fraction_changed TO MTongue.set_fraction
ROUTE TS.fraction_changed TO MSkull.set_fraction
ROUTE TS.fraction_changed TO MNeck.set_fraction
ROUTE TS.fraction_changed TO MTorso.set_fraction

ROUTE REye.value_changed TO hanim_r_eyeball.set_rotation
ROUTE REyebrow.value_changed TO c_reyebrow.set_point
ROUTE REyebrowwrinkle.value_changed TO c_rbrowwrinkle.set_point
ROUTE LEye.value_changed TO hanim_l_eyeball.set_rotation
ROUTE LEyebrowwrinkle.value_changed TO c_lbrowwrinkle.set_point
ROUTE LEyebrow.value_changed TO c_leyebrow.set_point
ROUTE RToplid.value_changed TO c_rtoplid.set_point
ROUTE RTopeyeline.value_changed TO c_rtopeyeline.set_point
ROUTE RBottomlid.value_changed TO c_rbottomlid.set_point
ROUTE RBottomeyeline.value_changed TO c_rbottomeyeline.set_point
ROUTE LToplid.value_changed TO c_ltoplid.set_point
ROUTE LTopeyeline.value_changed TO c_ltopeyeline.set_point
ROUTE LBottomlid.value_changed TO c_lbottomlid.set_point
ROUTE LBottomeyeline.value_changed TO c_lbottomeyeline.set_point
ROUTE MLips.value_changed TO c_lips.set_point
ROUTE MOlips.value_changed TO c_olips.set_point
ROUTE MTongue.value_changed TO hanim_r_tongue.set_translation
ROUTE MSkull.value_changed TO hanim_skullbase.set_rotation
ROUTE MNeck.value_changed TO hanim_vc1.set_rotation
ROUTE MTorso.value_changed TO hanim_vc7.set_rotation
#;
}
    if ($blah{vrml} eq "no") { print $mimehtml, "<pre>" };

print $mimevrml, $vrml, $timesensor, $animations, $routes, $faceroutes;

# print %blah;

exit;

