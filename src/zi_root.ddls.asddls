@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'CDS for root'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_ROOT as select from ztb_header

composition [0..*] of ZI_CHILD as _child

association[1..1] to ZI_MIDDLE as _middle 
    on $projection.userid = _middle.user_id
    and $projection.working_day = _middle.working_day

{
    key userid,
    key working_day,
    name,
    _middle.total_hours,
    case 
        when _middle.total_hours >= 8 then 'good'
        when _middle.total_hours <= 4 then 'try work harder'
        when _middle.total_hours > 4 and _middle.total_hours < 8 then 'warning'
        else 'lets create something' //None
    end as status,
    case
        when _middle.total_hours >= 8 then 3 //Green
        when _middle.total_hours <= 4 then 1 //Red
        when _middle.total_hours > 4 and _middle.total_hours < 8 then 2 //Yellow
        else 0 //None
     end as Criticality,
    _middle,
    _child
}
