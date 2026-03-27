CLASS lhc_poheader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.
    CLASS-DATA mt_log_buffer TYPE TABLE OF zyai_po_log.
  PRIVATE SECTION.
    METHODS:
      get_global_authorizations FOR GLOBAL AUTHORIZATION
        IMPORTING REQUEST requested_authorizations FOR poheader RESULT result,
      get_instance_features FOR INSTANCE FEATURES
        IMPORTING keys REQUEST requested_features FOR poheader RESULT result,
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

  METHOD get_instance_features.
    READ ENTITIES OF zr_yaipoheader IN LOCAL MODE
      ENTITY poheader
        FIELDS ( IsDeleted )
        WITH CORRESPONDING #( keys )
      RESULT DATA(lt_pos)
      FAILED DATA(lt_failed).

    result = VALUE #( FOR ls_po IN lt_pos
      ( %tky                  = ls_po-%tky
        %action-deleteorder   = COND #( WHEN ls_po-IsDeleted = 'X'
                                        THEN if_abap_behv=>fc-o-disabled
                                        ELSE if_abap_behv=>fc-o-enabled ) ) ).
  ENDMETHOD.

  METHOD lock_master.
  ENDMETHOD.

  METHOD read.
    IF keys IS INITIAL.
      RETURN.
    ENDIF.

    DATA lt_po_range TYPE RANGE OF i_purchaseorderapi01-PurchaseOrder.
    lt_po_range = VALUE #( FOR key IN keys ( sign = 'I' option = 'EQ' low = key-PurchaseOrder ) ).

    SELECT FROM I_PurchaseOrderAPI01 AS po
      FIELDS po~PurchaseOrder,
             po~Supplier,
             po~CompanyCode,
             po~PurchasingOrganization,
             po~PurchasingGroup,
             po~DocumentCurrency,
             po~CreatedByUser,
             po~CreationDate,
             po~PurchaseOrderDate
      WHERE po~PurchaseOrder IN @lt_po_range
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

    LOOP AT lt_pos INTO DATA(ls_po).
      APPEND VALUE zyai_po_log(
        log_uuid      = cl_system_uuid=>create_uuid_x16_static( )
        purchaseorder = ls_po-purchaseorder
        supplier      = ls_po-supplier
        companycode   = ls_po-companycode
        deleted_at    = lv_ts
        deleted_by    = cl_abap_context_info=>get_user_alias( )
      ) TO lhc_poheader=>mt_log_buffer.
    ENDLOOP.

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


CLASS lsc_zr_yaipoheader DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS save             REDEFINITION.
    METHODS cleanup          REDEFINITION.
    METHODS cleanup_finalize REDEFINITION.
ENDCLASS.

CLASS lsc_zr_yaipoheader IMPLEMENTATION.

  METHOD save.
    IF lhc_poheader=>mt_log_buffer IS NOT INITIAL.
      INSERT zyai_po_log FROM TABLE @lhc_poheader=>mt_log_buffer.
      CLEAR lhc_poheader=>mt_log_buffer.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
    CLEAR lhc_poheader=>mt_log_buffer.
  ENDMETHOD.

  METHOD cleanup_finalize.
    CLEAR lhc_poheader=>mt_log_buffer.
  ENDMETHOD.

ENDCLASS.
