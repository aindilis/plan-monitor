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
  my ( $self, %args ) = @_;
  if ($args{Controller}) {
    $self->tree->Controller($args{Controller});
  }
  $self->tree->Start();
}

sub BTStop {
  my ( $self, %args ) = @_;
  $self->tree->Stop();
}

1;
