*** Settings ***
Library       RequestsLibrary 
Library       Collections

*** Variables ***
${base_url}   https://restapi.demoqa.com

*** Test Cases ***
Basic Auth Test
  ${auth}=            create list            ToolsQA            TestPassword
  create session      mysession              ${base_url}        auth=${auth}
  ${response}=        get request            mysession            /authentication/CheckForAuthentication/
  ${json_object}=     to json                ${response.content} 

  # Validation
  should be equal as strings    ${response.status_code}         200