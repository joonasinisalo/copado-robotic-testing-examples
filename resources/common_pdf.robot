*** Settings ***
Library                           QWeb
Library                           QVision
Library                           String


*** Variables ***
${BROWSER}                        chrome
${home_url}                       https://www.traficom.fi/en/news/open-data
${open_data_faq}                  Usein kysytyt kysymykset Avoin Data
${pdf_file}                       Avoin Data 10 kysytyintä kysymystä
${text_in_file}                   Excelissä
${images_dir}                     ../resources/images


*** Keywords ***
Setup Browser
    Set Library Search Order      QWeb
    Open Browser                  about:blank    ${BROWSER}


End Suite
    Close All Browsers


Home
    GoTo                          ${home_url}
