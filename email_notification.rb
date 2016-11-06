require 'mail'

module EmailNotification
  MESSAGE = "Silver Fern Job Search Visa opened.\n\n" +
            "Login the following URL to get the visa:\n" +
            "https://onlineservices.immigration.govt.nz/secure/Login+Silver+Fern.htm\n\n" +
            "Or use the script to login and show the payment page."

  def send_visa_open_email
    set_default_email_options

    Mail.deliver do
           to ARGV[3]
         from ARGV[3]
      subject '[Important] Silver Fern Job Search Visa opened'
         body MESSAGE
    end
  end

  def set_default_email_options
    options = { :address              => "smtp.gmail.com",
                :port                 => 587,
                :user_name            => ARGV[3],
                :password             => ARGV[4],
                :authentication       => 'plain',
                :enable_starttls_auto => true }

    Mail.defaults do
      delivery_method :smtp, options
    end
  end
end