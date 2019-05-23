# frozen_string_literal: true

require 'English'

# Container for license fetching utilities
module Gem::License
  module_function

  def fetch_license_list
    list_uri = URI('https://spdx.org/licenses/licenses.json')
    JSON.parse(list_uri.read)['licenses']
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
    perfect_match = id_list.find { |id| id.downcase == license_id.downcase }
    return perfect_match if perfect_match

    spell_checker = DidYouMean::SpellChecker.new(dictionary: id_list)
    id = spell_checker.correct(license_id).first
    abort 'Unable to find a matching SPDX identifier.' + (id ? " Did you mean `#{id}'?" : '')
  end

  def write_license(license_obj, path = nil)
    text = fetch_license_text(license_obj['detailsUrl'])
    text = format_license(text) if format

    if path
      File.open(path, 'w+') do |f|
        f.write text
      end
    else
      $DEFAULT_OUTPUT.puts text
    end
  end

  def download(shortname, opt)
    license_list = fetch_license_list
    id_list = license_list.collect { |l_obj| l_obj['licenseId'] }

    id = match_license_id(shortname, id_list)
    license_obj = license_list.find { |l_obj| l_obj['licenseId'] == id }

    path = opt[:output_path]
    path = 'LICENSE' + (opt[:markdown] ? '.md' : '') if path.nil? && !opt[:stdout]

    write_license license_obj, path
  end
end
