*** Settings ***
Resource                    ../resources/common_pdf.robot
Suite Setup                 Setup Browser
Suite Teardown              End Suite


*** Test Cases ***
Read PDF Text
    [Documentation]         Read values from a pdf file.
    VerifyText              EUR-Lex.europa.eu

    # Cookie consent handling
    ${consent}=             IsText    This site uses cookies
    IF                      ${consent}    ClickText    Accept only essential cookies

    ClickText               Access to European Union law

    VerifyTitle             EU law - EUR-Lex
    TypeText                Quick search    cookies\n

    VerifyText              Search Results
    ClickText               (EU) 2017/1128

    VerifyText              Document 32017R1128

    # Open the English version of the pdf document
    ClickItem               PDF English

    # Live Testing and normal test runs use different execution and download directories
    # and that needs to be taken into account
    IF    "${EXECDIR}" == "/home/executor/execution"    # normal test run environment
        ${downloads_folder}=    Set Variable    /home/executor/Downloads
    ELSE    # Live Testing environment
        ${downloads_folder}=    Set Variable    /home/services/Downloads
    END
 
    ${pdf_file}=            Set Variable    CELEX_32017R1128_EN_TXT.pdf

    #
    # Method 1: use QVision to verify text in the pdf reader
    #
    QVision.TypeText        100%    150\n
    QVision.ClickText       REGULATIONS
    FOR    ${i}    IN RANGE    ${1}    ${30}
        
        ${text_found}=    QVision.IsText    Subject matter and scope
        
        IF    ${text_found} == ${False}
            QVision.PageDown        1
        ELSE
            LogScreenshot
            BREAK
        END
    END

    #
    # Method 2: download the pdf and read its contents to a variable, find text from the content
    #

    # Define the location of reference images to QVision
    QVision.SetReferenceFolder   ${CURDIR}/../resources/images

    # QVision is needed to access elements in the pdf reader, use the reference icon to click the download button
    QVision.ClickIcon       pdf_download_icon

    # 
    ExpectFileDownload
    QVision.ClickText       Save    anchor=Cancel

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
    ${find_position}        Evaluate    $file_content.find("Article 1")
    ${details}              Evaluate    $file_content[$find_position:$find_position+36].lstrip("Article 1").replace("\\n", " ")
    Log                     ${details}    console=true
