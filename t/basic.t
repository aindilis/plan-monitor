use Mojo::Base -strict;

use Data::Dumper;
use IO::File;

use Test::More;
use Test::Mojo;

my $t = Test::Mojo->new('FRDCSA::PlanMonitor');
$t->get_ok('/')->status_is(200)->content_like(qr/Name:/i)->content_like(qr/Password:/i);

# try logging in
$t->post_ok('/' => form => {user => 'aindilis', pass => 'changeme'})
  ->status_is(302);

$t->get_ok('/ipm')
  ->status_is(200)
  ->content_like(qr/Interactive Plan Monitor/i);

# my $res = $t->websocket_ok('/act')
#   ->send_ok({json => {'action' => 'startup'}});

$t->get_ok('/ipm')
  ->status_is(200)
  ->content_like(qr/Interactive Plan Monitor/i);

my $content = $t->tx->res->text();
if ($content =~ /<b>Task Name:<\/b> <span id="task-name" align="center">(.*?)<\/span><br>/) {
  print $1."\n";
  # my $text = $t->websocket_ok('/act')
  #   ->send_ok({json => {'action' => 'update','value' => 'done','name' => $1}})
  #   ->message_ok->res->text();
  # print Dumper({Text => $text});
}

done_testing();
