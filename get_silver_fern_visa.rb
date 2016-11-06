require 'capybara/poltergeist'
require_relative 'opt_parser'
require_relative 'silver_fern'

STDOUT.sync = true
current_directory = File.dirname(File.expand_path(__FILE__))
ENV['PATH'] += ";#{current_directory}"

options = Optparser.parse(ARGV)

Capybara.default_max_wait_time = 60
Capybara.default_driver = options[:check]? :poltergeist : :selenium

get_silver = SilverFern.new(options[:username], options[:password], options[:id],
                            options[:gmail], options[:gmail_password])
get_silver.get_sfv
