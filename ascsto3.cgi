#!/usr/local/gnu/bin/perl5

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

print $mimehtml;

print qq#<h1>ASCII-Stokoe Module 3</h1>

<P>This is the module that will parse strings of ASCII-Stokoe text.#;

#
# Get CGI query
#
%blah = HTTPgetquery();
@blah_order = @formlist_order;

getdeefaults();

getsto();

$astext = $blah{astext};

$astext =~ s/\</&lt/g;

$astext =~ s/\>/&gt/g;

print "<P>Your submission was $astext<P>\n";

@sign = split(" ", $astext);

$length = (scalar @sign - 1);

foreach $num (0 .. $length) {
  print "Sign number $num is $sign[$num]<br>\n";
  (${loc}[$num],${shape}[$num],${mov}[$num]) = split ("/",$sign[$num]);
  print "<ul>\n";
  foreach $prime (loc, shape, mov) {
    print "<li>The $prime for sign number $num is ${$prime}[$num]\n";
    if ($prime eq "loc") { 
      $loc = ${loc}[$num];
      if (exists($nh{$loc})) {
	print "<br>This is a handshape.  I should set \$nh{$num} to $loc and the loc to a.";
      }
    }
  }
  ${hs}[$num] = substr(${shape}[$num],0,1);
  ${orient}[$num] = substr(${shape}[$num],1,1);
  $hs = ${hs}[$num]; $orient = ${orient}[$num];
  print "<li>The hs for sign number $num is $hs";
  print "<li>The orient for sign number $num is $orient\n";
  print "</ul>\n"
}

print "</html>\n";

exit;

