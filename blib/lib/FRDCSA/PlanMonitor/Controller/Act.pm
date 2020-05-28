package FRDCSA::PlanMonitor::Controller::Act;
use Mojo::Base 'Mojolicious::Controller';

use Mojo::IOLoop;
use Mojo::JSON qw(decode_json encode_json);

use Data::Dumper;

has send_message => 0;

my $controller;
my $tx;

sub index {
  my ($c) = @_;
  $c->app->log->debug('WebSocket opened');
  $c->app->websockets->{$c->session->{user}} =
    {
     C => $c,
     TX => $c->tx,
    };

  # Increase inactivity timeout for connection a bit
  $c->inactivity_timeout(300);

  # Incoming message
  $c->on
    (message => sub {
       my ($c, $json) = @_;
       $c->app->log->debug('JSON: '.$json);
       my $hash = decode_json($json);
       # this is where we handle the state update
       # node name, $action
       # update the bahavior tree

       if ($hash->{action} eq 'startup') {
	 $c->send('action: '.$hash->{action});
	 $c->users->users->{$c->session->{user}}->BTStart(Controller => $c);
       } else {
	 my $state_update = [input => $hash];
	 # my @requests = $c->users->{$c->session->{username}}->tree->Blackboard->UpdateState
	 # 	 (
	 # 	  StateUpdate => FRDCSA::BehaviorTree::Blackboard::StateUpdate->new
	 # 	  (
	 # 	   Update => $hash,
	 # 	  ),
	 # 	 );
	 # do a response based on this
	 $c->send('action: '.$hash->{action});
       }
     });

  # Mojo::IOLoop->timer
  # 	   (2 => sub ($c) {
  # 	      $c->send('hello there');
  # 	    });

  # Closed
  $c->on
    (finish => sub {
       my ($c, $code, $reason) = @_;
       $c->app->log->debug("WebSocket closed with status $code");
     });
}

1;
