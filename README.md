# chandler

[![Gem Version](https://badge.fury.io/rb/chandler.svg)](http://badge.fury.io/rb/chandler)
[![Build Status](https://travis-ci.org/mattbrictson/chandler.svg?branch=master)](https://travis-ci.org/mattbrictson/chandler)

**chandler syncs your CHANGELOG entries to GitHub's release notes so you don't have to enter release notes manually.** For Ruby projects, you can even add chandler to your gem's Rakefile to make this an automatic part of your release process!

### How does it work?

chandler scans your git repository for version tags (e.g. `v1.0.2`), parses out the corresponding release notes for those tags from your CHANGELOG, and uploads those notes to the GitHub releases area via the GitHub API.

### Why go through the trouble?

GitHub's releases feature is a nice UI for browsing the history of your project and downloading snapshots of each version. It is also structured data that can be queried via GitHub's API, making it a available for third-party integrations. For example, [Sibbell][] can automatically send the release notes out to interested parties whenever you publish a new version.

Of course, as a considerate developer you also want to have a plain text CHANGELOG that travels with the code, can be collaboratively edited in pull requests, and so on. But that means you need two copies of the same release notes!

chandler takes the hassle out of maintaining these two separate formats: your CHANGELOG is the authoritative source, and GitHub releases are updated with a simple `chandler` command.

## Requirements

* Ruby 2.1 or higher
* Your project's CHANGELOG must be in Markdown with version numbers in the headings (similar to the format advocated by [keepachangelog.com](http://keepachangelog.com))
* You must be an owner or collaborator of the GitHub repository to update its releases

## Installation

### 1. Install the gem

```
gem install chandler
```

### 2. Configure .netrc

In order to access the GitHub API on your behalf, you must provide chandler with your GitHub credentials. Do this by creating a `~/.netrc` file with your GitHub username and password, like this:

```
machine api.github.com
  login defunkt
  password c0d3b4ssssss!
```

For more security, you can use an OAuth access token in place of your password. [Here's how to generate one][access-token].


## Usage

To push all CHANGELOG entries for all tags to GitHub, just run:

```
chandler push
```

chandler will make educated guesses as to what GitHub repository to use, the location of the CHANGELOG, and the tags that represent releases. To see what will happen without actually making changes, run:

```
chandler push --dry-run
```

To upload only a specific tag, `v1.0.2` for example:

```
chandler push v1.0.2
```

Other command-line options:

* `--git=/path/to/project/.git` – location of the local git repository (defaults to `.git`)
* `--github=username/repo` – GitHub repository to upload to (if unspecified, chandler will guess based on your git remotes)
* `--changelog=History.md` – location of the CHANGELOG (defaults to `CHANGELOG.md`)


## Rakefile integration

If you maintain a Ruby gem and use Bundler's gem tasks (i.e. `rake release`) to publish your gem, then you can use chandler to automate update your GitHub release notes.

### 1. Update the gemspec

```ruby
spec.add_development_dependency "chandler"
```

### 2. Modify the Rakefile

```ruby
require "bundler/gem_tasks"
require "chandler/tasks"

# Optional: override default chandler configuration
Chandler::Tasks.configure do |config|
  config.changelog_path = "History.md"
  config.github_repository = "mattbrictson/mygem"
end

# Add chandler as a prerequisite for `rake release`
task "release:rubygem_push" => "chandler:push"
```

That's it! Now when you run `rake release`, your GitHub release notes will be updated automatically based on your CHANGELOG entries.

[Sibbell]: http://sibbell.com
[access-token]: https://help.github.com/articles/creating-an-access-token-for-command-line-use/

## Contributing

Contributions are welcome! Read [CONTRIBUTING.md](CONTRIBUTING.md) to get started.
