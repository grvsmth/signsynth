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

sub getdeefaults {
    @default_order = ();
#    if ($newdefaults) { $deffile = "defaults1.txt" } else { $deffile = "defaults.txt" }

    $deffile = "defaults" . $newdefaults . ".txt";
	unless(open (DEFAULTS, $deffile)) {
            print "Content-Type: text/plain\n\nCouldn't open $deffile!\n";
	    return;
	}
# 	print $mimehtml . "\n\n<PRE>\n";
	while ($keydefault = <DEFAULTS>) {
# 		print ($keydefault);
		chomp ($keydefault);
		$valdefault = <DEFAULTS>;
 #		print ($valdefault);
		chomp ($valdefault);
		$default{$keydefault} = $valdefault;
	        push(@default_order, $keydefault);
	}
	close (DEFAULTS);

}

1;










