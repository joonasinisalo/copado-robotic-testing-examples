*** Settings ***
Library                           QWeb
Library                           QVision
Library                           OperatingSystem
Library                           String


*** Variables ***
${BROWSER}                        chrome
${home_url}                       https://www.traficom.fi/en/communications/communications-networks/internal-networks


*** Keywords ***
Setup Browser
    Set Library Search Order      QWeb    QVision
    Open Browser                  about:blank    ${BROWSER}


End Suite
    Close All Browsers


Home
    GoTo                          ${home_url}
