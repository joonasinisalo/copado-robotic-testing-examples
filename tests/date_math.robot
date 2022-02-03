*** Settings ***
Library                     QWeb
Library                     DateTime
Suite Setup                 Open Browser    about:blank    chrome
Suite Teardown              Close All Browsers

*** Test Cases ***
Date Handling Example
    ${current_date}         Get Current Date    result_format=%m/%d/%Y
