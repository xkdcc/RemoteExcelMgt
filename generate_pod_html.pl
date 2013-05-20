#!/usr/bin/env perl

use strict;
use warnings;

print "\n";
print "Generating RemoteExcelMgt.pl...\n";
system("pod2html --infile=RemoteExcelMgt.pl --outfile=RemoteExcelMgt.html  --title=RemoteExcelMgt");
print "Generating lib/BC_ExcelAdmin.pm...\n";
system("pod2html --infile=lib/BC_ExcelAdmin.pm --outfile=lib/BC_ExcelAdmin.html  --title=RemoteExcelMgt");
print "Generating lib/BC_NetworkAdmin.pm...\n";
system("pod2html --infile=lib/BC_NetworkAdmin.pm --outfile=lib/BC_NetworkAdmin.html  --title=RemoteExcelMgt");
print "Generating lib/BC_Math.pm...\n";
system("pod2html --infile=lib/BC_Math.pm --outfile=lib/BC_Math.html  --title=RemoteExcelMgt");
print "Generating lib/BC_Constant.pm...\n";
system("pod2html --infile=lib/BC_Constant.pm --outfile=lib/BC_Constant.html  --title=RemoteExcelMgt");
print "Generating t/bc_exceladmin_test01.pm...\n";
system("pod2html --infile=t/bc_exceladmin_test01.pl --outfile=t/bc_exceladmin_test01.html  --title=bc_exceladmin_test01");
print "Generating t/bc_netadmin_test01.pm...\n";
system("pod2html --infile=t/bc_netadmin_test01.pl --outfile=t/bc_netadmin_test01.html  --title=bc_netadmin_test01");

print "Done.\n";

system("RemoteExcelMgt.html");
system("lib\\BC_ExcelAdmin.html");
system("lib\\BC_NetworkAdmin.html");
system("lib\\BC_Math.html");
system("lib\\BC_Constant.html");
system("t\\bc_exceladmin_test01.html");
system("t\\bc_netadmin_test01.html");

exit 0;
