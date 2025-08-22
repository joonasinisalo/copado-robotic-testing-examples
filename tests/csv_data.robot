*** Settings ***
Resource                      ../resources/common.resource
Resource                      ../resources/csv.resource
Suite Setup                   Setup Browser
Suite Teardown                Close All Browsers


*** Test Cases ***
Create Account From Data
    [Tags]                    account    csv
    Login
    LaunchApp                 Sales

    # Read account data from a csv file. It's a list of dictionaries, where each
    # line from the csv file is a dictionary item in the list.
    @{data_list}=             Read Account Data    ${CURDIR}/../files/accounts.csv

    FOR    ${item}    IN    @{data_list}
        ClickItem                 Accounts    tag=a
        VerifyText                Recently Viewed    anchor=Accounts

        ClickUntil                Account Information         New
        UseModal                  On

        TypeText                  Account Name    ${item}[Account Name]
        TypeText                  Phone    ${item}[Phone]    anchor=Fax    delay=1
        TypeText                  Fax    ${item}[Fax]    delay=1
        TypeText                  Website    ${item}[Website]    delay=1
        Picklist                  Type    ${item}[Type]
        Picklist                  Industry    ${item}[Industry]

        TypeText                  Employees    ${item}[Employees]
        TypeText                  Annual Revenue    ${item}[Annual Revenue]    delay=1

        ClickText                 Save    partial_match=False    delay=1
        UseModal                  Off

        VerifyText                was created.

        VerifyText                ${item}[Account Name]    anchor=Account
    END
