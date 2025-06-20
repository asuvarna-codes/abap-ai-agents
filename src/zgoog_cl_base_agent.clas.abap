class ZGOOG_CL_BASE_AGENT definition
  public
  create public .

public section.

  methods CONSTRUCTOR
    raising
      /GOOG/CX_SDK .
protected section.
private section.
ENDCLASS.



CLASS ZGOOG_CL_BASE_AGENT IMPLEMENTATION.


  METHOD constructor.

*    DATA(lv_model_id) = get_model_id( ). " Call abstract method
*    DATA(lv_system_instruction) = get_system_instruction( ). " Call abstract method
*    DATA(lt_tools) = get_tool_definitions( ). " Call abstract method
*    DATA(ls_inline_data) = get_inline_data( ). "Call abstract method
*
*    TRY.
*        " 1. Create the Model Instance
*        me->mo_model = NEW #( iv_model_key = lv_model_id ).
*
*        " 2. Set System Instructions
*        mo_model->set_system_instructions( lv_system_instruction ).
*
*        " mo_model->set_generation_config( iv_response_mime_type = 'application/json'   ).
*
*        " 3. Register Tools (Function Declarations) if any
*        IF lt_tools IS NOT INITIAL.
*          register_tools( lt_tools ).
*          "mo_model->set_auto_invoke_sap_function( abap_true ).
*        ENDIF.
*
*        " 4. Set Inline Data is available
*        IF ls_inline_data IS NOT INITIAL.
*          mo_model->set_inline_data( iv_mime_type          = ls_inline_data-mime_type
*                                     iv_data               = ls_inline_data-file_data
*                                     iv_video_start_offset = ls_inline_data-video_start_offset
*                                     iv_video_end_offset   = ls_inline_data-video_end_offset ).
*        ENDIF.
*
*        mv_is_initialized = abap_true.
*
*      CATCH /goog/cx_sdk INTO DATA(lx_sdk).
*        " Log exception or handle appropriately
*        RAISE EXCEPTION lx_sdk.
*    ENDTRY.

  ENDMETHOD.
ENDCLASS.
