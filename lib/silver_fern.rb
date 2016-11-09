require_relative 'silver_fern_pages'
require_relative 'email_notification'

class SilverFern
  include EmailNotification

  def initialize(username, password, application_id, gmail, gmail_password, check, mails)
    @username = username
    @password = password
    @application_id = application_id
    @gmail = gmail
    @gmail_password = gmail_password
    @check = check
    @mails = mails
  end

  def get_sfv
    if @check
      #send_email_notification_check_email(@gmail, @gmail_password, @mails)
      check_available_visa
    else
      get_available_visa
    end
  rescue Exception => ex
    message = "Error during processing: #{ex.message}\n" +
              "Backtrace:\n\t#{ex.backtrace.join("\n\t")}"
    puts message
    send_script_crash_email(@gmail,
                            @gmail_password,
                            @mails,
                            message) if @check
  end

  private

  def check_available_visa
    @continue_execution = true
    loop do
      retry_when_error(5, 60) do
        sign_in(@username, @password)
        check_sfv_status_on_home_page
      end

      retry_when_error(3, 20) do
        check_sfv_status_on_visa_intro_page
      end

      break unless @continue_execution
      sleep 20 # interval for each check
      puts "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    end
  end

  def get_available_visa
    retry_when_error(3, 5) do
      sign_in(@username, @password)
    end

    retry_when_error(3, 5) do
      submit_application(@application_id)
    end

    sleep 3600  # an hour for user to pay the visa
  end

  def retry_when_error(retry_times, sleep_time, &block)
    current_retry ||= 0
    yield if block_given?
  rescue => ex
    PageUtils.save_page_content # save page for debug

    current_retry += 1
      if current_retry > retry_times
        raise ex
      else
        sleep sleep_time
        retry
      end
  end

  def sign_in(username, password)
    SilverFernLoginPage.visit_login_page
    SilverFernLoginPage.fill_in_username(username)
    SilverFernLoginPage.fill_in_password(password)
    SilverFernLoginPage.click_login_button

    if SilverFernLoginPage.logged_in?
      puts "#{Time.now} sign in successfully."
    else
      puts "#{Time.now} sign in failed."
      raise "Login failed."
    end
  end

  def check_sfv_status_on_home_page
    SilverFernHomePage.visit_silver_fern_home_page
    if SilverFernHomePage.visa_opened?
      puts "#{Time.now} SFV probably opened!!!"
      send_visa_open_email(@gmail,
                           @gmail_password,
                           @mails,
                           @application_id)
      @continue_execution = false
    else
      puts "#{Time.now} SFV not opened."
    end
  end

  def check_sfv_status_on_visa_intro_page
    return if @status_email_sent
    SilverFernDisplayPage.visit_silver_fern_display_page
    if SilverFernDisplayPage.visa_status_changed?
      puts "#{Time.now} SFV status changed!!!"
      send_visa_status_changed_email(@gmail,
                                     @gmail_password,
                                     @mails,
                                     @application_id)
      @continue_execution = false
    else
      puts "#{Time.now} SFV status not changed."
    end
  end

  def submit_application(application_id)
    raise "Please provide your application id." unless application_id

    # SilverFernApplicationFormPage.visit_application_form_page(@application_id)
    # SilverFernApplicationFormPage.click_continue_button
    SilverFernSubmitPage.visit_silver_fern_submit_page(application_id)
    SilverFernSubmitPage.check_all_checkboxes
    SilverFernSubmitPage.click_submit_button

    if SilverFernSubmitPage.visa_opened?(application_id)
      puts "#{Time.now} SFV probably opened!!!"
    else
      puts "#{Time.now} SFV not opened."
    end
  end
end
