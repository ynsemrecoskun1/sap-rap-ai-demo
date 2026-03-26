@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Item - Base View'
@ObjectModel.usageType: {
  serviceQuality: #X,
  sizeCategory: #M,
  dataClass: #MIXED
}
define view entity ZR_YAIPOITEM
  as select from I_PurchaseOrderItemAPI01 as poi
  association to parent ZR_YAIPOHEADER as _Header
    on $projection.PurchaseOrder = _Header.PurchaseOrder
{
  key poi.PurchaseOrder          as PurchaseOrder,
  key poi.PurchaseOrderItem      as PurchaseOrderItem,
      poi.Plant                  as Plant,
      poi.Material               as Material,
      poi.PurchaseOrderItemText  as PurchaseOrderItemText,
      poi.OrderQuantity          as OrderQuantity,
      poi.PurchaseOrderQuantityUnit as PurchaseOrderQuantityUnit,
      @Semantics.amount.currencyCode: 'DocumentCurrency'
      poi.NetPriceAmount         as NetPriceAmount,
      poi.DocumentCurrency       as DocumentCurrency,

      _Header
}
