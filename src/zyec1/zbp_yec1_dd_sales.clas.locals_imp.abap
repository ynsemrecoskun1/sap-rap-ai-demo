CLASS lhc_zyec1_pv_sales DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zyec1_pv_sales RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ zyec1_pv_sales RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zyec1_pv_sales.

    METHODS showOrder FOR MODIFY
      IMPORTING keys FOR ACTION zyec1_pv_sales~showOrder.

ENDCLASS.

CLASS lhc_zyec1_pv_sales IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD read.
    SELECT * FROM I_SalesOrder
      FOR ALL ENTRIES IN @keys
      WHERE SalesOrder = @keys-SalesOrder
      INTO TABLE @DATA(lt_sales).

    result = VALUE #(
      FOR ls_sales IN lt_sales
        ( %key-SalesOrder = ls_sales-SalesOrder
          %data = CORRESPONDING #( ls_sales MAPPING
            SalesOrder       = SalesOrder
            SalesOrderType   = SalesOrderType
            SalesOrganization = SalesOrganization
            SoldToParty      = SoldToParty
            CreationDate     = CreationDate
            TotalNetAmount   = TotalNetAmount
            TransactionCurrency = TransactionCurrency
          )
        )
    ).
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD showOrder.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<key>).
      DATA(lv_msg) = new_message_with_text(
        text     = |Sales Order: { <key>-SalesOrder }|
        severity = cl_abap_behv=>ms-success
      ).
      APPEND VALUE #( %msg = lv_msg ) TO reported-zyec1_pv_sales.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zyec1_pv_sales DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize            REDEFINITION.
    METHODS check_before_save   REDEFINITION.
    METHODS save                REDEFINITION.
    METHODS cleanup             REDEFINITION.
    METHODS cleanup_finalize    REDEFINITION.
ENDCLASS.

CLASS lsc_zyec1_pv_sales IMPLEMENTATION.
  METHOD finalize.
  ENDMETHOD.
  METHOD check_before_save.
  ENDMETHOD.
  METHOD save.
  ENDMETHOD.
  METHOD cleanup.
  ENDMETHOD.
  METHOD cleanup_finalize.
  ENDMETHOD.
ENDCLASS.
