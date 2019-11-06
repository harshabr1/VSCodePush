/*
Name            : BOT_BenefitDesignTriggerHandlerTest
Created By      : Sreenivasulu A
Created Date    : 19-SEP-2018
Overview        : This class is writtern by BusinessOne Technologies Inc. It is a test class for BOT_BenefitDesignTriggerHandler class.
*/
@isTest(seeAllData=false)
class BOT_BenefitDesignTriggerHandlerTest 
{
    @testSetup static void createTestData()
    {
    	//To create the Account records
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(5,'MCO');
        
        //Test data validation
        system.assert([SELECT count() FROM Account] == 5);
    }
    
    //Testing while creating a Benefit design record with Medicare channel and name morethan 80 characters
    static testMethod void createBenefitDesignWithMedicareChannel()
    {
    	Account objAccount;							//To store an Account record
        Benefit_Design_vod__c objBenefitDesign;		//To store a Benefit design record
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        //To create a benefit design record with Medicare channel and name morethan 80 charcters
        clsTestDataFactory.createBenefitDesignRecords(1,1,'Medicare');
        
        //Querying the created test data
        objAccount = [SELECT Id FROM Account ORDER BY BOT_Entity_Id__c LIMIT 1];
        objBenefitDesign = [SELECT Id, Name, Account_vod__c FROM Benefit_Design_vod__c LIMIT 1];
        
        //Test data validation
        system.assert(objBenefitDesign.Name == 'BOT Test Formulary Name where name is morethan 80 Characters BOT Tes..- Medicare');
        system.assertEquals(objBenefitDesign.Account_vod__c, objAccount.Id);
    }
    
    //Testing while creating a Benefit design record with Employer channel and name lessthan 80 characters
    static testMethod void createBenefitDesignWithEmployerChannel()
    {
    	Account objAccount;							//To store an Account record
        Benefit_Design_vod__c objBenefitDesign;		//To store a Benefit design record
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        //To create a benefit design record with Employer channel and name lessthan 80 charcters
        clsTestDataFactory.createBenefitDesignRecords(1,1,'Employer');
        
        //Querying the created test data
        objAccount = [SELECT Id, BOT_Plan_Lives_Rx__c FROM Account ORDER BY BOT_Entity_Id__c LIMIT 1];
        objBenefitDesign = [SELECT Id, Name, Account_vod__c, Lives_vod__c FROM Benefit_Design_vod__c LIMIT 1];
        
        //Test data validation
        system.assert(objBenefitDesign.Name == 'BOT Test Formulary Name 0 - Employer');
        system.assertEquals(objBenefitDesign.Account_vod__c, objAccount.Id);
        system.assertEquals(objAccount.BOT_Plan_Lives_Rx__c, objBenefitDesign.Lives_vod__c);
        
        //Updating the Benefit design Lives
        objBenefitDesign.Lives_vod__c = 1500;
        update objBenefitDesign;
        
        //Querying the updated test data
        objAccount = [SELECT Id, BOT_Plan_Lives_Rx__c FROM Account ORDER BY BOT_Entity_Id__c LIMIT 1];
        
        //Testing Plan lives Rx on Account
        system.assertEquals(objAccount.BOT_Plan_Lives_Rx__c, objBenefitDesign.Lives_vod__c);
        
        /*
        //To Delete the Benefit design Record
        delete objBenefitDesign;
        
        //Querying the updated test data
        objAccount = [SELECT Id, BOT_Plan_Lives_Rx__c FROM Account ORDER BY BOT_Entity_Id__c LIMIT 1];
        
        //Testing Plan lives Rx on Account
        system.assertEquals(objAccount.BOT_Plan_Lives_Rx__c, objBenefitDesign.Lives_vod__c);
		*/
    }
    
    //Testing while creating a list of Benefit design records with Medicare channel and name morethan 80 characters
    static testMethod void createBenefitDesignsWithMedicareChannel()
    {
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a benefit design record with Medicare channel and name morethan 80 charcters
        clsTestDataFactory.createBenefitDesignRecords(5,5,'Medicare');
        
        //Test data validation
        system.assert([SELECT count() FROM Benefit_Design_vod__c WHERE name = 'BOT Test Formulary Name where name is morethan 80 Characters BOT Tes..- Medicare'] == 25);
        
        //To verify the number of Benefit design records created for each Account
        for(AggregateResult res : [SELECT count(Id) sum FROM Benefit_Design_vod__c GROUP BY Account_vod__c])
        {
            system.assertEquals(res.get('sum'), 5);
        }
    }
    
    //Testing while creating a list of Benefit design records with Employer channel and name lessthan 80 characters
    static testMethod void createBenefitDesignsWithEmployerChannel()
    {
        List<Benefit_Design_vod__c> lstBenefitDesign;	//To store a list of Benefit design records
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a benefit design record with Employer channel and name lessthan 80 charcters
        clsTestDataFactory.createBenefitDesignRecords(5,5,'Employer');
        
        //Querying the created test data
        lstBenefitDesign = [SELECT Id, Name FROM Benefit_Design_vod__c ORDER BY Account_vod__c];
        
       	//Test data validation
        system.assertEquals(lstBenefitDesign.size(), 25);
        for(Integer i = 0; i < 25; i++)
        {
            system.assertEquals(lstBenefitDesign[i].Name, 'BOT Test Formulary Name '+ i +' - Employer');
        }
        
        //To verify the number of Benefit design records created for each Account
        for(AggregateResult res : [SELECT count(Id) sum FROM Benefit_Design_vod__c GROUP BY Account_vod__c])
        {
            system.assertEquals(res.get('sum'), 5);
        }
    }
    
    //Testing while creating a Benefit design record without Entity Id
    static testMethod void singleRecordNegativeScenario()
    {
    	List<Benefit_Design_vod__c> lstBenefitDesign;	//To store a list of Benefit design records
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a benefit design record with Medicare channel and name morethan 80 charcters
        lstBenefitDesign = clsTestDataFactory.benefitDesignRecordsWithoutEntityID(1,1);
        
        try {
            insert lstBenefitDesign;    
        }
        catch(DMLException e) {
            system.assertEquals('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+
                                'Entity ID and Benefit Design Id fields are mandatory for BOT records: []', e.getMessage());
        }
    }
}