RemoteExcelMgt.pl
---
Copyright 2012 - 2013 Brant Chen (brantchen2008@gmail.com and xkdcc@163.com), All Rights Reserved 

##SYNOPSIS

To remote update team's LOC_Machines_List.xls. Of course, you can have a try on any other Excle file.

##REQUIREMENTS

Need modules from CPAN:
* Spreadsheet::ParseExcel
* Spreadsheet::ParseExcel::SaveParser;
* Spreadsheet::WriteExcel
* Text::ASCIITable 

##DESCRIPTION

Testing under ActivePerl 5.16.3.1603.

1. FTP to remote system, write down modified date/time.
2. Download the specified Excel.
3. Modify specified cells.
4. Call a VBA method which build-in this Excel to produce a html file.
5. Check remote Excel file's modfied date/time:
   <1> If remote one's time is older, update local copy (Excel
       and html) to overwrite the remote ones.
   <2> If remote one's time is newer, give warning and choice.


##USAGE        

This perl script will provide a CMD MENU. Esc means return to previous menu at any time.

```
perl RemoteExcelMgt.pl
Main menu:
1. Download files by FTP
2. Upload files to FTP 
3. Operations on local excel file

Sub menu of "1":
1. Given FTP IP/Username/Password to log on.
   This will in a FTP shell, you could navigate to your destination and download Files.
   This will check whether newer/older files if Net::FTP module doesn't do it.

Sub menu of "2":
1. Given FTP IP/User Name/Password to log on. (It will provide related credentials you used for conveniences.)
   This will in a FTP shell, you could navigate to your destination and upload Files.
   This will check whether newer/older if Net::FTP module doesn't do it. 
   
Sub menu of "3":
1. Give path to local excel file. Check file/path.
   If OK, list all sheet names.
2. Type sheet index, will print sheet with index.
3. Set range(for example, r_1, r_3, c_3, c_5. For more details, please check code), then print range.
4. Specify which cells you want to modify one by one.
   For example, (r_3, c_1), or (r3) (means you want to modify r3 from your given col start index, for example, (r3,c3). (r3,c4), (r3,c5))
   Provide esx to cancel operations; 
   Provide "stop fill out rest cells" to submit your changes even you didn't complete fill out all the cells in your specified range.
   Ask whether to preview.
   Ask whether submit
   Print range after submit changes.
   Provide one-time undo after submit.
```

###Welcome to my blog
<a href="http://www.brantchen.com">![Brant's Blog](http://brant-public.qiniudn.com/site-Logo215x100-Brant%20Blog.png)</a>

###Follow me on social networking 
<a href="http://google.com/+BrantChenGo">![Brant's Google+](http://brant-public.qiniudn.com/googleplus1@2x.png)</a>
<a href="http://cn.linkedin.com/pub/brant-chen/9/6a9/a03/">![Brant's LinkedIn](http://brant-public.qiniudn.com/linkedin@2x.png)</a>
<a href="https://www.facebook.com/brantchen2008">![Brant's Facebook](http://brant-public.qiniudn.com/facebook@2x.png)</a>
<a href="https://twitter.com/brantchen2008">![Brant's Twitter](http://brant-public.qiniudn.com/icon-twitter-2x.png)</a>
