@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Item - Projection View'
@Metadata.allowExtensions: true
define view entity ZC_YAIPOITEM
  as projection on ZR_YAIPOITEM
{
  key PurchaseOrder,
  key PurchaseOrderItem,
      Plant,
      Material,
      PurchaseOrderItemText,
      OrderQuantity,
      PurchaseOrderQuantityUnit,
      NetPriceAmount,
      DocumentCurrency,

      _Header : redirected to parent ZC_YAIPOHEADER
}
