@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Item - Base View'
define view entity ZR_YAIPOITEM
  as select from zyai_po_i as i
  association to parent ZR_YAIPOHEADER as _Header
    on $projection.PoUUID = _Header.PoUUID
{
  key i.itemuuid              as ItemUUID,
      i.pouuid                as PoUUID,
      i.itemid                as ItemId,
      i.material              as Material,
      i.orderqty              as OrderQty,
      i.uom                   as Uom,
      i.netprice              as NetPrice,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      i.local_last_changed_at as LocalLastChangedAt,

      _Header
}
