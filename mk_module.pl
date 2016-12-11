#!/usr/bin/perl

$file = "@ARGV";
$last_port_num = 0;
$intent_num = 3;
$max_line_length = 62;

####################
##     INTENT     ##
####################
$speace = " ";
$intent = " ";
for (my $i = 0; $i < $intent_num; $i++){
    $intent = $intent.$speace;
}



####################
##make module file##
####################
open (IN, $file);
while (my $line = <IN>){
    $last_port_num++;
    my($IO,$outfile,$bit) = split(/,/,$line);
    if($IO eq "filename"){
        open(OUT,">$outfile");
        $module_file = "$outfile";
        print "Make file       : $module_file"
    }
};
close(IN);
close(OUT);

#######################
##  input port name ###
#######################
$input_num = 0;
$output_num = 0;
$line_length = 0;
open(OUT,">$module_file");
open (IN, $file);
while (my $line=<IN>){
   chomp($line);
   $line =~ tr/\015//d;
   my($IO,$pin,$bit) = split(/,/,$line);
   if($IO eq "module"){
       print "Module name     : $pin\n";
       print OUT "module $pin (\n";
       print OUT "$intent//INPUT\n$intent";
   }

   if($IO eq "input") {
       $input_num++;
       if ($line_length > $max_line_length){
           print OUT "\n$intent";
           $line_length = 0;
       }
       print OUT "$pin,";
       $line_length = $line_length + length($pin) + 1;
   }
};
print OUT "\n\n$intent";
close(IN);
close(OUT);

#######################
## output port name ###
#######################
open(OUT,">>$module_file");
open (IN, $file);
$port_num = 0;
$line_length = 0;
print OUT "//OUTPUT\n$intent";
while (my $line=<IN>){
   $port_num ++;
   my($IO,$pin,$bit) = split(/,/,$line);
   if($IO eq "output") {
       $output_num++;
       if ($line_length > $max_line_length){
           print OUT "\n$intent";
           $line_length = 0;
       }
       if ($port_num == $last_port_num){
           print OUT "$pin";
       }
       else{
            print OUT "$pin,";
       }
       $line_length = $line_length + length($pin) + 1;
   }
};
print OUT "\n$intent);\n\n";
close(IN);
close(OUT);

print "Input port num  : $input_num\n";
print "Output port num : $output_num\n";

##############################
## bit width and port name ###
##############################
open(OUT,">>$module_file");
open (IN, $file);
while (my $line=<IN>){
   my($IO,$pin,$bit) = split(/,/,$line);
   $bit = $bit - 1 ;
   if($IO eq "input"){
       $input_num++;
       print OUT  "$intent";
       print OUT  "input     ";
       if ($bit eq 0){
           print OUT "            ";
       }
       else
       {
           if ($bit > 9){
               print OUT  "[$bit:0]      ";
           }
           else{
               print OUT  "[$bit:0]       ";
           }
       }
       print OUT  "$pin;\n";
   }
   if($IO eq "output"){
       $output_num++;
       print OUT "$intent";
       print OUT "output    ";
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

print OUT "endmodule\n";
close(OUT);
close(IN);
