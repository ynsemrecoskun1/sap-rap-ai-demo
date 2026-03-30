@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Header - Base View'
@ObjectModel.usageType: {
  serviceQuality: #X,
  sizeCategory: #M,
  dataClass: #MIXED
}
define root view entity ZR_YAIPOHEADER
  as select from I_PurchaseOrderAPI01 as po
  left outer join ZI_YAIPODELETED as log
    on po.PurchaseOrder = log.PurchaseOrder
  composition [0..*] of ZR_YAIPOITEM as _Item
{
  key po.PurchaseOrder          as PurchaseOrder,
      po.Supplier               as Supplier,
      po.CompanyCode            as CompanyCode,
      po.PurchasingOrganization as PurchasingOrganization,
      po.PurchasingGroup        as PurchasingGroup,
      po.DocumentCurrency       as DocumentCurrency,
      po.CreatedByUser          as CreatedByUser,
      po.CreationDate           as CreationDate,
      po.PurchaseOrderDate      as PurchaseOrderDate,

      cast( 'sap-icon://calendar' as abap.char( 255 ) ) as ImageUrl,

      cast( case when log.PurchaseOrder is not initial
        then 'X'
        else ' '
      end as abap.char( 1 ) )    as IsDeleted,

      cast( case when log.PurchaseOrder is not initial
        then 1
        else 3
      end as abap.int1 )         as DeletionCriticality,

      _Item
}
