# PluginDirectory plugin classes #

The following is a list of the PluginDirectory plugin's expected classes and
their descriptions:

* `PluginDirectory`

  This plugin's `MT::Plugin` subclass and value for `plugin_class` key.

* `PluginDirectory::App`

  An MT::App subclass providing handlers for public access to the plugin
  directory.

* `PluginDirectory::App::API`

  A subclass of `PluginDirectory::App` which provides handlers for the REST
  API.

* `PluginDirectory::API`

  The base class for the Plugin Directory's API classes

* `PluginDirectory::API::Metadata`

  A subclass of `PluginDirectory::API` which defines the Plugin Directory's
  Metadata API.

* `PluginDirectory::API::REST`

  A subclass of `PluginDirectory::API` which defines the Plugin Directory's
  REST API.

* `PluginDirectory::Blog`

  An MT::Blog subclass which represents the blog used as a container for
  Plugin Directory entries. The design of this plugin assumes there will not
  be multiple Plugin Directory blogs within the same MT/Melody installation.

* `PluginDirectory::Client`

  Base class for all `PluginDirectory::Client` subclasses.

* `PluginDirectory::Client::Git`

   A class which provides client methods for interacting with a local Git
   repository

* `PluginDirectory::Client::GitHub`

  A class which provides client methods for interacting with GitHub's web
  services API.

* `PluginDirectory::Entry`

  A subclass of MT::Entry with extra capabilities and intelligence. This class
  will play a critical role in marshaling all of the metadata and information
  gathered about a PluginDirectory::Item into and out of an entry record and,
  surely, a large number of `MT::Entry::Meta` records which it will define.

* `PluginDirectory::Item`

  An MT::Object subclass whose records represent plugins submitted for
  inclusion in the Plugin Directory. See following section for expected
  properties.

* `PluginDirectory::Item::Metadata`

  A metadata object class containing methods for locating, consuming, merging
  and reporting plugin metadata values from
  `PluginDirectory::Item::YAML::Config` and
  `PluginDirectory::Item::YAML::Plugin` objects. This may be later renamed to
  `PluginDirectory::Item::Repository::Metadata`

* `PluginDirectory::Item::YAML`

  A base class for `PluginDirectory::Item::YAML::Config` and
  `PluginDirectory::Item::YAML::Plugin` containing methods consuming plugin
  YAML files. This may be later renamed to
  `PluginDirectory::Item::Repository::YAML`

* `PluginDirectory::Item::YAML::Config`

  A subclass of `PluginDirectory::Item::YAML` which represents a plugin's
  `config.yaml` file. It contains methods for validating its contents to
  ensure that it meets our requirements. This may be later renamed to
  `PluginDirectory::Item::Repository::YAML::Config`.

* `PluginDirectory::Item::YAML::Plugin`

  Same as above but for `plugin.yaml` files.

* `PluginDirectory::Item::Repository`

  A class which represents a remote repository specified by the `git_url`
  value of each `PluginDirectory::Item`.

* `PluginDirectory::Worker`

  A subclass of `TheSchwartz::Worker` and base class for all
  `PluginDirectory::Worker::*` classes

* `PluginDirectory::Worker::Updater`

  A subclass of `PluginDirectory::Worker` responsible for responding to update
  pings from remote Git repositories and checking for possible updates, new
  releases, etc.

* `PluginDirectory::Worker::Validator`

   TheSchwartz::Worker subclass responsible for carrying out the process of
   validating all new Git remote repositories (i.e. `git_url`)

## `PluginDirectory::Item` properties ##

* `child_of:        MT::Blog`
* `child_classes:   MT::Entry`
* `datasource:      pd_item`
* `primary_key:     id`
* `audit:           1`
* `meta:            1`
* `columns`
    * `id           integer not null auto_increment`
    * `basename     string(255)`
    * `author_id`
    * `entry_id`
    * `git_url      string(255) not null`
    * `status       string(255)`
    * `in_process`
    * `status_on`
    * `pinged_on`
    * `validated_on`
    * `validator_jobid`
    * `updater_jobid`
    * `scanned_on`
    * `created_by`
    * `created_on`
    * `modified_by`
    * `modified_on`
* `indexes`
    * `basename`
    * `entry_id`
    * `author_id`
    * `validated_on`
    * `scanned_on`
    * `created_by`
    * `created_on`
    * `modified_by`
    * `modified_on`
