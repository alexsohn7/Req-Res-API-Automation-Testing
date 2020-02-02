*** Settings ***
Library   RequestsLibrary 
Library   Collections


*** Variables ***
${base_url}   http://jsonplaceholder.typicode.com



*** Test Cases ***
TestHeaders
  create session              mysession                     ${base_url}
  ${response}=                get request                   mysession                         /photos

  # Validations
  ${contentTypeValue}=        get from dictionary           ${response.headers}               Content-Type
  should be equal             ${contentTypeValue}           application/json; charset=utf-8 

  ${contentTypeEncodeValue}=  get from dictionary           ${response.headers}               Content-Encoding
  should be equal             ${contentTypeEncodeValue}     gzip

TestCookies
  create session              mysession                     ${base_url}
  ${response}=                get request                   mysession                         /photos

  ${cookieValue}=             get from dictionary           ${response.cookies}               __cfduid
  log to console              ${cookieValue}