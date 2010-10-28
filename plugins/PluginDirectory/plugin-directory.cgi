#!/usr/bin/env perl

use strict;
use warnings;

use lib 'plugins/PluginDirectory/lib';
use lib $ENV{MT_HOME} ? "$ENV{MT_HOME}/lib" : 'lib';
use MT::Bootstrap App => 'PluginDirectory::App';

1;

