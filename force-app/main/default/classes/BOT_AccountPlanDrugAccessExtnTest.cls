/*
Name            : BOT_AccountPlanDrugAccessExtnTest
Created by      : Sreenivasulu Adipudi
Created date    : 18-DEC-2018
Description     : This class is created by BusinessOneTechnologies Inc.
				  It is a test class for BOT_AccountPlanDrugAccessExtn class.
*/
@isTest(seeAllData=false)
class BOT_AccountPlanDrugAccessExtnTest 
{
	//Testing BOT_AccountPlanDrugAccessExtn standard controller class
    static testMethod void BOT_AccountPlanDrugAccessExtnTest()
    {
    	List<Account_Plan_vod__c> lstAccountPlans;	//To store the list of Account Plan records
        List<BOT_Drug_Access__c> lstDrugAccess;		//To store list of Drug access records
        ID accountId;								//To store associated Account Id of selected Account plan
        
        //To create Drug access records
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(1,'MCO');
        clsTestDataFactory.createFormularyProductRecords(5);
        lstDrugAccess = clsTestDataFactory.createDrugAccessRecords(1, 5);
        try{
        	insert lstDrugAccess;
        }
        catch(Exception e) 
        {
            system.debug('Exception '+e.getMessage()+ ' found in class BOT_AccountPlanDrugAccessExtnTest at line number '+e.getLineNumber());
        }
        
        accountId = [SELECT Id FROM Account].Id;
        //To create an Account plan with associated Account Id
        lstAccountPlans = clsTestDataFactory.createAccountPlanRecords(accountId, 1);
        try{
        	insert lstAccountPlans;
        }
        catch(Exception e) 
        {
            system.debug('Exception '+e.getMessage()+ ' found in class BOT_AccountPlanDrugAccessExtnTest at line number '+e.getLineNumber());
        }
        
        test.startTest();
        //Creating an instance for AccountPlanDrugAccess controller class
        ApexPages.StandardController controller = new ApexPages.StandardController(lstAccountPlans[0]);
        BOT_AccountPlanDrugAccessExtn clsAccountPlanDrugAccess = new BOT_AccountPlanDrugAccessExtn(controller);
        
        system.assertEquals(clsAccountPlanDrugAccess.getDynamicList().size(), 6);
        
        //Calling marketFilterRetrieve method with selected market as 'Test Market 1'
        clsAccountPlanDrugAccess.strSelectedMarket = 'Test Market 1';
        clsAccountPlanDrugAccess.getDrugAccessFilteredByMarket();
        
        //Calling marketFilterRetrieve method with selected market as 'ALL'
        clsAccountPlanDrugAccess.strSelectedMarket = 'ALL';
        clsAccountPlanDrugAccess.getDrugAccessFilteredByMarket();
        test.stopTest();
    }
}