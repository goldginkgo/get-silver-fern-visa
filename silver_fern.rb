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
    sign_in(@username, @password)
    # if status changed, send just one email.
    @status_email_sent = false
    loop do
      check_visa_status if @check
      submit_application
      sleep 10
    end
  end

  def sign_in(username, password)
    loop do
      begin
        SilverFernLoginPage.visit_login_page
        SilverFernLoginPage.fill_in_username(username)
        SilverFernLoginPage.fill_in_password(password)
        SilverFernLoginPage.click_login_button
        if SilverFernLoginPage.logged_in?
          puts "#{Time.now} sign in successfully."
          break
        else
          puts "#{Time.now} sign in failed."
          sleep 5
        end
      rescue Exception => ex
        puts ex.message
        next
      end
    end
  end

  def check_visa_status
    return if @status_email_sent
    SilverFernDisplayPage.visit_silver_fern_display_page
    if SilverFernDisplayPage.visa_status_changed?
      send_visa_status_changed_email(@gmail, @gmail_password)
      @status_email_sent = true
      puts "#{Time.now} SFV status changed."
    else
      puts "#{Time.now} SFV status not changed."
    end
  end

  def submit_application
    # SilverFernApplicationFormPage.visit_application_form_page(@application_id)
    # SilverFernApplicationFormPage.click_continue_button
    SilverFernSubmitPage.visit_silver_fern_submit_page(@application_id)
    SilverFernSubmitPage.check_all_checkboxes
    SilverFernSubmitPage.click_submit_button
    if SilverFernSubmitPage.visa_opened?
      send_visa_open_email(@gmail, @gmail_password) if @check
      puts "#{Time.now} SFV opened!!!"
      sleep 3600
    else
      puts "#{Time.now} SFV not opened."
    end
  end
end
