#!/usr/local/gnu/bin/perl

# This is ASC-Sto2, the subroutine that converts ASCII-Stokoe into
# rotation specs directly.
#
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
 

if ($debugem) { print "Content-Type: text/html\n\n<h1>Welcome to ASCII-Sto 2</h1>";}

1;

sub getsto {
    my $ascstofile = "ascsto.txt";
    unless(open (ASCSTO, $ascstofile)) {
            print "Content-Type: text/plain\n\nCouldn't open $ascstofile: $!\n";
            return;
        }

        while ($keyas = <ASCSTO>) {
	  chomp ($keyas);
	  if (substr ($keyas, 0, 1) eq "\$"){ 
	    $jptemp = (substr ($keyas, 1));
	    if ($debugem eq 2) {print "\$jptemp is $jptemp\n";}
	    if (substr($keyas, 1, 1) eq "r" | substr($keyas,1,1) eq "l" | substr($keyas,1,1) eq "m") {
	      unless ($jptemp eq "l") { push (@jointlist_order, $jptemp) }
	    } else { 
		push (@prime_order, $jptemp);
		if ($debugem eq 2) {print "Adding $jptemp to \@prime_order<br>";}
	    }
	  } else {
	    ($astemp, $dummyvar) = split ('=', $keyas);
	    if ((substr($astemp,0,1) eq "G") && ($astemp ne "G")) {
	      if ($vrmlfile =~ /genny/) {
		$realastemp = substr($astemp,1);
		if ($debugem eq 2) {
		  print "<P>Changing \${$jptemp}{$realastemp} to $dummyvar\n";
		}
		${$jptemp}{$realastemp} = $dummyvar;
		push (@$jptemp,$realastemp);
	      } else {next}
	    }
		
	    ${$jptemp}{$astemp} = $dummyvar;
	    if ($debugem eq 2) {print "$jptemp {$astemp} = $dummyvar <br>";}
	    push (@$jptemp,$astemp);

            #  We can recycle rotation specs, e.g.

	    if ( substr (${$jptemp}{$astemp}, 0, 1) eq "u") { 
	      ${$jptemp}{$astemp} = ${$jptemp}{substr(${$jptemp}{$astemp},1)}
            }
          }
        }
        close (ASCSTO);
#	print "Leaving getsto(); \$rthumb1k{C} is $rthumb1k{C}<P>";
#	foreach $ii (keys %rthumb1k) { print "$ii," }

# Here I'm just going to set up the hashes for time stuff

%tm = ( "p" => .05 , "t" => .11, "c" => 1, "k" => 1.33, "q" => 1.67);

%th = ("m" => .15, "n" => .5, "g" => .75, "h" => 1);

if ($debugem) {print "\$tm{p} is $tm{p}<P>";}



}

