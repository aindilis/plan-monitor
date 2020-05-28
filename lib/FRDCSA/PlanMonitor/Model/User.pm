package FRDCSA::PlanMonitor::Model::User;
use Mojo::Base -base;

use strict;
use warnings;

use Mojo::AsyncAwait;
use Mojo::Util qw(secure_compare);

use Time::HiRes qw(usleep);

use Data::Dumper;

has 'username';
has 'tree';

my $websocket;

sub BTStart {
  my ( $self, $c ) = @_;
  my $res = $self->tree->Start();
  print Dumper({BTStartRes => $res});
}

sub BTStop {
  my ( $self, $status ) = @_;
  my $res = $self->tree->Stop(Status => $status);
  print Dumper({BTStopRes => $res});
}

1;
