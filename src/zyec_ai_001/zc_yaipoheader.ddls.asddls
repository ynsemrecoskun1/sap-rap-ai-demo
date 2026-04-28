@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Header - Projection View'
@Metadata.allowExtensions: true
@UI.headerInfo: {
  typeName: 'Purchase Order',
  typeNamePlural: 'Purchase Orders',
  title: { type: #STANDARD, label: 'Purchase Order', value: 'PurchaseOrder' },
  imageUrl: 'ImageUrl'
}
define root view entity ZC_YAIPOHEADER
  provider contract transactional_query
  as projection on ZR_YAIPOHEADER
{
  key PurchaseOrder,
      Supplier,
      SupplierName,
      CompanyCode,
      PurchasingOrganization,
      PurchasingGroup,
      DocumentCurrency,
      CreatedByUser,
      CreationDate,
      PurchaseOrderDate,
      @Semantics.imageUrl: true
      ImageUrl,
      IsDeleted,
      DeletionCriticality,

      _Item : redirected to composition child ZC_YAIPOITEM
}
