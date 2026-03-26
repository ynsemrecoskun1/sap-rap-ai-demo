@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Header - Projection View'
@Metadata.allowExtensions: true
define root view entity ZC_YAIPOHEADER
  provider contract transactional_query
  as projection on ZR_YAIPOHEADER
{
  key PoUUID,
      PoId,
      Supplier,
      Status,
      TotalAmount,
      Currency,
      CreatedBy,
      CreatedAt,
      LastChangedBy,
      LastChangedAt,
      LocalLastChangedAt,

      _Item : redirected to composition child ZC_YAIPOITEM
}
