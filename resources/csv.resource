*** Settings ***
Library               QForce
Library               OperatingSystem
Resource              ${CURDIR}/common.resource


*** Keywords ***
Read Account Data
    [Documentation]               Read a csv file and return a list of dictionaries where keys are created from the values
    ...                           of the first row of the csv. Expects a csv with 8 columns
    [Arguments]                   ${csv_file_arg}

    ${csv}=                       Get File    ${csv_file_arg}

    # Read header row to separate values
    ${header}=                    Get Line    ${csv}    0
    @{header_values}=             Split String    ${header}    ;

    @{read}=                      Create List    ${csv}
    @{data_lines}=                Split To Lines    @{read}    1

    # Create a list where to store the created dictionaries
    @{data_dict_list}=            Create List

    # Create a dictionary of each data line where keys are header values
    FOR    ${data_line}    IN    @{data_lines}
        @{data_values}=               Split String    ${data_line}    ;
        &{data_dict}=                 Create Dictionary
        ...    ${header_values}[0]=${data_values}[0]
        ...    ${header_values}[1]=${data_values}[1]
        ...    ${header_values}[2]=${data_values}[2]
        ...    ${header_values}[3]=${data_values}[3]
        ...    ${header_values}[4]=${data_values}[4]
        ...    ${header_values}[5]=${data_values}[5]
        ...    ${header_values}[6]=${data_values}[6]
        ...    ${header_values}[7]=${data_values}[7]

        Append To List                ${data_dict_list}    ${data_dict}
    END

    RETURN                        @{data_dict_list}