sub cnvstorot {

if ($debugem) {
  foreach $blahkey (@formlist_order) {
    print "...$blahkey $blah{$blahkey}<P>\n";
  }
}

    $handedness = substr($blah{handed},0,1);
    foreach $time4 (1 .. ($finallength+1)) {

#      unless ($blah{astext}) {push @relinterval, 1;}

#      if ($time4 eq $finallength+1) {push @relinterval, 1}

      if ($debugem) {print "\$time4 is $time4<br>";}

#     make a list of the parameters for this time

      foreach $postin (@formlist_order) {
	if ($postin !~ /[hlmoXY]/) {next}
	if (substr($postin,2) eq $time4) {
	  $postsdummy = "posts$time4";
	  push (@{$postsdummy}, $postin);
        }
      }

#     look in each parameter

      foreach $cnvkey (@{$postsdummy}) {
#	print "\$cnvkey is $cnvkey\n";
	$param1 = substr($cnvkey,1,1);
	foreach $joint3 (keys(%{$param1})) {

#	  create the joint names from the lists for each param

	  if ((substr($cnvkey,0,1)) eq "d") { $joint2 = $handedness . $joint3 }
	  if ((substr($cnvkey,0,1)) eq "n") {
	    if ($handedness eq "l") { $joint2 = "r" . $joint3 }
	    else { $joint2 = "l" . $joint3 }
	  }

	  if (((substr($cnvkey,0,1)) =~ /[XY]/) and (($joint3 =~ /lips|tongue|skull|neck|torso/))) { $joint2 = "m" . $joint3 }

	  if (((substr($cnvkey,0,1)) eq "X") and (($joint3 =~ /eye|lid|line/))) { $joint2 = "l" . $joint3}
	  
	  if (substr($joint2,0,6) eq "lthumb") { $joint2 = "lef" . $joint3 }

#	  get the value for this joint as specified in the form
	  $joint5 = ${$joint2}{$blah{$cnvkey}};

#	  if this value exists, then assign it to the joint's hash

	  if ($joint5) { ${$joint2}{$time4} = $joint5 }
	  if ($debugem) {print $joint2, "{$time4}($blah{$cnvkey})=", $joint5, ",", ${$joint2}{$time4}, "\n";}

#	repeat this stuff for the other side of the face.
	  if (((substr($cnvkey,0,1)) eq "X") && (($joint3 =~ /eye|lid|line/))) {
	    $joint2 = "r" . $joint3;
	    $joint5 = ${$joint2}{$blah{$cnvkey}};
	    if (joint5) { ${$joint2}{$time4} = $joint5 }
#	    print "Facial: setting $joint2 {$time4} to $joint5\n";
	  }

	}
      }
      if ($debugem) {print "\$relbow {$time4} is $relbow{$time4}\n";}
      foreach $jointkey (@jointlist_order) {
	unless (${$jointkey}{$time4}) {
	  ${$jointkey}{$time4} = $default{$jointkey};
 	  if ($debugem) { 
	  print "setting $jointkey {$time4} to default $default{$jointkey}\n";
	  }
	}
      }
      if ($debugem) {print "\$relbow {$time4} is $relbow{$time4}\n";}
      $tmvar = "Tm" . $time4;
      $thvar = "Th" . $time4;
      if ($blah{$tmvar}) {
        push (@relinterval,$tm{$blah{$tmvar}});
        if ($debugem) { print "Now adding $tm{$blah{$tmvar}} to \@relinterval<P>";}
      } else {
        push(@relinterval,1);
        if ($debugem) { print "\$blah{$tmvar} was empty.  Now adding 1 to \@relinterval<P>";}
      }
      if ($blah{$thvar}) {
        push (@holds,$th{$blah{$thvar}});
        if ($debugem) { print "Now adding $th{$blah{$tmvar}} to \@holds<P>";}
      } else {
        push(@holds,1);
        if ($debugem) { print "\$blah{$thvar} was empty.  Now adding 1 to \@holds<P>";}
      }
    }

}

