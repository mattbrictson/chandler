## Next release

* Your contribution here!

## 0.20.1 (2015-05-29)

* An internal change in Capistrano 3.4.0 caused `fiftyfive:aptitude:install` to fail to install packages. This is now fixed.

## 0.20.0 (2015-05-29)

* Increase SSL/TLS security of the generated nginx configuration by following the suggestions of [weakdh.org](https://weakdh.org/sysadmin.html).

## 0.19.0 (2015-04-10)

* Add `--retry=3` to bundle install options. This will help prevent deployment failures in case that a gem initially fails to download during the `bundle install` step.
* Ensure that `--dry-run` works without crashing. This involved working around Capistrano's `download!` behavior (it returns a String normally, but an entirely different object during a dry run).

## 0.18.0

* **The abbreviated log formatter has been removed and is now available in a new gem: `airbrussh`.** With this change, capistrano-fiftyfive no longer automatically changes the logging format of capistrano. To opt into the prettier, more concise format, add the airbrussh gem to your project as explained in the [airbrussh README](https://github.com/mattbrictson/airbrussh#readme).
* The version initializer that capistrano-fiftyfive adds during deployment sets a new value: `Rails.application.config.version_time`. You can use this value within your app for the date and time of the last commit that produced the version that is currently deployed.


## 0.17.2

* Default self-signed SSL certificate is now more generic (for real this time).

## 0.17.1

* Cosmetic changes to the gemspec.

## 0.17.0

* Write a banner message into `capistrano.log` at the start of each cap run, to aid in troubleshooting.
* Default self-signed SSL certificate is now more generic.

## 0.16.0

* capistrano-fiftyfive now requires capistrano >= 3.3.5 and sshkit => 1.6.1
* `ask_secretly` has been removed in favor of Capistrano's built-in `ask ..., :echo => false`
* `agree` no longer takes an optional second argument
* highline dependency removed
* Install libffi-dev so that Ruby 2.2.0 can be compiled

## 0.15.2

* The capistrano-fiftyfive GitHub repository has changed: it is now <https://github.com/mattbrictson/capistrano-fiftyfive>.

## 0.15.1

* Remove `-j4` bundler flag

## 0.15.0

* Dump useful troubleshooting information when a deploy fails.
* Nginx/unicorn: fix syntax errors introduced by changes in 0.14.0, ensuring that gzip and far-future expires headers are sent as expected.

## 0.14.0

* The `highline` gem is now a dependency ([#3](https://github.com/mattbrictson/capistrano-fiftyfive/pull/3) from [@ahmozkya](https://github.com/ahmozkya)).
* Dotenv: only mask input when prompting for keys containing the words "key", "secret", "token", or "password". Input for other keys is echoed for easier data entry.
* Dotenv: update `.env` files in sequence rather than in parallel, to avoid parallel command output clobbering the input prompt.
* Nginx/unicorn: tweak reverse-proxy cache settings to prevent cache stampede.
* Nginx/unicorn: apply far-future expires cache headers only for assets that have fingerprints.

## 0.13.0

The provisioning tasks now work for a non-root user that has password-less sudo privileges. Assuming a user named `matt` that can sudo without being prompted for a password ([instructions here](http://askubuntu.com/questions/192050/how-to-run-sudo-command-with-no-password)), simply modify `deploy.rb` with:

```ruby
set :fiftyfive_privileged_user, "matt"
```

Now all provisioning tasks that would normally run as root will instead run as `matt` using `sudo`.

## 0.12.0

* capistrano-fiftyfive's abbreviated format now honors the new `SSHKIT_COLOR` environment variable. Set `SSHKIT_COLOR=1` to force ANSI color even on non-ttys (e.g. Jenkins).
* The generated nginx config now enables reverse proxy caching by default.
* INFO messages printed by sshkit are now printed to console under the appropriate rake task heading.

## 0.11.1

Fixes errors caused by PostgreSQL password containing shell-unsafe characters. Passwords are now safely hashed with MD5 before being used in the `CREATE USER` command.

## 0.11.0

* INFO log messages are now included in abbreviated output (e.g. upload/download progress).
* Add `agree()` method to the DSL, which delegates to `HighLine.new.agree`.
* Add `fiftyfive:postgresql:dump`/`restore` tasks.

## 0.10.0

Add support for Ubuntu 14.04 LTS. To provision a 14.04 server, use the new `provision:14_04` task.

## 0.9.1

Flush console output after each line is printed. This allows deployment progress to be monitored in e.g. Jenkins.

## 0.9.0

Initial Rubygems release!
