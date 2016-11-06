require 'mail'

module EmailNotification
  STATUS_CHANGE = "Silver Fern Job Search Visa status changed.\n\n" +
                  "Please visit the following URL for details:\n" +
                  "https://onlineservices.immigration.govt.nz/secure/Login+Silver+Fern.htm"

  VISA_OPEN = "Silver Fern Job Search Visa opened.\n\n" +
              "Login the following URL to get the visa:\n" +
              "https://onlineservices.immigration.govt.nz/secure/Login+Silver+Fern.htm\n\n" +
              "Or use the script to login and show the payment page."

  def send_visa_status_changed_email(email_address, password, mails)
    set_default_email_options(email_address, password)

    Mail.deliver do
           to mails
         from email_address
      subject '[Important] Silver Fern Job Search Visa status changed'
         body STATUS_CHANGE
    end
  end

  def send_visa_open_email(email_address, password, mails)
    set_default_email_options(email_address, password)

    Mail.deliver do
           to mails
         from email_address
      subject '[Important] Silver Fern Job Search Visa opened'
         body VISA_OPEN
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
