#!/usr/local/gnu/bin/perl5
#

1;

# Retrieve HTTP GET or POST form based query
sub HTTPgetquery {
    local $querydata;
    local %formlist;
    local $variable;
    local($name, $value);

    %formlist = ();
    @formlist_order = ();

    if ($ENV{'REQUEST_METHOD'} eq 'GET') 
    {
        $querydata = $ENV{'QUERY_STRING'} ;
    } 
    else 
    {
        read(STDIN, $querydata, $ENV{"CONTENT_LENGTH"}) ;
#	print $querydata;
    }
     
    # Extract list of variable/value pairs from html query

    $querydata =~ s/$/\&/g ;

    #%formlist = ($querydata =~ /([^=&]*)\=([^=&]*)\&/g) ;
    #foreach $variable (keys(%formlist))
    #{
    #    $formlist{$variable} =~ s/\+/ /g ;
    #    $formlist{$variable} =~ s/\%([0-9a-fA-F][0-9a-fA-F])/pack("C", hex($1))/eg ;
    #}

    foreach (split('&', $querydata)) {
        ($name, $value) = split('=', $_);
        
        # Un-Webify plus signs and %-encoding
        $name =~ tr/+/ /;
        $name =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
        $value =~ tr/+/ /;
        $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;

	$formlist{$name} = $value;
	push(@formlist_order, $name);
#	print "$name=$value\n";
    }
    # Parse list, translate all %xx strings into real
    # characters and +'s into spaces.

    return(%formlist);
}

# Converts string to acceptable form for POST queries
#
sub HTTPcnvstring {
    local ($str) = @_;

    $str =~ s/ /+/g;
    return($str);
}




