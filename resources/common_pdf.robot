*** Settings ***
Library                           QWeb
Library                           QVision
Library                           String


*** Variables ***
${BROWSER}                        chrome
${home_url}                       https://www.traficom.fi/en/news/open-data


*** Keywords ***
Setup Browser
    Set Library Search Order      QWeb
    Open Browser                  about:blank    ${BROWSER}


End Suite
    Close All Browsers


Home
    GoTo                          ${home_url}
