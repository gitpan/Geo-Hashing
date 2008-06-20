package Geo::Hashing::Source::Peeron;

use strict;
use warnings;
use Carp;
require Exporter;
use LWP::Simple qw/$ua get/;

$ua->agent("Geo::Hashing/" . $Geo::Hashing::VERSION);
my $URL = "http://irc.peeron.com/xkcd/map/data/%04d/%02d/%02d";

our @ISA = qw/Exporter/;
our @EXPORT = qw/get_djia/;

sub get_djia {
  my $self = shift;
  my $date = shift;

  croak "Invalid call to get_djia - missing date!" unless $date;

  my ($y, $m, $d) = split /-/, $date, 3;
  croak "Invalid year $y" unless $y and $y >= 1928;
  croak "Invalid month $m" unless $m and $m >= 1 and $m <= 12;
  croak "Invalid day $d" unless $d and $d >= 1 and $m <= 31;

  my $page = get(sprintf($URL, $y, $m, $d));

  return $page;
}

1;
