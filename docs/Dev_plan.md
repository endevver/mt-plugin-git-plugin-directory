# Development Plan #

***Note:** I moved the initial contents of this file to their own files:
`Classes.md` and `Use_case_walkthroughs.md`.*

The following is high-level development plan for the plugin:

1. Base plugin function and initial public API endpoints **(30 hours)**

    * `plugin.cgi`
    * `PluginDirectory`
    * `PluginDirectory::App`
    * `PluginDirectory::App::API`
    * `PluginDirectory::API`
    * `PluginDirectory::API::REST`

2. Plugin Directory item object persistence and metadata caching **(10 hours)**

    * `PluginDirectory::Item`
    * `PluginDirectory::Blog`
    * `PluginDirectory::Entry`

3. Plugin Directory item metadata parsing and validation **(30 hours)**

    * `PluginDirectory::API::Metadata`
    * `PluginDirectory::Item::Metadata`
    * `PluginDirectory::Item::YAML`
    * `PluginDirectory::Item::YAML::Config`
    * `PluginDirectory::Item::YAML::Plugin`

4. Git repository cloning and management **(20 hours)**

    * `PluginDirectory::Item::Repository`
    * `PluginDirectory::Client`
    * `PluginDirectory::Client::Git`
    * `PluginDirectory::Client::GitHub`

5. Periodic tasks workers **(20 hours)**

    * `PluginDirectory::Worker`
    * `PluginDirectory::Worker::Updater`
    * `PluginDirectory::Worker::Validator`

6. Final documentation and packaging **(10 hours)**
