
use lib qw(t/lib lib extlib plugins/PluginDirectory/lib);

use strict;
use warnings;

BEGIN {
    $ENV{MT_APP} = 'PluginDirectory::App';
}

use MT::Test qw(:app :db :data);
use Test::More tests => 6;

my $json = q!{
  "after": "09fc914268eb17b5515ed2ac154374c03d4f4fc7", 
  "base": null, 
  "before": "bf80e6e863a45bd97550995e628cfa2ba27728b9", 
  "commits": [
    {
      "added": [], 
      "author": {
        "email": "rayners@gmail.com", 
        "name": "David Raynes", 
        "username": "rayners"
      }, 
      "distinct": true, 
      "id": "49f7ad25de66de4c1586641b1c34c4ede8b3ef9c", 
      "message": "Sketched out starter bits for the plugin directory app", 
      "modified": [
        "plugins\/PluginDirectory\/config.yaml"
      ], 
      "removed": [], 
      "timestamp": "2011-03-14T19:21:03-07:00", 
      "url": "https:\/\/github.com\/rayners\/mt-plugin-git-plugin-directory\/commit\/49f7ad25de66de4c1586641b1c34c4ede8b3ef9c"
    }, 
    {
      "added": [
        "plugins\/PluginDirectory\/t\/20-github.t"
      ], 
      "author": {
        "email": "rayners@gmail.com", 
        "name": "David Raynes", 
        "username": "rayners"
      }, 
      "distinct": true, 
      "id": "09fc914268eb17b5515ed2ac154374c03d4f4fc7", 
      "message": "Initial skeleton for github update ping test", 
      "modified": [], 
      "removed": [], 
      "timestamp": "2011-03-14T19:21:21-07:00", 
      "url": "https:\/\/github.com\/rayners\/mt-plugin-git-plugin-directory\/commit\/09fc914268eb17b5515ed2ac154374c03d4f4fc7"
    }
  ], 
  "compare": "https:\/\/github.com\/rayners\/mt-plugin-git-plugin-directory\/compare\/bf80e6e...09fc914", 
  "created": false, 
  "deleted": false, 
  "forced": false, 
  "pusher": {
    "email": "rayners@gmail.com", 
    "name": "rayners"
  }, 
  "ref": "refs\/heads\/master", 
  "repository": {
    "created_at": "2010\/10\/15 06:06:30 -0700", 
    "description": "A plugin framework for hosting a super simple, git-backed, software directory.", 
    "fork": true, 
    "forks": 0, 
    "has_downloads": true, 
    "has_issues": false, 
    "has_wiki": false, 
    "homepage": "", 
    "language": "Perl", 
    "name": "mt-plugin-git-plugin-directory", 
    "open_issues": 0, 
    "owner": {
      "email": "rayners@gmail.com", 
      "name": "rayners"
    }, 
    "private": false, 
    "pushed_at": "2011\/03\/14 19:21:25 -0700", 
    "size": 212, 
    "url": "https:\/\/github.com\/rayners\/mt-plugin-git-plugin-directory", 
    "watchers": 4
  }

}!;

require MT::Entry;
is( MT::Entry->count( { title => 'Plugin Directory' } ),
    0, "No entries for the Plugin Directory plugin yet" );

_run_app( 'PluginDirectory::App', { payload => $json } );

is( MT::Entry->count( { title => 'Plugin Directory' } ),
    1, "Now there is an entry for the Plugin Directory plugin" );

# need to check for the entry and deets here
my $e = MT::Entry->load( { title => 'Plugin Directory' } );

# TODO: this test isn't going to work long term
#       since there will eventually be a tag
is( $e->status, MT::Entry::HOLD(),  "Entry is draft" );
is( $e->title,  "Plugin Directory", "Entry has the correct title" );
is( $e->excerpt,
    "A framework for deploying a plugin directory powered by git.",
    "Entry has the correct excerpt"
);

my $readme_txt;
{
    local $/ = undef;
    $readme_txt = <DATA>;
}

# TODO: Append new-line to README
is( $e->text . "\n", $readme_txt, "Entry has the correct text" );

1;

__DATA__
This plugin provides a simple framework for deploying a git-powered
plugin directory.

# Installation

To install this plugin follow the instructions found here:

http://tinyurl.com/easy-plugin-install

# About Endevver

We design and develop web sites, products and services with a focus on 
simplicity, sound design, ease of use and community. We specialize in 
Movable Type and offer numerous services and packages to help customers 
make the most of this powerful publishing platform.

http://www.endevver.com/

# Copyright

Copyright 2009-2010, Endevver, LLC. All rights reserved.

# License

This plugin is licensed under the same terms as Perl itself.
