*** Settings ***
Resource                    ../resources/common_pdf.robot
Suite Setup                 Setup Browser
Suite Teardown              End Suite


*** Test Cases ***
Read PDF Text
    [Documentation]         Read values from a pdf file.
    AppState                Home
    VerifyText              Finnish Transport and Communications Agency

    ${consent}=             IsText    CONSENT: visitor statistics
    IF                      ${consent}    ClickText    Block    anchor=Allow

    ScrollText              Internal networks in properties
    ClickText               Regulation 65 on internal networks

    # Live Testing and normal test runs use different execution and download directories
    # and that needs to be taken into account
    IF    "${EXECDIR}" == "/home/executor/execution"    # normal test run environment
        ${downloads_folder}=    Set Variable    /home/executor/Downloads
    ELSE    # Live Testing environment
        ${downloads_folder}=    Set Variable    /home/services/Downloads
    END

    # Extract pdf file name from the download link
    ${download_link}=       GetAttribute    //span[contains(text(), "Regulation 65D/2019")]/../..    href
    ${pdf_file}=            Evaluate    $download_link.split("/")[-1]

    # Clicking the file name starts the download, therefore calling ExpectFileDownload first
    ExpectFileDownload
    ClickText               Regulation 65D/2019

    ${file_exists}          Set Variable    False

    # Wait for file download
    FOR    ${i}    IN RANGE    0    20
        ${file_exists}      Run Keyword And Return Status
        ...                 File Should Exist    ${downloads_folder}/${pdf_file}

        IF                  ${file_exists}       BREAK
        Sleep               0.5s
    END

    List Files In Directory    ${downloads_folder}

    # When dowloading a large file there should be a waiting mechanism
    UsePdf                  ${downloads_folder}/${pdf_file}

    # Read file contents to a variable, find a text field from the file and return its contents
    ${file_content}         GetPdfText
    ${find_position}        Evaluate    $file_content.find("Modification details:")
    ${details}              Evaluate    $file_content[$find_position:$find_position+153].lstrip("Modification details:")
    Log                     ${details}    console=true
