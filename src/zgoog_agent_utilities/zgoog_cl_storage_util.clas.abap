class ZGOOG_CL_STORAGE_UTIL definition
  public
  create public .

public section.

  class-methods READ_FILE_FROM_GCS
    importing
      !IV_KEY_NAME type /GOOG/KEYNAME
      !IV_BUCKET type STRING
      !IV_OBJECT type STRING
    returning
      value(R_RESULT) type STRING
    raising
      /GOOG/CX_SDK .
protected section.
private section.
ENDCLASS.



CLASS ZGOOG_CL_STORAGE_UTIL IMPLEMENTATION.


  METHOD read_file_from_gcs.


    DATA ls_data      TYPE xstring.
    DATA ls_output    TYPE /goog/cl_storage_v1=>ty_013.
    DATA lv_ret_code  TYPE i.
    DATA ls_err_resp  TYPE /goog/err_resp.
    DATA lo_exception TYPE REF TO /goog/cx_sdk.
    DATA lv_length TYPE i.
    DATA lt_bin_tab TYPE TABLE OF char1024.
    DATA lv_err_text  TYPE string.



    DATA(lo_client) = NEW /goog/cl_storage_v1( iv_key_name = iv_key_name ).

    lo_client->add_common_qparam( iv_name = 'alt' iv_value = 'media' ).

    lo_client->get_objects(
      EXPORTING
        iv_p_bucket = iv_bucket
        iv_p_object = iv_object
      IMPORTING
        es_output   = ls_output
        ev_ret_code = lv_ret_code
        ev_err_text = lv_err_text
        es_err_resp = ls_err_resp
        es_raw = ls_data ).


    IF lo_client->is_success( lv_ret_code ).

      CALL FUNCTION 'SCMS_XSTRING_TO_BINARY'
        EXPORTING
          buffer        = ls_data
        IMPORTING
          output_length = lv_length
        TABLES
          binary_tab    = lt_bin_tab.

      CALL FUNCTION 'SCMS_BINARY_TO_STRING'
        EXPORTING
          input_length = lv_length
        IMPORTING
          text_buffer  = r_result
        TABLES
          binary_tab   = lt_bin_tab
        EXCEPTIONS
          failed       = 1
          OTHERS       = 2.
      IF sy-subrc <> 0.
        lv_err_text = 'Error convering Binary to String'.
        CALL METHOD /goog/cl_vertex_ai_sdk_utility=>raise_error
          EXPORTING
            iv_ret_code = /goog/cl_http_client=>c_ret_code_461
            iv_err_text = lv_err_text.
      ENDIF.


    ELSE.
      CALL METHOD /goog/cl_vertex_ai_sdk_utility=>raise_error
        EXPORTING
          iv_ret_code = lv_ret_code
          iv_err_text = lv_err_text.
    ENDIF.

    "Close HTTP Connection
    lo_client->close( ).



  ENDMETHOD.
ENDCLASS.
