#!/usr/bin/perl
#!perl -w
use strict;
use DBI;
#open LOG, ">d:/Proclog/log.txt";  #log for debug

#open the file being processed
open (PRLOG, "c:/log/out") or die "was error $!";
my @prLog;  #all srings from the log
my @strPrLog;   #one string from the log
#get all strings from log
@prLog = <PRLOG>;


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

        @strPrLog = split ;  #get all string values
        #check flag and choose the table
        if (/<=/){
         &procStrIn;
        }
        else {
         &procStrOth;
        }



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




     $created = shift(@strPrLog); #add data to created
     $created = $created . " " . shift(@strPrLog);  #add time to created
     $str = join " ", @strPrLog; #result without first two fields
     $int_id = shift(@strPrLog); #add int_id to int_id field

            #find id field
            foreach (@strPrLog) {
                     if (/id=/){
                      $id = substr($_, 3); #cut the first 3 symbols
                      last;
                     }

            }

    if ($id){
      #if "id" isn't empty - wright the ready fields into database
      $dbh->do("insert into message (created, id, int_id, str) values('$created','$id','$int_id','$str')")
    }

 print "into message $created $id $int_id \n";

 }

#processing others strings
 sub procStrOth {

my $created;
my $int_id;
my $str;
my $address;




     $created = shift(@strPrLog);
     $created = $created . " " . shift(@strPrLog);
     $str = join " ", @strPrLog; #result without first two fields
     $str =~ s/[\\\?\']//g;   #delet "?" and "\" and "'" from string
     $int_id = shift(@strPrLog);


            #check the first availability the mail address
            foreach (@strPrLog) {
                   if (/.+@.+\..+/i){
                    $address = $_;
                    last;  #first availability(!)
                   }



            }


   #wright the ready fields into database
   $dbh->do("insert into log (created, int_id, str, address) values('$created','$int_id','$str','$address')");

 print "into log $created $int_id $address \n";

 }