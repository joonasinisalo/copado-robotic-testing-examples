*** Settings ***
Resource                    ../resources/common_pdf.robot
Suite Setup                 Setup Browser
Suite Teardown              End Suite


*** Test Cases ***
Read PDF Text
    [Documentation]         Read values from a pdf file.
    AppState                Home
    VerifyText              Open data for vehicles
    ClickText               Open data for vehicles
    ScrollText              Open data for vehicles contains registration, approval and technical information

    ClickText               ${open_data_faq}    partial_match=true

    # Pdf opens to a new tab and we need to switch focus
    SwitchWindow            NEW

    # Use QVision library to access elements on the pdf viewer
    QVision.SetReferenceFolder   ../resources/images
    QVision.ClickIcon       pdf_download_icon
    ExpectFileDownload
    QVision.ClickText       Save    anchor=Cancel

    # When dowloading a large file there should be a waiting mechanism
    UsePdf                  /root/Downloads/${pdf_file}.pdf

    # Read file contents to a variable and find an address
    ${file_content}         GetPdfText
    ${find_position}        Evaluate    $file_content.find("${text_in_file}")
    ${onsight_address}      Evaluate    $file_content[$find_position:$find_position+77].lstrip("${text_in_file}; ")
    Log                     ${onsight_address}    console=true
    
    CloseWindow
    SwitchWindow            1
