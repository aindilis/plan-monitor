package FRDCSA::PlanMonitor;
use Mojo::Base 'Mojolicious';

use Mojo::File qw(curfile);
use Mojo::Home;

use FRDCSA::PlanMonitor::Model::Users;

use Data::Dumper;

our $VERSION = '0.001';

has websockets => sub { {} };

sub plan_monitor_log {
  my ($self,$controller,$message) = @_;
  if ($message and exists $self->websockets->{$controller->session->{user}}) {
    my $newmessage = 'sending to '.$controller->session->{user}.': '.$message;
    # print $newmessage."\n";
    $self->log->debug($newmessage);
    $self->websockets->{$controller->session->{user}}->{C}->send($message);
  }
}

sub startup {
  my $self = shift;

  $self->home(Mojo::Home->new(curfile->sibling('PlanMonitor')));

  # # https://mojolicious.org/perldoc/Mojolicious/Guides/Cookbook

  # Switch to installable "public" directory
  $self->static->paths->[0] = $self->home->child('public');

  # Switch to installable "templates" directory
  $self->renderer->paths->[0] = $self->home->child('templates');

  # Exclude author commands
  $self->commands->namespaces(['Mojolicious::Commands']);


  # Load configuration from hash returned by config file
  $self->plugin('Mobi');
  my $config = $self->plugin('Config');



  # Configure the application
  $self->secrets($config->{secrets});
  # $self->log->handle(\*STDOUT);

  # # http://blogs.perl.org/users/joel_berger/2016/03/super-easy-ssl-certs-for-mojolicious-apps.html

  #  $self->config
  #    (
  #     hypnotoad => {
  # 		   listen => ['https://*:443?cert=/etc/tls/domain.crt&key=/etc/tls/domain.key']
  # 		  },
  #    );

  $self->helper(users => sub { state $users = FRDCSA::PlanMonitor::Model::Users->new });

  # Router
  my $r = $self->routes;

  # $self->routes->route("/")->over(mobile=>1)->to("Mobile#index");

  $r->any('/')->to('login#index')->name('index');

  my $logged_in = $r->under('/')->to('login#logged_in');
  $logged_in->any(['POST','GET'],'/ipm')->to('ipm#index');
  # $logged_in->get('/protected')->to('login#protected');

  $r->get('/logout')->to('login#logout');

  $r->websocket('/act')->to('act#index');
}

1;

=head1 NAME

FRDCSA::PlanMonitor - Plan Monitor based on Interactive Behavior Trees

=head1 DESCRIPTION

This software presently implements a barebones real-time web-based
interactive behavior tree plan monitor.

=head1 SYNOPSIS

This system will take recommendations (such as for instance the
CDC/WHO's guidelines related to the COVID-19 pandemic) compiled into a
behavior tree specification, an interactively walks people through
tasks most likely a mobile phone's web-browser.

Eventually, the user will be able to enter into the interface a task
such as 'go to the grocery store' and the corresponding procedure wll
be found.  The user will then be walked through this procedure, like
an interactive checklist that can branch based on results of tasks.

Currently, there is a default behavior tree specified in the Users
model, which the user will be walked through.  We are working to
expand the kinds of behavior tree nodes available, the loading and
context switching mechanism, etc.

We are releasing early and often in order to successfully release this
system.  It is part of the FRDCSA (https://frdcsa.org), but designed
to be independent of any existing (unreleased) FRDCSA libraries to
make it easier to install.

=head1 AUTHOR

Andrew John Dougherty

=head1 LICENSE

GPLv3

=head1 INSTALLATION

Using C<cpan>:

    $ cpan FRDCSA::PlanMonitor

Manual install:

    $ perl Makefile.PL
    $ make
    $ make install

=cut
