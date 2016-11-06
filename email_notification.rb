require 'mail'

module EmailNotification
  LOGIN_SUCCESS = "Logged into SFV website successfully.\n" +
                  "The script is running well."

  STATUS_CHANGE = "Silver Fern Job Search Visa status changed.\n\n" +
                  "Please visit the following URL for details:\n" +
                  "https://www.immigration.govt.nz/new-zealand-visas/apply-for-a-visa/visa-factsheet/silver-fern-job-search-work-visa\n\n" +
                  "Login the following URL to get the visa:\n" +
                  "https://onlineservices.immigration.govt.nz/secure/Login+Silver+Fern.htm\n\n" +
                  "Then submit the application with the following URL.\n" +
                  "https://onlineservices.immigration.govt.nz/SILVERFERN/Submit/Submit?applicationId=%s&hasagent=False&hassubmit=False&hasagree=true\n\n" +
                  "Or use the command line tool to login and show the payment page."

  VISA_OPEN = "Silver Fern Job Search Visa opened.\n\n" +
              "Login the following URL to get the visa:\n" +
              "https://onlineservices.immigration.govt.nz/secure/Login+Silver+Fern.htm\n\n" +
              "Then submit the application with the following URL.\n" +
              "https://onlineservices.immigration.govt.nz/SILVERFERN/Submit/Submit?applicationId=%s&hasagent=False&hassubmit=False&hasagree=true\n\n" +
              "Or use the command line tool to login and show the payment page."

  SCRIPT_CRASHED = "The execution of SFV script crashed.\n\n%s"

  def send_login_successful_email(email_address, password, mails)
    set_default_email_options(email_address, password)

    Mail.deliver do
           to mails
         from email_address
      subject 'Logged into SFV website successfully'
         body LOGIN_SUCCESS
    end
  end

  def send_visa_status_changed_email(email_address, password, mails, application_id)
    set_default_email_options(email_address, password)

    Mail.deliver do
           to mails
         from email_address
      subject '[Important] Silver Fern Job Search Visa status changed'
         body STATUS_CHANGE % application_id
    end
  end

  def send_visa_open_email(email_address, password, mails, application_id)
    set_default_email_options(email_address, password)

    Mail.deliver do
           to mails
         from email_address
      subject '[Important] Silver Fern Job Search Visa opened'
         body VISA_OPEN % application_id
    end
  end

  def send_script_crash_email(email_address, password, mails, message)
    set_default_email_options(email_address, password)

    Mail.deliver do
           to mails
         from email_address
      subject '[Important] SFV script crashed'
         body SCRIPT_CRASHED % message
    end
  end

  def set_default_email_options(username, password)
    options = { :address              => "smtp.gmail.com",
                :port                 => 587,
                :user_name            => username,
                :password             => password,
                :authentication       => 'plain',
                :enable_starttls_auto => true }

    Mail.defaults do
      delivery_method :smtp, options
    end
  end
end
