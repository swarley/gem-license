# gem-license

A gem plugin for fetching licenses

## Installation

```sh
gem install gem-license
```

## Usage

```sh
gem license mit

# output to stdout
gem license gpl-3.0 -s

# create a LICENSE.md
gem license apl-1.0 -d

# specify output path
gem license mit -o MIT.license

# view a list of all available licenses
gem license -l
```

Licenses names are all based on SPDX identifiers and are not case sensitive.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/swarley/gem-license.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
