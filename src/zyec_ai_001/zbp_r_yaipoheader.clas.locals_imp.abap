CLASS lhc_poheader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING REQUEST requested_authorizations FOR poheader RESULT result,
      lock_master FOR LOCK
        IMPORTING keys FOR LOCK poheader,
      read FOR READ
        IMPORTING keys FOR READ poheader RESULT result,
      deleteorder FOR MODIFY
        IMPORTING keys FOR ACTION poheader~deleteorder RESULT result.
ENDCLASS.

CLASS lhc_poheader IMPLEMENTATION.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD lock_master.
  ENDMETHOD.

  METHOD read.
    SELECT FROM I_PurchaseOrderAPI01
      FIELDS PurchaseOrder,
             PurchaseOrderType,
             Supplier,
             CompanyCode,
             PurchasingOrganization,
             PurchasingGroup,
             DocumentCurrency,
             CreatedByUser,
             CreationDate,
             PurchaseOrderDate
      FOR ALL ENTRIES IN @keys
      WHERE PurchaseOrder = @keys-PurchaseOrder
      INTO CORRESPONDING FIELDS OF TABLE @result.
  ENDMETHOD.

  METHOD deleteorder.
    READ ENTITIES OF zr_yaipoheader IN LOCAL MODE
      ENTITY poheader
        FIELDS ( PurchaseOrder Supplier CompanyCode )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_pos)
      FAILED DATA(lt_failed).

    IF lt_failed IS NOT INITIAL.
      LOOP AT lt_failed-poheader INTO DATA(ls_failed).
        APPEND VALUE #( %tky = ls_failed-%tky ) TO failed-poheader.
        APPEND VALUE #( %tky = ls_failed-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Purchase Order not found' ) ) TO reported-poheader.
      ENDLOOP.
      RETURN.
    ENDIF.

    GET TIME STAMP FIELD DATA(lv_ts).
    DATA lt_log TYPE TABLE OF zyai_po_log.

    LOOP AT lt_pos INTO DATA(ls_po).
      APPEND VALUE zyai_po_log(
        log_uuid      = cl_system_uuid=>create_uuid_x16_static( )
        purchaseorder = ls_po-purchaseorder
        supplier      = ls_po-supplier
        companycode   = ls_po-companycode
        deleted_at    = lv_ts
        deleted_by    = cl_abap_context_info=>get_user_alias( )
      ) TO lt_log.
    ENDLOOP.

    cl_abap_tx=>uncontrolled(
      EXPORTING
        restrict_to_action = abap_false
      IMPORTING
        handle             = DATA(lo_handle)
    ).
    INSERT zyai_po_log FROM TABLE @lt_log.
    lo_handle->finish( ).

    LOOP AT lt_pos INTO DATA(ls_po_result).
      APPEND VALUE #( %tky   = ls_po_result-%tky
                      %param = ls_po_result ) TO result.
      APPEND VALUE #( %tky = ls_po_result-%tky
                      %msg = new_message_with_text(
                               severity = if_abap_behv_message=>severity-success
                               text     = |PO { ls_po_result-purchaseorder } logged for deletion| ) ) TO reported-poheader.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
