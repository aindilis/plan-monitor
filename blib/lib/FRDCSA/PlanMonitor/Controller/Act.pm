package FRDCSA::PlanMonitor::Controller::Act;
use Mojo::Base 'Mojolicious::Controller';

use Mojo::IOLoop;
use Mojo::JSON qw(decode_json encode_json);

use Data::Dumper;

my $controller;
my $tx;

sub index {
  my ($c) = @_;

  $controller = $c;
  $tx = $c->tx;

  $c->app->log->debug('WebSocket opened');

  # Increase inactivity timeout for connection a bit
  $c->inactivity_timeout(300);

  # Incoming message
  $c->on
    (message => sub {
       my ($c, $json) = @_;
       print Dumper({JSON => $json});
       my $hash = decode_json($json);
       # this is where we handle the state update
       # node name, $action
       # update the bahavior tree

       my $state_update = [input => $hash];
       # my @requests = $c->users->{$c->session->{username}}->tree->Blackboard->UpdateState
       # 	 (
       # 	  StateUpdate => FRDCSA::BehaviorTree::Blackboard::StateUpdate->new
       # 	  (
       # 	   Update => $hash,
       # 	  ),
       # 	 );
       # do a response based on this
       Mojo::IOLoop->timer
	   (2 => sub ($c) {
	      $c->send('hello there');
	    });
       $c->send('action: '.$hash->{action});
     });

  # Closed
  $c->on
    (finish => sub {
       my ($c, $code, $reason) = @_;
       $c->app->log->debug("WebSocket closed with status $code");
     });

  # $c->users->{$c->session->{username}}->
}

1;
