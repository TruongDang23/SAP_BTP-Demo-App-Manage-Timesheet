@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS for child'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_CHILD as select from ztb_tsheet
association to parent ZI_ROOT as _root
    on $projection.user_id = _root.userid
    and $projection.working_day = _root.working_day
{
    key timesheet_id,
    user_id,
    working_day,
    task,
    start_time,
    end_time,
    working_hours,
    status,
    reason,
    case status
        when 'approved' then 3 //Green
        when 'cancel' then 1 //Red
        when 'waiting for approval' then 2 //Yellow
        when 'reject' then 1 //Red
        else 0 //None
     end as Criticality,
    _root
}
