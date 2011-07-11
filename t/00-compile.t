
use lib qw(t/lib lib extlib);

use strict;
use warnings;

use MT::Test;
use Test::More tests => 3;

require MT;
ok(MT->component('PluginDirectory'), "Plugin Directory plugin successfully loads");
require_ok('PluginDirectory::Plugin');
require_ok('PluginDirectory::App');

1;
