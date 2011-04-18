package Time::Naive::Duration;

use strict;
use warnings;

use 5.008003;
our $VERSION = '0.0551';
our $FATALS  = 1;

use Carp;
use Scalar::Util qw/looks_like_number blessed/;
use POSIX qw(strftime floor);

use base qw/Time::Naive::TimeOfDay/;

sub _compare {
  my ($self, $x, $reverse) = @_;
  $x = Time::Naive::Duration->new($x)
    unless UNIVERSAL::isa($x, 'Time::Simple');
  my $c = $self->total_seconds <=> $x->total_seconds;
  return $reverse ? -$c : $c;
}

sub new {
  my ($that, @hms) = (@_);
  my $time;

  # mostly stolen from Time::Simple with some modifications
  # to allow time-spans larger than 24h and removing everything
  # pertaining to the current time, it just doesn't make sense
  # to create a duration out of the current time of day in almost
  # all use cases.

  my $class = ref($that) || $that;

  if ( @hms == 1 and ! ref $hms[0] and looks_like_number( $hms[0] ) ) {
    # nuber of secs as default
    $time = $hms[0];
  } elsif (@hms == 1) {
    if (ref $hms[0] eq 'ARRAY') {
      @hms = join':',@{$hms[0]};
    }
    @hms = $hms[0] =~ /^(-?\d{1,})(:\d{1,2})?(:\d{1,2})?$/;
    $hms[1] ||= '00';
    $hms[2] ||= '00';
    s/^:// foreach @hms[1..2];
    if (not defined $hms[0]) {
      if ($FATALS) {
        croak"'$_[1]' is not a valid ISO 8601 formated time" ;
      } else {
        Carp::cluck("'$_[1]' is not a valid ISO 8601 formated time") if $^W;
        return undef;
      }
    }
  }

  if (not defined $time) {
    if (@hms == 3) {
      unless (validate(@hms)){
        if ($FATALS) {
          croak "Could not make a time - please read the documentation";
        } else {
          Carp::cluck("Could not make a time - please read the documentation") if $^W;
          return undef;
        }
      }

      # mktime(sec, min, hour, mday, mon, year, wday = 0, yday = 0, isdst = 0/-1)
      $time = $hms[0] * 3600 + $hms[1] * 60 + $hms[2]
    } elsif ($FATALS) {
      croak "Could not make a time - please read the documentation";
    } else {
      Carp::cluck("Could not make a time - please read the documentation") if $^W;
      return undef;
    }
  }

  Carp::confess("Internal error while creating duration from %s", $time)
      if ref $time or not looks_like_number( $time );

  return bless \$time, $class;
}

sub validate ($$$) {
  my ($h, $m, $s)= @_;
  foreach my $i ( $m, $s ){
    return 0 if $i != abs int $i or $i < 0;
  }
  return 0 unless looks_like_number($h);
  return 0 if $m > 59 or $s > 59;
  return 1;
}

sub hour    { my $t = ${$_[0]}; return int( abs( $t ) / 3600 )}
sub hours   { my $t = ${$_[0]}; return int( abs( $t ) / 3600 )}
sub minute  { my $t = ${$_[0]}; return int( abs( $t ) % 3600 / 60 )}
sub minutes { my $t = ${$_[0]}; return int( abs( $t ) % 3600 / 60 )}
sub second  { my $t = ${$_[0]}; return int( abs( $t ) % 60 )}
sub seconds { my $t = ${$_[0]}; return int( abs( $t ) % 60 )}
sub is_negative { my $t = ${$_[0]}; return $t < 0 }

sub format {
  my $self = shift;
  my $format = shift || '%H:%M:%S';
  # strftime(fmt, sec, min, hour, mday, mon, year, wday = -1, yday = -1, isdst = -1)
  # pp { format => $self, sec => $self->seconds, min =>  $self->minutes, h => $self->hours, };
  my $return = eval{ strftime(
    $format,
    $self->seconds, $self->minutes, $self->hours,
    1, 1, 1970,
  )};
  if ( my $err = $@ ) {
    Carp::confess "You supplied $$self, error is: [$err]";
  };
  return $self->is_negative ? "-${return}" : $return;
}

sub _add {
  my $self = shift;
  my ( $n, $reverse) = @_;
  if (UNIVERSAL::isa($n, 'Time::Naive::Duration')) {
    my $copy = $self->_copy;
    $$copy += $$n;
    return $copy;
  } else {
    $self->SUPER::_add( @_ );
  }
}

sub _multiply {
    my ($self, $n, $reverse) = @_;

    if (UNIVERSAL::isa($n, 'Time::Simple')) {
    Carp::cluck "Cannot multiply a time by a time, only a time by a number.";
  }

  # Convert time to seconds
  my $ss = $self->total_seconds;
  $ss *= $n;
  my @hms = $ss->_mktime_seconds;
  return $self->new( @hms );
}

sub _divide {
    my ($self, $n, $reverse) = @_;

    if (UNIVERSAL::isa($n, 'Time::Simple')) {
    Carp::cluck "Cannot multiply a time by a time, only a time by a number.";
  }

  # Convert time to seconds
  my $ss = $self->total_seconds;
  my $return = $ss /= $n;
  return $self->new( $return );
}

sub total_seconds {
  my $self = shift;
  return int( $$self );
}

1;
