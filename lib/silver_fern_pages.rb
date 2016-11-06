require 'capybara/dsl'

# Silver Fern Visa Display page
module SilverFernDisplayPage
  extend Capybara::DSL

  DISPLAY_PAGE_URL   = "https://www.immigration.govt.nz/new-zealand-visas/apply-for-a-visa/visa-factsheet/silver-fern-job-search-work-visa"
  ACCESS_FAILED_MSG  = "Visiting the following URL failed:\n" + DISPLAY_PAGE_URL

  def visit_silver_fern_display_page
    visit DISPLAY_PAGE_URL
    puts "#{Time.now} visit SFV display page."
  end

  def visa_status_changed?
    raise ACCESS_FAILED_MSG if current_url != DISPLAY_PAGE_URL
    ! has_content?("Applications for this visa are currently closed until further notice", wait: 1)
  end

  module_function :visit_silver_fern_display_page, :visa_status_changed?
end

# login page
module SilverFernLoginPage
  extend Capybara::DSL

  LOGIN_PAGE_URL = "https://www.immigration.govt.nz/secure/Login+Silver+Fern.htm"
  MY_PAGE_URL    = "http://onlineservices.immigration.govt.nz/migrant/default.htm"

  def visit_login_page
    visit LOGIN_PAGE_URL
    puts "#{Time.now} visit SFV login page."
  end

  def fill_in_username(username)
    fill_in 'OnlineServicesLoginStealth_VisaLoginControl_userNameTextBox',
            :with => username
  end

  def fill_in_password(password)
    fill_in 'OnlineServicesLoginStealth_VisaLoginControl_passwordTextBox',
            :with => password
  end

  def click_login_button
    click_on 'OnlineServicesLoginStealth_VisaLoginControl_loginImageButton'
  end

  def logged_in?
    return false unless current_url == MY_PAGE_URL
    return false if has_content?("Invalid", wait: 1)
    true
  end

  module_function :visit_login_page, :fill_in_username, :fill_in_password,
                  :click_login_button, :logged_in?
end

# application form page
module SilverFernApplicationFormPage
  extend Capybara::DSL

  FORM_PAGE_URL = "https://onlineservices.immigration.govt.nz/SILVERFERN/Questionnaire/Details/PersonalDetails/%s"

  def visit_application_form_page(application_id)
    visit FORM_PAGE_URL % application_id
    puts "#{Time.now} visit SFV application form page."
  end

  def click_continue_button
    click_on("Continue", match: :first)
  end

  module_function :visit_application_form_page, :click_continue_button
end

# submit page
module SilverFernSubmitPage
  extend Capybara::DSL

  SUBMIT_PAGE_URL    = "https://onlineservices.immigration.govt.nz/SILVERFERN/Submit/Submit?applicationId=%s&hasagent=False&hassubmit=False&hasagree=true"
  ACCESS_FAILED_MSG  = "Visiting the following URL failed:\n" +
                       SUBMIT_PAGE_URL + "\n\n" +
                       "Maybe SFV is open."

  def visit_silver_fern_submit_page(application_id)
    visit SUBMIT_PAGE_URL % application_id
    puts "#{Time.now} visit SFV Submit page."
  end

  def check_all_checkboxes
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
  end

  def click_submit_button
    click_on("Submit")
  end

  def visa_opened?(application_id)
    return true if has_button?("Pay Now", wait: 1)
    raise ACCESS_FAILED_MSG if current_url != SUBMIT_PAGE_URL % application_id
    ! has_content?("Silver Fern Quota is Full", wait: 1)
  end

  module_function :visit_silver_fern_submit_page, :check_all_checkboxes, :click_submit_button, :visa_opened?
end
