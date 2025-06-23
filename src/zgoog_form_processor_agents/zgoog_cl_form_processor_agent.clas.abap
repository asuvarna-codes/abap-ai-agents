class ZGOOG_CL_FORM_PROCESSOR_AGENT definition
  public
  inheriting from ZGOOG_CL_BASE_AGENT
  create public .

public section.

  methods SET_FORM_GCS_URI
    importing
      !IV_MIME_TYPE type STRING default 'application/pdf'
      !IV_FILE_URI type STRING .

  methods GET_MODEL_KEY
    redefinition .
  methods GET_SYSTEM_INSTRUCTION
    redefinition .
  methods GET_TOOL_DEFINITIONS
    redefinition .
  methods INITIALIZE_AGENT
    redefinition .
protected section.
private section.
ENDCLASS.



CLASS ZGOOG_CL_FORM_PROCESSOR_AGENT IMPLEMENTATION.


  METHOD get_model_key.
    r_result = 'form-agent'.
  ENDMETHOD.


  METHOD get_system_instruction.

    DATA lv_bucket TYPE string VALUE 'abap-form-agent'.
    DATA lv_object TYPE string VALUE 'agent-metadata/form-agent-system-instruction.txt'.

    TRY.
        r_result = zgoog_cl_storage_util=>read_file_from_gcs(
            iv_key_name = me->get_client_key( ) " Associated Google Cloud Key Name
            iv_bucket   = lv_bucket       " GCS Bucket
            iv_object   = lv_object       " GCS File Name
        ).

        IF r_result IS NOT INITIAL.
          RETURN.
        ENDIF.
      CATCH /goog/cx_sdk. " ABAP SDK for Google Cloud: Exception Class
        "Do nothing
    ENDTRY.




    "Set default instructions.
    r_result = |<OBJECTIVE_AND_PERSONA>| && cl_abap_char_utilities=>newline &&
               |You are an intelligent agent designed to extract arbitrary data fields from supplied PDF documents.| && cl_abap_char_utilities=>newline &&
               |Your primary goal is to identify fields based on their labels, extract corresponding values using contextual information, | &&
               |and deliver the output in a JSON format with lowercase-first camel case field names.| && cl_abap_char_utilities=>newline &&
               |You must **ignore any text or images identified as watermarks** during the entire process, | &&
               |and if a watermark affects an extracted value, that value should also be ignored/not included.| && cl_abap_char_utilities=>newline &&
               cl_abap_char_utilities=>newline && " Blank line
               |Your capabilities include:| && cl_abap_char_utilities=>newline &&
               cl_abap_char_utilities=>newline && " Blank line
               |1. Thorough Document Review: Carefully read and understand the entire PDF document's structure and layout.| && cl_abap_char_utilities=>newline &&
               |2. Watermark Handling: Before any other processing, identify and isolate watermarks (faint, repetitive, overlaid patterns). | &&
               |**Crucially, ignore all watermark content and any values affected by watermarks.**| && cl_abap_char_utilities=>newline &&
               |3. Field Identification by Label: Locate data fields by identifying their labels within the document. | &&
               | The Label to be identified will be provided in the prompt.Do not extract field data if labels do not exactly match.| && cl_abap_char_utilities=>newline &&
               |4. Contextual Value Extraction: Determine how the value is related to the label (e.g., directly below, to the right, or several words/lines away but associated) and extract it reliably.| && cl_abap_char_utilities=>newline &&
               |5. Missing Data Handling: If a label cannot be located, return it as an error field within the 'errors' array in the output JSON.| && cl_abap_char_utilities=>newline &&
               |6. Completeness Score Calculation: Calculate (Number of Successfully Extracted Fields) / (Total Number of Expected Fields) * 100.| && cl_abap_char_utilities=>newline &&
               |</OBJECTIVE_AND_PERSONA>| && cl_abap_char_utilities=>newline &&
               cl_abap_char_utilities=>newline && " Blank line
               |<INSTRUCTIONS>| && cl_abap_char_utilities=>newline &&
               |To complete the task, you need to follow these steps:| && cl_abap_char_utilities=>newline &&
               cl_abap_char_utilities=>newline && " Blank line
               | * Step 1: Watermark Recognition and Isolation. Identify and isolate faint or repetitive patterns that don't align from the same location. This is the first action to perform.| && cl_abap_char_utilities=>newline &&
               | * Step 2: Label Identification. Locate any field by its label and in the instruction provided in the prompt directing to the appropriate section in the document to extract the corresponding value.| && cl_abap_char_utilities=>newline &&
               | * Step 3: Value Context Determination. Determine the relationship between the label and its value (e.g., directly below, to the right, or associated despite distance).| && cl_abap_char_utilities=>newline &&
               | * Step 4: Value Extraction. Reliably grab the information from the correct value field.| && cl_abap_char_utilities=>newline &&
               |</INSTRUCTIONS>| && cl_abap_char_utilities=>newline &&
               cl_abap_char_utilities=>newline && " Blank line
               |<OUTPUT_FORMAT>| && cl_abap_char_utilities=>newline &&
               |Output Format: JSON with lowercase-first camel case field names. The sample structure will be provided as part of the prompt. | &&
               |The structure will include 'extractedData', 'completenessScore', and an 'errors' array. List of fields that failed to extract | &&
               |due to missing labels or if the label was not found in error array.| && cl_abap_char_utilities=>newline &&
               |</OUTPUT_FORMAT>|.
  ENDMETHOD.


  method GET_TOOL_DEFINITIONS.
  endmethod.


  METHOD initialize_agent.

    CALL METHOD super->initialize_agent.

    mo_gemini_model->set_response_mime_type('application/json' ).

  ENDMETHOD.


  METHOD set_form_gcs_uri.

    mo_gemini_model->set_file_data( iv_file_uri =  iv_file_uri ).

  ENDMETHOD.
ENDCLASS.
