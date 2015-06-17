# Contributing to chandler

Have a feature idea, bug fix, or refactoring suggestion? Contributions are welcome!

## Pull requests

1. Check [Issues][] to see if your contribution has already been discussed and/or implemented.
2. If not, open an issue to discuss your contribution. I won't accept all changes and do not want to waste your time.
3. Once you have the :thumbsup:, fork the repo, make your changes, and open a PR.
4. Don't forget to add your contribution and credit yourself in `CHANGELOG.md`!

## Coding guidelines

* This project has a coding style enforced by [rubocop][]. Use hash rockets and double-quoted strings, and otherwise try to follow the [Ruby style guide][style].
* Writing tests is strongly encouraged! This project uses Minitest.

## Getting started

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment. To run your checked-out version of chandler, use `bundle exec chandler`.

To execute chandler's tests and rubocop checks, run `rake`.


[Issues]: https://github.com/mattbrictson/chandler/issues
[rubocop]: https://github.com/bbatsov/rubocop
[style]: https://github.com/bbatsov/ruby-style-guide
