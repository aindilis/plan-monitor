package FRDCSA::PlanMonitor;
use Mojo::Base 'Mojolicious';

use Mojo::File qw(curfile);
use Mojo::Home;

our $VERSION = '0.001';

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
  my $config = $self->plugin('Config');


  # Configure the application
  $self->secrets($config->{secrets});

  # # http://blogs.perl.org/users/joel_berger/2016/03/super-easy-ssl-certs-for-mojolicious-apps.html

  #  $self->config
  #    (
  #     hypnotoad => {
  # 		   listen => ['https://*:443?cert=/etc/tls/domain.crt&key=/etc/tls/domain.key']
  # 		  },
  #    );


  # Router
  my $r = $self->routes;

  # Normal route to controller
  $r->get('/')->to('example#welcome');
}

1;

=head1 NAME

FRDCSA::PlanMonitor - Plan Monitor based on Interactive Behavior Trees

=head1 DESCRIPTION

This software presently does nothing, please do not install it until a
later version, which we will upload ASAP.  We are releasing early and
often in order to successfully release this system.  It is part of the
FRDCSA (https://frdcsa.org), which has historically had trouble being
released properly.

This system will take recommendations such as for instance the
CDC/WHO's guidelines related to the COVID-19 pandemic, and compiles
them into a Behavior Tree specification that can interactively walk
people through tasks via something like a mobile phone's web-browser.

For instance, the user enters into the interface a task such as 'go to
the grocery store'.  The corresponding procedure is found, and the
user is walked through this procedure, like an interactive checklist
that can branch based on results of tasks.

=head1 SYNOPSIS

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
