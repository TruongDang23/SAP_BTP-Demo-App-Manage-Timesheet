CLASS lhc_ZI_ROOT_ADMIN DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_root_admin RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR zi_root_admin RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_root_admin RESULT result.

    METHODS approve FOR MODIFY
      IMPORTING keys FOR ACTION zi_root_admin~approve RESULT result.

    METHODS reject FOR MODIFY
      IMPORTING keys FOR ACTION zi_root_admin~reject RESULT result.
    METHODS setReason FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_root_admin~setReason.
    METHODS checkStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_root_admin~checkStatus.
    METHODS triggerOnSave FOR DETERMINE ON SAVE
      IMPORTING keys FOR ZI_ROOT_ADMIN~triggerOnSave.

ENDCLASS.

CLASS lhc_ZI_ROOT_ADMIN IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD get_instance_features.
    READ ENTITIES OF zi_root_admin IN LOCAL MODE
    ENTITY zi_root_admin
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header).

    result = VALUE #( FOR ls_header IN lt_header
                        (
                            %tky = ls_header-%tky
                            %features-%action-Approve = COND #( WHEN ls_header-status = 'approved'
                                                                THEN if_abap_behv=>fc-o-disabled
                                                                ELSE if_abap_behv=>fc-o-enabled )
                            %features-%action-Reject = COND #( WHEN ls_header-status = 'reject'
                                                               THEN if_abap_behv=>fc-o-disabled
                                                               ELSE if_abap_behv=>fc-o-enabled )
                        )
                    ).
  ENDMETHOD.

  METHOD Approve.
    "EML - READ
    READ ENTITIES OF zi_root_admin IN LOCAL MODE
    ENTITY zi_root_admin
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header)
    FAILED DATA(lt_failed).

    "EML - UPDATE
    MODIFY ENTITIES OF zi_root_admin IN LOCAL MODE
        ENTITY zi_root_admin
        UPDATE FIELDS ( status )
        WITH VALUE #( FOR key IN keys
                        ( %tky = key-%tky status = 'approved' ) )

    REPORTED DATA(update).

    result = VALUE #( FOR time IN lt_header
                        ( %tky = time-%tky %param = time ) ).
  ENDMETHOD.

  METHOD Reject.
    READ ENTITIES OF zi_root_admin IN LOCAL MODE
    ENTITY zi_root_admin
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header)
    FAILED DATA(lt_failed).

    DATA(lv_reason) = keys[ 1 ]-%param-reason.

    IF lv_reason IS INITIAL.
      APPEND VALUE #( %tky                = lt_header[ 1 ]-%tky ) TO failed-zi_root_admin.

      APPEND VALUE #( %tky                = lt_header[ 1 ]-%tky
                      %msg                = new_message_with_text(  text = 'Please fill in reason'
                                                          severity = if_abap_behv_message=>severity-error )
                      %element-reason = if_abap_behv=>mk-on ) TO reported-zi_root_admin.
    ELSE.

      MODIFY ENTITIES OF zi_root_admin IN LOCAL MODE
          ENTITY zi_root_admin
          UPDATE FIELDS ( status reason )
          WITH VALUE #( FOR key IN keys
                          (
                              %tky = key-%tky
                              status = 'reject'
                              reason = lv_reason
                          ) )
      REPORTED DATA(update).
    ENDIF.

    result = VALUE #( FOR time IN lt_header
                        ( %tky = time-%tky %param = time ) ).
  ENDMETHOD.

  METHOD setReason.
    "EML - READ
    READ ENTITIES OF zi_root_admin IN LOCAL MODE
    ENTITY zi_root_admin
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header)
    FAILED DATA(lt_failed).

    "EML - UPDATE
    MODIFY ENTITIES OF zi_root_admin IN LOCAL MODE
    ENTITY zi_root_admin
    UPDATE FIELDS ( reason )
    WITH VALUE #( FOR ls_header IN lt_header
                    (
                        %tky = ls_header-%tky
                        reason = 'Determine to set reason'
                    )
                )
    FAILED DATA(lt_failed_update)
    REPORTED DATA(lt_reported_update).
  ENDMETHOD.

  METHOD checkStatus.
    "EML - READ
    READ ENTITIES OF zi_root_admin IN LOCAL MODE
    ENTITY zi_root_admin
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header)
    FAILED DATA(lt_failed).

    CHECK lt_header IS NOT INITIAL.

    LOOP AT lt_header INTO DATA(ls_header).
      IF ls_header-status <> 'reject'.
        APPEND VALUE #( %tky                = ls_header-%tky ) TO failed-zi_root_admin.

        APPEND VALUE #( %tky                = ls_header-%tky
                        %msg                = new_message_with_text(  text     = 'Error message for validation'
                                                                      severity = if_abap_behv_message=>severity-error )
                        %element-status     = if_abap_behv=>mk-on ) TO reported-zi_root_admin.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD triggerOnSave.
    DATA(lv_test) = 1 .
  ENDMETHOD.

ENDCLASS.
