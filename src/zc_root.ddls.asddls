@EndUserText.label: 'Projection view for root'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true //Cho phép tìm kiếm trên form
@Metadata.allowExtensions: true //Cho phép mở rộng: Tạo giao diện trên Fiori
define root view entity ZC_ROOT
  provider contract transactional_query as projection on ZI_ROOT
{
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ROOT', element: 'userid' } }]
    key userid,
    key working_day,
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ROOT', element: 'name' } }]
    @Search.defaultSearchElement: true
    name,
    total_hours,
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ROOT', element: 'status' } }]
    @Search.defaultSearchElement: true
    status,
    Criticality,
    _child : redirected to composition child ZC_CHILD
}
