package FRDCSA::PlanMonitor::Model::User;
use Mojo::Base -base;

# FRDCSA::BehaviorTree

use strict;
use warnings;

use Mojo::Util qw(secure_compare);

use Data::Dumper;
use Text::Levenshtein qw(distance);

has 'username';
has 'tree';
has 'trees';

sub BTStart {
  my ( $self, %args ) = @_;
  # choose the tree (randomly for now)
  my $count = scalar keys %{$self->trees};
  my $treename;
  if (1) {
    my $treenames = [sort keys %{$self->trees}];
    print Dumper({TreeNames => $treenames});
    $treename = $treenames->[int(rand($count))];
    print "Choosing Randomly (for now): $treename\n";
  } else {
    $treename = 'root';
  }
  $self->BTLoad
    (
     Name => $treename,
     Controller => $args{Controller},
    );
}

sub BTLoad {
  my ( $self, %args ) = @_;
  $self->tree($self->trees->{$args{Name}});
  if ($args{Controller}) {
    $self->tree->Controller($args{Controller});
  }
  $self->tree->Start();
}

sub BTSearch {
  my ( $self, %args ) = @_;
  my $bestdistance = 999999;
  my $bestname = 'root';
  foreach my $name (keys %{$self->trees}) {
    my $distance = distance($args{Text},$name);
    if ($distance < $bestdistance) {
      $bestdistance = $distance;
      $bestname = $name;
    }
  }
  print "Choosing Closest Match: $bestname\n";
  $self->BTLoad
    (
     Name => $bestname,
     Controller => $args{Controller},
    );
}

sub BTStop {
  my ( $self, %args ) = @_;
  $self->tree->Stop();
}

1;