sub fingerspell {

    my $offset = 1;
    my $suspend = 0;
    $handedness = substr($blah{handed},0,1);
    $spelltext = (substr($blah{spelltext},0,1)) . ($blah{spelltext});
    $spelltext .= substr($spelltext,-1);

#    $spelltext = uc($cspelltext);

    push @relinterval, 1; #add one mora for the first letter

    @spelltext = split //, $spelltext;

    $lookuplength = length($spelltext); #number of letters

    my $timelookup = 1; #letter counter

    until ($timelookup eq ($lookuplength+1)) {

	my $oldletter = 0;

	if ($suspend) { $letter{$timelookup}=$suspend } else {
	  $letter{$timelookup} = $spelltext[($timelookup-$offset)] }

	if ($letter{$timelookup} !~ /\w/ ) { $letter{$timelookup} = $letter{($timelookup-1)}}


	if ($letter{$timelookup} =~ /[A-Z]/) {
	    lookatthehand($timelookup)
	} else {
	    $leye{$timelookup} = $reye{$timelookup} = $reye{f} }

	$ucletter{$timelookup} = uc($letter{$timelookup});

#	print "\$letter{$timelookup} is $letter{$timelookup}<br>";

#	substitute handshapes that are not in the Stokoe set

	@keysfshand = keys(%fshand);
	$keysfshand = "[@keysfshand]";
	$keysfshand =~ s/ //g;
# $re = '(' . join('|', map(quotemeta($_), @stuff)) . ')';

        $oldletter = $ucletter{$timelookup};

        if (exists ($fshand{$ucletter{$timelookup} }) ) {
	  $ucletter{$timelookup} = $fshand{$ucletter{$timelookup}}
	}

#     look in each parameter

	foreach $joint (keys(%h)) {

#	create the joint names from the lists for each param

          $handedjoint = $handedness . $joint; #specify which hand

	  if (substr($handedjoint,0,6) eq "lthumb") { $handedjoint = "lef" . $joint }

#	  get the value for this joint as specified in the form

	  $jointvalue = ${$handedjoint}{$ucletter{$timelookup}};

#	  if this value exists, then assign it to the handedjoint's hash

	  if (defined($jointvalue)) { ${$handedjoint}{$timelookup} = $jointvalue }

        }

#	now put the fingerspelling location in for all the locations

	$joint = $jointvalue = $handedjoint = 0;

	foreach $joint (keys(%l)) {
	  $handedjoint = $handedness . $joint;
	  $jointvalue = ${$handedjoint}{Q};
	  if (defined($jointvalue)) {
	    ${$handedjoint}{$timelookup} = $jointvalue
	  }
	}

	my $ugga = ($timelookup - $offset);
	if ((($ugga) ne 1)&&($timelookup - $offset ne (length($spelltext))-1)) {
	  if ($spelltext[($timelookup-$offset)] eq $spelltext[(($timelookup-$offset)-1)]) {
	    if ($handedness eq "r") {
	      $relbow{$timelookup} = "1 .05 0 -1.57";
	    } else {
	      $lelbow{$timelookup} = "1 -.05 0 -1.57"
	    }
	  }
	}

#	set wrist to display rotation

	$whichwrist = $handedness . "wrist";
	${$whichwrist}{$timelookup} = ${$whichwrist}{f};


#	wrist wrotation substitution

#	@keysfswrist = keys(%fswrist);
#	$keysfswrist = "[@keysfswrist]";
#	$keysfswrist =~ s/ //g;

#	print "Oldletter is $oldletter; fswrist is $fswrist{$oldletter}.\n";

	if (exists($fswrist{$oldletter})) {${$whichwrist}{$timelookup} = ${$whichwrist}{$fswrist{$oldletter}}}

	if ($oldletter !~ /\w/) {${$whichwrist}{$timelookup} = ${$whichwrist}{rest}}

#       fill the rest up with defaults

        foreach $jointkey (@jointlist_order) {
	  unless (${$jointkey}{$timelookup}) {
	    ${$jointkey}{$timelookup} = $default{$jointkey}
	  }
#	  print "\$ $jointkey {$timelookup} is ${$jointkey}{$timelookup}\n";
        }

#timing for J/Z

	if ($oldletter eq "J") {
	  ++$lookuplength; ++$offset; $suspend = "J2";
	  push @relinterval, .8
	}
	if ($oldletter eq "J2") { $suspend = 0; push @relinterval, .8 }

	if ($oldletter eq "Z") {
	  ++$lookuplength; ++$offset; $suspend = "Z2";
	  push @relinterval, .8 }
	if ($oldletter eq "Z2") {
	  ++$lookuplength; ++$offset; $suspend = "Z3";
	  push @relinterval, .8 }
	if ($oldletter eq "Z3") {
	  ++$lookuplength; ++$offset; $suspend = "Z4";
	  push @relinterval, .8 }
	if ($oldletter eq "Z4") { $suspend = ();
	  push @relinterval, .8 }

	unless (substr($oldletter,0,1) =~ /[JZ]/) {
	  push @relinterval, 1;
#	  $testlength = @relinterval;
#	  print "\$relinterval is now $testlength long<br>"
	}

	++$timelookup
      }

      my $finallength = (@relinterval-2);
      return $finallength;

}



