@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Data'
@Metadata.allowExtensions: true
define view entity zyec1_dd_sales
  as select from I_SalesOrder as h
{
  key h.SalesOrder,
      h.SalesOrderType,
      h.SalesOrganization,
      h.SoldToParty,
      h.CreationDate,
      h.TotalNetAmount
}
