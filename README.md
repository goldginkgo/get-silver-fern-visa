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

6. Execute the following command.
   ```
   ruby get_silver_fern_visa.rb USERNAME PASSWORD APPLICATION_ID
   ```
