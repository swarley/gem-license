# frozen_string_literal: true

require 'gem_license'
require 'open-uri'
require 'json'

# license gem plugin
class Gem::Commands::LicenseCommand < Gem::Command
  include Gem::License

  def initialize
    super('license', 'Download a license by SPDX id')

    add_option('-m', '--markdown', 'Download as LICENSE.md') do |_, options|
      options[:markdown] = true
    end

    add_option('-s', '--stdout', 'Write to STDOUT instead of LICENSE') do |_, options|
      options[:stdout] = true
    end

    add_option('-o', '--output=PATH', 'Specify an output path') do |value, options|
      options[:output_path] = value
    end

    add_option('-l', '--list', 'View all available licenses') do |_, options|
      options[:list] = true
    end

    add_option('-f', '--format', 'Attempt to fill in values like year, author, and program name') do |_, options|
      options[:format] = true
    end
  end

  def execute
    if options[:list]
      list = fetch_license_list
      just_size = list.collect { |lsc| lsc['licenseId'].length }.max
      list.each do |license|
        say(license['licenseId'].ljust(just_size) + ' - ' + license['name'])
      end
      exit
    end

    id = options[:args].first || abort("USAGE: #{usage}")
    download(id, options)
  end

  def description
    'Fetch a LICENSE based on an SPDX identifier'
  end

  def arguments
    'SPDX_IDENTIFIER   An identifier from SPDX\'s license list https://spdx.org/licenses/'
  end

  def usage
    'gem license SPDX_IDENTIFIER'
  end
end
