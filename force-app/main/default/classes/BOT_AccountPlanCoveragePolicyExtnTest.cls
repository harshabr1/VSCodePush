/*
Name			: BOT_AccountPlanCoveragePolicyExtnTest
Created date	: 21-Dec-2018
Created by		: Sreenivasulu Adipudi
Description		: This class is created by BusinessOneTechnologies Inc.
				  It is a test class of BOT_AccountPlanCoveragePolicyExtn class.
*/
@isTest
class BOT_AccountPlanCoveragePolicyExtnTest 
{
	//Testing BOT_AccountPlanCoveragePolicyExtnTest standard controller class
    static testMethod void BOT_AccountPlanCoveragePolicyExtnTest()
    {
        List<BOT_Coverage_Policy__c> lstCoveragePolicy;	//To store the list of coverage policy records
        Id accountId;									//To the SFDC Account Id
        List<Account_Plan_vod__c> lstAccountPlans;		//To store the list of Account Plan records
        
        //To create Coverage policy records
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(1,'MCO');
        clsTestDataFactory.createFormularyProductRecords(5);
        accountId = [SELECT Id FROM Account LIMIT 1].Id;
        lstCoveragePolicy = clsTestDataFactory.createCoveragePolicyRecords(1,5);
        try{
        	insert lstCoveragePolicy;
        }
        catch(Exception e) 
        {
            system.debug('Exception '+e.getMessage()+ ' found in class BOT_AccountPlanCoveragePolicyExtnTest at line number '+e.getLineNumber());
        }
        
        //To create an Account plan with associated Account Id
        lstAccountPlans = clsTestDataFactory.createAccountPlanRecords(accountId, 1);
        try{
        	insert lstAccountPlans;
        }
        catch(Exception e) 
        {
            system.debug('Exception '+e.getMessage()+ ' found in class BOT_AccountPlanCoveragePolicyExtnTest at line number '+e.getLineNumber());
        }
        
        test.startTest();
        //Creating an instance for AccountPlanconveragepolicy Extension class
        ApexPages.StandardController controller = new ApexPages.StandardController(lstAccountPlans[0]);
        BOT_AccountPlanCoveragePolicyExtn clsAccountPlanCoveragePolicy = new BOT_AccountPlanCoveragePolicyExtn(controller);
        
        //Test data validation
        system.assertEquals(clsAccountPlanCoveragePolicy.getDynamicList().size(), 6);
        system.assertEquals(clsAccountPlanCoveragePolicy.lstCoveragePolicy.size(), 1);
        
        //Calling clsAccountPlanCoveragePolicy method with selected market as 'Test Market 1'
        clsAccountPlanCoveragePolicy.strSelectedMarket = 'Test Market 1';
        clsAccountPlanCoveragePolicy.getCoveragePolicyFilteredByMarket();
        system.assertEquals(clsAccountPlanCoveragePolicy.lstCoveragePolicy.size(), 1);
        
        //Calling clsAccountPlanCoveragePolicy method with selected market as 'Test Market 5'
        clsAccountPlanCoveragePolicy.strSelectedMarket = 'Test Market 1';
        clsAccountPlanCoveragePolicy.getCoveragePolicy();
        system.assertEquals(clsAccountPlanCoveragePolicy.lstCoveragePolicy.size(), 1);
        
        //Calling clsAccountPlanCoveragePolicy method with selected market as 'ALL'
        clsAccountPlanCoveragePolicy.strSelectedMarket = 'ALL';
        clsAccountPlanCoveragePolicy.getCoveragePolicy();
        system.assertEquals(clsAccountPlanCoveragePolicy.lstCoveragePolicy.size(), 5);
        test.stopTest();
    }
}