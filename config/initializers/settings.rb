require 'erb'
require 'yaml'

raw_config = ERB.new(File.read(Rails.root.join('config/settings.yml'))).result
SETTINGS = YAML.safe_load(raw_config, aliases: true).deep_symbolize_keys

# Parse regex
SETTINGS[:user][:valid_email_regex] = Regexp.new(SETTINGS[:user][:valid_email_regex], Regexp::IGNORECASE)

# Parse range
start_date = Date.parse(SETTINGS[:user][:birthday_range_start])
end_date = Date.parse(SETTINGS[:user][:birthday_range_end])
SETTINGS[:user][:birthday_range] = start_date..end_date