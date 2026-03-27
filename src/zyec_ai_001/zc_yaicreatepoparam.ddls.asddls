@EndUserText.label: 'Create PO - Action Parameter'
@MappingRole: true
define abstract entity ZC_YAICREATEPOPARAM
{
  OrderType             : purchaseordertype;
  Supplier              : lifnr;
  CompanyCode           : bukrs;
  PurchasingOrganization: ekorg;
  PurchasingGroup       : bkgrp;
}
