
use lib qw(t/lib lib extlib plugins/PluginDirectory/lib);

use strict;
use warnings;

BEGIN {
    $ENV{MT_APP} = 'PluginDirectory::App';
}

use MT::Test qw(:app :db :data);
use Test::More tests => 1;

my $json = '{}';
_run_app( 'PluginDirectory::App', { payload => $json } );

# need to check for the entry and deets here

1;