sub astext {

  my $varname = my $length = my $shape = my $loc = my $mov = "";
  my @hsinfo = ();

  $lastwd = "none";

  $astext = $blah{astext};

# split the text into signs

  @sign = split(/[ \|]/, $astext);

  $astext =~ s/\</&lt/g;
  $astext =~ s/\>/&gt/g;
#  print "<P>Your submission was $astext<P>\n";

# grab the length

  $blah{length} = (scalar @sign);
  $length = $blah{length} -1;

#now analyze each sign

  foreach $num (0 .. $length) {
    if ($debugem) {
	my $snum = $sign[$num];
	$snum =~ s/\</&lt/go;
	print "Working on sign $num: $snum <P>\n";
    }

    if ($sign[$num] !~ /\//) {
	if ($debugem) {print "Calling facials()<P>";}
	facials($sign[$num],$snum);
	$lastfacial = $sign[$num];
	next;
    }   

# otherwise we check to see if the last one was also ascii-stokoe;
# if it was, we do the facials for the last one.

    if ($debugem) {print "\$lastwd is $lastwd DD<P>";}

    if ($lastwd eq "ascsto") {
      facials($lastfacial, $snum);
    }



    $snum++;

#    $snum = $num+1;
    @ast = split ("/",$sign[$num]);
    unless (defined $ast[2]) {
      if ($ast[1] =~ /[A-PR-Z]/) {
        ($shape,$mov) = @ast;
      } else {
	($loc,$shape) = @ast;
      }
    } else {
      ($loc,$shape,$mov) = @ast;
    }
    if ($debugem) {
      print "<ul><li>\$loc is $loc<li>\$shape is $shape<li>\$mov is $mov</ul>\n";
    }

    $loc1 = substr($loc,0,1);
    if ($debugem) {
      print "\$loc1 is $loc1; \$rthumb1k{$loc1} is $rthumb1k{$loc1}<P>\n";
    }
    if (exists($rthumb1k{$loc1})) {
#      This is a base handshape.
      @hsinfo = ashs($loc, $num, "non-dominant");
      $varname = "nh" . $snum; $blah{$varname} = $hsinfo[0];
      push (@formlist_order,$varname);
      if ($debugem) {print "Now adding $varname to \@formlist_order<P>\n";}
      $varname = "no" . $snum; $blah{$varname} = $hsinfo[4];
      push (@formlist_order,$varname);
      if ($hsinfo[1] eq "\'") {
        $varname = "nl" . $snum; $blah{$varname} = "side";
        push (@formlist_order,$varname);
      } else {
        $varname = "nl" . $snum; $blah{$varname} = "below";
        push (@formlist_order,$varname);
      }
      $varname = "dl" . $snum; $blah{$varname} = "as";
      push (@formlist_order,$varname);
    } else {
      $varname = "dl" . $snum; $blah{$varname} = $loc;
      push (@formlist_order,$varname);
    }
    @hsinfo = ashs($shape, $num, "dominant");
#    print "<ul>";
#    foreach $hinf (0 .. scalar @hsinfo) {
#	print "<li>$hinf $hsinfo[$hinf]";
#    }
#    print "</ul>";
    $varname = "dh" . $snum; $blah{$varname} = $hsinfo[0];
    if ($debugem) {print "Now adding $varname to \@formlist_order<P>";}
    push (@formlist_order,$varname);
    $varname = "do" . $snum; $blah{$varname} = $hsinfo[4];
    if ($debugem) {print "The dominant orientation is $hsinfo[4]<P>";}
    push (@formlist_order,$varname);

#    push (@relinterval,1);

    $lastwd = "ascsto";

  }

  if ($lastwd eq "ascsto") {
    facials($lastfacial, $snum);
  }

  return ($snum);

}

