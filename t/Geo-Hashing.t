# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Geo-Hashing.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 24; # 'no_plan'; #
BEGIN { use_ok('Geo::Hashing') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $debug = 1;
my $g = Geo::Hashing->new(debug => $debug);
is(ref($g), "Geo::Hashing", "Geo::Hashing object returned");
is($g->source, 'Geo::Hashing::Source::Peeron', "Peeron is the default source");

like($g->date, qr/^\d\d\d\d-\d\d-\d\d$/, "Default date matches pattern");
is($g->date("2008-05-24"), "2008-05-24", "Setting date worked");
is($g->date, "2008-05-24", "Setting date indeed set it");
is($g->lat, 0.126648011396999, "Correct dlat returned");
is($g->lon, 0.547533124094281, "Correct dlon returned");

$g = Geo::Hashing->new(debug => $debug, date => "2008-05-25", lat => 37, lon => -122);
is($g->date, "2008-05-25", "Constructor date indeed set it");
is($g->lat, 37.94177485284444, "Correct dlat returned");
is($g->lon, -122.18287359766967, "Correct dlon returned");

$g->date("2008-05-30");
is($g->lat, 37.8531025811716, "Correct lat for 2008-05-30");
is($g->lon, -122.244602195936, "Correct lon for 2008-05-30");
is($g->use_30w_rule, 0, "30W is corrected disabled");
is($g->lon(0), 0.704583434704204, "Correct lon for 30W2008-05-30");
is($g->use_30w_rule, 1, "30W is corrected enabled");
is($g->lat, 37.3227205387098, "Correct lat for 30W2008-05-30");

is($g->lat("-0"), -0.322720538709827,  "Setting lat to -0 sticks");
is($g->lon("-0"), -0.704583434704204, "Setting lon to -0 sticks");

$g->date("2008-05-26");
is($g->use_30w_rule, 0, "30W is corrected disabled before 2008-05-27");

{ 
  $g = Geo::Hashing->new(debug => $debug, source => 'random');
  is($g->source, 'Geo::Hashing::Source::Random', "Presetting the source to random works");
  my $djia1 = $g->djia;
  like($djia1, qr/^\d+(?:\.\d+)?$/, "Random DJIA looks right");
  my $djia2 = $g->djia;
  like($djia2, qr/^\d+(?:\.\d+)?$/, "Second random DJIA looks right");
  isnt($djia1, $djia2, "The two random DJIAs are different");
}
