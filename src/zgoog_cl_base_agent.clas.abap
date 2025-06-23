class ZGOOG_CL_BASE_AGENT definition
  public
  abstract
  create public .

public section.

  types:
      "! Structure for defining agent tools (ABAP Functions/Methods)
    BEGIN OF ty_tool_parameter,
        name        TYPE string,
        type        TYPE string, " e.g., 'string', 'number', 'integer', 'boolean', 'array', 'object'
        description TYPE string,
        is_required TYPE boolean,
      END OF ty_tool_parameter .
  types:
    tt_tool_parameters TYPE STANDARD TABLE OF ty_tool_parameter WITH EMPTY KEY .
  types:
    BEGIN OF ty_tool_definition,
        name           TYPE string,             " Name of the Function Module or Method (as registered)
        description    TYPE string,
        parameters     TYPE tt_tool_parameters,
        implementation TYPE string,             " Function Module name or Class-Method name (for reference)
      END OF ty_tool_definition .
  types:
    tt_tool_definitions TYPE STANDARD TABLE OF ty_tool_definition WITH EMPTY KEY .

  methods GET_MODEL_KEY
  ABSTRACT
    returning
      value(R_RESULT) type /GOOG/MODEL_KEY
    raising
      /GOOG/CX_SDK .
  methods GET_SYSTEM_INSTRUCTION
  ABSTRACT
    returning
      value(R_RESULT) type STRING
    raising
      /GOOG/CX_SDK .
  methods GET_TOOL_DEFINITIONS
  ABSTRACT
    returning
      value(R_RESULT) type TT_TOOL_DEFINITIONS
    raising
      /GOOG/CX_SDK .
  methods PROCESS_PROMPT
    importing
      !IV_PROMPT type STRING
    returning
      value(R_RESULT) type STRING
    raising
      /GOOG/CX_SDK .
  methods GET_CLIENT_KEY
    returning
      value(R_RESULT) type /GOOG/KEYNAME
    raising
      /GOOG/CX_SDK .
  methods INITIALIZE_AGENT
    raising
      /GOOG/CX_SDK .
protected section.

  data MO_GEMINI_MODEL type ref to /GOOG/CL_GENERATIVE_MODEL .
  data MT_TOOLS_REGISTERED type TT_TOOL_DEFINITIONS .
private section.
ENDCLASS.



CLASS ZGOOG_CL_BASE_AGENT IMPLEMENTATION.


  METHOD get_client_key.

    DATA lv_model_key TYPE /goog/model_key.
    DATA lx_sdk TYPE REF TO /goog/cx_sdk.

    lv_model_key = me->get_model_key( ).

    SELECT SINGLE client_key INTO r_result
      FROM /goog/ai_config
      WHERE model_key = lv_model_key.

    IF sy-subrc <> 0.
      lx_sdk = NEW /goog/cx_sdk( msgtx = 'Client key not found' ).
      RAISE EXCEPTION lx_sdk.
    ENDIF.


  ENDMETHOD.


  METHOD initialize_agent.

    me->mo_gemini_model = NEW /goog/cl_generative_model( iv_model_key = me->get_model_key( ) ).

    me->mo_gemini_model->set_system_instructions( get_system_instruction( ) ).


  ENDMETHOD.


  METHOD process_prompt.

    " Generate content using the prompt
    DATA(lo_response) = mo_gemini_model->generate_content( iv_prompt_text = iv_prompt ).

    " Get the final text response
    r_result = lo_response->get_text( ).

  ENDMETHOD.
ENDCLASS.
