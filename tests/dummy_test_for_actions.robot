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

*** Test Cases ***
Verify Latest Commit
    [Documentation]     Check the timestamp of latest commit.
    GoTo                https://github.com/joonasinisalo/copado-robotic-testing-examples/commits/${branch}
    ${timestamp}        GetText    ${latest_commit}
    ${current_date}     Get Current Date
