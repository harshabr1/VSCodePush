/*
Name            : BOT_BenefitDesignLineTriggerHandlerTest
Created By      : Sreenivasulu A
Created Date    : 20-sep-2018
Overview        : It is implemented by BusinessOne Technologies Inc. It is a test class of BOT_BenefitDesignLineTriggerHandler class.
*/
@isTest(seeAllData=false)
class BOT_BenefitDesignLineTriggerHandlerTest 
{
    @testSetup static void createTestData()
    {
    	//To create the Account, Benefit design and Fromulary product records
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(1,'Employer');
        clsTestDataFactory.createBenefitDesignRecords(1,5,'Employer');
        clsTestDataFactory.createFormularyProductRecords(5);   
        
        //Test data validation
        system.assert([SELECT count() FROM Account] == 1);
        system.assert([SELECT count() FROM Benefit_Design_vod__c] == 5);
        system.assert([SELECT count() FROM Formulary_Products_vod__c] == 5);
    }
    
    //Testing while creating a Benefit design Line record
    static testMethod void createBenefitDesignLineRecord()
    {
        Benefit_Design_vod__c objBenefitDesign;           		//To store a Benefit design record
        Formulary_Products_vod__c objFormularyProduct;    		//To store a Formulary product record
        List<Benefit_Design_Line_vod__c> lstBenefitDesignLine;	//To store a Benefit design records returned by test data factory.
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a Benefit design Line record
        lstBenefitDesignLine = clsTestDataFactory.createBenefitDesignLineRecords(1,1);
       	insert lstBenefitDesignLine;
        
        //Querying the created test data
        objBenefitDesign = [SELECT Id FROM Benefit_Design_vod__c ORDER BY BOT_Benefit_Design_ID__c LIMIT 1];
        objFormularyProduct = [SELECT Id FROM Formulary_Products_vod__c ORDER BY BOT_Formulary_Product_ID__c LIMIT 1];
        lstBenefitDesignLine = [SELECT Id, Benefit_Design_vod__c, Product_vod__c FROM Benefit_Design_Line_vod__c];        
        
        //Test data validation
        system.assertEquals(lstBenefitDesignLine[0].Benefit_Design_vod__c, objBenefitDesign.Id);
        system.assertEquals(lstBenefitDesignLine[0].Product_vod__c, objFormularyProduct.Id);
	}
    
    //Testing while creating a list of Benefit design Line records
    static testMethod void createBenefitDesignLineRecords()
    {
        List<Benefit_Design_vod__c> lstBenefitDesign;           //To store list of Benefit design records
        List<Formulary_Products_vod__c> lstFormularyProduct;    //To store list of Formulary product records
        List<Benefit_Design_Line_vod__c> lstBenefitDesignLine;  //To store the list of Benefit design records returned by test data factory.
        Integer intTemp = 0;
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a list of Benefit design Line records
        lstBenefitDesignLine = clsTestDataFactory.createBenefitDesignLineRecords(5,5);
       	insert lstBenefitDesignLine;
        
        //Querying the created test data
        lstBenefitDesign = [SELECT Id FROM Benefit_Design_vod__c ORDER BY BOT_Benefit_Design_ID__c];
        lstFormularyProduct = [SELECT Id FROM Formulary_Products_vod__c ORDER BY BOT_Formulary_Product_ID__c];
        lstBenefitDesignLine = [SELECT Id, Benefit_Design_vod__c, Product_vod__c FROM Benefit_Design_Line_vod__c ORDER BY BOT_Benefit_Design_ID__c,BOT_Formulary_Product_ID__c];        
        
        //Test data validation
        system.assertEquals(lstBenefitDesign.size(), 5);
        system.assertEquals(lstFormularyProduct.size(), 5);
        for(Integer i = 0; i < 5; i++)
        {
            for(Integer j = 0; j < 5; j++)
            {
            	system.assertEquals(lstBenefitDesignLine[intTemp].Benefit_Design_vod__c, lstBenefitDesign[i].Id);
        		system.assertEquals(lstBenefitDesignLine[intTemp].Product_vod__c, lstFormularyProduct[j].Id);
                intTemp++;
            }
        }
	}
    
    //Testing while creating a Benefit design Line record with out Formulary Product Id
    static testMethod void benefitDesignLineWithoutFormularyProductId()
    {	
    	List<Benefit_Design_Line_vod__c> lstBenefitDesignLine;	//To store a Benefit design records returned by test data factory.
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        //To create a Benefit design Line record without Formulary Product Id
        lstBenefitDesignLine = clsTestDataFactory.benefitDesignLineWithoutFormularyProductId(1,1);
        
        try {
        	insert lstBenefitDesignLine;
        }
        catch(DMLException e) {
            system.assertEquals('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+
                                'Benefit Design Id and Formulary Product Id fields are mandatory for BOT records: []', e.getMessage());
        }
    }
    
    //Testing while creating a Benefit design Line record with out Benefit design Id
    static testMethod void benefitDesignLineWithoutBenefitDesignId()
    {	
    	List<Benefit_Design_Line_vod__c> lstBenefitDesignLine;	//To store a Benefit design records returned by test data factory.
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        //To create a Benefit design Line record
        lstBenefitDesignLine = clsTestDataFactory.benefitDesignLineWithoutFormularyProductId(1,1);
        
        try {
        	insert lstBenefitDesignLine;    
        }
        catch(DMLException e) {
            system.assertEquals('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+
                                'Benefit Design Id and Formulary Product Id fields are mandatory for BOT records: []', e.getMessage());
        }
    }
}