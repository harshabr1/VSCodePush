/*
Name            : BOT_AccountDrugAccessExtnTest
Created by      : Sreenivasulu Adipudi
Created date    : 02-FEB-2019
Description     : This class is created by BusinessOneTechnologies Inc.
				  It is a test class of BOT_AccountDrugAccessExtn class.
*/
@isTest(seeAllData=false)
public class BOT_AccountDrugAccessExtnTest 
{
	//Testing BOT_AccountDrugAccessExtn standard controller class
    static testMethod void AccountDrugAccessExtn()
    {
    	List<BOT_Drug_Access__c> lstDrugAccess;		//To store list of Drug access records
        Account objAccount;							//To store an Account record
        
        //To create Drug access records
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(1,'MCO');
        clsTestDataFactory.createFormularyProductRecords(5);
        lstDrugAccess = clsTestDataFactory.createDrugAccessRecords(1, 5);
        insert lstDrugAccess;
        
        objAccount = [SELECT Id FROM Account];
        
        test.startTest();
        //Creating an instance for AccountDrugAccessExtn controller class
        ApexPages.StandardController controller = new ApexPages.StandardController(objAccount);
        BOT_AccountDrugAccessExtn clsAccountDrugAccess = new BOT_AccountDrugAccessExtn(controller);
        
        system.assertEquals(clsAccountDrugAccess.getDynamicList().size(), 6);
        
        //Calling marketFilterRetrieve method with selected market as 'Test Market 1'
        clsAccountDrugAccess.strSelectedMarket = 'Test Market 1';
        clsAccountDrugAccess.getDrugAccessFilteredByMarket();
        
        //Calling marketFilterRetrieve method with selected market as 'ALL'
        clsAccountDrugAccess.strSelectedMarket = 'ALL';
        clsAccountDrugAccess.getDrugAccessFilteredByMarket();
        test.stopTest();
    }
}