require 'capybara/dsl'
require 'capybara/poltergeist'
require_relative 'silver_fern_pages'

STDOUT.sync = true
current_directory = File.dirname(File.expand_path(__FILE__))
ENV['PATH'] += ";#{current_directory}"

Capybara.default_max_wait_time = 60
Capybara.default_driver = :selenium

class SilverFern

  def initialize(username, password, application_id)
    @username = username
    @password = password
    @application_id = application_id
  end

  def get_sfv
    loop do
      log_in(@username, @password)
      break if SilverFernLoginPage.logged_in?
      sleep 5
    end
    visit_questionnaire
  end

  def log_in(username, password)
    SilverFernLoginPage.visit_login_page
    SilverFernLoginPage.fill_in_username(username)
    SilverFernLoginPage.fill_in_password(password)
    SilverFernLoginPage.click_login_button
  end

  def visit_questionnaire
    SilverFernApplicationFormPage.visit_application_form_page(@application_id)
    SilverFernApplicationFormPage.click_continue_button
    SilverFernSubmitPage.check_all_checkboxes
    SilverFernSubmitPage.click_submit_button
    sleep 3600
  end
end

#get_silver = SilverFern.new(ARGV[0], ARGV[1], ARGV[2], :poltergeist)
get_silver = SilverFern.new(ARGV[0], ARGV[1], ARGV[2])
get_silver.get_sfv
