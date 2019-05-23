# gem-license

A gem plugin for fetching licenses

## Installation

```sh
gem install gem-license
```

## Usage

```sh
# download the MIT license to `LICENSE'
gem license mit

# output to stdout
gem license gpl-3.0 -s

# create a LICENSE.md
gem license apl-1.0 -m

# specify output path
gem license mit -o MIT.license

# attempt to format common values
# Uses git config --get user.name for author names,
# and the base name of the current working directory for
# program/project name.
gem license mit -f

# view a list of all available licenses
gem license -l
```

Licenses names are all based on SPDX identifiers and are not case sensitive.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/swarley/gem-license.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
