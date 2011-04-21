use strict;
use warnings;
use ExtUtils::testlib;
use Test::More;

use lib '../lib'; # For when this script is run directly

use_ok('Time::Naive::TimeOfDay' => "0.01") or BAIL_OUT;
use_ok('Time::Simple' => "0.06") or BAIL_OUT;

my $t1 = Time::Simple->new("16:03");
my $t2 = Time::Naive::TimeOfDay->new("17:03");
my $d = $t2 - $t1;

is( $d, "01:00", "TNT works together with Time::Simple" );

my $ts_in = Time::Naive::TimeOfDay->new("23:30");
isa_ok($ts_in, 'Time::Naive::TimeOfDay');

my $ts_out = Time::Naive::TimeOfDay->new("7:45");
isa_ok($ts_out, 'Time::Naive::TimeOfDay');

my $ts = $ts_in->until( $ts_out );

is( $ts, "08:15:00", 'Duration is as long as expected' );

cmp_ok( $ts, '>',  '08:00',    'Comparing durations with strings works' );
cmp_ok( $ts, '<',  '09:00',    'Comparing durations with strings works' );
cmp_ok( $ts, '==', '08:15',    'Comparing durations with strings works' );
cmp_ok( $ts, 'eq', '08:15',    'Comparing durations with strings works' );
cmp_ok( $ts, '==', '08:15:00', 'Comparing durations with strings works' );
cmp_ok( $ts, 'eq', '08:15:00', 'Comparing durations with strings works' );
cmp_ok( $ts, '!=', '08:16',    'Comparing durations with strings works' );
cmp_ok( $ts, 'ne', '08:14',    'Comparing durations with strings works' );

my $long_ts = $ts * 10;
cmp_ok(
  $long_ts, '==', "82:30:00",
  'Comparing long durations with strings works'
);

cmp_ok(
  $long_ts, 'eq', "82:30:00",
  'Comparing long durations with strings works'
);
is(
  $long_ts, "82:30:00",
  "Calculating and comparing long durations"
);

my $neg_long_ts = $long_ts * -1;
cmp_ok(
  $neg_long_ts, '==', "-82:30:00",
  'Comparing long negative durations with strings works'
);

cmp_ok(
  $neg_long_ts, 'eq', "-82:30:00",
  'Comparing long negative durations with strings works'
);

is(
  $neg_long_ts, "-82:30:00",
  "Calculating and comparing long negative durations"
);


my $neg_ts_in = Time::Naive::TimeOfDay->new("23:30");
isa_ok($neg_ts_in, 'Time::Naive::TimeOfDay');

my $neg_ts_out = Time::Naive::TimeOfDay->new("23:45");
isa_ok($neg_ts_out, 'Time::Naive::TimeOfDay');

my $neg_ts = $neg_ts_in - $neg_ts_out;

is( $neg_ts, "-00:15:00", 'Duration is as long as expected' );

cmp_ok( $neg_ts, '>',  '-01:00',    'Comparing durations with strings works');
cmp_ok( $neg_ts, '<',   '00:00',    'Comparing durations with strings works');
cmp_ok( $neg_ts, '==', '-00:15',    'Comparing durations with strings works');
cmp_ok( $neg_ts, 'eq', '-00:15',    'Comparing durations with strings works');
cmp_ok( $neg_ts, '==', '-00:15:00', 'Comparing durations with strings works');
cmp_ok( $neg_ts, 'eq', '-00:15:00', 'Comparing durations with strings works');
cmp_ok( $neg_ts, '!=', '-00:16',    'Comparing durations with strings works');
cmp_ok( $neg_ts, 'ne', '-00:14',    'Comparing durations with strings works');

my $pos_ts = $neg_ts + "00:30";

cmp_ok( $pos_ts, '>',  '00:00',    'Comparing durations with strings works');
cmp_ok( $pos_ts, '<',  '01:00',    'Comparing durations with strings works');
cmp_ok( $pos_ts, '==', '00:15',    'Comparing durations with strings works');
cmp_ok( $pos_ts, 'eq', '00:15',    'Comparing durations with strings works');
cmp_ok( $pos_ts, '==', '00:15:00', 'Comparing durations with strings works');
cmp_ok( $pos_ts, 'eq', '00:15:00', 'Comparing durations with strings works');
cmp_ok( $pos_ts, '!=', '00:16',    'Comparing durations with strings works');
cmp_ok( $pos_ts, 'ne', '00:14',    'Comparing durations with strings works');

done_testing;
