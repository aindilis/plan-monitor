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
  $c->inactivity_timeout(1000000);

  # Incoming message
  $c->on
    (message => sub {
       my ($c, $json) = @_;
       $c->app->log->debug('JSON: '.$json);
       my $hash = decode_json($json);
       # this is where we handle the state update
       # node name, $action
       # update the behavior tree
       if ($hash->{action} eq 'startup') {
	 $c->send('Log: '.$hash->{action});
	 $c->users->users->{$c->session->{user}}->BTStart(Controller => $c);
       } elsif ($hash->{action} eq 'search') {
	 $c->send('Log: '.$hash->{action}.':'.$hash->{value});
	 $c->users->users->{$c->session->{user}}->BTSearch(Controller => $c, Text => $hash->{value});
       } elsif (defined $hash->{action}) {
	 $c->send('Log: '.$hash->{action}.':'.$hash->{value});
	 # now process the action
	 $c->users->users->{$c->session->{user}}->tree->Nodes->{$hash->{name}}->UserFeedback($hash);
	 $c->users->users->{$c->session->{user}}->tree->Root->Tick();
       } else {

	 # $c->send();
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