sub ashs {
  my $hs = $_[0];
  my $num = $_[1];
  my $handed = $_[2];
  $hshape = substr($hs,0,1);
  if (($hshape =~ /[BLY]/) && (substr($hs,1,1) =~ /[538]/)) {
    $hshape .= substr($hs,1,1);
    my $flah = 1;
  }
#  print "<ul><li>The $handed hs for sign number $num is $hshape";
  foreach $l (1 .. length($hs)-1) {
    if ($flah eq 1) {$flah = undef; next; }
    $char = substr($hs,$l,1);
    if (($char eq "\`" )||($char eq "\"")) {
      my $hsdiacrit = $char;
#      print "<li>The diacritic for sign number $num is $char\n";
    } elsif ($char eq "j") {
      my $forearm = $char;
#      print "<li>Sign number $num is forearm prominent\n";
    } elsif ($char =~ /[goq\+\-\_\']/) {
      my $spatial = $char;
#      print "<li>The spatial relation for sign number $num is $char\n";
    } else {
      my $orientp = $orient = $char;
      $orientp =~ s/\</&lt/g;
      $orientp =~ s/\>/&gt/g;
#      print "<li>The orient for sign number $num is $orientp\n";
    }
  }
#  print "</ul>\n";
   my @hsinfo = ($hshape, $hsdiacrit, $forearm, $spatial, $orient);

#    print "<ul>";
#    foreach $hinf (0 .. scalar @hsinfo) {
#	print "<li>$hinf $hsinfo[$hinf]";
#    }
#    print "</ul>";
   return (@hsinfo);
}


sub lookatthehand {
#    print "Now entering lookatthehand().  Arugument is $_[0]\n";
    my $timelookup = $_[0];
    if ($handedness eq "l") {$leye{$timelookup}=$reye{$timelookup}=$reye{dl}
    } else { $leye{$timelookup} = $reye{$timelookup} = $reye{dr} }
    $leyebrow{$timelookup} = $leyebrow{bd};
#    print "\$timelookup is $timelookup. \$leye{ $timelookup } is now $leye{$timelookup}, and should be $leye{dr}\n";
    $leyebrowwrinkle{$timelookup} = $leyebrowwrinkle{bd};
    $reyebrow{$timelookup} = $reyebrow{bd};
    $reyebrowwrinkle{$timelookup} = $reyebrowwrinkle{bd};
}

sub facials {

    my $ftext = $_[0];

    my $number = $_[1];

#    my $date = scalar localtime;

    if ($debugem) {print "Now in facials(). \$ftext is $ftext<P>";}

    $blah{humanoid} = "genny3.wrl";

    my @fcode = split(//,$ftext);

    my $flen = length($ftext);

#   Now I parse the facial stuff; the head and body come later

    @fparam = ("Xb","Xi","Xey","Xex","Xm","Ys","Yk","Yty","Ytx","Tm","Th");

    @fvalues = ("bdg","yrl","iu","oae","njxmwts","ptkgcbd","fsh","iu",
		"oae","ptckq","mngh");

    my $jplace = 0;

    my $lastcode = "";

    foreach $i (0 .. $flen-1) {
      if ($debugem) {print "\$fcode[$i] is $fcode[$i]; \$jplace is $jplace<P>";}
      foreach $j ($jplace .. 10) {
	if ($debugem) {
	  print "  \$fparam[$j] is $fparam[$j]<br>";
	  print "  \$fvalues[$j] is $fvalues[$j]<p>";
	}
	if ($fcode[$i] =~/[$fvalues[$j]]/) {
	  if ($debugem) {print "Matched with $fparam[$j]<p>";}
	  if (substr($fparam[$j],-1) eq "y") {
	    $lastcode = $fcode[$i];
	    $jplace = $j+1;
	    last;
	  } elsif (substr($fparam[$j],-1) eq "x") {
	    $varname = substr($fparam[$j],0,2) . $number;
	    $blah{$varname} = $lastcode . $fcode[$i];
	    push (@formlist_order,$varname);
	    if ($debugem) {
	      print "Setting \$blah{$varname} to $blah{$varname}<P>";
	    }
	    $jplace= $j+1;
	    $lastcode = "";
	    last;
	  } else {
	    $varname = $fparam[$j] . $number;
	    $blah{$varname} = $fcode[$i];
	    if ($debugem) {print "Set \$blah{$varname} to $blah{$varname}<P>"}
	    push (@formlist_order,$varname);
	    $jplace=$j+1;
	    last;
	  }
	}
      }
    }
    $lastwd = "facial";
}
