package FRDCSA::PlanMonitor::Model::Users;
use Mojo::Base -base;

use strict;
use warnings;

use FRDCSA::PlanMonitor::Model::User;

use FRDCSA::BehaviorTree;
use FRDCSA::BehaviorTree::Node::Root;
use FRDCSA::BehaviorTree::Node::Sequence;
use FRDCSA::BehaviorTree::Node::LeafTask;

use Data::Dumper;

use Mojo::Util qw(secure_compare);

has 'creds' => sub {
  return
    {
     aindilis      => 'changeme',
    },
  };

has 'users' => sub { {} };

sub check {
  my ($self, $user, $pass) = @_;

  # Success
  return 1 if $self->creds->{$user} && secure_compare $self->creds->{$user}, $pass;

  # Fail
  return undef;
}

sub setup {
  my ($self, $username) = @_;
  print "Setting up $username\n";
  my $bt = FRDCSA::BehaviorTree->new
     (Root => FRDCSA::BehaviorTree::Node::Root->new
      (
       Children => [
		    FRDCSA::BehaviorTree::Node::Sequence->new
		    (Children =>
		     [
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Make shopping list'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Print out shopping and instruction lists'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Clear off dining room table'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Eat beforehand'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Make all preparations'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Wait until 11 30 pm to leave'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Put gloves on before leaving house'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Bring water bottles to refill'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Wear masks'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Leave house'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Get in car'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Check gas level'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Drive to Walmart'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Are lots of people there'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Are they out of inventory'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Walk into Walmart'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Start shopping'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Get extra 5 gal jugs'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Use self checkout'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Finish shopping'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Drive home'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Put food in staging area'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Decontaminate food with bleach solution'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Remove gloves and masks'),
		      FRDCSA::BehaviorTree::Node::LeafTask->new(Description => 'Dispose properly of gloves and masks'),
		     ],
		    ),
		   ],
      ),
     );

  $self->users->{$username} = FRDCSA::PlanMonitor::Model::User->new
    (
     username => $username,
     tree => $bt,
    );
  print Dumper({User => $self->users->{$username}});
  $self->users->{$username}->BTStart();
}

sub destroy {
  my ($self, $username, $status) = @_;
  $self->users->{$username}->BTStop($status);
}

1;
