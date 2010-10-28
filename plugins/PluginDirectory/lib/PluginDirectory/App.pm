
package PluginDirectory::App;

use strict;
use warnings;

use base MT::App;

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
    my $e = $p->_repo_to_entry ($repo_url);
    $e->author_id($user->id);
    $e->status(MT::Entry::RELEASE());

    $e->blog_id($app->blog->id);

    $e->save or die "Error saving entry for plugin: " . $e->errstr;

    $app->rebuild_entry(Entry => $e);

    # some kind of response here, but we can't assume the entry has been built
    # just a thank you template, I suppose

    $app->load_tmpl('repository_submitted.tmpl');
}

1;
