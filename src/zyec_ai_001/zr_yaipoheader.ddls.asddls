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

      cast( 'PO' as abap.char( 2 ) ) as ImageUrl,

      cast( case when exists (
              select 1 from zyai_po_log as log
              where log.purchaseorder = po.PurchaseOrder )
        then 'X'
        else ' '
      end as abap.char( 1 ) )    as IsDeleted,

      cast( case when exists (
              select 1 from zyai_po_log as log
              where log.purchaseorder = po.PurchaseOrder )
        then 1
        else 3
      end as abap.int1 )         as DeletionCriticality,

      _Item
}
