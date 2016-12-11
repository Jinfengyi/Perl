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
$intent_num = 3;

####################
##     INTENT     ##
####################
$speace = " ";
$intent = " ";
for (my $i = 0; $i < $intent_num; $i++){
    $intent = $intent.$speace;
}


#####################
## make out file   ##
#####################
open (IN, $file);
while (my $line = <IN>){
    my($IO,$outfile,$bit) = split(/,/,$line);
    if($IO eq "filename"){
        $module_file = "$outfile";
        print "Make file      : $outfile"
    }
};
close(IN);
close(OUT);

###############################
##  write  file for emacs   ###
###############################
$Input_num = 0;
$Output_num = 0;
open(OUT,">$module_file");
open (IN, $file);
while (my $line=<IN>){
   chomp($line);
   $line =~ tr/\015//d;
   my($IO,$pin,$bit) = split(/,/,$line);
   $bit = $bit - 1;
   if($IO eq "module"){
       print"Module name    : $pin\n";
       print OUT "module $pin ( /*AUTOARG*/\n$intent);  \n\n";
   }
   if($IO eq "input"){
       $Input_num ++;
       print OUT "$intent";
       print OUT  "input     ";
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
       print OUT  "$pin;\n";
   }
   if($IO eq "output"){
       $Output_num ++;
       print OUT "$intent";
       print OUT  "output    ";
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
       print OUT  "$pin;\n";
   }
};
print OUT "\nendmodule\n";
print "Input Port Num : $Input_num\n";
print "Output Port Num: $Output_num\n";
close(IN);
close(OUT);

