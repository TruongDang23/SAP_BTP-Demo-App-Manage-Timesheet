@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection view for root admin'
@Metadata.allowExtensions: true
define root view entity ZC_ROOT_ADMIN
  provider contract transactional_query as projection on ZI_ROOT_ADMIN
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
    Criticality
}
