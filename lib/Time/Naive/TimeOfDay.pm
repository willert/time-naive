package Time::Naive::TimeOfDay;

use strict;
use warnings;

use 5.008003;

use base qw/Time::Simple/;

use Carp;
use Scalar::Util qw/looks_like_number blessed/;
use Time::Naive::Duration;

sub _subtract {
  my $self = shift;
  my ( $n, $reverse) = @_;
  if ( UNIVERSAL::isa($n, 'Time::Simple')) {
    my $diff = $$self - $$n;
    # pp { diff => $diff };
    my $ret = Time::Naive::Duration->new( $reverse ? -$diff : $diff );
    # pp { diff => $diff, returns => $ret };
    return $ret;
  } else {
    my $ret = $self->SUPER::_subtract( @_ );
    # pp { returns => $ret };
    return $ret;
  }
}

sub until {
  my ( $self, $x ) = @_;
  my $res = $x - $self;
  $res += 60 * 60 * 24 if $res < 0;
  return $res;
}

1;
