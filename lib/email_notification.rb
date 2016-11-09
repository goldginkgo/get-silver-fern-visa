require 'mail'

module EmailNotification
  EMAIL_CHECK = "Email notification is OK.\nThe script is running well."

  GET_VISA = "Please make sure your credit card is available and " +
             "use the command line tool to display payment page.\n\n" +
             "You can also login the following URL to get the visa:\n" +
             "https://onlineservices.immigration.govt.nz/secure/Login+Silver+Fern.htm\n\n" +
             "Then submit the application with the following URL. (replace <REPLACE_APPLICATION_ID> if necessary)\n" +
             "https://onlineservices.immigration.govt.nz/SILVERFERN/Submit/Submit?applicationId=%s&hasagent=False&hassubmit=False&hasagree=true\n\n" +
             "Your application form can be accessed with the following URL. (replace <REPLACE_APPLICATION_ID> if necessary)\n" +
             "https://onlineservices.immigration.govt.nz/SILVERFERN/Questionnaire/Details/PersonalDetails/%s\n\n" +
             "Good luck!"

  STATUS_CHANGE = "Silver Fern Job Search Visa status changed.\n\n" +
                  "Please visit the following URL for details:\n" +
                  "https://www.immigration.govt.nz/new-zealand-visas/apply-for-a-visa/visa-factsheet/silver-fern-job-search-work-visa\n\n" +
                  "Also please check if SFV is reopen. If it is open:\n\n" + GET_VISA

  VISA_OPEN = "Silver Fern Job Search Visa probably opened.\n\n" + GET_VISA

  SCRIPT_CRASHED = "The execution of SFV script crashed.\n\n%s"

  def send_email_notification_check_email(email_address, password, mails)
   set_default_email_options(email_address, password)

    Mail.deliver do
           to mails
         from email_address
      subject 'Check email notification for SFV script'
         body EMAIL_CHECK
    end
  end

  def send_visa_status_changed_email(email_address, password,
                                     mails, application_id)
    application_id = "<REPLACE_APPLICATION_ID>" unless application_id
    set_default_email_options(email_address, password)

    Mail.deliver do
           to mails
         from email_address
      subject '[Important] Silver Fern Job Search Visa status changed'
         body STATUS_CHANGE % [application_id, application_id]
    end
  end

  def send_visa_open_email(email_address, password, mails, application_id)
    application_id = "<REPLACE_APPLICATION_ID>" unless application_id
    set_default_email_options(email_address, password)

    Mail.deliver do
           to mails
         from email_address
      subject '[Important] Silver Fern Job Search Visa probably opened'
         body VISA_OPEN % [application_id, application_id]
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
