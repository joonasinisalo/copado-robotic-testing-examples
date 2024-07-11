*** Settings ***
Library                     QWeb
Library                     DateTime
Suite Setup                 Open Browser    about:blank    chrome
Suite Teardown              Close All Browsers

*** Test Cases ***
Date Handling Example
    # Getting current date in different formats

    # US
    ${current_date_us}=      Get Current Date    result_format=%m/%d/%Y

    # US - remove leading zeros (in Linux, Windows uses # instead of -)
    ${current_date_us}=      Get Current Date    result_format=%-m/%-d/%Y

    # US - month in text format
    ${current_date_us}=      Get Current Date    result_format=%B %-d, %Y

    # Finland
    ${current_date_fi}=      Get Current Date    result_format=%d.%m.%Y

    # Sweden
    ${current_date_se}=      Get Current Date    result_format=%Y-%m-%d

    # Add time to date
    ${plus45_date}=          Add Time To Date    ${current_date_us}    45 days    date_format=%m/%d/%Y    result_format=%m/%d/%Y

    # Subtract time from date
    ${minus45_date}=         Subtract Time From Date    ${current_date_us}    45 days    date_format=%m/%d/%Y    result_format=%m/%d/%Y

Time Zones
    # Get current date in different timezones and formats

    # Local
    ${current_time_local}=   Get Current Date    time_zone=local    result_format=%H:%M:%S
    
    # UTC
    ${current_time_utc}=     Get Current Date    time_zone=UTC    result_format=%H:%M:%S

    # Calculate IST time from UTC
    ${ist_time}=             Add Time To Time    5:30:0    ${current_time_utc}    timer    exclude_millis=True

    # Converting to AM/PM format after calculations
    ${current_time_utc}=     Get Current Date    time_zone=UTC
    ${new_time}=             Add Time To Date    ${current_time_utc}    2 mins
    ${new_time}=             Convert Date    ${new_time}    result_format=%H:%M:%S %p


Convert String to DateTime
    # Convert string variable to a DateTime object

    ${string_date}=          Set Variable    20/01/2023
    ${converted}=            Convert Date    ${string_date}    datetime    date_format=%d/%m/%Y

    # Change converted date to custom result format
    ${custom_format}=        Convert Date    ${converted}    result_format=%-m/%-d/%Y
