*** Settings ***
Library       RequestsLibrary 
Library       Collections
Library       JSONLibrary
Library       os

*** Variables ***
${base_url}                   https://reqres.in
${page}                       2

*** Test Cases ***
TC1: Get all users first name and email (GET) on page 2
  create session              mysession                         ${base_url}
  ${response}=                get request                       mysession                             /api/users?page=${page}
  ${json_object}=             to json                           ${response.content}

  # Single Data Validation
  ${status_code}=             convert to string                 ${response.status_code}
  should be equal             ${status_code}                    200
  ${response_page}=           get value from json               ${json_object}                        $.page
  ${page}=                    convert to integer                ${page}
  should be equal             ${response_page[0]}               ${page}

  # Multiple Data Validation
  ${first_names}=             get value from json         ${json_object}                       $..first_name
  ${first_name_count}=        get length                  ${first_names}
  ${first_name_count}=        convert to string           ${first_name_count}
  ${emails}=                  get value from json         ${json_object}                       $..email
  ${email_count}=             get length                  ${emails}
  ${email_count}=             convert to string           ${email_count}
  should be equal             ${first_name_count}         6
  should contain any          ${first_names}              Michael  Lindsay  Tobias  Byron  George  Rachel
  should be equal             ${email_count}              6
  should contain any          ${emails}                   michael.lawson@reqres.in  lindsay.ferguson@reqres.in tobias.funke@reqres.in  byron.fields@reqres.in  george.edwards@reqres.in rachel.howell@reqres.in
                                        


TC2: Get a single user by id (GET)
  create session              mysession                         ${base_url}
  ${response}=                get request                       mysession                                   /api/users/2
  ${json_object}=             to json                           ${response.content}

  # Single Data Validations
  ${status_code}=             convert to string                 ${response.status_code}
  should be equal             ${status_code}                    200
  ${email}=                   get value from json               ${json_object}                              data.email
  should be equal             ${email[0]}                       janet.weaver@reqres.in
  ${first_name}=              get value from json               ${json_object}                              data.first_name
  should be equal             ${first_name[0]}                  Janet
  ${last_name}=               get value from json               ${json_object}                              data.last_name
  should be equal             ${last_name[0]}                   Weaver
  ${avatar}=                  get value from json               ${json_object}                              data.avatar
  should be equal             ${avatar[0]}                 https://s3.amazonaws.com/uifaces/faces/twitter/josephstein/128.jpg               

TC4: Create a user (POST)
  create session              mysession                         ${base_url}
  ${body}=                    create dictionary                 name=Alex   job=QA Automation Engineer
  ${header}=                  create dictionary                 Content-Type=application/json
  ${response}=                post request                      mysession                                   /api/users      data=${body}                headers=${header}

  # Validations 
  ${status_code}=             convert to string                 ${response.status_code}
  should be equal             ${status_code}                    201
  ${res_body}=                convert to string                 ${response.content}
  should contain              ${res_body}                       Alex 
  should contain              ${res_body}                       QA Automation Engineer

TC5: Update job field for an already existing user (PUT)
  create session              mysession                         ${base_url}
  ${body}=                    create dictionary                 job=Software Developer
  ${header}=                  create dictionary                 Content-Type=application/json
  ${response}=                put request                       mysession                                 /api/users/3      data=${body}                headers=${header}

  # Validations 
  ${status_code}=             convert to string                 ${response.status_code}
  should be equal             ${status_code}                    200
  ${res_body}=                convert to string                 ${response.content}
  should contain              ${res_body}                       Software Developer

TC6: Delete a user by id (DELETE)
  create session              mysession                         ${base_url}
  ${response}=                delete request                    mysession                                 /api/users/5

  # Validations
  ${status_code}=             convert to string                 ${response.status_code}
  should be equal             ${status_code}                    204
