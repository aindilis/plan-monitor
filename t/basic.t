use Mojo::Base -strict;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('FRDCSA::PlanMonitor');
$t->get_ok('/')->status_is(200)->content_like(qr/Interactive Plan Monitor/i);

done_testing();
