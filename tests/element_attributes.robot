*** Settings ***
Library                 QWeb
Suite Setup             Open Browser    about:blank    chrome
Suite Teardown          Close All Browsers


*** Test Cases ***
Get Element Color
    GoTo                https://qentinelqi.github.io/shop/
    VerifyText          Find your spirit animal

    # Shopping cart
    ${elem}=            GetWebElement   //i[@class\="material-icons"]
    ${color}=           Evaluate    $elem[0].value_of_css_property("color")

    # Sacha the Deer second style picker
    ${elem}=            GetWebElement   //ul[@class\="product-list"]/li[1]//div[@class\="style-picker"]/div[2]
    ${color}=           Evaluate    $elem[0].value_of_css_property("background-color")
    Log                 ${color}
    Log To Console      ${color}
