# chandler

[![Gem Version](https://badge.fury.io/rb/chandler.svg)](http://badge.fury.io/rb/chandler)
[![Build Status](https://travis-ci.org/mattbrictson/chandler.svg?branch=master)](https://travis-ci.org/mattbrictson/chandler)
[![Build status](https://ci.appveyor.com/api/projects/status/qmmk5ra8mom6503i/branch/master?svg=true)](https://ci.appveyor.com/project/mattbrictson/chandler/branch/master)
[![Code Climate](https://codeclimate.com/github/mattbrictson/chandler/badges/gpa.svg)](https://codeclimate.com/github/mattbrictson/chandler)
[![Coverage Status](https://coveralls.io/repos/mattbrictson/chandler/badge.svg?branch=master)](https://coveralls.io/r/mattbrictson/chandler?branch=master)

⚠️ **This project is no longer actively maintained.** I have found myself embracing tools like [release-drafter](https://github.com/apps/release-drafter) to keep release notes updated automatically, rather than relying on a manually edited CHANGELOG.md. If you are interested in taking over chandler development, let me know by [opening an issue](https://github.com/mattbrictson/chandler/issues/new).

---

**chandler syncs your CHANGELOG entries to GitHub's release notes so you don't have to enter release notes manually.** For Ruby projects, you can even add chandler to your gem's Rakefile to make this an automatic part of your release process!

### How does it work?

chandler scans your git repository for version tags (e.g. `v1.0.2`), parses out the corresponding release notes for those tags from your `CHANGELOG`, and uploads those notes to your project's [GitHub Releases][gh-releases] via the GitHub API.

By default, chandler makes reasonable assumptions about:

- the name of your `CHANGELOG` file,
- your project's GitHub repository URL, and
- the naming convention of your Git version tags.

These can all be overridden with command line options.

### Why go through the trouble?

[GitHub Releases][gh-releases] are a nice UI for browsing the history of your project and downloading snapshots of each version. It is also structured data that can be queried via GitHub's API, making it a available for third-party integrations. For example, [Sibbell][] can automatically send the release notes out to interested parties whenever you publish a new version.

But as a considerate developer, you also want a plain text `CHANGELOG` that travels with the code, can be edited collaboratively in pull requests, and so on.

_But that means you need two copies of the same release notes!_ 😵

**chandler takes the hassle out of maintaining these two separate formats.**
Your `CHANGELOG` is the authoritative source, and GitHub Releases are updated with a simple `chandler` command.

## Requirements

* Ruby 2.3 or higher
* Your project's `CHANGELOG` must be in Markdown, with version numbers in the headings (similar to the format advocated by [keepachangelog.com](http://keepachangelog.com))
* You must be an _owner_ or _collaborator_ of the GitHub repository to update its Releases

## Installation

### 1. Install the gem

```
gem install chandler
```

### 2. Configure credentials

#### Option 1 - `.netrc`

In order to access the GitHub API on your behalf, you must provide chandler with your GitHub credentials.

Do this by creating a `~/.netrc` file with your GitHub username and password, like this:

```
machine api.github.com
  login defunkt
  password c0d3b4ssssss!
```

#### Option 2 - Set ENV variables

Alternatively, just expose the ENV variable `CHANDLER_GITHUB_API_TOKEN` in your CI.

For more security, you can use an OAuth access token in place of your password. [Here's how to generate one][access-token]. Make sure to enable `public_repo` scope for the token.


## Usage

To push all `CHANGELOG` entries for all tags to GitHub, just run:

```
chandler push
```

chandler will make educated guesses as to what GitHub repository to use, the location of the `CHANGELOG`, and which tags represent releases.

You can preview what will happen without actually making changes, using `--dry-run`:

```
chandler push --dry-run
```

To upload only a specific tag (`v1.0.2`, for example):

```
chandler push v1.0.2
```

Other command-line options:

* `--git=/path/to/project/.git` – location of the local git repository (defaults to `.git`)
* `--github=username/repo` – GitHub repository to upload to (if unspecified, chandler will guess based on your git remotes)
* `--changelog=History.md` – location of the CHANGELOG (defaults to `CHANGELOG.md`)
* `--tag-prefix=myapp-` – specify Git version tags are in the format `myapp-1.0.0` instead of `1.0.0`

## GitHub Enterprise

Chandler supports GitHub Enterprise as well as public GitHub repositories. It will make an educated guess as to where your GitHub Enterprise installation is located based on the `origin` git remote. You can also specify your GitHub Enterprise repository using the `--github` option like this:

```
--github=git@github.mycompany.com:organization/project.git
```

Or like this:

```
--github=https://github.mycompany.com/organization/project
```

To authenticate, Chandler relies on your `~/.netrc`, as explained above. GitHub Enterprise users simply need to replace `api.github.com` with the hostname of your GitHub Enterprise installation (`github.mycompany.com` in the example above).

## Rakefile integration

If you maintain a Ruby gem and use Bundler's gem tasks (i.e. `rake release`) to publish your gem, then you can use chandler to update your GitHub release notes automatically.

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

That's it! Now when you run `rake release`, your GitHub Release notes will be updated automatically based on your `CHANGELOG` entries.

And yes, chandler uses itself to automatically push its own [release notes][release-notes] to GitHub! Check out the [Rakefile](Rakefile).

[Sibbell]: http://sibbell.com
[access-token]: https://help.github.com/articles/creating-an-access-token-for-command-line-use/
[release-notes]: https://github.com/mattbrictson/chandler/releases
[gh-releases]: https://help.github.com/articles/about-releases/

## Contributing

This project is no longer accepting pull requests. If you are interested in taking over chandler development, let me know by [opening an issue](https://github.com/mattbrictson/chandler/issues/new).
