@EndUserText.label: 'Projection view for child'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_CHILD as projection on ZI_CHILD
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
    Criticality,
    /* Associations */
    _root : redirected to parent ZC_ROOT
}
