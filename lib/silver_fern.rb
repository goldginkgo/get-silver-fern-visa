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
    sign_in(@username, @password)

    @jump_out_of_loop = false
    loop do
      if @check
        check_sfv_status_on_home_page
        check_sfv_status_on_visa_intro_page
      end

      submit_application

      break if @jump_out_of_loop
      sleep 10 # interval for each retry
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
        retry
      end
    end
    send_login_successful_email(@gmail,
                                @gmail_password,
                                @mails) if @check
  end

  def check_sfv_status_on_home_page
    SilverFernHomePage.visit_silver_fern_home_page
    if SilverFernHomePage.visa_opened?
      puts "#{Time.now} SFV probably opened!!!"
      send_visa_status_changed_email(@gmail,
                                     @gmail_password,
                                     @mails,
                                     @application_id)
      @jump_out_of_loop = true
    else
      puts "#{Time.now} SFV not opened."
    end
  end

  def check_sfv_status_on_visa_intro_page
    return if @status_email_sent
    SilverFernDisplayPage.visit_silver_fern_display_page
    if SilverFernDisplayPage.visa_status_changed?
      puts "#{Time.now} SFV status changed."
      send_visa_status_changed_email(@gmail,
                                     @gmail_password,
                                     @mails,
                                     @application_id)
      @jump_out_of_loop = true
    else
      puts "#{Time.now} SFV status not changed."
    end
  end

  def submit_application
    unless @application_id
      return if @check
      raise "Please provide your application id."
    end

    # SilverFernApplicationFormPage.visit_application_form_page(@application_id)
    # SilverFernApplicationFormPage.click_continue_button
    SilverFernSubmitPage.visit_silver_fern_submit_page(@application_id)
    SilverFernSubmitPage.check_all_checkboxes
    SilverFernSubmitPage.click_submit_button

    if SilverFernSubmitPage.visa_opened?(@application_id)
      puts "#{Time.now} SFV probably opened!!!"
      if @check
        send_visa_open_email(@gmail,
                             @gmail_password,
                             @mails,
                             @application_id)
        @jump_out_of_loop = true
      else
        sleep 3600  # an hour for user to pay the visa
      end
    else
      puts "#{Time.now} SFV not opened."
    end
  end
end
