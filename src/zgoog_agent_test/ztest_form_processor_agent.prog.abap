*&---------------------------------------------------------------------*
*& Report ZTEST_FORM_PROCESSOR_AGENT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztest_form_processor_agent.

INCLUDE ztest_form_processor_agent_def.


START-OF-SELECTION.

  DATA lo_agent TYPE REF TO zgoog_cl_form_processor_agent.
  DATA lv_bucket TYPE string VALUE 'abap-form-agent'.
  DATA lv_object TYPE string VALUE 'agent-metadata/form-agent-prompt1.txt'.
  DATA lv_prompt TYPE string.
  DATA lv_result TYPE string.
  DATA lx_sdk TYPE REF TO /goog/cx_sdk.


  TRY.
      "Step1: Initialize the agent
      lo_agent = NEW zgoog_cl_form_processor_agent( ).
      lo_agent->initialize_agent( ).

      "Step2: Set the file path
      lo_agent->set_form_gcs_uri( iv_file_uri  = 'gs://abap-form-agent/Invoice1.pdf' ).

      "Step3: Process the prompt
      lv_prompt = zgoog_cl_storage_util=>read_file_from_gcs(
                    iv_key_name = lo_agent->get_client_key( )
                    iv_bucket   = lv_bucket
                    iv_object   = lv_object
                  ).

      lv_result = lo_agent->process_prompt( iv_prompt = lv_prompt ).


    CATCH /goog/cx_sdk INTO lx_sdk.
      cl_demo_output=>display_text( lx_sdk->if_message~get_text( ) ).
      return.
  ENDTRY.


  "Display JSON output
  cl_demo_output=>display_json( lv_result ).


  /ui2/cl_json=>deserialize(
                  EXPORTING
                    json             =  lv_result
                    pretty_name      =  /ui2/cl_json=>pretty_mode-extended
                  CHANGING
                    data             = ls_form_data ).


  "Display Structured Output
  cl_demo_output=>begin_section( 'From Page Header:' ).
  cl_demo_output=>write_data( ls_form_data-extracted_data-sb_no ).
  cl_demo_output=>end_section( ).

  cl_demo_output=>begin_section( 'From "PART - I - SHIPPING BILL SUMMARY" section "A STATUS" sub section:' ).
  cl_demo_output=>write_data( ls_form_data-extracted_data-dbk ).
  cl_demo_output=>write_data( ls_form_data-extracted_data-rodtp ).
  cl_demo_output=>end_section( ).

  cl_demo_output=>begin_section( 'From "PART - I - SHIPPING BILL SUMMARY" section "C.VALU SUMMA" sub section:' ).
  cl_demo_output=>write_data( ls_form_data-extracted_data-com ).
  cl_demo_output=>end_section( ).

  cl_demo_output=>begin_section( 'From "PART - I - SHIPPING BILL SUMMARY" section "D.EX.PR." sub section:' ).
  cl_demo_output=>write_data( ls_form_data-extracted_data-dbk_claim ).
  cl_demo_output=>write_data( ls_form_data-extracted_data-rodtep_amt ).
  cl_demo_output=>end_section( ).

  cl_demo_output=>begin_section( 'From "PART - I - SHIPPING BILL SUMMARY" section "F.INVOICE SUMMARY" sub section extract all records:' ).
  cl_demo_output=>write_data( ls_form_data-extracted_data-invoice_summary ).
  cl_demo_output=>end_section( ).

  cl_demo_output=>begin_section( 'From "PART - IV - EXPORT SCHEME DETAILS" section "A. DRAWBACK & ROSL CLAIM" sub section extract the below fields for all records:' ).
  cl_demo_output=>write_data( ls_form_data-extracted_data-drawback_rosl_claim ).
  cl_demo_output=>end_section( ).

  cl_demo_output=>display( ).
