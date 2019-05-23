# frozen_string_literal: true

require 'open-uri'
require 'json'

# license gem plugin
class Gem::Commands::LicenseCommand < Gem::Command
  def initialize
    super('license', 'Download a license by SPDX id')

    add_option('-m', '--markdown', 'Download as LICENSE.md') do |_, options|
      options[:markdown] = true
    end

    add_option('-s', '--stdout', 'Write to STDOUT instead of LICENSE') do |_, options|
      options[:stdout] = true
    end
  end

  def fetch_license_list
    list_uri = URI('https://spdx.org/licenses/licenses.json')
    JSON.parse(list_uri.read)
  rescue OpenURI::HTTPError => e
    raise Gem::CommandLineError, "Unable to get license list. [#{e.message}]"
  end

  def fetch_license_text(url)
    license_uri = URI(url)
    license_obj = JSON.parse(license_uri.read)
    license_obj['licenseText']
  rescue OpenURI::HTTPError => e
    raise Gem::CommandLineError, "Unable to get license text. [#{e.message}]"
  end

  def match_license_id(license_id, id_list)
    license_id_rxp = Regexp.new(Regexp.escape(license_id), Regexp::IGNORECASE)
    matched_ids = id_list.select { |id| id =~ license_id_rxp }

    perfect_match = matched_ids.find { |id| id =~ /\A#{license_id_rxp}\Z/i }

    unless perfect_match
      say 'Unable to find an exact match. Suggestions below'
      matched_ids.each { |id| say "\t#{id}" }
      exit
    end

    perfect_match
  end

  def write_license(license_obj)
    text = fetch_license_text(license_obj['detailsUrl'])
    if options[:stdout]
      say text
    else
      fname = 'LICENSE'
      fname += '.md' if options[:markdown]
      File.open(fname, 'w+') do |f|
        f.write text
      end
    end
  end

  def download(shortname)
    license_list = fetch_license_list['licenses']
    id_list = license_list.collect { |l_obj| l_obj['licenseId'] }

    id = match_license_id(shortname, id_list)
    license_obj = license_list.find { |l_obj| l_obj['licenseId'] == id }

    write_license license_obj
  end

  def execute
    id = options[:args].first
    download(id)
  end
end
