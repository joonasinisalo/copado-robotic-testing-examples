*** Settings ***
Documentation           Test suite for Json parsing.
Library                 QWeb
Library                 String
Library                 Collections
Library                 OperatingSystem
Library                 JSONLibrary
Suite Setup             Open Browser    about:blank    chrome
Suite Teardown          Close All Browsers


*** Variables ***
${client_list}          ${CURDIR}/../resources/test_data/client_data.json
${product_list}         ${CURDIR}/../resources/test_data/clients_and_products.json
${sandbox_users}        ${CURDIR}/../resources/test_data/sandbox_users.json
${rest_api_data}        ${CURDIR}/../resources/rest_api_data.json


*** Test Cases ***
Read Data from JSON
    GoTo                https://qentinelqi.github.io/shop/
    ClickText           Contact
    VerifyText          Get in touch

    @{json_data}       Evaluate   json.load(open('${client_list}'))   json
    
    FOR                 ${item}    IN    @{json_data}
        Log             ${item}    console=true
        TypeText        Enter your name...    ${item}[name]    delay=1
        TypeText        Enter your email...    ${item}[email]    delay=1
    END

JSON With Nested Dictionaries
    GoTo                https://qentinelqi.github.io/shop/
    ClickText           Contact
    VerifyText          Get in touch

    @{json_data}        Evaluate   json.load(open('${product_list}'))   json

    Log To Console      ${json_data}[0][product][price]

    Print Products      ${json_data}

Read User Data with JSONlibrary
    ${json}=            Load JSON From File    ${sandbox_users}

    # Get username of the second test user
    ${username}=        Get Value From Json    ${json}    $.Sandboxes.TestUsers[1].UserName
    
    # Convert the returned list to string since Get Value From Json returns a list
    ${username_string}=    Convert To String    ${username}[0]

Write to JSON
    GoTo                https://qentinelqi.github.io/shop/
    ClickText           Contact
    VerifyText          Get in touch

    @{json_data}        Evaluate   json.load(open('${clients_products}'))   json

    # Create a message with product info 
    #TypeText            Enter your name...    ${json_data[1]['name']}    delay=1    # old style
    TypeText            Enter your name...    ${json_data}[1][name]    delay=1
    #TypeText            Enter your email...    ${json_data[1]['email']}    delay=1
    TypeText            Enter your email...    ${json_data}[1][email]    delay=1
    #TypeText            Enter your message...    I have product ${json_data[1]['product']['product_name']} which costs ${json_data[1]['product']['price']}
    TypeText            Enter your message...    I have product ${json_data}[1][product][product_name] which costs ${json_data}[1][product][price]

    # Generate new price
    Evaluate            random.seed()    random    # initialize random generator
    ${new_price}=       Generate Random String    3    [NUMBERS]

    # Change product name
    ${new_product_name}=    Set Variable    Henry the Hedgehog

    # Update new product name and price (as integer) to a nested dictionary
    Set To Dictionary   ${json_data}[1][product]    product_name=${new_product_name}
    Set To Dictionary   ${json_data}[1][product]    price=${${new_price}}

    # Write updated product to message field
    TypeText            Enter your message...    I have product ${json_data}[1][product][product_name] which costs ${json_data}[1][product][price]

    # Save changes to a new file
    ${json_string}=     Evaluate    json.dumps(${json_data})    json
    ${new_json_file}=   Set Variable    ${CURDIR}/../resources/test_data/clients_and_products2.json
    Create File         ${new_json_file}    ${json_string}
    Log File            ${new_json_file}

    # Open the newly created file as json data
    @{json_data}        Evaluate   json.load(open('${new_json_file}'))   json

    
*** Keywords ***
Print Products
    [Arguments]    ${data}
    FOR                 ${item}    IN    @{data}
        Log             ${item}    console=true
        TypeText        Enter your name...    ${item}[name]    delay=1
        TypeText        Enter your email...    ${item}[email]    delay=1

        TypeText        Enter your message...
        ...    I have product ${item}[product][product_name] which costs ${item}[product][price]
    END
