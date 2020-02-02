*** Settings ***
Library       RequestsLibrary 
Library       Collections

*** Variables ***
${base_url}                   https://reqres.in

*** Test Cases ***
TC1: Get all users (GET)
  create session              mysession                         ${base_url}
  ${response}=                get request                       mysession                                   /api/users?page=2

  # Validations
  ${status_code}=             convert to string                 ${response.status_code}
  should be equal             ${status_code}                    200

TC2: Get a single user by id (GET)
  create session              mysession                         ${base_url}
  ${response}=                get request                       mysession                                   /api/users/2

  # Validations
  ${status_code}=             convert to string                 ${response.status_code}
  should be equal             ${status_code}                    200

TC2: Create a user (POST)
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

TC3: Update job field for an already existing user (PUT)
  create session              mysession                         ${base_url}
  ${body}=                    create dictionary                 job=Software Developer
  ${header}=                  create dictionary                 Content-Type=application/json
  ${response}=                put request                       mysession                                 /api/users/3      data=${body}                headers=${header}

  # Validations 
  ${status_code}=             convert to string                 ${response.status_code}
  should be equal             ${status_code}                    200
  ${res_body}=                convert to string                 ${response.content}
  should contain              ${res_body}                       Software Developer

TC4: Delete a user by id (DELETE)
  create session              mysession                         ${base_url}
  ${response}=                delete request                    mysession                                 /api/users/5

  # Validations
  ${status_code}=             convert to string                 ${response.status_code}
  should be equal             ${status_code}                    204
