CLASS lhc__child DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS setHours FOR DETERMINE ON MODIFY
      IMPORTING keys FOR _child~setHours.
    METHODS precheck_update FOR PRECHECK
      IMPORTING entities FOR UPDATE _child.
    METHODS setstatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR _child~setstatus.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR _child RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _child RESULT result.

    METHODS sending FOR MODIFY
      IMPORTING keys FOR ACTION _child~sending RESULT result.
    METHODS cancel FOR MODIFY
      IMPORTING keys FOR ACTION _child~cancel RESULT result.
ENDCLASS.

CLASS lhc__child IMPLEMENTATION.

  METHOD setHours.
    " If you need the difference in HHMMSS format, you can convert it back
    DATA: diff_hours TYPE i,
          diff_minute TYPE p DECIMALS 1,
          result TYPE p DECIMALS 1.
    DATA: start_time TYPE t,
          end_time   TYPE t,
          diff_time  TYPE i,
          start_seconds TYPE i,
          end_seconds TYPE i.

    READ ENTITIES OF zi_root IN LOCAL MODE
        ENTITY _child
        FIELDS ( working_hours ) WITH CORRESPONDING #( keys )
    RESULT DATA(timesheets)
    FAILED DATA(fail).

    LOOP AT timesheets INTO DATA(time).
        start_time = time-start_time.
        end_time = time-end_time.

        " Convert start time to seconds
        start_seconds = ( start_time(2) * 3600 ) + ( start_time+2(2) * 60 ) + start_time+4(2).

        " Convert end time to seconds
        end_seconds = ( end_time(2) * 3600 ) + ( end_time+2(2) * 60 ) + end_time+4(2).

        " Calculate the difference in seconds
        diff_time = end_seconds - start_seconds.

        diff_hours = diff_time DIV 3600.

        diff_minute = ( ( diff_time MOD 3600 ) / 60 ) / 60.

        result = diff_hours + diff_minute.
        MODIFY ENTITIES OF zi_root IN LOCAL MODE
            ENTITY _child
            UPDATE
                SET FIELDS WITH VALUE #( ( %tky = time-%tky working_hours = result ) )
        REPORTED DATA(update).
    ENDLOOP.

    reported = CORRESPONDING #( DEEP update ).
  ENDMETHOD.

  METHOD precheck_update.
    LOOP AT ENTITIES ASSIGNING FIELD-SYMBOL(<ls_child>).
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
  ENDMETHOD.

  METHOD setStatus.
    READ ENTITIES OF zi_root IN LOCAL MODE
        ENTITY _child
        FIELDS ( status ) WITH CORRESPONDING #( keys )
    RESULT DATA(timesheets)
    FAILED DATA(fail).

    LOOP AT timesheets INTO DATA(time).
        MODIFY ENTITIES OF zi_root IN LOCAL MODE
            ENTITY _child
            UPDATE
                SET FIELDS WITH VALUE #( ( %tky = time-%tky status = 'created' ) )
        REPORTED DATA(update).
    ENDLOOP.
  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD Sending.
    MODIFY ENTITIES OF zi_root IN LOCAL MODE
        ENTITY _child
        UPDATE FIELDS ( status )
        WITH VALUE #( FOR key in keys
                        ( %tky = key-%tky status = 'waiting for approval' ) )

    REPORTED DATA(update).

    READ ENTITIES OF zi_root IN LOCAL MODE
        ENTITY _child
        ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(timesheets)
    FAILED DATA(fail).

    result = VALUE #( FOR time in timesheets
                        ( %tky = time-%tky %param = time ) ).

  ENDMETHOD.

  METHOD Cancel.
    MODIFY ENTITIES OF zi_root IN LOCAL MODE
        ENTITY _child
        UPDATE FIELDS ( status )
        WITH VALUE #( FOR key in keys
                        ( %tky = key-%tky status = 'cancel' ) )

    REPORTED DATA(update).

    READ ENTITIES OF zi_root IN LOCAL MODE
        ENTITY _child
        ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(timesheets)
    FAILED DATA(fail).

    result = VALUE #( FOR time in timesheets
                        ( %tky = time-%tky %param = time ) ).
  ENDMETHOD.

ENDCLASS.
