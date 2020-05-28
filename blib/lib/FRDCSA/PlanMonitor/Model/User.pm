package FRDCSA::PlanMonitor::Model::User;
use Mojo::Base -base;

# FRDCSA::BehaviorTree

use strict;
use warnings;

use Mojo::Util qw(secure_compare);

use Data::Dumper;

has 'username';
has 'tree';

sub BTStart {
  my ( $self ) = @_;
  my $res = $self->tree->Start();
  if ($res) {
    $self->tree->Log(Message => 'BTStartRes: '.$res);
  } else {
    $self->tree->Log(Message => 'BTStartRes.');
  }
}

sub BTStop {
  my ( $self ) = @_;
  my $res = $self->tree->Stop();
  if ($res) {
    $self->tree->Log(Message => 'BTStopRes: '.$res);
  } else {
    $self->tree->Log(Message => 'BTStopRes.');
  }
}

1;
