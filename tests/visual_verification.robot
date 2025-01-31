*** Settings ***
Library                 QWeb
Library                 QVision
Library                 QImage
Library                 OperatingSystem
Suite Setup             Open Browser    about:blank    chrome
Suite Teardown          Close All Browsers


*** Variables ***
${BASE_IMAGE_PATH}      ${CURDIR}${/}..${/}resources${/}images


*** Test Cases ***
Compare Images
    Set Library Search Order    QWeb    QVision        
    GoTo                https://qentinelqi.github.io/shop/
    VerifyText          Find your spirit animal

    ClickText           Sacha the Deer
    VerifyText          Add to cart

    RightClick          //img[contains(@src, "deer")]
    QVision.ClickText   Save image as...
    QVision.ClickText   Save    anchor=Cancel

    # Fetch filename to a list
    ${image_files}=     List Files In Directory    /home/services/Downloads

    # Compare to same image
    CompareImages       /home/services/Downloads/${image_files}[0]    sacha_the_deer_image.jpg    tolerance=0.99

    # Compare to a modified image (should fail)
    CompareImages       /home/services/Downloads/${image_files}[0]    sacha_the_deer_modified_image.jpg    tolerance=0.99
    
    # Adjusting tolerance allows slight differences in images
    CompareImages       /home/services/Downloads/${image_files}[0]    sacha_the_deer_modified_image.jpg    tolerance=0.6
    

*** Keywords ***
Home
    [Documentation]     Set the application state to the shop home page.
    GoTo                https://qentinelqi.github.io/shop/
