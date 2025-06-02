@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root for Admin'
define root view entity ZI_ROOT_ADMIN
  as select from ztb_tsheet
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
      @Semantics.user.createdBy: true
      created_by,
      @Semantics.systemDateTime.createdAt: true
      created_at,
      @Semantics.user.localInstanceLastChangedBy: true
      local_last_changed_by,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      local_last_changed_at,
      @Semantics.systemDateTime.lastChangedAt: true
      last_changed_at,
      case status
          when 'approved' then 3 //Green
          when 'cancel' then 1 //Red
          when 'waiting for approval' then 2 //Yellow
          when 'reject' then 1 //Red
          else 0 //None
       end as Criticality
}
where
      status <> 'created'
  and status <> 'cancel'
