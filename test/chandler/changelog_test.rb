require "minitest_helper"
require "chandler/changelog"

class Chandler::ChangelogTest < Minitest::Test
  def test_fetch_raises_for_nonexistent_version
    changelog = new_changelog("airbrussh.md")
    assert_raises(Chandler::Changelog::NoMatchingVersion) do
      changelog.fetch("v0.99.0")
    end
  end

  def test_fetch_activeadmin_versions
    changelog = new_changelog("activeadmin.md")

    assert_match("only once. [#5377] by [@kjeldahl]", changelog.fetch("v1.4.2"))
    assert_match(
      "[#5377]: https://github.com/activeadmin/activeadmin/pull/5377",
      changelog.fetch("v1.4.2")
    )
    assert_match(
      "[@kjeldahl]: https://github.com/kjeldahl",
      changelog.fetch("v1.4.2")
    )

    assert_match("delete. [#5583] by [@tiagotex]", changelog.fetch("v1.4.1"))
    assert_match(
      "[#5583]: https://github.com/activeadmin/activeadmin/pull/5583",
      changelog.fetch("v1.4.1")
    )
    assert_match(
      "[@tiagotex]: https://github.com/tiagotex",
      changelog.fetch("v1.4.1")
    )
  end

  def test_fetch_actionview_versions
    changelog = new_changelog("actionview.md")

    assert_match("`translate` should handle `rai", changelog.fetch("v4.1.12"))
    assert_match("No changes.", changelog.fetch("v4.1.11"))
    assert_match("Local variable in a partial is", changelog.fetch("v4.1.10"))
    assert_match("Added an explicit error message", changelog.fetch("v4.1.9"))
    assert_match("Update `select_tag` to work", changelog.fetch("v4.1.8"))
  end

  def test_fetch_airbrussh_versions
    changelog = new_changelog("airbrussh.md")

    assert_match(
      "Fix `Marshal.dump` warnings by removing `deep_copy` workaround "\
      "that it is no longer needed for the latest SSHKit "\
      "([#10](https://github.com/mattbrictson/airbrussh/issues/10)).",
      changelog.fetch("v0.4.1")
    )
    assert_match("Changes to ensure compatibility", changelog.fetch("v0.4.0"))
    assert_match("Explicitly specify UTF-8", changelog.fetch("v0.4.0"))
    assert_match("New `config.banner` option", changelog.fetch("v0.3.0"))
    assert_match("New `config.command_output`", changelog.fetch("v0.3.0"))
    assert_match("Un-pin SSHKit dependency", changelog.fetch("v0.2.1"))
    assert_match("Pin SSHKit dependency at", changelog.fetch("v0.2.0"))
    assert_match("Initial release", changelog.fetch("v0.0.1"))
  end

  def test_fetch_angular_versions
    changelog = new_changelog("angular.md")

    assert_match("Copy `inputs` for expressions", changelog.fetch("1.5.0"))
    assert_match("does not affect the `ngSwipe`", changelog.fetch("1.5.0-rc.2"))
    assert_match("**filterFilter:** due to", changelog.fetch("1.4.0-beta.2"))
  end

  def test_fetch_async_versions
    changelog = new_changelog("async.md")

    assert_match('Allow using `"consructor"`', changelog.fetch("v1.5.2"))
    assert_match("Various doc fixes (#971, #980)", changelog.fetch("v1.5.1"))
    assert_match("Added `asyncify`/`wrapSync`", changelog.fetch("v1.3.0"))
    assert_match("No known breaking changes", changelog.fetch("v1.0.0"))
  end

  def test_fetch_bootstrap_sass_versions
    changelog = new_changelog("bootstrap-sass.md")

    assert_match("Fix for standalone Compass", changelog.fetch("v3.3.5"))
    assert_match("No Sass-specific changes.", changelog.fetch("v3.3.4"))
    assert_match("This is a re-packaged release", changelog.fetch("v3.3.3"))
    assert_match("Fix glyphicons regression", changelog.fetch("v3.3.2.1"))
    assert_match("Autoprefixer is now required", changelog.fetch("v3.3.2.0"))
  end

  def test_fetch_bundler_versions
    changelog = new_changelog("bundler.md")

    assert_match("don't add BUNDLED WITH to the", changelog.fetch("v1.10.4"))
    assert_match("allow missing gemspec files", changelog.fetch("v1.10.3"))
    assert_match("fix regression in `bundle update", changelog.fetch("v1.10.2"))
    assert_match("silence ruby warning when", changelog.fetch("v1.10.1"))
    assert_match("(this space intentionally left", changelog.fetch("v1.10.0"))
  end

  def test_fetch_capistrano_fiftyfive_versions
    changelog = new_changelog("capistrano-fiftyfive.md")

    assert_match("An internal change in Capistrano", changelog.fetch("v0.20.1"))
    assert_match("Increase SSL/TLS security", changelog.fetch("v0.20.0"))
    assert_match("Add `--retry=3` to bundle", changelog.fetch("v0.19.0"))
    assert_match("The abbreviated log formatter", changelog.fetch("v0.18.0"))
    assert_match("Default self-signed SSL", changelog.fetch("v0.17.2"))
  end

  def test_fetch_capistrano_versions
    changelog = new_changelog("capistrano.md")

    assert_match("Fixed fetch revision", changelog.fetch("v3.4.0"))
    assert_match("Fixed setting properties twice", changelog.fetch("v3.3.5"))
    assert_match("Rely on a newer version of", changelog.fetch("v3.3.4"))
    assert_match("Added the variable `:repo_tree`", changelog.fetch("v3.3.3"))
    assert_match("3.2.0 introduced some behaviour", changelog.fetch("v3.2.1"))
  end

  def test_fetch_carrierwave_versions
    changelog = new_changelog("carrierwave.md")

    assert_match("Memoize uploaders and", changelog.fetch("v0.10.0"))
    assert_match("Use integer time (UTC)", changelog.fetch("v0.9.0"))
    assert_match("Remove 'fog\\_endpoint' in favor", changelog.fetch("v0.8.0"))
    assert_match("add a override to allow fog", changelog.fetch("v0.7.1"))
    assert_match("Rename 'fog\\_host' config option", changelog.fetch("v0.7.0"))
  end

  def test_fetch_devise_versions
    changelog = new_changelog("devise.md")

    assert_match("Clean up reset password token", changelog.fetch("v3.5.1"))
    assert_match("Devise default views now have", changelog.fetch("v3.4.1"))
    assert_match("Support added for Rails 4.2", changelog.fetch("v3.4.0"))
    assert_match("Support multiple warden config", changelog.fetch("v3.3.0"))
    assert_match("`bcrypt` dependency updated", changelog.fetch("v3.2.4"))
  end

  def test_fetch_less_js_versions
    changelog = new_changelog("less.js.md")

    assert_match("Underscore now allowed in dimen", changelog.fetch("2.6.0"))
    assert_match("Fix import inline a URL", changelog.fetch("2.5.3"))
    assert_match("less.parse now exposes a way to", changelog.fetch("2.2.0"))
    assert_match("browser bundle no longer leaks", changelog.fetch("2.0.0-b3"))
    assert_match("support @import-once", changelog.fetch("1.3.1"))
  end

  def test_fetch_rake_versions
    changelog = new_changelog("rake.rdoc")

    assert_match("Rake no longer edits ARGV", changelog.fetch("v10.4.2"))
    assert_match("Reverted fix for #277 as it", changelog.fetch("v10.4.1"))
    assert_match("Upgraded to minitest 5.", changelog.fetch("v10.4.0"))
    assert_match("Rake no longer infinitely loops", changelog.fetch("v10.3.2"))
    assert_match("Added --build-all option to rake", changelog.fetch("v10.3"))
  end

  def test_fetch_realm_cocoa
    changelog = new_changelog("realm-cocoa.md")

    assert_match("Fix a crash when opening a Realm", changelog.fetch("v0.98.5"))
    assert_match("addOrUpdate:/createOrUpdate: to", changelog.fetch("v0.98.4"))
    assert_match("Fix crashes when deleting an obj", changelog.fetch("v0.98.1"))
    assert_match("Added anonymous analytics on", changelog.fetch("v0.94.0"))
    assert_match("RLMArray has been split into", changelog.fetch("v0.87.0"))
  end

  def test_fetch_rst_definitions_semver
    changelog = new_changelog("rst-definition.md")

    assert_match("Added ACME project", changelog.fetch("0.0.1"))
    assert_match("Pre-release", changelog.fetch("0.0.2-rc1"))
    assert_match("Dev pre-release", changelog.fetch("0.0.2-dev-xyz"))
    assert_match("Release", changelog.fetch("0.0.2"))
    assert_match("Release 0.1", changelog.fetch("0.1.0"))
    assert_match("Update", changelog.fetch("v0.1.1"))
  end

  def test_fetch_rubocop_versions
    changelog = new_changelog("rubocop.md")

    assert_match("Adjust behavior of `Trailing", changelog.fetch("v0.32.0"))
    assert_match("`Rails/TimeZone` emits", changelog.fetch("v0.31.0"))
    assert_match("For assignments with line break", changelog.fetch("v0.30.1"))
    assert_match("Do not register offenses on", changelog.fetch("v0.30.0"))
    assert_match("Use Parser functionality rather", changelog.fetch("v0.29.1"))
  end

  def test_fetch_sshkit_versions
    changelog = new_changelog("sshkit.md")

    assert_match("Fix a regression in 1.7.0", changelog.fetch("v1.7.1"))
    assert_match("Update Vagrantfile to use", changelog.fetch("v1.7.0"))
  end

  def test_fetch_twitter_versions
    changelog = new_changelog("twitter.md")

    assert_match("Add `Twitter::NullObject", changelog.fetch("v5.14.0"))
    assert_match("Deprecate `Twitter::REST::Client", changelog.fetch("v5.13.0"))
    assert_match("Rescue `Twitter::Error::NotFound", changelog.fetch("v5.12.0"))
    assert_match("Return a Twitter::NullObject", changelog.fetch("v5.11.0"))
    assert_match("Add support for extended ent", changelog.fetch("v5.10.0"))
  end

  private

  def new_changelog(fixture)
    path = File.expand_path("../../fixtures/changelog/#{fixture}", __FILE__)
    Chandler::Changelog.new(:path => path)
  end
end
