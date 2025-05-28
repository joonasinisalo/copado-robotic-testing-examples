*** Settings ***
Library                       QVision
Library                       OperatingSystem
Resource                      ../resources/common.resource
Suite Setup                   Setup Browser
Suite Teardown                CloseAllBrowsers


***Variables***
${FILENAME}                   example_file.csv


*** Test Cases ***
Upload File Using File Explorer
    Set Library Search Order    QForce    QWeb    QVision
    Login
    LaunchApp                 Files
    VerifyText                Owned by Me    anchor=Files

    # Test job name (=folder name) is the first item in the suite name string, separated by dots
    @{test_suite}=            Split String    ${SUITE NAME}    .

    ClickText                 Upload Files    partial_match=false    delay=1
    QVision.VerifyText        Desktop

    # There's different folder structure between run environments that needs to be taken into account
    IF    "${EXECDIR}" == "/home/executor/execution"    # regression or development run
        RunBlock                  Double Click And Verify    execution           ${test_suite}[0]        timeout=45
        RunBlock                  Double Click And Verify    ${test_suite}[0]    files              1    timeout=45
    ELSE    # Live Testing
        RunBlock                  Double Click And Verify    suite               files                   timeout=45
    END

    RunBlock                  Double Click And Verify        files               ${FILENAME}             timeout=45
    RunBlock                  Double Click And Verify        ${FILENAME}         Upload Files            timeout=45

    ClickText                 Done    partial_match=false    delay=2
    VerifyText                was uploaded

    ClickText                 Home
    VerifyText                Seller Home

Delete Uploaded File
    Set Library Search Order    QForce    QWeb    QVision
    Home
    LaunchApp                 Files
    VerifyText                Owned by Me    anchor=Files

    # File name wihtout file type
    @{file_name}=             Split String    ${FILENAME}    .

    VerifyText                ${file_name}[0]
    ClickItem                 rowActionsPlaceHolder    anchor=${file_name}[0]
    ClickText                 Delete    partial_match=false    delay=1
    VerifyText                Delete File?
    ClickText                 Delete    anchor=Cancel    delay=1
    VerifyText                "${file_name}[0]" was deleted

    ClickText                 Home
    VerifyText                Seller Home


*** Keywords ***
Double Click And Verify
    [Arguments]               ${text_to_click}    ${text_to_verify}    ${text_to_click_index}=0
    Set Library Search Order    QForce    QWeb    QVision
    IF    ${text_to_click_index} == 0
        QVision.DoubleClick       ${text_to_click}
    ELSE
        QVision.DoubleClick       ${text_to_click}    index=${text_to_click_index}
    END
    QVision.VerifyText        ${text_to_verify}
