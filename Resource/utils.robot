[Documentation]            Keywords that will be used in main .robot

*** Settings ***

Library           RPA.Tables
Library           RPA.Excel.Files
Library           RPA.HTTP
Library           RPA.Browser.Selenium
Library           RPA.PDF
Library           Collections
Library           RPA.Archive




*** Keywords ***



    
Get orders
    Download         https://robotsparebinindustries.com/orders.csv        overwrite=True
    @{Table}=        Read table from CSV        ${CURDIR}/../orders.csv
    Log List         ${Table}
    [Return]         @{Table}




Close the annoying modal
    Wait Until Page Contains Element            //li//a[text()="Order your robot!"]
    Click Element If Visible                    //div[@class="alert-buttons"]//button[@class="btn btn-dark" and text()="OK"]
    

