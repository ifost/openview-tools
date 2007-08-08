#!/opt/OV/bin/Perl/bin/perl -w
use strict;

die "Usage: $0 systemname" 
 unless $#ARGV == 0;

my $host = $ARGV[0];
my $iaddr = $host;
if ($iaddr !~ /^(\d+\.){3}\d+/) {
 my (@addr) = gethostbyname($iaddr);
 die "No IP address for $host"
   unless @addr;
 my (@quad) = unpack('C4',$addr[4]);
 $iaddr = join(".",@quad);
}

my $ovobjcmd = "ovobjprint -a " .
 qq{ "Selection Name" } .
 qq{ "IP Address"="$iaddr" };

open (OVOBJPRINT,"$ovobjcmd |")
 || die "Can't run ovobjprint";

while (<OVOBJPRINT>) { 
 last if /OBJECT ID/;
}

my (@fields);
my ($objid);
my ($mib) = ".1.3.6.1.4.1.11.2".
              ".17.4.4.2.1.1.5";
my ($snmpcmd) = 
 "snmpget ".  `hostname`;
chomp($snmpcmd);
my ($result);
my ($crudless);
while (<OVOBJPRINT>) {
 die "$host ($iaddr) is unknown"
  if /NO FIELD VALUES FOUND/;
 @fields=split;
 $objid = $fields[0];
 open(SNMPGET,"$snmpcmd $mib.$objid|")
  || die "Can't run $snmpcmd";
 $result = <SNMPGET>;
 close (SNMPGET);
 if ($result !~ /^([^:]*:){2}(.*)$/) {
  warn "$snmpcmd $mib.$objid failed";
  next;
 }
 # pretty up the display a bit
 $crudless = $2;
 $crudless =~ s/ \d+ /\n/g;
 print "$crudless\n";
}
