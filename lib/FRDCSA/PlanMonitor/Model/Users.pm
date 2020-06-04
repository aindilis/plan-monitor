package FRDCSA::PlanMonitor::Model::Users;
use Mojo::Base -base;

use strict;
use warnings;

use FRDCSA::PlanMonitor::Model::User;

use FRDCSA::BehaviorTreePlanMonitor;
use FRDCSA::BehaviorTreePlanMonitor::Blackboard;
use FRDCSA::BehaviorTreePlanMonitor::Node::Root;
use FRDCSA::BehaviorTreePlanMonitor::Node::Sequence;
use FRDCSA::BehaviorTreePlanMonitor::Node::Selector;
use FRDCSA::BehaviorTreePlanMonitor::Node::UserTask;

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
  my $bt = FRDCSA::BehaviorTreePlanMonitor->new
    (
     # Controller => $c,
     Blackboard => FRDCSA::BehaviorTreePlanMonitor::Blackboard->new(),

     Root => FRDCSA::BehaviorTreePlanMonitor::Node::Root->new
     (
      Children => [
     		   FRDCSA::BehaviorTreePlanMonitor::Node::Sequence->new
     		   (Children =>
     		    [
     		     FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Walk to Door'),
		     FRDCSA::BehaviorTreePlanMonitor::Node::Selector->new
		     (Children =>
		      [
		       FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Open Door'),
		       FRDCSA::BehaviorTreePlanMonitor::Node::Sequence->new
		       (Children =>
			[
			 FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Unlock Door'),
			 FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Open Door'),
			]),
		       FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Smash Door'),
		      ]),
     		     FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Walk through Door'),
     		     FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Close Door'),
     		    ],
     		   ),
     		  ],
     ),

     # Root => FRDCSA::BehaviorTreePlanMonitor::Node::Root->new
     # (
     #  Children => [
     # 		   FRDCSA::BehaviorTreePlanMonitor::Node::Sequence->new
     # 		   (Children =>
     # 		    [
     # 		     FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Make shopping list'),
     # 		     FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Print out shopping and instruction lists'),
     # 		     FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Clear off dining room table'),
     # 		     FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Eat beforehand'),
     # 		     # FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Make all preparations'),
     # 		     # FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Wait until 11 30 pm to leave'),
     # 		     # FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Put gloves on before leaving house'),
     # 		     # FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Bring water bottles to refill'),
     # 		     # FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Wear masks'),
     # 		     # FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Leave house'),
     # 		     # FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Get in car'),
     # 		     # FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Check gas level'),
     # 		     # FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Drive to Walmart'),
     # 		     # FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Are lots of people there'),
     # 		     # FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Are they out of inventory'),
     # 		     # FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Walk into Walmart'),
     # 		     # FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Start shopping'),
     # 		     # FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Get extra 5 gal jugs'),
     # 		     # FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Use self checkout'),
     # 		     # FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Finish shopping'),
     # 		     # FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Drive home'),
     # 		     # FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Put food in staging area'),
     # 		     # FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Decontaminate food with bleach solution'),
     # 		     # FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Remove gloves and masks'),
     # 		     # FRDCSA::BehaviorTreePlanMonitor::Node::UserTask->new(Description => 'Dispose properly of gloves and masks'),
     # 		    ],
     # 		   ),
     # 		  ],
     # ),
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
  $self->users->{$username}->BTStop();
}

1;
