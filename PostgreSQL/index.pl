#!C:/Strawberry/perl/bin/perl -w
use strict;
use CGI qw(:standard);
use DBI;
print "Content-Type: text/html\n\n";


my $address;
# Getting data from HTML form
 $address = param ("Address");


my $hostname = "localhost";
my $port = "5432";
my $user = "postgres";
my $password = "12345";
my $dbname = "procfile";

my $dbh = DBI->connect("dbi:Pg:dbname=$dbname;host=$hostname;port=$port",$user,$password);

my $query = "SELECT message.int_id, message.created, message.str FROM message JOIN log USING (int_id) WHERE log.address = '$address' UNION SELECT int_id, created, str FROM  log WHERE address = '$address' ORDER BY int_id, created";

my $sth = $dbh->prepare($query);
my $rv = $sth->execute();
if (!defined $rv) {
  print "whith execute '$query' was error: " . $dbh->errstr . "\n";
  exit(0);
}

my $ref;
my $created;
my $str;
my $n=0;

print "<textarea rows='50' cols='200'>\n";

while ($ref = $sth->fetchrow_hashref()) {
   $n++;
   ($created, $str) = ($ref->{'created'}, $ref->{'str'});
   print "$created \x20  $str \n";
    if ($n == 100) {
          print "\n MORE THAN 100 ROWS WERE FOUND!";
          last;
    }

}

print "</textarea>\n";

$sth->finish();
$dbh->disconnect();

