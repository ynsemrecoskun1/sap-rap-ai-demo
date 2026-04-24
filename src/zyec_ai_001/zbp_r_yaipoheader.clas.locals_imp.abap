CLASS lhc_poheader DEFINITION INHERITING FROM cl_abap_behavior_handler.
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
      createpo FOR MODIFY
        IMPORTING keys FOR ACTION poheader~createpo RESULT result,
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
      ( %tky                = ls_po-%tky
        %action-deleteorder = COND #( WHEN ls_po-IsDeleted = 'X'
                                      THEN if_abap_behv=>fc-o-disabled
                                      ELSE if_abap_behv=>fc-o-enabled ) ) ).
  ENDMETHOD.

  METHOD lock_master.
  ENDMETHOD.

  METHOD read.
    IF keys IS INITIAL.
      RETURN.
    ENDIF.

    DATA lt_po_range TYPE RANGE OF zr_yaipoheader-PurchaseOrder.
    lt_po_range = VALUE #( FOR key IN keys ( sign = 'I' option = 'EQ' low = key-PurchaseOrder ) ).

    SELECT FROM zr_yaipoheader
      FIELDS PurchaseOrder,
             Supplier,
             CompanyCode,
             PurchasingOrganization,
             PurchasingGroup,
             DocumentCurrency,
             CreatedByUser,
             CreationDate,
             PurchaseOrderDate,
             IsDeleted
      WHERE PurchaseOrder IN @lt_po_range
      INTO CORRESPONDING FIELDS OF TABLE @result.
  ENDMETHOD.

  METHOD createpo.
    READ TABLE keys INTO DATA(ls_key) INDEX 1.

    MODIFY ENTITIES OF i_purchaseordertp_2
      ENTITY purchaseorder
        CREATE FIELDS ( PurchaseOrderType
                        Supplier
                        CompanyCode
                        PurchasingOrganization
                        PurchasingGroup )
        WITH VALUE #( ( %cid                   = 'NEW_PO'
                        PurchaseOrderType      = ls_key-%param-OrderType
                        Supplier               = ls_key-%param-Supplier
                        CompanyCode            = ls_key-%param-CompanyCode
                        PurchasingOrganization = ls_key-%param-PurchasingOrganization
                        PurchasingGroup        = ls_key-%param-PurchasingGroup ) )
      REPORTED DATA(lt_reported)
      FAILED DATA(lt_failed)
      MAPPED DATA(lt_mapped).

    IF lt_failed IS NOT INITIAL.
      APPEND VALUE #( %msg = new_message_with_text(
                               severity = if_abap_behv_message=>severity-error
                               text     = 'Purchase Order could not be created' ) )
        TO reported-poheader.
      RETURN.
    ENDIF.

    DATA(ls_mapped_po) = lt_mapped-purchaseorder[ 1 ].
    APPEND VALUE #( %cid   = ls_mapped_po-%cid
                    %param = VALUE #( PurchaseOrder = ls_mapped_po-PurchaseOrder ) ) TO result.

    APPEND VALUE #( %msg = new_message_with_text(
                             severity = if_abap_behv_message=>severity-success
                             text     = 'Purchase Order created successfully' ) )
      TO reported-poheader.
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
      " Insert log entry directly (unmanaged BO - no saver class)
      INSERT zyai_po_log FROM @( VALUE zyai_po_log(
        log_uuid      = cl_system_uuid=>create_uuid_x16_static( )
        purchaseorder = ls_po-purchaseorder
        supplier      = ls_po-supplier
        companycode   = ls_po-companycode
        deleted_at    = lv_ts
        deleted_by    = cl_abap_context_info=>get_user_alias( )
      ) ).

      APPEND VALUE #( %tky   = ls_po-%tky
                      %param = ls_po ) TO result.
      APPEND VALUE #( %tky = ls_po-%tky
                      %msg = new_message_with_text(
                               severity = if_abap_behv_message=>severity-success
                               text     = |PO { ls_po-purchaseorder } logged for deletion| ) ) TO reported-poheader.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
