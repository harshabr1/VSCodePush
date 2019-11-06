/*
Name            : BOT_PlanProductTriggerHandlerTest
Created By      : Sreenivasulu A
Created Date    : 20-SEP-2018
Overview        : This class is writtern by BusinessOne Technologies Inc. It is a test class for BOT_PlanProductTriggerHandler class.
*/
@isTest(seeAllData = false)
class BOT_PlanProductTriggerHandlerTest 
{
    @testSetup static void createTestData()
    {
    	//To create the Account records
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(5,'MCO');
        
        //Test data validation
        system.assert([SELECT count() FROM Account] == 5);
    }
    //Testing while creating a Plan product record with Medicare channel and name morethan 80 charcters 
    static testMethod void createPlanProductRecordWithMedicareChannel()
    {
        Account objAccount;						//To store an Account record
        BOT_Plan_Product__c objPlanProduct;     //To store a Plan product record
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a plan product record with Medicare channel and name morethan 80 charcters
        clsTestDataFactory.createPlanProductRecords(1,1,'Medicare');
        
        //Querying the created test data
        objAccount = [SELECT Id FROM Account ORDER BY BOT_Entity_ID__c LIMIT 1];
        objPlanProduct = [SELECT Id, BOT_Account__c, BOT_Medical_Admin__c FROM BOT_Plan_Product__c 
        				  WHERE name = 'BOT Test Product Name Where product name is having more than 80 characters ar...'];
        
        //Test data validation
        system.assertEquals(objPlanProduct.BOT_Account__c, objAccount.Id);
        system.assert(objPlanProduct.BOT_Medical_Admin__c==null);
    }
    
    //Testing while creating a Plan product record with Employer channel, Medical Admin and name lessthan 80 characters
    static testMethod void createPlanProductRecordWithEmployerChannel()
    {
        Account objAccount;							//To store an Account record
        BOT_Plan_Product__c objPlanProduct;       	//To store a Plan product records
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a plan product record with Employer channel and name lessthan 80 charcters
        clsTestDataFactory.createPlanProductRecords(1,1,'Employer');
        
       	//Querying the created test data
        objAccount = [SELECT Id FROM Account ORDER BY BOT_Entity_ID__c LIMIT 1];
       	objPlanProduct = [SELECT Id, Name, BOT_Account__c, BOT_Medical_Admin__c FROM BOT_Plan_Product__c 
                          WHERE name = 'BOT Test Product Name 0'];
        
        //Test data validation     
        system.assertEquals(objPlanProduct.BOT_Account__c, objAccount.Id);
        system.assertEquals(objPlanProduct.BOT_Medical_Admin__c, objAccount.Id);
    }
	
    //Testing while creating a list of Plan product records with Medicare channel, Medical Admin and name morethan 80 characters 
    static testMethod void createPlanProductRecordswithMedicareChannel()
    {
        List<Account> lstAccount;						//To store a list of Account records
        List<BOT_Plan_Product__c> lstPlanProduct;       //To store a list of Plan product records
        Integer intTemp = 0;                            //Temporary variable used as index position of plan prouduts list
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a plan product record with Medicare channel and name morethan 80 charcters
        clsTestDataFactory.createPlanProductRecords(5,5,'Medicare');
        
        //Querying the created test data
        lstAccount = [SELECT Id FROM Account ORDER BY BOT_Entity_ID__c];
        lstPlanProduct = [SELECT Id, BOT_Account__c, BOT_Medical_Admin__c FROM BOT_Plan_Product__c 
                          WHERE name = 'BOT Test Product Name Where product name is having more than 80 characters ar...' 
                          ORDER BY BOT_Account__c, BOT_Medical_Admin__c];
        
        //Test data validation
        system.assert(lstAccount.size() == 5);
        system.assert(lstPlanProduct.size() == 25);
		for(Integer i = 0; i < 5; i++)
        {
        	for(Integer j = 0; j < 5; j++ )
            {
                system.assertEquals(lstPlanProduct[intTemp].BOT_Account__c, lstAccount[i].Id, 'Plan Product BOT_Account__c field value is equal to Account Id');
                system.assert(lstPlanProduct[intTemp].BOT_Medical_Admin__c == null, 'Plan Product BOT_Medical_Admin__c field value is null');
            	intTemp++;
            }
        }
    }
    
    //Testing while creating a list of Plan product records with Employer channel and name lessthan 80 characters
    static testMethod void createPlanProductRecordswithEmployerChannel()
    {
        List<Account> lstAccount;						//To store a list of Account records
        List<BOT_Plan_Product__c> lstPlanProduct;       //To store a list of Plan product records
        Integer intTemp = 0;                            //Temporary variable used as index position of plan prouduts list
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a plan product record with Employer channel and name lessthan 80 charcters
        clsTestDataFactory.createPlanProductRecords(5,5,'Employer');
        
        //Querying the created test data
        lstAccount = [SELECT Id FROM Account ORDER BY BOT_Entity_ID__c];
        lstPlanProduct = [SELECT Id, Name, BOT_Account__c, BOT_Medical_Admin__c FROM BOT_Plan_Product__c 
                          ORDER BY BOT_Account__c, BOT_Medical_Admin__c];
        
        //Test data validation
        system.assert(lstAccount.size() == 5);
        system.assert(lstPlanProduct.size() == 25);
        for(Integer i = 0; i < 5; i++)
        {
        	for(Integer j = 0; j < 5; j++ )
            {
                system.assertEquals(lstPlanProduct[intTemp].BOT_Account__c, lstAccount[i].Id, 'Plan Product BOT_Account__c field value is equal to Account Id');
                system.assertEquals(lstPlanProduct[intTemp].BOT_Medical_Admin__c, lstAccount[i].Id, 'Plan Product BOT_Medical_Admin__c field value is equal to Account Id');
                system.assertEquals(lstPlanProduct[intTemp].Name, 'BOT Test Product Name ' + intTemp, 'Validating Plan product name');
            	intTemp++;
            }
        }
    }
    
    //Testing while creating a Plan Product record without Entity Id
    static testMethod void singleRecordNegativeScenario()
    {
        List<BOT_Plan_Product__c> lstPlanProduct;       //To store a list of Plan product records
    	BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a plan product record without Entity Id
        lstPlanProduct = clsTestDataFactory.createPlanProductWithoutEntityID(1,1);
        try {
            //To create a plan product record without Entity Id
            insert lstPlanProduct;
        }
        catch(DMLException e) {
            system.assertEquals('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+
                                'Entity ID and Plan Product ID fields are required to save the record: []', e.getMessage());
        }
    }
}