require 'optparse'

class Optparser
  def self.parse(args)
    options = {}

    opts = OptionParser.new do |opts|
      opts.banner = "Usage: ruby get_silver_fern_visa.rb [options]"

      opts.separator ""
      opts.separator "Specific options:"

      opts.on("-c", "--check", "Check if places are available for SFV. " +
              "No browser will be launched for this option.") do |v|
        options[:check] = true
      end

      opts.on("-u Name", "--username Name",
              "Specify username for NZ immigration website.") do |value|
        options[:username] = value
      end

      opts.on("-p Password", "--password Password",
              "Specify password for NZ immigration website.") do |value|
        options[:password] = value
      end

      opts.on("-i ID", "--application-id ID",
              "Specify Silver Fern Visa application id.") do |value|
        options[:id] = value
      end

      opts.on("-g Name", "--gmail-address Name",
              "Specify your Gmail address.") do |value|
        options[:gmail] = value
      end

      opts.on("-d Password", "--gmail-password Password",
              "Specify your Gmail password.") do |value|
        options[:gmail_password] = value
      end

      opts.on("-m Mails", "--mail-address Mails",
              "Specify your email address that will be notified. " +
              "(use \",\" between multiple emails)") do |value|
        options[:mails] = value
      end

      opts.separator ""
      opts.separator "Common options:"

      opts.on_tail("-h", "--help", "Show this message.") do
        puts opts
        exit
      end
    end

    opts.parse!(args)
    options
  end
end
