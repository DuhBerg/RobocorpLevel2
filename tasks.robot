*** Settings ***
Documentation     Orders robots from RobotSpareBin Industries Inc.
...               Saves the order HTML receipt as a PDF file.
...               Saves the screenshot of the ordered robot.
...               Embeds the screenshot of the robot to the PDF receipt.
...               Creates ZIP archive of the receipts and the images.



Resource          ./Resource/utils.robot


*** Tasks ***
Order robots from RobotSpareBin Industries Inc
   Open the robot order website         


*** Keywords ***

Open the robot order website

    @{Orders}=        Get orders

    Open Available Browser               https://robotsparebinindustries.com    headless=True
    Wait Until Page Contains Element            //li//a[text()="Order your robot!"]
    Click Element If Visible                    //li//a[text()="Order your robot!"]
    
    FOR    ${Row}    IN    @{Orders}
        Fill form    ${Row}
    END
    
    Zipping PDFs




Fill form
    [Arguments]        ${Row}


    Close the annoying modal
    Select From List By Value    //select[@id="head"]       ${Row}[Head]  
    Click Element If Visible     //input[@type="radio" and @id="id-body-${Row}[Body]"]
    Input Text    //input[@class="form-control" and @placeholder="Enter the part number for the legs"]    ${Row}[Legs]
    Input Text    //input[@id="address"]    ${Row}[Address]
    Click Element If Visible     //button[@id="preview"]


    
    # ${pdf}=    Store the receipt as a PDF file    ${row}[Order number]
    ${pdf}=        Wait Until Keyword Succeeds    10x    0    Store the receipt as a PDF file    ${Row}[Order number]
    ${screenshot}=    Take a screenshot of the robot    ${Row}[Order number]
    Embed the robot screenshot to the receipt PDF file    ${screenshot}    ${pdf}
    
    Log        ${screenshot}
    
    Click Element If Visible     //button[@id="order-another"]



Zipping PDFs
    ${zip_file_name}=    Set Variable    ${OUTPUT_DIR}/PDFs.zip
    Archive Folder With Zip            ${OUTPUT_DIR}/receipts    ${zip_file_name}

Embed the robot screenshot to the receipt PDF file
    [Arguments]        ${screenshot}        ${pdf}
    Open Pdf        ${pdf}
    ${files}=    Create List    ${screenshot}
    Add Files To Pdf    ${files}    ${pdf}       True
    Close Pdf



Take a screenshot of the robot
    [Arguments]        ${OrderNumber}    

    
    ${screenshot}=        Set Variable        ${OUTPUT_DIR}${/}${OrderNumber}.png
    Capture Element Screenshot        //div[@id="robot-preview"]        ${screenshot}
    [Return]    ${screenshot}
    



Store the receipt as a PDF file
    [Arguments]        ${OrderNumber}        
    

    Click Element If Visible     //button[@id="order"]

    ${element}=      RPA.Browser.Selenium.Get Element Attribute        //div[@id="receipt"]      outerHTML   
    Html To Pdf         ${element}        ${OUTPUT_DIR}${/}receipts${/}${OrderNumber}.pdf 
    ${pdf}=    Set Variable        ${OUTPUT_DIR}${/}receipts${/}${OrderNumber}.pdf 
    [Return]    ${pdf}

