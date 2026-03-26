@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Header - Base View'
@ObjectModel.usageType: {
  serviceQuality: #X,
  sizeCategory: #M,
  dataClass: #MIXED
}
define root view entity ZR_YAIPOHEADER
  as select from I_PurchaseOrder as po
  composition [0..*] of ZR_YAIPOITEM as _Item
{
  key po.PurchaseOrder          as PurchaseOrder,
      po.PurchaseOrderType      as PurchaseOrderType,
      po.Supplier               as Supplier,
      po.CompanyCode            as CompanyCode,
      po.PurchasingOrganization as PurchasingOrganization,
      po.PurchasingGroup        as PurchasingGroup,
      po.DocumentCurrency       as DocumentCurrency,
      po.CreatedByUser          as CreatedByUser,
      po.CreationDate           as CreationDate,
      po.PurchaseOrderDate      as PurchaseOrderDate,

      _Item
}
