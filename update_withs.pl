#! /usr/bin/perl

use strict;

# Declare some variables we intend to use.
my $file = "test_file.ada"; # Could easily be replaced with a passed in file, 
                            # good for using in programs which can call a program 
                            # with the filename as a parameter.
my %withs = ();
my @lines = ();
my $line = ();
my $key = "";
my $list;


# Open the file and grab the contents, if the files are crazy large, yea this is a bad idea
# however if your ada code files are that big, you have bigger problems
open(FILE, "$file");
@lines = <FILE>;
close(FILE);

# Scan through each line, remove any comments, they just get in the way.
foreach $line (@lines)
{
   $line =~ s/(.*)\-\-.*/$1/;
   # I haven't decided if I want to remove the withs that are already there, might be better to leave them
   # then when we hit the first one, we just print our list, and ignore any other withs....we'll see.
   #if ($line =~ s/^\s*with\s+(.*);\s*$//) # Get Rid of the withs that are already in the document
   #{
   #   $withs{$1} = 1; #contains existing with statements!
   #}
}


# Time for the meat of the script, start looking for packages within the file, if you find one we add it to the withs list.
for(my $i=0; $i<$#lines;$i++)
{
   trim(@lines[$i]);
   if (@lines[$i] =~ m/\./)
   {
      my @list_of_packages = find_packages(@lines[$i]);      
      foreach $list (@list_of_packages)
      {
         $withs{$list} = 1;
      }
   }
}

# For right now we're going to print the withs, however it would be best to update the withs in the file, that'll come with time.
foreach $key (sort keys %withs)
{
   print "With " . $key . ";\n";
}


################
#
# End of Program
#
################




###################################################
#
# Name: find_packages
# About: This should find a package out of a line 
#        of code
#
# Returns: Array of packages to be used for with list
###################################################
sub find_packages()
{
   my $line = $_[0];
   my $call = "";
   my @possible_calls = ();
   my @possible_package = ();
   my @return_withs = ();
   # Remove any keywords which might mess with what we're going for
   strip_ada_keywords($line);
   
   # Clean up the line, if there was an If then, or something like that
   # we might still have some trailing or leading spaces
   trim($line);
   
   # Time to split on the spaces (in the event we have multiple .'s
   @possible_calls = split('\s+', $line);
   
   # Go through each of the segments looking for .'s
   # If we see one, then we'll want to start doing some looking.
   foreach $call (@possible_calls)
   {
      if ($call =~ /\./)
      {
         @possible_package = split('\.', $call);
         # well this is probably trickier then we're wanting to deal with at the moment if there are more then 2 elements to the array0
         if ($#possible_package < 2)
         {
            push(@return_withs, @possible_package[0]);
         }
      }
   }
   return @return_withs;
}

###################################################
# Name: strip_ada_keywords
# About: This should strip out things like "if,then,
#        etc" this is most definately not complete, 
#        but should somewhat usable at this point
# Returns: Technically just modifies the variable 
#          directly, this way we don't have to pass
#          then re-assign.
###################################################
sub strip_ada_keywords()
{
   while ($_[0] =~ /(^\s*if| then\s*$|^\s*end| or | else )/)
   {
         $_[0] =~ s/(^\s*if| then\s*$|^\s*end| or | else )//; # The indentation is weird, because I want to make sure they're the same regex
   }
}

###################################################
# Name: trim
# About: This should strip out whitespace from the
#        beginning and end of a variable.
# Returns: Technically just modifies the variable 
#          directly, this way we don't have to pass
#          then re-assign.
###################################################
sub trim()
{
   $_[0] =~ s/^\s*(.*)\s*$/$1/;
}
