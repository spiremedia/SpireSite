#!/usr/bin/perl

#  SpireMedia, Inc.  Thaddeus Batt thad@spiremedia.com
#  vbscript that calls wmi service to restart the coldfusion services
#  this script can be called via the associated perl script
#  the default location of this file is
#  
#  Date: 02/23/2007
 use Net::Telnet;


$| = 1;


 $telnet = new Net::Telnet ( Timeout=>30,
                             Errmode=>'die');
 $telnet->open('localhost');
 $telnet->waitfor('/login: $/i');
 $telnet->print('root');
 $telnet->waitfor('/password: $/i');
 $telnet->print('password');
 $telnet->waitfor('/\# $/i');
 $telnet->print('/opt/coldfusionmx7/bin/coldfusion restart');
 $output = $telnet->waitfor('/\# $/i');
 print "Content-Type: text/html\n\n";
 print $output;


#@args_exe = ("/opt/coldfusionmx7/bin/coldfusion","restart");
#system(@args_exe) == 0
#   or die "it didn't work:  @args_exe";

# and comment out the print section for go live version
print <<HTMLDOC;
<body >
<h1>restarting services</h1>
<PRE>
<p><hr>
</PRE><HR>

HTMLDOC

# end section to be commented out


# this section is the subroutine that sorts the get or post keys

for $var (sort keys %ENV){
        print "<B>$var</B>: $ENV{$var}<BR>\n";
}

print "</BODY></HTML>";

sub GetCgiParam {
    my ($paramname) = @_;
    my ($request_method, $query_string);
    if (! %cgiparams) {
        $request_method = $ENV{REQUEST_METHOD};
        if ($request_method eq 'GET') {
            $query_string = $ENV{QUERY_STRING};
        }
        elsif ($request_method eq 'POST') {
            read (STDIN, $query_string, $ENV{CONTENT_LENGTH});
        }
        elsif ($ARGV[0]) {
            $query_string = $ARGV[0];
        }
        else {
            die "Not a Get or a Post";
        }
        foreach $pair (split /&/, $query_string) {
            my ($key, $value) = split /=/, $pair;
            $value =~ tr/+/ /;
            $value =~ s/%([\dA-Fa-f][\dA-Fa-f])/pack 'C', hex($1)/eg;
            $cgiparams{$key} = $value;
        }
    }
    $cgiparams{$paramname};
}

exit;
