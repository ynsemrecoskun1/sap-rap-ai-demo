@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Item - Projection View'
@Metadata.allowExtensions: true
define view entity ZC_YAIPOITEM
  as projection on ZR_YAIPOITEM
{
  key ItemUUID,
      PoUUID,
      ItemId,
      Material,
      OrderQty,
      Uom,
      NetPrice,
      Currency,
      LocalLastChangedAt,

      _Header : redirected to parent ZC_YAIPOHEADER
}
