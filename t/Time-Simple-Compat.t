use strict;
use warnings;
use ExtUtils::testlib;
use Test::More;

use lib '../lib'; # For when this script is run directly
use local::lib 'perl5';

use_ok('Time::Naive::TimeOfDay' => "0.01") or BAIL_OUT;

my $ts = Time::Naive::TimeOfDay->new;
isa_ok($ts, 'Time::Naive::TimeOfDay');
like(scalar(localtime), qr/$ts/, 'Without args is Localtime');

$ts = Time::Naive::TimeOfDay->new('23:59:59');
isa_ok($ts, 'Time::Naive::TimeOfDay', 'New from scalar');
is($ts->hour,23,'hr from array');
is($ts->minute,59,'min from array');
is($ts->second,59,'sec from array');
isnt($$ts, 2298322799, 'Adding seconds') or BAIL_OUT;

my $printed = "$ts";
isnt($$ts, 2298322799, 'Adding seconds') or BAIL_OUT;
like($printed, qr/23:59:59/, 'stringified');
isa_ok($ts, 'Time::Naive::TimeOfDay');
$ts++;
isa_ok($ts, 'Time::Naive::TimeOfDay', 'obj after inc');
isnt($$ts, 2298322799, 'Adding seconds') or BAIL_OUT;
like($ts, qr'00:00:00', 'inc after inc') or BAIL_OUT;
$printed = "$ts";
is($printed, '00:00:00', 'stringified');

$ts--;
isa_ok($ts, 'Time::Naive::TimeOfDay', 'obj after dec');
like($ts, qr'23:59:59', 'dec after dec') or BAIL_OUT;
$printed = "$ts";
is($printed, '23:59:59', 'stringified') or BAIL_OUT;

$ts = Time::Naive::TimeOfDay->new(1,2,3);
isa_ok($ts, 'Time::Naive::TimeOfDay');
is($ts->hour,1,'hr from array');
is($ts->minute,2,'min from array');
is($ts->second,3,'sec from array');
$printed = "$ts";
is($printed, '01:02:03', 'stringified');

$ts = Time::Naive::TimeOfDay->new('23:59');
isa_ok($ts, 'Time::Naive::TimeOfDay', 'New from scalar no seconds');
is($ts->hour,23,'hr from scalar');
is($ts->minute,59,'min from scalar');
is($ts->second,0,'sec from scratch');

$ts = Time::Naive::TimeOfDay->new([23,59]);
isa_ok($ts, 'Time::Naive::TimeOfDay', 'New from array no seconds');
is($ts->hour,23,'hr from scalar');
is($ts->minute,59,'min from scalar');
is($ts->second,0,'sec from scratch');

$ts = Time::Naive::TimeOfDay->new('23');
isa_ok($ts, 'Time::Naive::TimeOfDay', 'New from scalar no seconds');
is($ts->hour,23,'hr from scalar');
is($ts->minute,0,'min from scratch');
is($ts->second,0,'sec from scratch');

$ts = Time::Naive::TimeOfDay->new([23]);
isa_ok($ts, 'Time::Naive::TimeOfDay', 'New from array no seconds');
is($ts->hour,23,'hr from array');
is($ts->minute,0,'min from scratch');
is($ts->second,0,'sec from scratch');

$ts = Time::Naive::TimeOfDay->new('23:59:59');
like($ts->next, qr'00:00:00', 'next');

$ts = Time::Naive::TimeOfDay->new('00:00:20');
is($ts+1,'00:00:21', '20 plus one');
is($ts,'00:00:20', 'no change');
$ts = Time::Naive::TimeOfDay->new('00:00:00');

$ts = Time::Naive::TimeOfDay->new('10:00:00');
like($ts->prev, qr'09:59:59', 'prev');

# Perlop:
#    Binary "cmp" returns -1, 0, or 1 depending on whether the left argument
#    is stringwise less than, equal to, or greater than the right argument.
$ts = Time::Naive::TimeOfDay->new('10:00:00');
is( ($ts cmp "10:00:01"), -1, 'cmp >');
is( ($ts cmp "10:00:00"), 0, 'cmp ==') or BAIL_OUT;
is( ($ts cmp "09:59:59"), 1, 'cmp <');

is( ($ts <=> "10:00:01"), -1, '<=> >');
is( ($ts <=> "10:00:00"), 0, '<=> ==');
is( ($ts <=> "09:59:59"), 1, '<=> <');

is( ($ts cmp [10,0,1]), -1, 'cmp >');
is( ($ts cmp [10,0,0]), 0, 'cmp ==');
is( ($ts cmp [9,59,59]), 1, 'cmp <');

is( ($ts <=> [10,0,1]), -1, '<=> >');
is( ($ts <=> [10,0,0]), 0, '<=> ==');
is( ($ts <=> [9,59,59]), 1, '<=> <');

is( ($ts > "09:59:59"), 1, '>');
is( ($ts gt "09:59:59"), 1, 'gt');

ok(not("09:59:59" > $ts),, '! >');
is( ($ts == "10:00:00"), 1, '==');
ok(not($ts == "10:00:01"), '! ==');
is( ($ts != "10:00:01"), 1, '!=');

is( ($ts < "10:00:01"), 1, '<');
is( ($ts lt "10:00:01"), 1, '<');
ok(not($ts < "09:58:59"), '! <');

is( ++$ts, "10:00:01", '++');
is( --$ts, "10:00:00", '--');
$ts++;
is( $ts, "10:00:01", '++');
$ts--;
is( $ts, "10:00:00", '--');



