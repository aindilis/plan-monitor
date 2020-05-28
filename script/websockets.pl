#!/usr/bin/perl -w

use Mojolicious::Lite;

# Template with browser-side code
get '/' => 'index';

# WebSocket echo service
websocket '/echo' => sub {
  my $c = shift;

  # Opened
  $c->app->log->debug('WebSocket opened');

  # Increase inactivity timeout for connection a bit
  $c->inactivity_timeout(300);

  # Incoming message
  $c->on(message => sub {
	   my ($c, $msg) = @_;
	   $c->send("echo: $msg");
	 });

  # Closed
  $c->on(finish => sub {
	   my ($c, $code, $reason) = @_;
	   $c->app->log->debug("WebSocket closed with status $code");
	 });
};

app->start;
__DATA__

@@ index.html.ep
<!DOCTYPE html>
<html>
    <head><title>Echo</title></head>
    <body>
	<script>
         var ws = new WebSocket('<%= url_for('echo')->to_abs %>');


	 // Incoming messages
	 ws.onmessage = function (event) {
	     document.body.innerHTML += event.data + '<br/>';
	 }
	 ;

	 // Outgoing messages
	 ws.onopen = function (event) {
	     window.setInterval(function () { ws.send('Hello Mojo!') }, 1000);
	 }
	 ;
	</script>
    </body>
</html>
