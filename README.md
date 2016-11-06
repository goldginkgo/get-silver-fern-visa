# Get SFV More Efficiently

## Introduction
This application is used to get a sporadic SFV quota more efficiently.

It is useful when you have completed the Silver Fern Schema
and payment is your only step towards SFV when places are available.
So you must be aware of your application form id.

Two functions are provided:
  - Inform the user by email if there are places available for the visa.
  - Launch Chrome, sign in SFV website and display the payment page automatically.

For command line options, refer to the following:
```
Usage: ruby get_silver_fern_visa.rb [options]

Specific options:
    -c, --check                      Check if places are available for SFV. No browser will be launched for this option.
    -u, --username Name              Specify username for NZ immigration website.
    -p, --password Password          Specify password for NZ immigration website.
    -i, --application-id ID          Specify Silver Fern Visa application id.
    -g, --gmail-address Name         Specify your Gmail address.
    -d, --gmail-password Password    Specify your Gmail password.
    -m, --mail-address Mails         Specify your email address that will be notified. (use "," between multiple emails)

Common options:
    -h, --help                       Show this message.
```

## Running the application
1. Install Ruby and Chrome.

2. Clone the repository.
  ```
  git clone https://github.com/goldginkgo/get-silver-fern-visa.git
  ```

3. Download the latest chromedriver from the following URL, extract the folder,
   and put chromedriver in the get-silver-fern-visa folder.
   ```
   http://chromedriver.storage.googleapis.com/index.html
   ```

4. Download phantomjs from the following URL, extract the folder,
   and put phantomjs in the get-silver-fern-visa folder.
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
   ruby get_silver_fern_visa.rb -u USERNAME -p PASSWORD -i APPLICATION_ID -g GMAIL_ADDRESS -d GMAIL_PASSWORD -m MAIL1,MAIL2,MAIL3 -c
   ```
   Please give your Gmail address information, and emails will be sent to all email addresses you provided if SFV is reopen. Make sure you turned on your mobile phone notification for all email applications.

7. Execute the following command to launch a browser to do the operations automatically before payment.
   ```
   ruby get_silver_fern_visa.rb -u USERNAME -p PASSWORD -i APPLICATION_ID
   ```
   Perform this step if the previous step indicates SFV is reopen.
