require 'capybara/dsl'

# Silver Fern Visa Display page
module SilverFernDisplayPage
  extend Capybara::DSL

  def visit_silver_fern_display_page
    visit "https://www.immigration.govt.nz/new-zealand-visas/apply-for-a-visa/visa-factsheet/silver-fern-job-search-work-visa"
    puts current_url
  end

  def visa_status_changed?
    ! has_content?("Applications for this visa are currently closed until further notice", wait: 5)
  end

  module_function :visit_silver_fern_display_page, :visa_status_changed?
end

# login page
module SilverFernLoginPage
  extend Capybara::DSL

  def visit_login_page
    visit "https://www.immigration.govt.nz/secure/Login+Silver+Fern.htm"
    puts current_url
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
    puts current_url
  end

  def logged_in?
    ! has_content?("Invalid", wait: 5)
  end

  module_function :visit_login_page, :fill_in_username, :fill_in_password,
                  :click_login_button, :logged_in?
end

# application form page
module SilverFernApplicationFormPage
  extend Capybara::DSL

  def visit_application_form_page(application_id)
    visit "https://onlineservices.immigration.govt.nz/SILVERFERN/Questionnaire/Details/PersonalDetails/#{application_id}"
    puts current_url
  end

  def click_continue_button
    click_on("Continue", match: :first)
    puts current_url
  end

  module_function :visit_application_form_page, :click_continue_button
end

# submit page
module SilverFernSubmitPage
  extend Capybara::DSL

  def visit_silver_fern_submit_page(application_id)
    visit "https://onlineservices.immigration.govt.nz/SILVERFERN/Submit/Submit?applicationId=#{application_id}&hasagent=False&hassubmit=False&hasagree=true"
    puts current_url
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

  def visa_opened?
    ! has_content?("Silver Fern Quota is Full", wait: 5)
  end

  module_function :visit_silver_fern_submit_page, :check_all_checkboxes, :click_submit_button, :visa_opened?
end
