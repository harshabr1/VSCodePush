/*
Name            : BOT_CoveragePolicyTriggerHandlerTest
Created By      : Sreenivasulu A
Created Date    : 04-FEB-2019
Overview        : It is implemented by BusinessOne Technologies Inc. It is a test class of BOT_CoveragePolicyTriggerHandler class.
*/
@isTest(seeAllData=false)
public class BOT_CoveragePolicyTriggerHandlerTest 
{
 	@testSetup static void createTestData()
    {
    	//To create the Account and Fromulary product records
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(5,'Employer');
        clsTestDataFactory.createFormularyProductRecords(5);
        
        //Test data validation
        system.assert([SELECT count() FROM Account] == 5);
        system.assert([SELECT count() FROM Formulary_Products_vod__c] == 5);
    }
    
    //Testing while creating a Coverage policy record
    static testMethod void createCoveragePolicyRecords()
    {
        Account objAccount;                                 //To store an Account record  
        Formulary_Products_vod__c objFormularyProduct;      //To store a formulary product record
        List<BOT_Coverage_Policy__c> lstCoveragePolicy;     //To store a list of Coverage Policy records
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a Coverage policy record
        lstCoveragePolicy = clsTestDataFactory.createCoveragePolicyRecords(1,1);
        insert lstCoveragePolicy;
        
        //Querying the created test data
        objAccount = [SELECT Id FROM Account ORDER BY BOT_Entity_Id__c LIMIT 1];
        objFormularyProduct = [SELECT Id, Market_vod__c FROM Formulary_products_vod__c ORDER BY BOT_Formulary_Product_ID__c LIMIT 1];
        lstCoveragePolicy = [SELECT Id, Name, BOT_Account__c, BOT_Formulary_Product__c FROM BOT_Coverage_Policy__c];

        //Test data validation
        system.assert(objAccount != null);
        system.assert(objFormularyProduct != null);
        system.assert(lstCoveragePolicy[0].Name == 'BOT Test Policy Name 0');
        system.assertEquals(lstCoveragePolicy[0].BOT_Account__c, objAccount.Id);
        system.assertEquals(lstCoveragePolicy[0].BOT_Formulary_Product__c, objFormularyProduct.Id);
    }
    
    //Testing while creating the list of Coverage policy records
    static testMethod void createDrugAccessRecords()
    {
        List<Account> lstAccount;                           	//To store a list of Account records
        List<Formulary_Products_vod__c> lstFormularyProduct;    //To store a list of formulary product records
        List<BOT_Coverage_Policy__c> lstCoveragePolicy;         //To store a list of Coverage policy records
        Integer intTemp = 0;
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create the list of Coverage policy records
        lstCoveragePolicy = clsTestDataFactory.createCoveragePolicyRecords(5, 5);
        insert lstCoveragePolicy;
        
        //Querying the created test data
        lstAccount = [SELECT Id FROM Account ORDER BY BOT_Entity_Id__c];
        lstFormularyProduct = [SELECT Id, Market_vod__c FROM Formulary_products_vod__c ORDER BY BOT_Formulary_Product_ID__c];
        lstCoveragePolicy = [SELECT Id, Name, BOT_Account__c, BOT_Formulary_Product__c FROM BOT_Coverage_Policy__c ORDER BY BOT_Entity_Id__c];
        
        //Test data validation
        system.assertEquals(lstAccount.size(), 5);
        system.assertEquals(lstFormularyProduct.size(), 5);
        system.assertEquals(lstCoveragePolicy.size(), 25);
        for(Integer i = 0; i < 5; i++)
        {
        	for(Integer j = 0; j < 5; j++)
            {
            	system.assertEquals(lstCoveragePolicy[intTemp].BOT_Account__c, lstAccount[i].Id);
                system.assertEquals(lstCoveragePolicy[intTemp].BOT_Formulary_Product__c, lstFormularyProduct[j].Id);
                system.assert(lstCoveragePolicy[intTemp].Name == 'BOT Test Policy Name Where product name is having more than 80 characters are...');
                intTemp++;
            }
        }
    }
    
    //Testing while creating a Coverage policy record without Entity Id
    static testMethod void singleRecordNegativeScenario()
    {	
    	List<BOT_Coverage_Policy__c> lstCoveragePolicy;         //To store the list of Coverage policy records
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a Coverage policy record without Entity Id
        lstCoveragePolicy = clsTestDataFactory.createCoveragePolicyWithoutEntityID(1,1);
        try {
        	insert lstCoveragePolicy;    
        }
        catch(DMLException e) {
            system.assertEquals('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+
                                'Entity Id and Formulary Product Id fields are required to save the record: []', e.getMessage());
        }
    }
}