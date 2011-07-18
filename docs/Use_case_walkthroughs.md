# Use case walkthroughs #

## New submission by plugin author or helpful fan ##

1. User registers and/or authenticates with system (email confirmation???)

2. User clicks "Submit plugin" somewhere on site. Presented with a form
containing only:

    * A text input box for Git clone URL
    * An unchecked checkbox for "Proxy submission: I am submitting on someone
      else's behalf"
    * A submit button

   ***Note:** If email is not confirmed on registration, perhaps we should
   stress NOW that a valid email in your profile is very important because of
   asynchronous processing and notification? And perhaps have a "test email"
   button there?*

3. Upon submission, the Git URL is checked for validity and response.
Immediately return an error if we encounter one so the user can fix their
mistake. Otherwise...

4. A `PluginDirectory::Item` object is created with the following fields
populated:

    id                auto increment
    author_id         proxy submission ? undef : current user's ID
    git_url           From the form
    created_by        Submitter's author ID
    created_on        `now()`

5. An `PluginDirectory::Worker::Validator` job is added to the RPT queue with
a param of the value of `pd_item.id`

6. User is redirected to the "pending validation" landing page informing them
that they will receive a notification when the validation process is complete

7. *[Time passes until job is picked up by RPT....]*

8. `PluginDirectory::Item` loaded from job parameters

9. Check `valid_on`.  If set, abort processing and delete job

10. Clone the plugin's repo

11. Grep `plugin.yaml` for the `version_tag` key. Use its value as the ref for
`git checkout`

12. Parse `plugin.yaml` YAML

13. Locate `config.yaml` using `config_yaml_path` or look in the root of repo.

14. Parse `config.yaml` YAML

15. In addition to the separate YAML objects, create a merged YAML object
giving precedence to settings in `plugin.yaml`

16. Run the YAML and the repo through battery of validation tests.
**Examples?**

17. During this process, cached validated metadata in a newly created entry
object

18. **In case of complete success**

    * a. Set `pd_item.basename` and `$entry->basename` to string derived from
      repo metadata

    * b. If `pd_item.author_id` is null set to default PD `author_id`

    * c. Save entry as DRAFT and set `pd_item.entry_id` with `entry_id`

    * d. In `mt_pd_item`, update `status` and assign `now()` to `status_on`,
      `valid_on` and `scanned_on`

    * e. Send notification to PluginDirectory moderators and a status update
      to submitter

   **In case of failure at any point**

    * a. Undefine the entry object where repo information had been cached

    * b. Set `status`, `status_on` in pd_item record

    * c. Send notification of FAIL to submitter


## Alteration of a plugin's Git clone URL of record ##

A user needs to update their Git clone URL on record because it has changed
for whatever reason: moved Git host providers, transferred ownership of plugin
to another or changed its name and that altered the Git URL, etc

1. Once authenticated, User initiates action somewhere in UI which gets
him/her to a screen with the same fields as the submission screen.

2. User edits the Git clone URL and perhaps modifies the Proxy submission box
and submits. Any change in the Git clone URL must be revalidated since it is
the source of all of our features and information about the plugin.

3. Set `valid_on` to NULL and save PluginDirectory::Item object

4. If entry_id is set, load entry.  If published, unpublish it.

5. Add an `PluginDirectory::Worker::Validator` job to the RPT queue with a
param of the value of `pd_item.id` and, if the entry status changed from
published in the previous step, an `republish_entry` boolean parameter set to
true.

4. Continue at step #6 in the previous walkthrough

5. Once everything is done, if the outcome at #18 was success and if the job
params contained a true value for `republish_entry`, then republish the entry
in `$pditem->entry_id`

## Plugin submission moderation process ##

TODO

## A plugin author claims his plugin submitted by proxy ##

TODO

## GitHub service hook ping upon repository update ##

TODO
