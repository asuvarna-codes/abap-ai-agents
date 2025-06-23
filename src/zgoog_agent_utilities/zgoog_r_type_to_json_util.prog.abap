*&---------------------------------------------------------------------*
*& Report ZGOOG_TYPE_TO_JSON_UTIL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZGOOG_R_TYPE_TO_JSON_UTIL.

include ztest_form_processor_agent_def.

INSERT ls_inv_summary INTO TABLE ls_form_data-extracted_data-invoice_summary.
insert ls_drawback_rosl_claim into table ls_form_data-extracted_data-drawback_rosl_claim.

DATA(lv_json) = /ui2/cl_json=>serialize( data           = ls_form_data
                                         ts_as_iso8601  = abap_true
                                         compress       = abap_false
                                         pretty_name    = 'X'
                                         numc_as_string = abap_true ).

cl_demo_output=>display_json( lv_json ).
