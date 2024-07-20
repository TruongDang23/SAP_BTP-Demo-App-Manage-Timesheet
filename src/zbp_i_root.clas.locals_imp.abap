CLASS lhc__root DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _root RESULT result.
    METHODS precheck_cba_child FOR PRECHECK
      IMPORTING entities FOR CREATE _root\_child.
    METHODS getname FOR DETERMINE ON SAVE
      IMPORTING keys FOR _root~getname.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR CREATE _root.
    METHODS earlynumbering_cba_child FOR NUMBERING
      IMPORTING entities FOR CREATE _root\_child.

ENDCLASS.

CLASS lhc__root IMPLEMENTATION.

  METHOD get_instance_authorizations.
    LOOP AT KEYS ASSIGNING FIELD-SYMBOL(<ls_data>).
        IF requested_authorizations-%update = if_abap_behv=>mk-on.

        ELSEIF requested_authorizations-%delete = if_abap_behv=>mk-on.
            IF <ls_data>-userid <> sy-uname.
                APPEND VALUE #( %key = <ls_data>-%key
                                %delete = if_abap_behv=>auth-unauthorized ) TO result.
                APPEND VALUE #( %key = <ls_data>-%key
                                %msg = new_message_with_text(
                                        severity = if_abap_behv_message=>severity-error
                                        text = 'You does not have authorization to delete that user ' )
                               ) TO reported-_root.
            ENDIF.
        ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD earlynumbering_cba_Child.
    SELECT MAX( timesheet_id )
    FROM ztb_tsheet
    INTO @DATA(max).

    LOOP AT ENTITIES ASSIGNING FIELD-SYMBOL(<ls_root>).
        LOOP AT <ls_root>-%target ASSIGNING FIELD-SYMBOL(<ls_child>).
            INSERT VALUE #( %cid = <ls_child>-%cid
                            timesheet_id = max + 1 ) INTO TABLE mapped-_child.
        ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD precheck_cba_Child.
    LOOP AT ENTITIES ASSIGNING FIELD-SYMBOL(<ls_root>).
        LOOP AT <ls_root>-%target ASSIGNING FIELD-SYMBOL(<ls_child>).
            IF <ls_child>-start_time > <ls_child>-end_time.
                "Return error message
                APPEND VALUE #( %key = <ls_child>-%key ) TO failed-_child.
                APPEND VALUE #( %key = <ls_child>-%key
                                %msg = new_message_with_text(
                                        severity = if_abap_behv_message=>severity-error
                                        text = 'The start time must occur before the end time' )
                               ) TO reported-_child.
            ENDIF.
        ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD earlynumbering_create.
    LOOP AT ENTITIES ASSIGNING FIELD-SYMBOL(<ls_root>).
        APPEND VALUE #( %cid = <ls_root>-%cid
                        %key = <ls_root>-%key
                        userid = sy-uname ) TO mapped-_root.
    ENDLOOP.
  ENDMETHOD.

  METHOD getName.
    SELECT SINGLE name
    FROM ztb_header
    WHERE userid = @sy-uname
    INTO @DATA(uname).

    READ ENTITIES OF zi_root IN LOCAL MODE
        ENTITY _root
        FIELDS ( name ) WITH CORRESPONDING #( keys )
    RESULT DATA(datas)
    FAILED DATA(fail).

    LOOP AT datas INTO DATA(data).
        MODIFY ENTITIES OF zi_root IN LOCAL MODE
            ENTITY _root
            UPDATE
                SET FIELDS WITH VALUE #( ( %tky = data-%tky name = uname ) )
        REPORTED DATA(update).
    ENDLOOP.

    reported = CORRESPONDING #( DEEP update ).
  ENDMETHOD.

ENDCLASS.
