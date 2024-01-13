#!/usr/bin/perl
#!perl -w
use strict;
use DBI;
#open LOG, ">d:/Proclog/log.txt";  #log for debug

#open the file being processed
open (PRLOG, "c:/log/out") or die "was error $!";
my @strPrLog;
#get all strings from log
my (@prLog) = <PRLOG>;


#host MySQL
my($dbhost) ='localhost';
#user MySQL
my($dbuser) ='procfile';
#password MySQL
my($dbpass) ='12345';
#DB name MySQL
my($dbname) ='procfile';

my $dbh;
#DB connect
$dbh = DBI->connect("DBI:mysql:database=$dbname;host=$dbhost",$dbuser, $dbpass) || die print "Can't connect";

#main cycle - iterate through all log entries
foreach (@prLog) {
    my $tmp1;  #the variable for debug
    $tmp1 = $_;
    @strPrLog = split ;  #get all string values
        #check flag and choose the table
        if ($tmp1 =~ /<=/){
         &procStrIn;
        }
        else {
         &procStrOth;
        }


    #print LOG "$tmp1 \n";

}

#close LOG;
close PRLOG;
$dbh->disconnect();

print "finish \n";
#print LOG "finish\n";

#processing incoming strings
sub procStrIn {

my $created;
my $id;
my $int_id;
my $str;
my @strPL_in_w; #for change fields
my $tmp2;

@strPL_in_w = @strPrLog;


     $created = shift(@strPL_in_w);
     $created = $created . " " . shift(@strPL_in_w);
     $int_id = shift(@strPL_in_w);
     $str = join " ", @strPL_in_w; #result without first two symbols

            #find id field
            foreach (@strPL_in_w) {
                     $tmp2 = $_;
                     if ($tmp2 =~ /id=/){
                      $id = substr($tmp2, 3); #cut the first 3 symbols
                      last;
                     }



            }

    if ($id){
      #if "id" isn't empty - wright the ready fields into database
      $dbh->do("insert into message (created, id, int_id, str) values('$created','$id','$int_id','$str')")
    }

 print "into message $created $id $int_id \n";
 #print LOG "procedure1 \n";
 }

#processing others strings
 sub procStrOth {

my $created;
my $int_id;
my $str;
my $address;
my @strPL_in_w; #for change fields
my $tmp3;

@strPL_in_w = @strPrLog;


     $created = shift(@strPL_in_w);
     $created = $created . " " . shift(@strPL_in_w);
     $int_id = shift(@strPL_in_w);
     $str = join " ", @strPL_in_w; #result without first two symbols
     $str =~ s/[\\\?\']//g;   #delet "?" and "\" and "'" from string

            #check the first availability the mail address
            foreach (@strPL_in_w) {
                   $tmp3 = $_;
                   if ($tmp3 =~ /.+@.+\..+/i){
                    $address = $tmp3;
                    last;  #first availability(!)
                   }



            }


   #wright the ready fields into database
   $dbh->do("insert into log (created, int_id, str, address) values('$created','$int_id','$str','$address')");

 print "into log $created $int_id $address \n";
 #print LOG "procedure2 \n";
 }
