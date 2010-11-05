package PluginDirectory::Plugin;

use strict;
use warnings;

use base qw(MT::Plugin);

sub _entry_for_repo {
    my $p = shift;
    my ($url) = @_;

    require MT::Entry;
    my @e = MT::Entry->search_by_meta( 'repository_url', $url );
    if ( !@e ) {
        $e[0] = _repo_to_entry($url);
    }

    return $e[0];
}

sub _repo_to_entry {
    my $p = shift;
    my ($url) = @_;

    # grab the configured tempdir
    require MT;
    my $tmp_dir = MT->config->TempDir;

    # generate a temp directory name
    # since we can't clone into an existing directory
    require File::Temp;
    $tmp_dir = File::Temp::tempdir( DIR => $tmp_dir, CLEANUP => 1 );

    # start the cloning process
    require Git::Repository;
    my $r = Git::Repository->create( clone => $url => $tmp_dir );

    # take the plugin dir and build a hash from it
    my $p_hash = $p->_plugin_to_hash($tmp_dir);

    return if !$p_hash;

    require MT::Entry;

    # name => title
    # description => excerpt
    # README => text
    # other bits?
    my $e = MT::Entry->new;
    $e->title( $p_hash->{name} );
    $e->excerpt( $p_hash->{description} );
    $e->text( $p_hash->{readme_text} || $p_hash->{description} );
    $e->repository_url($url);

    return $e;
}

sub _plugin_to_hash {
    my $p = shift;
    my ($dir) = @_;

    # find the config.yaml file
    require File::Find;

    my $p_hash;
    my $readme_txt;
    my $wanted = sub {
        my $file = $_;
        my $name = $File::Find::name;
        if ( $file =~ /^config\.yaml\z/s ) {

            # this doesn't take into account
            # multiple config.yaml files
            # in a plugin (rare, but possible)

            require YAML::Tiny;
            my $y = YAML::Tiny->read($name) or die YAML::Tiny->errstr;
            $p_hash = $y->[0];
        }
        elsif ( $file =~ /^README(?:\.\w+)\z/s ) {
            open( my $readme_fh, "<", $name );
            local $/ = undef;
            $readme_txt = <$readme_fh>;
            close($readme_fh);
        }
    };
    File::Find::find( { wanted => $wanted }, $dir );

    # shove the readme text into the hash
    # if it was found
    $p_hash->{readme_text} = $readme_txt if $readme_txt;
    return $p_hash;
}

1;
__END__
