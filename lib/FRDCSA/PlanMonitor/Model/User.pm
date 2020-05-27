package FRDCSA::PlanMonitor::Model::User;
use Mojo::Base -base;

use strict;
use warnings;

use Mojo::Util qw(secure_compare);

use Data::Dumper;

has 'username';
has 'tree';

sub proceed {
  my ( $self ) = @_;
  my $res = $self->tree->proceed();
  print Dumper({Res => $res});
}

1;
