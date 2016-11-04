require 'capybara'
require 'capybara/poltergeist'

STDOUT.sync = true
current_directory = File.dirname(File.expand_path(__FILE__))
ENV['PATH'] += ";#{current_directory}"

Capybara.default_max_wait_time = 60

class SilverFern
  def initialize(username, password, application_id, driver)
    @username = username
    @password = password
    @application_id = application_id
    @page = Capybara::Session.new(driver)
  end

  def get_sfv
    loop do
      log_in(@page, @username, @password)
      break if logged_in?(@page)
      sleep 5
    end
    visit_questionnaire(@page)
  end

  def log_in(page, username, password)
    page.visit "https://www.immigration.govt.nz/secure/Login+Silver+Fern.htm"
    page.fill_in 'OnlineServicesLoginStealth_VisaLoginControl_userNameTextBox', :with => username
    page.fill_in 'OnlineServicesLoginStealth_VisaLoginControl_passwordTextBox', :with => password
    page.click_on('OnlineServicesLoginStealth_VisaLoginControl_loginImageButton')
  end

  def logged_in?(page)
    ! page.has_content?("Invalid", wait: 1)
  end

  def visit_questionnaire(page)
    page.visit "https://onlineservices.immigration.govt.nz/SILVERFERN/Questionnaire/Details/PersonalDetails/#{@application_id}"
    sleep 3
    page.click_on("Continue", match: :first)
    page.check("FalseStatementCheckBox")
    page.check("NotesCheckBox")
    page.check("CircumstancesCheckBox")
    page.check("WarrantsCheckBox")
    page.check("InformationCheckBox")
    page.check("HealthCheckBox")
    page.check("AdviceCheckBox")
    page.check("RegistrationCheckBox")
    page.check("EntitlementCheckBox")
    page.check("PermitExpiryCheckBox")
    page.check("MedicalInsuranceCheckBox")
    sleep 5
    page.click_on("Submit")
    sleep 10
  end


end

#get_silver = SilverFern.new(ARGV[0], ARGV[1], ARGV[2], :poltergeist)
get_silver = SilverFern.new(ARGV[0], ARGV[1], ARGV[2], :selenium)
get_silver.get_sfv
