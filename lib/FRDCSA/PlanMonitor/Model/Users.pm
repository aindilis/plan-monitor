package FRDCSA::PlanMonitor::Model::Users;

# use FRDCSA::PlanMonitor::Model::User;

use strict;
use warnings;

use Mojo::Util qw(secure_compare);

my $USERS = {
  aindilis      => 'changeme',
};

sub new { bless {}, shift }

sub check {
  my ($self, $user, $pass) = @_;

  # Success
  return 1 if $USERS->{$user} && secure_compare $USERS->{$user}, $pass;

  # Fail
  return undef;
}

1;
