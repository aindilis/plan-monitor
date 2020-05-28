package FRDCSA::PlanMonitor::Controller::Login;
use Mojo::Base 'Mojolicious::Controller';

use Data::Dumper;

sub index {
  my $self = shift;

  my $user = $self->param('user') || '';
  my $pass = $self->param('pass') || '';
  return $self->render unless $self->users->check($user, $pass);

  $self->session(user => $user);
  $self->flash(message => 'Thanks for logging in.');
  $self->users->setup($user);

  $self->redirect_to('ipm');
}

sub logged_in {
  my $self = shift;
  return 1 if $self->session('user');
  $self->redirect_to('index');
  return undef;
}

sub logout {
  my $self = shift;
  print Dumper({Session => $self->session});
  $self->users->destroy($self->session->{'user'},'success');
  $self->session(expires => 1);
  $self->redirect_to('index');
}

1;
