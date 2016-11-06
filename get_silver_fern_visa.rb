require 'capybara/poltergeist'
require_relative 'opt_parser'
require_relative 'silver_fern'

STDOUT.sync = true
current_directory = File.dirname(File.expand_path(__FILE__))
ENV['PATH'] += ";#{current_directory}"

options = Optparser.parse(ARGV)

Capybara.default_max_wait_time = 60
# override the selenium driver configuration to use chrome
Capybara.register_driver :selenium do |app|
  Capybara::Selenium::Driver.new(app, :browser => :chrome)
end
Capybara.default_driver = options[:check] ? :poltergeist : :selenium

get_silver = SilverFern.new(options[:username], options[:password], options[:id],
                            options[:gmail], options[:gmail_password], options[:check], options[:mails])
get_silver.get_sfv
