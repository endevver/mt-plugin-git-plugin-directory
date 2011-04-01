package PluginDirectory::Plugin;

use strict;
use warnings;

use base qw(MT::Plugin);
use File::Spec;

sub _entry_for_repo {
    my $p = shift;
    my ($url) = @_;

    require MT::Entry;
    my @e = MT::Entry->search_by_meta( 'repository_url', $url );
    if ( !@e ) {
        $e[0] = $p->_repo_to_entry($url);
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

    # git can complain about existing directories
    $tmp_dir = File::Spec->catdir( $tmp_dir, 'gh-repo' );

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
    if (   $p_hash->{readme_ext} eq 'md'
        || $p_hash->{readme_ext} eq 'markdown' )
    {
        $e->convert_breaks('markdown');
    }

    $e->repository_url($url);

    # The Blog ID
    $e->blog_id( MT->config->PluginDirectoryBlogID );

    # The Author
    # TODO: In the future, offer option to auto-create authors in MT/Melody
    #       and load by email address from the github ping payload
    $e->author_id( MT->config->PluginDirectoryAuthorID );

    # Default status is draft
    $e->status( MT::Entry::HOLD() );
    return $e;
}

sub _plugin_to_hash {
    my $p = shift;
    my ($dir) = @_;

    # find the config.yaml file
    # and README(.*) file
    # and ignore anything in a /t/ directory
    # just in case
    require File::Find;

    my $p_hash;
    my $readme_txt;
    my $readme_ext;
    my $wanted = sub {
        my $file = $_;
        my $name = $File::Find::name;
        if (   $file =~ /^config\.yaml\z/s
            && $name !~ m{/t/.*config\.yaml\z}s )
        {

            # this doesn't take into account
            # multiple config.yaml files
            # in a plugin (rare, but possible)

            require YAML::Tiny;
            my $y = YAML::Tiny->read($name) or die YAML::Tiny->errstr;
            $p_hash = $y->[0];
        }
        elsif ($name !~ m{/t/.*README.*\z}s
            && $file =~ /^README(?:\.(\w+))\z/s )
        {
            $readme_ext = $1;
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
    $p_hash->{readme_ext}  = $readme_ext if $readme_ext;
    return $p_hash;
}

1;
__END__
