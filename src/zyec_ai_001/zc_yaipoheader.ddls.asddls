@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Header - Projection View'
@Metadata.allowExtensions: true
define root view entity ZC_YAIPOHEADER
  provider contract transactional_query
  as projection on ZR_YAIPOHEADER
{
  key PurchaseOrder,
      Supplier,
      CompanyCode,
      PurchasingOrganization,
      PurchasingGroup,
      DocumentCurrency,
      CreatedByUser,
      CreationDate,
      PurchaseOrderDate,
      ImageUrl,
      IsDeleted,
      DeletionCriticality,

      _Item : redirected to composition child ZC_YAIPOITEM
}
