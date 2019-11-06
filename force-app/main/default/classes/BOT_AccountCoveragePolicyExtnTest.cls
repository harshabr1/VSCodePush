/*
Name			: BOT_AccountCoveragePolicyExtnTest
Created date	: 20-DEC-2018
Created by		: Sreenivasulu Adipudi
Description		: This class is written by BusinessOne Technologies Inc. It is a test class of BOT_AccountCoveragePolicyExtn class.
*/
@isTest
class BOT_AccountCoveragePolicyExtnTest 
{
	//Testing BOT_AccountCoveragePolicyExtn standard controller class
    static testMethod void BOT_AccountCoveragePolicyExtnTest()
    {
        List<BOT_Coverage_Policy__c> lstCoveragePolicy;	//To store the list of coverage policy records
        Account objAccount;								//To store an account record
        
        //To create Coverage policy records
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(1,'MCO');
        clsTestDataFactory.createFormularyProductRecords(5);
        objAccount = [SELECT Id FROM Account LIMIT 1];
        lstCoveragePolicy = clsTestDataFactory.createCoveragePolicyRecords(1, 5);
        
        try{
        	insert lstCoveragePolicy;
        }
        catch(Exception e) 
        {
            system.debug('Exception '+e.getMessage()+ ' found in class BOT_AccountCoveragePolicyExtnTest at line number '+e.getLineNumber());
        }
        
        test.startTest();
        //Creating an instance for Account converage policy Extension class
        ApexPages.StandardController controller = new ApexPages.StandardController(objAccount);
        BOT_AccountCoveragePolicyExtn clsAccountCoveragePolicy = new BOT_AccountCoveragePolicyExtn(controller);
        
        //Test data validation
        system.assertEquals(clsAccountCoveragePolicy.getDynamicList().size(), 6);
        system.assertEquals(clsAccountCoveragePolicy.lstCoveragePolicy.size(), 1);
        
        //Calling getCoveragePolicy method with selected market as 'Test Market 1'
        clsAccountCoveragePolicy.strSelectedMarket = 'Test Market 1';
        clsAccountCoveragePolicy.getCoveragePolicy();
        
        //Test data validation
        system.assertEquals(clsAccountCoveragePolicy.lstCoveragePolicy.size(), 1);
        
        //Calling getCoveragePolicy method with selected market as 'ALL'
        clsAccountCoveragePolicy.strSelectedMarket = 'ALL';
        clsAccountCoveragePolicy.getCoveragePolicy();
        
        //Test data validation
        system.assertEquals(clsAccountCoveragePolicy.lstCoveragePolicy.size(), 5);
        test.stopTest();
    }
}