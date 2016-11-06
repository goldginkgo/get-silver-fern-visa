# Get SFV More Efficiently

## Introduction
This application is used to get a sporadic SFV quota.

It is useful when you have completed the Silver Fern Schema
and payment is your only step towards SFV when places are available.

It provides two functions:
  - Inform the user if there are places available for the visa.
  - Open a browser, sign in and display the payment page automatically.

## Running the application
1. Install Ruby and Chrome.

2. Clone the repository.

  ```
  git clone https://github.com/goldginkgo/get-silver-fern-visa.git
  ```

3. Download the latest chromedriver from the following URL, extract the folder,
   and put chromedriver.exe in the get-silver-fern-visa folder.
   ```
   http://chromedriver.storage.googleapis.com/index.html
   ```

4. Download phantomjs from the following URL, extract the folder,
   and put phantomjs.exe in the get-silver-fern-visa folder.
   ```
   http://phantomjs.org/download.html
   ```

5. Install required gems.
   ```
   cd get-silver-fern-visa
   bundle install
   ```

6. Execute the following command to check SFV status.
   ```
   ruby get_silver_fern_visa.rb -u USERNAME -p PASSWORD -i APPLICATION_ID -g GMAIL_ADDRESS -d GMAIL_PASSWORD -c
   ```
   Please provide your gmail address information, and emails will be sent to your gmail if SFV is opened. Make sure you turned on your mobile notification for gmail.

   For each option, refer to the following:
   ```
    $ ruby get_silver_fern_visa.rb -h
    Usage: ruby get_silver_fern_visa.rb [options]

    Specific options:
        -c, --check                      Check if places are available for SFV.
        -u, --username Name              Specify the username for immigration website.
        -p, --password Password          Specify the password for immigration website.
        -i, --application-id ID          Specify Silver Fern Visa application id.
        -g, --gmail-address Name         Specify your gmail address.
        -d, --gmail-password Password    Specify your gmail password.

    Common options:
        -h, --help                       Show this message.
   ```

7. Execute the following command to do the operations before payment.
   ```
   ruby get_silver_fern_visa.rb -u USERNAME -p PASSWORD -i APPLICATION_ID -g GMAIL_ADDRESS -d GMAIL_PASSWORD
   ```
   Perform this step if the previous step indicates SFV is open.
