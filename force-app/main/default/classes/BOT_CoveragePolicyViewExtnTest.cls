/*
Name 		 : BOT_CoveragePolicyViewExtnTest
Created Date : 05-MAR-2019
Created By   : Sreenivasulu Adipudi
Overview 	 : It is written by BusinessOne Technologies Inc. It is a test class for BOT_CoveragePolicyViewExtn controller class. 
*/
@isTest(seeAllData=false)
public class BOT_CoveragePolicyViewExtnTest 
{
	public static testMethod void BOT_CoveragePolicyViewExtnTest()
    {
        List<BOT_Coverage_Policy__c> lstCoveragePolicy;	//To store the list of coverage policy records
        Account objAccount;								//To an account record
        
        //To create Coverage policy records
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(1,'MCO');
        clsTestDataFactory.createFormularyProductRecords(1);
        lstCoveragePolicy = clsTestDataFactory.createCoveragePolicyRecords(1, 1);
        
         try{
        	insert lstCoveragePolicy;
        }
        catch(Exception e) 
        {
            system.debug('Exception '+e.getMessage()+ ' found in class BOT_CoveragePolicyViewExtnTest at line number '+e.getLineNumber());
        }
        
        //Creating an instance for BOT_CoveragePolicyViewExtn class
        test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(lstCoveragePolicy[0]);
        BOT_CoveragePolicyViewExtn clsCoveragePolicyView = new BOT_CoveragePolicyViewExtn(controller);
        
        //Calling retrieveCPformPDF method
        test.setMock(HttpCalloutMock.class, new BOT_CoveragePolicyCalloutMock());
        PageReference pgref = clsCoveragePolicyView.retrieveCPformPDF();
        test.stopTest();
        
        system.debug('Page reference : '+pgref);
        //Test data validation
        system.assert(pgref != null);
    }
}