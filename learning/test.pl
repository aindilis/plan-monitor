#!/usr/bin/perl -w

use Mojo::UserAgent;
use Mojo::IOLoop;
use Mojo::Promise;

# Wrap continuation-passing style APIs with promises
my $ua = Mojo::UserAgent->new;
sub get {
  my $promise = Mojo::IOLoop->delay;
  $ua->get(@_ => sub {
	     my ($ua, $tx) = @_;
	     my $err = $tx->error;
	     if (!$err || $err->{code}) {
	       $promise->resolve($tx);
	     } else {
	       $promise->reject($err->{message});
	     }
	   });
  return $promise;
}
my $cpan = get('https://metacpan.org');
my $mojo = get('https://frdcsa.org');
Mojo::Promise->race($mojo, $cpan)->then(sub { print shift->req->url."\n" })->wait;

# Synchronize multiple non-blocking operations
my $delay = Mojo::IOLoop->delay(sub { print 'BOOM!'."\n" });
for my $i (1 .. 10) {
  my $end = $delay->begin;
  Mojo::IOLoop->timer($i => sub {
			print((10 - $i)."\n");
			$end->();
		      });
}
$delay->wait;

# Sequentialize multiple non-blocking operations
Mojo::IOLoop->delay
  (
   # First step (simple timer)
   sub {
     my $delay = shift;
     Mojo::IOLoop->timer(2 => $delay->begin);
     print 'Second step in 2 seconds.'."\n";
   },

   # Second step (concurrent timers)
   sub {
     my $delay = shift;
     Mojo::IOLoop->timer(1 => $delay->begin);
     Mojo::IOLoop->timer(3 => $delay->begin);
     print 'Third step in 3 seconds.'."\n";
   },

   # Third step (the end)
   sub { print 'And done after 5 seconds total.'."\n" }
  )->wait;
