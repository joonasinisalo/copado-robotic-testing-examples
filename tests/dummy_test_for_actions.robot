*** Settings ***
Documentation           Dummy tests for Github actions testing
Library                 QWeb
Library                 DateTime
Suite Setup             Open Browser    about:blank    chrome
Suite Teardown          Close All Browsers

*** Variables ***
${branch}               main
${latest_commit}        (//h2[@class="f5 text-normal"])[1]

*** Keywords ***
Convert Month String To Number
    [Arguments]         ${month_string}
    @{months}           Create List     Jan  Feb  Mar  Apr  May  Jun  Jul  Aug  Sep  Oct  Nov  Dec
    ${month_num}        Evaluate    $months.index($month_string) + 1
    [Return]            ${month_num}

*** Test Cases ***
Verify Latest Commit
    [Documentation]     Check the timestamp of latest commit.
    GoTo                https://github.com/joonasinisalo/copado-robotic-testing-examples/commits/${branch}

    # Get timestamp of the latest commit
    ${timestamp}        GetText    ${latest_commit}

    # Get current date in datetime format
    ${current_date}     Get Current Date    result_format=datetime
    Log                 ${current_date.year}    console=true

    # Parse timestamp to be comparable with datetime object
    @{timestamp_list}   Evaluate    $timestamp.split(" ")
    ${commit_day}       Evaluate    $timestamp_list[3].rstrip(",")
    ${commit_month}     Convert Month String To Number    ${timestamp_list}[2]
    ${commit_year}      Set Variable    ${timestamp_list}[4]

    # Verify that dates match (latest commit is made today)
    Should Be Equal As Numbers    ${commit_day}    ${current_date.day}
    Should Be Equal As Numbers    ${commit_month}    ${current_date.month}
    Should Be Equal As Numbers    ${commit_year}    ${current_date.year}
