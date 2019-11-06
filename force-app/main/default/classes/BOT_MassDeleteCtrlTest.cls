/*
Name			: BOT_MassDeleteCtrlTest
Created By		: Sreenivasulu A
Created Date	: 27-FEB-2019
Overview		: This class is written by BusinessOne Technologies Inc. It is a test class for BOT_MassDeleteCtrl Page.
*/
@isTest(seeAllData=false)
public class BOT_MassDeleteCtrlTest 
{
	public static testMethod void BOT_MassDeleteCtrlTest()
    {
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        //To create the list of Accounts with Employer channel records
        clsTestDataFactory.createAccountRecords(5,'Employer');
        //To create the list of Accounts with Specialty Provider channel records
        clsTestDataFactory.createAccountRecords(5,'Specialty Provider');
        //To create the list of Accounts with PBM channel records
        clsTestDataFactory.createAccountRecords(5,'PBM');
        //To create the list of affiliate Accounts with MCO channel records
        clsTestDataFactory.createAccountsWithParentId(5,5,'MCO');
        //To create the list of Formulary products records
        clsTestDataFactory.createFormularyProductRecords(5);
        //To create the list of Benefit designs records
        clsTestDataFactory.createBenefitDesignRecords(5,5,'Employer');
        //To create the list of Addresses records
        insert clsTestDataFactory.createAddressRecords(5,1);
        //To create the list of Plan Products records
        clsTestDataFactory.createPlanProductRecords(5,5,'Employer');
		//To create the list of Benefit design line records
        insert clsTestDataFactory.createBenefitDesignLineRecords(5,5);
        //To create the list of Pharmacy Service records
        clsTestDataFactory.createPharmacyServices(5,5,'Mail order');
        //To create the list of Specialty provider to Account junction object records
        insert clsTestDataFactory.createSPPToAccountRecords(5,5);
        //To create the list of Therapeutic class records
        insert clsTestDataFactory.createTheraClassWithSpecialtyId(5,5);
        //To create the list of Drug Access records records
        insert clsTestDataFactory.createDrugAccessRecords(5,5);
        //To create the list of Plan-Product formulary Junction object records
        insert clsTestDataFactory.createProductFormularyRecords(5,5);
        //To create the list of Coverage policy records
        insert clsTestDataFactory.createCoveragePolicyRecords(5,5);
        
        test.startTest();
        BOT_MassDeleteCtrl clsMassDeleteCtrl = new BOT_MassDeleteCtrl();
        clsMassDeleteCtrl.deleteCoveragePolicy();
        clsMassDeleteCtrl.deleteProductFormulary();
        clsMassDeleteCtrl.deleteDrugAccess();
        clsMassDeleteCtrl.deleteTheraClass();
        clsMassDeleteCtrl.deleteSpecialtyProviderJO();
        clsMassDeleteCtrl.deleteBenefitDesignLine();
        clsMassDeleteCtrl.deleteBenefitDesign();
        clsMassDeleteCtrl.deletePlanProduct();
        clsMassDeleteCtrl.deleteAddress();
        clsMassDeleteCtrl.deleteFormularyProduct();
        
        clsMassDeleteCtrl.blnIncludeIDNAccount = true;
        clsMassDeleteCtrl.blnIncludeIDNAccount = true;
        clsMassDeleteCtrl.blnIncludePersonAccount = true;
        clsMassDeleteCtrl.deleteAccount();
                
        clsMassDeleteCtrl.blnIncludeAccount = true;
        clsMassDeleteCtrl.blnIncludeAccountAddress = true;
        clsMassDeleteCtrl.blnIncludeCoveragePolicy = true;
        clsMassDeleteCtrl.blnIncludeFormularyProduct = true;
        clsMassDeleteCtrl.deleteAll();
        test.stopTest();
    }
}