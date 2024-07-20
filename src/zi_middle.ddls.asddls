@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS for summary information'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_MIDDLE as select from ztb_tsheet as _t
{
    _t.user_id,
    _t.working_day,
    sum(_t.working_hours) as total_hours
}
where _t.status = 'approved'
group by _t.user_id, _t.working_day
