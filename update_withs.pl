#! /usr/bin/perl

use strict;
my $file = "";
my %withs = ();
my @lines = ();
my $line = ();

open(FILE, "$file");
@lines = <FILE>;
close(FILE);


foreach $line (@lines)
{
   $line =~ s/(.*)\-\-.*/$1/; # Remove Comments this saves some headache
   if ($line =~ s/^\s*with\s+(.*);$//) # Get Rid of the withs that are already in the document
   {
      $withs{$1} = 1; #contains existing with statements!
   }
}

foreach $line (@lines)
{
   

}

