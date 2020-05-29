package FRDCSA::PlanMonitor::Model::Users;
use Mojo::Base -base;

use strict;
use warnings;

use FRDCSA::PlanMonitor::Model::User;

use FRDCSA::BehaviorTree;
use FRDCSA::BehaviorTree::Blackboard;
use FRDCSA::BehaviorTree::Node::Root;
use FRDCSA::BehaviorTree::Node::Sequence;
use FRDCSA::BehaviorTree::Node::UserTask;

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
  my ($self, $c, $username) = @_;
  print "Setting up $username\n";
  my %args =
    (
     StartCallback => sub {
       # send out riders, gondor will answer

       # when an action starts, send a notification via websockets to
       # the client, to display that node
     },
    );
  my $bt = FRDCSA::BehaviorTree->new
    (
     # Controller => $c,
     Blackboard => FRDCSA::BehaviorTree::Blackboard->new(),
     Root => FRDCSA::BehaviorTree::Node::Root->new
     (
      Children => [
		   FRDCSA::BehaviorTree::Node::Sequence->new
		   (Children =>
		    [
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Make shopping list'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Print out shopping and instruction lists'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Clear off dining room table'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Eat beforehand'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Make all preparations'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Wait until 11 30 pm to leave'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Put gloves on before leaving house'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Bring water bottles to refill'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Wear masks'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Leave house'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Get in car'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Check gas level'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Drive to Walmart'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Are lots of people there'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Are they out of inventory'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Walk into Walmart'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Start shopping'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Get extra 5 gal jugs'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Use self checkout'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Finish shopping'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Drive home'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Put food in staging area'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Decontaminate food with bleach solution'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Remove gloves and masks'),
		     FRDCSA::BehaviorTree::Node::UserTask->new(%args, Description => 'Dispose properly of gloves and masks'),
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
  $c->app->log->debug('User: '.$username); # Dumper($self->users->{$username}));
}

sub destroy {
  my ($self, $username, $status) = @_;
  $self->users->{$username}->BTStop($status);
}

1;
