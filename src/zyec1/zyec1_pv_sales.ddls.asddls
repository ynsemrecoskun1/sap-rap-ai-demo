@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Projection View'
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity zyec1_pv_sales
  provider contract transactional_query
  as select from zyec1_dd_sales
{
  key SalesOrder,
      SalesOrderType,
      SalesOrganization,
      SoldToParty,
      CreationDate,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TotalNetAmount,
      TransactionCurrency
}
