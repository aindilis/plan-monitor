package FRDCSA::PlanMonitor::Model::User;
use Mojo::Base -base;

# FRDCSA::BehaviorTree

use strict;
use warnings;

use Mojo::Util qw(secure_compare);

use Data::Dumper;

has 'username';
has 'tree';
has 'trees';

sub BTStart {
  my ( $self, %args ) = @_;
  # choose the tree (randomly for now)
  my $count = scalar keys %{$self->trees};
  my $treename = [sort keys %{$self->trees}]->[int(rand($count))];
  print "Choosing Randomly (for now): $treename\n";
  $self->tree($self->trees->{$treename});
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
