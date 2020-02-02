*** Settings ***
Library       RequestsLibrary 
Library       Collections

*** Variables ***
${base_url}                   https://reqres.in

*** Test Cases ***
TC1: Returns all users (GET)
  create session          mysession               ${base_url}
  ${response}=            get request             mysession         /api/users?page=2

  # Validation 
  ${status_code}=         convert to string       ${response.status_code}
  should be equal         ${status_code}          200

TC2: Add a new user (POST)
  create session          mysession               ${base_url}
  ${body}=                create dictionary       name=Alex                         job=QA Automation Engineer
  ${header}=              create dictionary       Content-Type=application/json
  ${response}=            post request            mysession          /api/users     data=${body}          headers=${header}

  # Validation 
  ${status_code}=         convert to string       ${response.status_code}
  should be equal         ${status_code}          201

  ${res_body}=            convert to string       ${response.content}
  should contain          ${res_body}             id 
  should contain          ${res_body}             createdAt

TC3: Get a single user by id (GET)
  create session          mysession               ${base_url}
  ${response}=            get request             mysession        /api/users/2

  # Validation 
  ${status_code}=         convert to string       ${response.status_code}
  should be equal         ${status_code}          200

  ${res_body}=            convert to string       ${response.content}
  should contain          ${res_body}             Janet

TC4: Update an existing user's job
  create session          mysession               ${base_url}
  ${body}=                create dictionary       job= Construction worker
  ${header}=              create dictionary       Content-Type=application/json
  ${response}=            put request             mysession         /api/users/4        data=${body}      headers=${header}

  # Validations
  ${status_code}=         convert to string       ${response.status_code}
  should be equal         ${status_code}          200
  ${res_body}=            convert to string       ${response.content}
  should contain          ${res_body}             Construction worker

TC5: Delete a user by id
  create session          mysession               ${base_url}
  ${response}=            delete request          mysession         /api/users/3        

  # Validations
  ${status_code}=         convert to string       ${response.status_code}
  should be equal         ${status_code}          204  