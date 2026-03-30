@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Deleted Log - Distinct'
define view entity ZI_YAIPODELETED
  as select distinct from zyai_po_log
{
  key purchaseorder as PurchaseOrder
}
