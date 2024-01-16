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
         &procStrIn(@strPrLog);
        }
        else {
         &procStrOth(@strPrLog);
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

     $created = shift(@_); #add data to created
     $created = $created . " " . shift(@_);  #add time to created
     $str = join " ", @_; #result without first two fields
     $int_id = shift(@_); #add int_id to int_id field

            #find id field
            foreach (@_) {
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
my $flag;

     $created = shift(@_);
     $created = $created . " " . shift(@_);
     $str = join " ", @_; #result without first two fields
     $str =~ s/[\\\?\']//g;   #delete "?" and "\" and "'" from string
     $int_id = shift(@_);
     $flag = shift(@_);  #for check only

        if ((length($flag)) == 2){    #check to ignore mail for rows without flag
            #check the first availability the mail address
            foreach (@_) {
                   if (/.+@.+\..+/i){
                    s/[<>\:]//g;  #delete "<" and ">" and ":" from string (from $_)
                    $address = $_;
                    last;  #first availability(!)
                   }
            }
         }
   #wright the ready fields into database
   $dbh->do("insert into log (created, int_id, str, address) values('$created','$int_id','$str','$address')");

 print "into log $created $int_id $address \n";

 }