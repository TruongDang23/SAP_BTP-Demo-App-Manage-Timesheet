CLASS zcl_gen_data_203 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_gen_data_203 IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
*    out->write( sy-uname ).

*    DATA: it_acc TYPE TABLE OF ztb_header.
*
*    it_acc = VALUE #(
*    ( userid = 'CB9980001659' working_day = '20240523' name = 'truongdang' )
*    ( userid = 'CB9980001659' working_day = '20240522' name = 'truongdang' )
*    ( userid = 'CB9980001659' working_day = '20240521' name = 'truongdang' )
*    ( userid = 'CB9980001659' working_day = '20240520' name = 'truongdang' )
*    ).
*    INSERT ztb_header FROM TABLE @it_acc.
*    out->write( sy-dbcnt ).
*    out->write( 'Inserted into table timesheet successfully' ).

    DATA: it_time TYPE TABLE OF ztb_tsheet.

    it_time = VALUE #(
        ( timesheet_id = 1 user_id = 'CB9980001659' task = 'CDSView' working_day = '20240523' start_time = '083000' end_time = '123000' working_hours = '4.5' status = 'created' )
        ( timesheet_id = 2 user_id = 'CB9980001659' task = 'ALV + RTF' working_day = '20240523' start_time = '130000' end_time = '170000' working_hours = '4' status = 'created' )
        ( timesheet_id = 3 user_id = 'CB9980001659' task = 'RAP Model' working_day = '20240522' start_time = '083000' end_time = '113000' working_hours = '3.2' status = 'waiting for approval' )
        ( timesheet_id = 4 user_id = 'CB9980001659' task = 'ALV + RTF' working_day = '20240522' start_time = '130000' end_time = '140000' working_hours = '1' status = 'waiting for approval' )
        ( timesheet_id = 5 user_id = 'CB9980001659' task = 'DataElement' working_day = '20240521' start_time = '090000' end_time = '110000' working_hours = '2.4' status = 'waiting for approval' )
        ( timesheet_id = 6 user_id = 'CB9980001659' task = 'Domain' working_day = '20240521' start_time = '140000' end_time = '170000' working_hours = '3' status = 'approved' )
        ( timesheet_id = 7 user_id = 'CB9980001659' task = 'DataElement' working_day = '20240520' start_time = '083000' end_time = '123000' working_hours = '4.5' status = 'approved' )
        ( timesheet_id = 8 user_id = 'CB9980001659' task = 'Database Table' working_day = '20240520' start_time = '130000' end_time = '170000' working_hours = '4' status = 'approved' )
    ).

    INSERT ztb_tsheet FROM TABLE @it_time.
    out->write( sy-dbcnt ).
    out->write( 'Inserted into table timesheet successfully' ).

*     READ ENTITIES OF ZI_ROOT
*         ENTITY _child
*             FIELDS ( start_time end_time )
*             WITH VALUE #( ( timesheet_id = 1 ) )
*         RESULT DATA(data).
*
*     out->write( data ).
*DELETE from ztb_tsheet.
  ENDMETHOD.

ENDCLASS.
