*** Settings ***
Library                 QWeb
Library                 QVision
Library                 QImage
Suite Setup             Open Browser    about:blank    chrome
Suite Teardown          Close All Browsers


*** Test Cases ***
Verify Image
    Set Library Search Order    QWeb    QVision
    GoTo                https://qentinelqi.github.io/shop/
    VerifyText          Find your spirit animal

    

*** Keywords ***
Home
    [Documentation]     Set the application state to the shop home page.
    GoTo                https://qentinelqi.github.io/shop/
