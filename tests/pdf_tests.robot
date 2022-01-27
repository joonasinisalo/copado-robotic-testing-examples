*** Settings ***
Resource                    ../resources/common_pdf.robot
Suite Setup                 Setup Browser
Suite Teardown              End Suite


*** Test Cases ***
Verify PDF
    [Documentation]         Read values from a pdf file.
    AppState                Home
    VerifyText              Open data for vehicles
    ClickText               Open data for vehicles
    ScrollText              Open data for vehicles contains registration, approval and technical information

    ClickText               Usein kysytyt kysymykset Avoin Data    partial_match=true

    # Pdf opens to a new tab and we need to switch focus
    SwitchWindow            NEW

    # Use QVision library to access elements on the pdf viewer
    QVision.SetReferenceFolder   ../resources/images
    ClickText               Download         
    QVision.ClickIcon       pdf_download_icon
    ExpectFileDownload
    QVision.ClickText       Save    anchor=Cancel

    # TODO: wait for download to complete
    UsePdf                  /root/Downloads/Preview-Q-05362-18102021.pdf

    # Read file contents to a variable and find expiration date
    ${file_content}         GetPdfText
    ${date_position}        Evaluate    $file_content.find("Expiration")
    ${exp_date}             Evaluate    $file_content[$date_position:$date_position+20].lstrip("Expiration ")
    Should Be Equal As Strings    ${exp_date}    11/18/20    strip_spaces=true

