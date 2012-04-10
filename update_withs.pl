#! /usr/bin/perl

use strict;
my $file = "test_file.ada";
my %withs = ();
my @lines = ();
my $line = ();
my @possible_package = ();
my $key = "";

open(FILE, "$file");
@lines = <FILE>;
close(FILE);


foreach $line (@lines)
{
   $line =~ s/(.*)\-\-.*/$1/; # Remove Comments this saves some headache
   if ($line =~ s/^\s*with\s+(.*);\s*$//) # Get Rid of the withs that are already in the document
   {
      $withs{$1} = 1; #contains existing with statements!
   }
}

for(my $i=0; $i<$#lines;$i++)
{
   trim(@lines[$i]);
   if (@lines[$i] =~ m/\./)
   {
      @possible_package = split('\.', @lines[$i]);
      $withs{@possible_package[0]} = 1;
   }
}


foreach $key (sort keys %withs)
{
   print "With " . $key . ";\n";
}





sub trim()
{
   $_[0] =~ s/^\s*(.*)\s*$/$1/;
}
