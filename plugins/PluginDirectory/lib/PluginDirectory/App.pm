
package PluginDirectory::App;

use strict;
use warnings;

use base qw(MT::App);

use JSON;

sub id {'plugin_directory'}

sub init { return shift->SUPER::init(@_); }

sub init_request { shift->SUPER::init_request(@_); }

sub submit_repository {
    my $app = shift;

    # how do we determine the blog?
    # just go with the blog_id parameter?

    $app->load_tmpl('submit_repository.tmpl');
}

sub do_submit_repository {
    my $app = shift;

    # need a logged in user here
    my $user = $app->user;

    my $repo_url = $app->query->param('repository_url');

    my $p = $app->{component};

    require MT::Entry;
    my $e = $p->_repo_to_entry($repo_url);
    $e->author_id( $user->id );
    $e->status( MT::Entry::RELEASE() );

    $e->blog_id( $app->blog->id );

    $e->save or die "Error saving entry for plugin: " . $e->errstr;

    $app->rebuild_entry( Entry => $e );

    # some kind of response here, but we can't assume the entry has been built
    # just a thank you template, I suppose

    $app->load_tmpl('repository_submitted.tmpl');
}

# github docs here: http://help.github.com/post-receive-hooks/
#         and here: http://develop.github.com/p/repo.html

sub github_update_ping {
    my $app = shift;

    my $payload = $app->query->param('payload');

    my $payload_hash = decode_json($payload);

    # repository url is *NOT* the git cloning URL
    # I'm thinking just appending .git to the end is enough
    my $repo_url = $payload_hash->{repository}->{url};
    $repo_url
        .= ".git";   # with recent github changes, we probably don't need this

    my $p = $app->{component};

    # get the entry
    my $e = $p->_entry_for_repo($repo_url);

    # if it's new or if it's a draft entry
    # we need to check for tags to determine
    # whether or not we can publish it
    if ( !$e->id || $e->status != MT::Entry::RELEASE() ) {

        # TODO: this needs to get factored out
        my $gh_api_url
            = 'http://github.com/api/v2/json/repos/show/%s/%s/tags';
        $gh_api_url = sprintf $gh_api_url,
            $payload_hash->{repository}->{owner}->{name},
            $payload_hash->{repository}->{name};

        my $ua   = MT->new_ua;
        my $res  = $ua->get($gh_api_url);
        my $json = $res->content;

        my $tag_hash = decode_json($json);
        my @tags = keys %{ $tag_hash->{tags} || {} };
        $e->repository_tags( [@tags] );

        # if there are tags, publish the sucker
        if (@tags) {
            $e->status(MT::Entry::RELEASE);
        }
    }

    # we're getting pinged about the entry's repository
    # we should save no matter what
    # even if something in the entry itself didn't change
    # something in the repository did
    # and somebody might want to rebuild something
    $e->save;

    if ( MT::Entry::RELEASE == $e->status ) {
        require MT::Util;
        MT::Util::start_background_task(
            sub {
                $app->rebuild_entry(
                    Entry             => $e,
                    Force             => 1,
                    BuildDependencies => 1
                );
            }
        );
    }
}

1;
