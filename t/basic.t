use strict;
use warnings;
use ExtUtils::testlib;
use Test::More;

use lib '../lib'; # For when this script is run directly
use local::lib 'perl5';

use_ok('Time::Naive::TimeOfDay' => "0.01") or BAIL_OUT;

my $ts_in = Time::Naive::TimeOfDay->new("23:30");
isa_ok($ts_in, 'Time::Naive::TimeOfDay');

my $ts_out = Time::Naive::TimeOfDay->new("7:45");
isa_ok($ts_out, 'Time::Naive::TimeOfDay');

my $ts = $ts_in->until( $ts_out );

is( $ts, "08:15:00" );

done_testing;
