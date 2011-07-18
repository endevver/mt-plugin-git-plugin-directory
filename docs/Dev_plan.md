# Development Plan #

***Note:** I moved the initial contents of this file to their own files:
`Classes.md` and `Use_case_walkthroughs.md`.*

The following is high-level development plan for the plugin:

1. Base plugin function and initial public API endpoints

    * `plugin.cgi`
    * `PluginDirectory`
    * `PluginDirectory::App`
    * `PluginDirectory::App::API`
    * `PluginDirectory::API`
    * `PluginDirectory::API::REST`

2. Plugin Directory item object persistence 

    * `PluginDirectory::Item`

3. Plugin Directory item metadata parsing and validation

    * `PluginDirectory::API::Metadata`
    * `PluginDirectory::Item::Metadata`
    * `PluginDirectory::Item::YAML`
    * `PluginDirectory::Item::YAML::Config`
    * `PluginDirectory::Item::YAML::Plugin`

4. Plugin Directory blog, entries and caching of plugin metadata

    * `PluginDirectory::Blog`
    * `PluginDirectory::Entry`

5. Git repository cloning and management

    * `PluginDirectory::Item::Repository`
    * `PluginDirectory::Client`
    * `PluginDirectory::Client::Git`
    * `PluginDirectory::Client::GitHub`

6. Periodic tasks workers

    * `PluginDirectory::Worker`
    * `PluginDirectory::Worker::Updater`
    * `PluginDirectory::Worker::Validator`
