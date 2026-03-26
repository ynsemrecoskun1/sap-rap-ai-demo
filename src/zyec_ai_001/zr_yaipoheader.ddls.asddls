@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Header - Base View'
define root view entity ZR_YAIPOHEADER
  as select from zyai_po_h as h
  composition [0..*] of ZR_YAIPOITEM as _Item
{
  key h.pouuid             as PoUUID,
      h.poid               as PoId,
      h.supplier           as Supplier,
      h.status             as Status,
      @Semantics.amount.currencyCode: 'Currency'
      h.totalamount        as TotalAmount,
      h.currency           as Currency,
      @Semantics.user.createdBy: true
      h.created_by         as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      h.created_at         as CreatedAt,
      @Semantics.user.lastChangedBy: true
      h.last_changed_by    as LastChangedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      h.last_changed_at    as LastChangedAt,
      @Semantics.systemDateTime.localInstanceLastChangedAt: true
      h.local_last_changed_at as LocalLastChangedAt,

      _Item
}
