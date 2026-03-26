CLASS lhc_poheader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS:
      get_instance_authorizations FOR INSTANCE AUTHORIZATION
        IMPORTING keys REQUEST requested_authorizations FOR poheader RESULT result,
      deleteorder FOR MODIFY
        IMPORTING keys FOR ACTION poheader~deleteorder RESULT result.
ENDCLASS.

CLASS lhc_poheader IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD deleteorder.
    DATA lt_header_keys TYPE TABLE FOR DELETE zr_yaipoheader\\poheader.
    DATA lt_item_keys   TYPE TABLE FOR DELETE zr_yaipoheader\\poitem.
    DATA lt_result      TYPE TABLE FOR ACTION RESULT zr_yaipoheader\\poheader~deleteorder.

    READ ENTITIES OF zr_yaipoheader IN LOCAL MODE
      ENTITY poheader
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_headers)
      FAILED DATA(lt_failed_read).

    IF lt_failed_read IS NOT INITIAL.
      LOOP AT lt_failed_read-poheader INTO DATA(ls_failed).
        APPEND VALUE #( %tky = ls_failed-%tky ) TO failed-poheader.
        APPEND VALUE #( %tky     = ls_failed-%tky
                        %msg     = new_message_with_text(
                                     severity = if_abap_behv_message=>severity-error
                                     text     = 'Purchase Order not found' )
                        %element = VALUE #( pouuid = if_abap_behv=>mk-on ) ) TO reported-poheader.
      ENDLOOP.
      RETURN.
    ENDIF.

    READ ENTITIES OF zr_yaipoheader IN LOCAL MODE
      ENTITY poheader BY \_item
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_items).

    LOOP AT lt_items INTO DATA(ls_item).
      APPEND VALUE #( %tky = ls_item-%tky ) TO lt_item_keys.
    ENDLOOP.

    IF lt_item_keys IS NOT INITIAL.
      MODIFY ENTITIES OF zr_yaipoheader IN LOCAL MODE
        ENTITY poitem
          DELETE FROM lt_item_keys
        MAPPED   DATA(lv_mapped_item)
        FAILED   DATA(lt_failed_item)
        REPORTED DATA(lt_reported_item).
    ENDIF.

    LOOP AT lt_headers INTO DATA(ls_header).
      APPEND VALUE #( %tky = ls_header-%tky ) TO lt_header_keys.
    ENDLOOP.

    MODIFY ENTITIES OF zr_yaipoheader IN LOCAL MODE
      ENTITY poheader
        DELETE FROM lt_header_keys
      MAPPED   DATA(lv_mapped_hdr)
      FAILED   DATA(lt_failed_hdr)
      REPORTED DATA(lt_reported_hdr).

    IF lt_failed_hdr IS NOT INITIAL.
      LOOP AT lt_failed_hdr-poheader INTO DATA(ls_failed_hdr).
        APPEND VALUE #( %tky = ls_failed_hdr-%tky ) TO failed-poheader.
        APPEND VALUE #( %tky = ls_failed_hdr-%tky
                        %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                 text     = 'Delete failed' ) ) TO reported-poheader.
      ENDLOOP.
      RETURN.
    ENDIF.

    LOOP AT lt_headers INTO DATA(ls_hdr_result).
      APPEND VALUE #( %tky   = ls_hdr_result-%tky
                      %param = ls_hdr_result ) TO result.
      APPEND VALUE #( %tky = ls_hdr_result-%tky
                      %msg = new_message_with_text(
                               severity = if_abap_behv_message=>severity-success
                               text     = |PO { ls_hdr_result-poid } deleted successfully| ) ) TO reported-poheader.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
