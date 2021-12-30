#!/usr/bin/perl

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


push(@INC, '.');
require('httputil.pl');
require('signutil.pl');
require('ascsto2.pl');

$tophtml = qq#Content-Type: text/html

<html>
<title>SignSynth - ASCII-Stokoe Module 2</title>
<h3>Welcome to SignSynth</h3>

<P>

#;

    print $tophtml;

#
# Get CGI query
#
%blah = HTTPgetquery();

$length = $blah {length};

$handed = "r";

unless ($length) { $length = 1 };

getdeefaults();

getsto();

$tabletop = "<table border=1 width=600>\n\n";

$formtop = "<form method=POST action=signgen3.cgi>\n\n";

$signnum = 0;

until ($signnum eq $length) {
    ++ $signnum;
    $formbody .= "<tr><th colspan=2>Sign $signnum<tr><td>";
    $tableflag = 0;
    foreach $prime (@prime_order) {
      if (substr($prime,0,1) !~ /[ndXYT]/) {next}
      if ($prime eq "param") {next}
      $prime2 = $prime . $signnum;
      if ($debugem) {print "$prime: ", %{$prime}, " <br>";}
      if ((substr ($prime,0, 1) eq "n") and ($tableflag eq 0)) {
	${$prime2} .= "<td>"; ++$tableflag
      }
      if ((substr ($prime,0,1) eq "X") and ($tableflag eq 1)) {
	${$prime2} .= "<tr><td>"; ++$tableflag
      }

      if ((substr ($prime,0,1) eq "Y") and ($tableflag eq 2)) {
	${$prime2} .= "<td>"; ++$tableflag
      }
      if ((substr ($prime,0,1) eq "T") and ($tableflag eq 2)) {
	${$prime2} .= "<td>"; ++$tableflag
      }


      ${$prime2} .= $param{$prime} . "<select name=" . $prime2 . ">\n";
      foreach $primekey ( @$prime ) {
        if (substr (${$prime}{$primekey}, -1,1) eq "*") {$selected = "selected"} else {$selected = ()}
        ${$prime2} .= "<option $selected value=$primekey>" . ${$prime}{$primekey} . "\n";
      }
      ${$prime2} .= "</select><br>\n";
      $formbody .= ${$prime2};
    }
}

$formbottom = qq#<input type=hidden name=length value=$length>
    <input type=hidden name=handed value=$handed>
<P><input type=submit value=\"Put it into action!\"></form>
#;

$gpl = qq#<P>SignSynth comes with ABSOLUTELY NO WARRANTY.  This is free
software, and you are welcome to redistribute it under certain
conditions; see the <a href=gpl.html>GNU Public License</a> for
details.#;


$bottomhtml = "</html>";


$tablebottom="</table>";



print $formtop, $tabletop, $formbody, $tablebottom, $formbottom, $gpl, $bottomhtml;


exit;

