*** Settings ***
Library             OperatingSystem
Library             Browser
Suite Setup         Check URL and open browser
Suite Teardown      Close browser

*** Variables ***
${BROWSER}          chromium
${URL}              ${EMPTY}

*** Tasks ***
Capture Screenshot
    Skip if  not $URL  msg=Target URL not specified
    New Page  ${URL}
    Take Screenshot  EMBED

*** Keywords ***
Open browser defined by environment
    ${browser}=  Get Environment Variable    BROWSER    ${BROWSER}
    New Browser  ${browser}
    New Context  viewport={'width': 1280, 'height': 720}

Check URL and open browser
    Skip if  not $URL  msg=Target URL not specified
    Open browser defined by environment
