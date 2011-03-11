
use lib qw(t/lib lib extlib);

use strict;
use warnings;

use MT::Test qw(:db :data);
use Test::More tests => 3;
use File::Spec;

# let's test a plugin import

require MT;
my $p = MT->component('PluginDirectory');

my $repo_path = File::Spec->catdir( $p->path, 't', 'repos', 'standard-plugin',
    '.subgit' );
my $e = $p->_repo_to_entry("$repo_path/");

is( $e->title,   'Standard Plugin',   'Plugin name => title' );
is( $e->excerpt, 'A standard plugin', 'Plugin description => excerpt' );
is( $e->text, "This is my testing plugin README file.
", 'Plugin README.md => text'
);

1;
