
use lib qw(t/lib lib extlib);

use strict;
use warnings;

use MT::Test qw(:db :data);
use Test::More tests => 1;
use File::Spec;

# let's test a plugin import

require MT;
my $p = MT->component('PluginDirectory');

my $repo_path = File::Spec->catdir($p->path, 't', 'repos', 'standard-plugin', '.subgit');
print "repo_path = file://$repo_path\n"; 
#my $e = $p->_repo_to_entry("$repo_path/");
my $e = $p->_repo_to_entry('git://github.com/rayners/mt-plugin-messages.git');

use Data::Dumper;
print Dumper($e);

1;
