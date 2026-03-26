@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order View'
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zyec1_pv_sales
  as select from I_SalesOrder as h
{
  key h.SalesOrder,
      h.SalesOrderType,
      h.SalesOrganization,
      h.SoldToParty,
      h.CreationDate,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      h.TotalNetAmount,
      h.TransactionCurrency
}
