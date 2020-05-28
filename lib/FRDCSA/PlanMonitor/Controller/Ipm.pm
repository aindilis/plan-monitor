package FRDCSA::PlanMonitor::Controller::Ipm;
use Mojo::Base 'Mojolicious::Controller';

use Data::Dumper;

sub index {
  my $self = shift;
  my $user = $self->session->{user};
}

1;
