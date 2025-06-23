*&---------------------------------------------------------------------*
*&  Include           ZTEST_FORM_PROCESSOR_AGENT_DEF
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_invoice_summary, "F. INVOICE SUMMARY
         sno     TYPE string,
         inv_no  TYPE string,
         invamt  TYPE string,
         currenc TYPE string,
       END OF ty_invoice_summary.

TYPES: tt_invoice_summary TYPE STANDARD TABLE OF ty_invoice_summary WITH EMPTY KEY.

TYPES: BEGIN OF ty_drawback_rosl_claim,
         inv_sno  TYPE string,
         item_sno TYPE string,
         rate     TYPE string,
         dbk_amt  TYPE string,
       END OF ty_drawback_rosl_claim.
TYPES: tt_drawback_rosl_claim TYPE STANDARD TABLE OF ty_drawback_rosl_claim WITH EMPTY KEY.

TYPES:
  BEGIN OF ty_extracted_data,
    sb_no               TYPE string, " sbNo
    dbk                 TYPE string, " dbk
    rodtp               TYPE string, " rodtp
    com                 TYPE string, " com
    dbk_claim           TYPE string, " dbkClaim
    rodtep_amt          TYPE string, " rodtepAmt
    invoice_summary     TYPE tt_invoice_summary, " Invoice Summary
    drawback_rosl_claim TYPE tt_drawback_rosl_claim, "Drawback & ROSL Claim
  END OF ty_extracted_data.

TYPES:
  tt_errors       TYPE STANDARD TABLE OF string WITH EMPTY KEY. " Array of strings for errors

TYPES:
  BEGIN OF ty_form_output,
    extracted_data     TYPE ty_extracted_data, " Corresponds to the 'extractedData' object
    completeness_score TYPE f,              " Corresponds to 'completenessScore' (float/decimal)
    errors             TYPE tt_errors,         " Corresponds to the 'errors' array
  END OF ty_form_output.

" Example of how you might declare a variable of this type:
DATA: ls_form_data TYPE ty_form_output.
DATA: ls_inv_summary TYPE ty_invoice_summary.
DATA: ls_drawback_rosl_claim TYPE ty_drawback_rosl_claim.
