require 'capybara/dsl'
require_relative 'silver_fern_pages'
require_relative 'email_notification'

class SilverFern
  include EmailNotification

  def initialize(username, password, application_id, gmail, gmail_password, check)
    @username = username
    @password = password
    @application_id = application_id
    @gmail = gmail
    @gmail_password = gmail_password
    @check = check
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

    loop do
      submit_application
      if SilverFernSubmitPage.visa_opened?
        send_visa_open_email(@gmail, @gmail_password)
        sleep 3600
      end
      sleep 10
    end
  end

  def log_in(username, password)
    SilverFernLoginPage.visit_login_page
    SilverFernLoginPage.fill_in_username(username)
    SilverFernLoginPage.fill_in_password(password)
    SilverFernLoginPage.click_login_button
  end

  def submit_application
    # SilverFernApplicationFormPage.visit_application_form_page(@application_id)
    # SilverFernApplicationFormPage.click_continue_button
    SilverFernSubmitPage.visit_silver_fern_submit_page(@application_id)
    SilverFernSubmitPage.check_all_checkboxes
    SilverFernSubmitPage.click_submit_button
  end
end
