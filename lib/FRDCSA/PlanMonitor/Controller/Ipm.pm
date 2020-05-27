package FRDCSA::PlanMonitor::Controller::Ipm;
use Mojo::Base 'Mojolicious::Controller';

use Data::Dumper;

sub index {
  my $self = shift;
  my $user_response = $self->param('user-response');
  if (defined $user_response) {
    if ($user_response eq 'done') {

    } elsif ($user_response eq 'failed') {

    } elsif ($user_response eq 'skipped') {

    } elsif ($user_response eq 'postponed') {

    }
  }
  # $self->render(msg => 'Welcome to the Mojolicious real-time web framework!');
}

1;
