#!/usr/bin/env perl

use strict;
use warnings;

print "\n";
print "Generating RemoteExcelMgt.pl...\n";
system("pod2html --infile=RemoteExcelMgt.pl --outfile=RemoteExcelMgt.html  --title=RemoteExcelMgt");
print "Generating Package/BC_ExcelAdmin.pm...\n";
system("pod2html --infile=Package/BC_ExcelAdmin.pm --outfile=Package/BC_ExcelAdmin.html  --title=RemoteExcelMgt");
print "Generating Package/BC_NetworkAdmin.pm...\n";
system("pod2html --infile=Package/BC_NetworkAdmin.pm --outfile=Package/BC_NetworkAdmin.html  --title=RemoteExcelMgt");
print "Generating Package/BC_Math.pm...\n";
system("pod2html --infile=Package/BC_Math.pm --outfile=Package/BC_Math.html  --title=RemoteExcelMgt");
print "Generating Package/BC_Constant.pm...\n";
system("pod2html --infile=Package/BC_Constant.pm --outfile=Package/BC_Constant.html  --title=RemoteExcelMgt");

print "Done.\n";

system("RemoteExcelMgt.html");
system("Package\\BC_ExcelAdmin.html");
system("Package\\BC_NetworkAdmin.html");
system("Package\\BC_Math.html");
system("Package\\BC_Constant.html");

exit 0;
