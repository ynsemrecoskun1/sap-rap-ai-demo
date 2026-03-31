@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Test View - AI Demo'
define view entity ZI_YAITEST
  as select distinct from zyai_po_log
{
  key purchaseorder as PurchaseOrder,
      supplier      as Supplier,
      companycode   as CompanyCode
}
