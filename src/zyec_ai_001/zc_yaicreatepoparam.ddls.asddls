@EndUserText.label: 'Create PO - Action Parameter'
define abstract entity ZC_YAICREATEPOPARAM
{
  OrderType             : abap.char( 4 );
  Supplier              : abap.char( 10 );
  CompanyCode           : abap.char( 4 );
  PurchasingOrganization: abap.char( 4 );
  PurchasingGroup       : abap.char( 3 );
}
