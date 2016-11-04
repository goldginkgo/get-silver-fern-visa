require 'capybara/dsl'
require 'capybara/poltergeist'

STDOUT.sync = true
current_directory = File.dirname(File.expand_path(__FILE__))
ENV['PATH'] += ";#{current_directory}"

Capybara.default_max_wait_time = 60
Capybara.default_driver = :selenium

class SilverFern
  include Capybara::DSL

  def initialize(username, password, application_id)
    @username = username
    @password = password
    @application_id = application_id
  end

  def get_sfv
    loop do
      log_in(@username, @password)
      break if logged_in?
      sleep 5
    end
    visit_questionnaire
  end

  def log_in(username, password)
    visit "https://www.immigration.govt.nz/secure/Login+Silver+Fern.htm"
    fill_in 'OnlineServicesLoginStealth_VisaLoginControl_userNameTextBox', :with => username
    fill_in 'OnlineServicesLoginStealth_VisaLoginControl_passwordTextBox', :with => password
    click_on 'OnlineServicesLoginStealth_VisaLoginControl_loginImageButton'
  end

  def logged_in?
    ! has_content?("Invalid", wait: 1)
  end

  def visit_questionnaire
    visit "https://onlineservices.immigration.govt.nz/SILVERFERN/Questionnaire/Details/PersonalDetails/#{@application_id}"
    sleep 3
    click_on("Continue", match: :first)
    check("FalseStatementCheckBox")
    check("NotesCheckBox")
    check("CircumstancesCheckBox")
    check("WarrantsCheckBox")
    check("InformationCheckBox")
    check("HealthCheckBox")
    check("AdviceCheckBox")
    check("RegistrationCheckBox")
    check("EntitlementCheckBox")
    check("PermitExpiryCheckBox")
    check("MedicalInsuranceCheckBox")
    sleep 5
    click_on("Submit")
    sleep 10
  end
end

#get_silver = SilverFern.new(ARGV[0], ARGV[1], ARGV[2], :poltergeist)
get_silver = SilverFern.new(ARGV[0], ARGV[1], ARGV[2])
get_silver.get_sfv
