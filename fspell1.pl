#!/usr/local/gnu/bin/perl
#
# This is FSpell1, the subroutine that converts fingerspelling into
# rotation specs directly.


1;

sub getsto {

        unless(open (FSPELL, "fspell1.txt")) {
            print "Content-Type: text/plain\n\nCouldn't open fspell1.txt!\n";
            return;
        }

        while ($keyfs = <FSPELL>) {
	    chomp ($keyfs);
	    if (substr ($keyas, 0, 1) eq "\$"){ 
		$jointtemp = (substr ($keyfs, 1));
		push (@jointlist_order, $jointtemp);
	    }
	    else {
		($fsstemp, $dummyvar) = split ('=', $keyfs);
		${$jointtemp}{$fstemp} = $dummyvar;

#  We can recycle rotation specs, e.g.

	if ( substr (${$jointtemp}{$fstemp}, 0, 1) eq "u") { 
    ${$jointtemp}{$fstemp} = ${$jointtemp}{substr(${$jointtemp}{$fstemp},1)}
}
}
	}
        close (FSPELL);
}

sub cnvfsrot {

    foreach $cnvkey (@formlist_order) {
	foreach $joint2 (@jointlist_order) {
	    $joint3 = ${$joint2}{$blah{$cnvkey}};

	unless ($blah{$joint2}) { if ($joint3) { $blah{$joint2} = $joint3}

}}
				  unless ($joint3) {$blah{$joint2} = $default{$joint2}}}

}














