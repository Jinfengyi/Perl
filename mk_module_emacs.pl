#!/usr/bin/perl
#################################################################
#################################################################
##    use .csv file                                            ##
##    csv fomart:                                              ##
##               --------------------------                    ##
##               | category |  name | bit |                    ##
##               --------------------------                    ##
##               |filename  | xxxx  |     |  <-filename        ##
##               |module    | xxxx  |     |  <-module name     ##
##               |input     | xxxx  | xxx |                    ##
##               |output    | xxxx  | xxx |                    ##
##               .          .       .     .                    ##
##               .          .       .     .                    ##
##                                                             ##
##                                                             ##
##    ex: ./mk_module_emacs.pl xxx.csv                         ##
#################################################################
#################################################################

$file = "@ARGV";
open (IN, $file);
#####################
## make out file   ##
#####################
while (my $line = <IN>){
    my($IO,$outfile,$bit) = split(/,/,$line);
    if($IO eq "filename"){
        $module_file = "$outfile";
        print "make file : $outfile"
    }
};
close(IN);
close(OUT);

###############################
##  write  file for emacs   ###
###############################
open(OUT,">$module_file");
open (IN, $file);
while (my $line=<IN>){
   chomp($line);
   $line =~ tr/\015//d;
   my($IO,$pin,$bit) = split(/,/,$line);
   $bit = $bit - 1;
   if($IO eq "module"){
       print"module name: $pin\n";
       print OUT "module $pin ( /*AUTOARG*/\n    );  \n\n";
   }
   if($IO eq "input"){
       print OUT  "   input     ";
       if ($bit eq 0){
           print OUT "           ";
       }
       else
       {
           if ($bit > 9){
               print OUT  "[$bit:0]     ";
           }
           else{
               print OUT  "[$bit:0]      ";
           }
       }
       print OUT  "$pin\n";
   }
   if($IO eq "output"){
       print OUT  "   output    ";
       if ($bit eq 0){
           print OUT "           ";
       }
       else
       {
           if ($bit > 9){
               print OUT  "[$bit:0]     ";
           }
           else{
               print OUT  "[$bit:0]      ";
           }
       }
       print OUT  "$pin\n";
   }
};
print OUT "\n\n endmodule\n";
close(IN);
close(OUT);

