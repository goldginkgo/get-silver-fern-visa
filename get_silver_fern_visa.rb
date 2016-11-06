require 'capybara/dsl'
require 'capybara/poltergeist'
require_relative 'opt_parser'
require_relative 'silver_fern_pages'
require_relative 'email_notification'

STDOUT.sync = true
current_directory = File.dirname(File.expand_path(__FILE__))
ENV['PATH'] += ";#{current_directory}"

Capybara.default_max_wait_time = 60
Capybara.default_driver = :selenium

class SilverFern
  include EmailNotification

  def initialize(username, password, application_id, gmail, gmail_password)
    @username = username
    @password = password
    @application_id = application_id
    @gmail = gmail
    @gmail_password = gmail_password
  end

  def get_sfv
    status_email_sent = false
    loop do
      unless status_email_sent
        SilverFernDisplayPage.visit_silver_fern_display_page
        if SilverFernDisplayPage.visa_status_changed?
          send_visa_status_changed_email(@gmail, @gmail_password)
          status_email_sent = true
        end
      end

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
    send_visa_open_email(@gmail, @gmail_password) if SilverFernSubmitPage.visa_opened?
    sleep 3600
  end
end

#get_silver = SilverFern.new(ARGV[0], ARGV[1], ARGV[2], :poltergeist)
options = Optparser.parse(ARGV)
get_silver = SilverFern.new(options[:username], options[:password], options[:id],
                            options[:gmail], options[:gmail_password])
get_silver.get_sfv