my $ts1 = Time::Naive::TimeOfDay->new('01:00:00');
my $ts2 = Time::Naive::TimeOfDay->new('01:00:00');
my $ts3 = $ts1 + $ts2;
isa_ok($ts3, 'Time::Naive::TimeOfDay', 'Addition creates new') or BAIL_OUT;
is("$ts3", '02:00:00', 'Made two hours') or BAIL_OUT;

{
  my $ts1 = Time::Naive::TimeOfDay->new('00:00:10');
  my $ts2 = Time::Naive::TimeOfDay->new('00:00:09');
  my $ts3 = eval { $ts1 - $ts2 };
 SKIP: {
    skip 'Difference now returns an object', 1;
    is( $ts3, 1, 'Difference via minus');
  }
  is( "$ts3", "00:00:01", 'Difference via minus');
}


my $a = Time::Naive::TimeOfDay->new('10:00:00');
is($a, '10:00:00', 'a 10');
my $b = Time::Naive::TimeOfDay->new('02:00:00');
is($b, '02:00:00', 'b 02');
my $c = $a + $b;
is($c, '12:00:00', 'c 10+02');


my $now = Time::Naive::TimeOfDay->new('00:00:00');
my $nexthour = $now + 60;
isa_ok($nexthour, 'Time::Naive::TimeOfDay');
is($nexthour, '00:01:00', '+scalar');

my $prevhour = $now - 1;
isa_ok($prevhour, 'Time::Naive::TimeOfDay');
is("$prevhour", '23:59:59', '-1 scalar');

{
  my $now  = Time::Naive::TimeOfDay->new;
  my $then = Time::Naive::TimeOfDay->new( $now + 60 );
  isa_ok($then, 'Time::Naive::TimeOfDay');
  is( $$now+60, $$then, 'Add scalar');
}

{
  my $now  = Time::Naive::TimeOfDay->new;
  my $then = Time::Naive::TimeOfDay->new( $now - 60 );
  isa_ok($then, 'Time::Naive::TimeOfDay');
  is( $$now-60, $$then, 'Subtract scalar');
}

{
  my $thirty  = Time::Naive::TimeOfDay->new('00:00:30');
  is ($thirty * 2, '00:01:00', '*');
  my $hr = Time::Naive::TimeOfDay->new('00:01:00');
  is ($hr / 2, '00:00:30', '/');
  is( $thirty, $hr/2, '*/ returns');
}

{
  # Test for BBC::SMSvisual::Imager::Rader
  my $t = Time::Naive::TimeOfDay->new("10:44:50");
  ok( $t * 1, "$t * 1");
  TODO: {
    local $TODO = "How to handle values > 24 hrs? Fatal?";
    eval {$_ = $t * 10};
    diag "GOT $@";
    ok( !$@, "no error after $t * 10" );
  }
}


# From BBC::SMSvisual::Imager::RadarGD
{
  my $max = Time::Naive::TimeOfDay->new( "00:00:02" );
  isa_ok($max, 'Time::Naive::TimeOfDay', $max);
  my $t = Time::Naive::TimeOfDay->new( "00:00:01" );
  isa_ok($t, 'Time::Naive::TimeOfDay', $t);
  my $a = $max - $t;
 SKIP: {
    skip 'Difference now returns an object', 1;
    is( $a, 1, "Leaves one");
  }
  is( "$a", "00:00:01", "Leaves one");
}


SKIP: {
  skip 'Difference not returns an object', 1;
  is(
    Time::Naive::TimeOfDay->new("00:00:02") -
        Time::Naive::TimeOfDay->new("00:00:01"),
    1, 'Time minus'
  );
}

is(
  q{} . (
    Time::Naive::TimeOfDay->new("00:00:02") -
        Time::Naive::TimeOfDay->new("00:00:01"),
  ), "00:00:01", 'Time minus'
);



# From BBC::SMSvisual::Imager::RadarGD
{
  my $max = Time::Naive::TimeOfDay->new( "18:18:31" );
  isa_ok($max, 'Time::Naive::TimeOfDay', $max);
  my $t = Time::Naive::TimeOfDay->new( "20:48:00" );
  isa_ok($t, 'Time::Naive::TimeOfDay', $t);
 SKIP: {
    skip "Durations are now order sensitive", 1;
    is($max - $t, $t - $max, 'Always positive');
  }
  is( q{}.($max-$t), "-02:29:29", 'Durations are order sensitive' );
  is( q{}.($t-$max), "02:29:29", 'Durations are order sensitive' );
  is(
    q{}.(($max-$t) + ($t-$max)), "00:00:00",
    'Durations are order sensitive'
  );
}

FROM_AGENT: {
    eval {
        Time::Naive::TimeOfDay->new('abc');
    };
    ok $@, 'invalid time detected';
    like $@, qr/'abc' is not a valid ISO 8601 formated time/, 'message ok';
}


FROM_TIME: {
  my $ts1 = Time::Naive::TimeOfDay->new();
  isa_ok($ts1, 'Time::Naive::TimeOfDay', 'blank');

  my $ts2 = Time::Naive::TimeOfDay->new( time );
  isa_ok($ts2, 'Time::Naive::TimeOfDay', 'from time');

  is( $ts1, $ts2, 'new(time) is as default new()' );
}

is(
  Time::Naive::TimeOfDay->new(),
  Time::Naive::TimeOfDay->new( time() ),
  'quick enough?'
);

done_testing;
