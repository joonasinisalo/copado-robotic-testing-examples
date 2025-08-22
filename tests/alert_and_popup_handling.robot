*** Settings ***
Library                 QWeb
Suite Setup             Open Browser    about:blank    chrome
Suite Teardown          Close All Browsers


*** Test Cases ***
Popup Test
    GoTo                https://demoqa.com/alerts
    VerifyTitle         DEMOQA
    VerifyText          Alerts

    # 1. Alert
    ClickText           Click me    anchor=Click Button to see alert
    CloseAlert          ACCEPT

    # 2. Confirm box
    ClickText           Click me    anchor=On button click, confirm box will appear
    CloseAlert          ACCEPT

    # 3. Prompt box
    ClickText           Click me    anchor=On button click, prompt box will appear
    WriteText           Jane
    ClickText           OK    anchor=Cancel
    