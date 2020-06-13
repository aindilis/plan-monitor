package FRDCSA::PlanMonitor::Model::Users;
use Mojo::Base -base;

use strict;
use warnings;

use FRDCSA::PlanMonitor::Model::User;
use FRDCSA::BehaviorTreePlanMonitor;
use FRDCSA::BehaviorTreePlanMonitor::Blackboard;
use FRDCSA::BehaviorTreePlanMonitor::Parser;
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
  my $bt;
  if (0) {
    my $parser = FRDCSA::BehaviorTreePlanMonitor::Parser->new();
    my $res1 = $parser->Parse(Files => ['./script/pmparser/test.btpm']);
    if ($res1->{Success}) {
      $bt = $res1->{BehaviorTree};
    } else {
      # throw error
    }
  } else {
    $bt = FRDCSA::BehaviorTreePlanMonitor->new
      (
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
      );
  }
  $self->users->{$username} = FRDCSA::PlanMonitor::Model::User->new
    (
     username => $username,
     tree => $bt,
    );
  $c->app->log->debug('User: '.$username); # Dumper($self->users->{$username}));
}

sub destroy {
  my ($self, $username, $status) = @_;
  if (defined $username and defined $self->users->{$username}) {
    $self->users->{$username}->BTStop();
  }
}

1;
