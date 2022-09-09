*** Settings ***
Library                     QWeb
Library                     DateTime
Suite Setup                 Open Browser    about:blank    chrome
Suite Teardown              Close All Browsers

*** Test Cases ***
Date Handling Example
    # Getting current date in different formats

    # US
    ${current_date_us}       Get Current Date    result_format=%m/%d/%Y

    # US - remove leading zeros (in Linux, Windows uses # instead of -)
    ${current_date_us}       Get Current Date    result_format=%-m/%-d/%Y

    # Finland
    ${current_date_fi}       Get Current Date    result_format=%d.%m.%Y

    # Sweden
    ${current_date_se}       Get Current Date    result_format=%Y-%m-%d

    # Add time to date
    ${plus45_date}           Add Time To Date    ${current_date_us}    45 days    date_format=%m/%d/%Y    result_format=%m/%d/%Y

    # Subtract time from date
    ${minus45_date}          Subtract Time From Date    ${current_date_us}    45 days    date_format=%m/%d/%Y    result_format=%m/%d/%Y
