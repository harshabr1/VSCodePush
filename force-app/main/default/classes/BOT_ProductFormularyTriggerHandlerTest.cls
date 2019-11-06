/*
Name			: BOT_ProductFormularyTriggerHandlerTest
Created by		: Sreenivasulu A
Created date	: 05-NOV-2018
Overview        : It is implemented by BusinessOne Technologies Inc. It is a test class of BOT_ProductFormularyTriggerHandler class.
*/
@isTest(seeAllData=false)
class BOT_ProductFormularyTriggerHandlerTest 
{
    @testSetup static void createTestData()
    {
    	BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(1,'MCO');					//To create the list of Account records
        clsTestDataFactory.createPlanProductRecords(1,5,'Commercial');		//To create the list of Plan Product records
        clsTestDataFactory.createBenefitDesignRecords(1,5,'Commercial');	//To create the list of Benefit design records
        
        //Test data validation
        system.assert([SELECT count() FROM Account] == 1);
        system.assert([SELECT count() FROM BOT_Plan_Product__c] == 5);
        system.assert([SELECT count() FROM Benefit_Design_vod__c] == 5);
    }
    
    //Testing while creating a Product Formulary record
    static testMethod void createProductFormularyRecord()
    {
        BOT_Plan_Product__c objPlanProduct;						//To store a Plan product record
        Benefit_Design_vod__c objBenefitDesign;					//To store a Benefit design record
        List<BOT_Product_Formulary_JO__c> lstProductFormulary;	//To store a list of Product formulary records returned by test data factory
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a Product Formulary record
        lstProductFormulary = clsTestDataFactory.createProductFormularyRecords(1,1);
        
       	insert lstProductFormulary;
        
        //Querying the created test data
        objPlanProduct = [SELECT Id FROM BOT_Plan_Product__c ORDER BY BOT_Product_ID__c LIMIT 1];
        objBenefitDesign = [SELECT Id FROM Benefit_Design_vod__c ORDER BY BOT_Benefit_Design_ID__c LIMIT 1];
        lstProductFormulary = [SELECT Id, BOT_Plan_Product__c, BOT_Benefit_Design__c FROM BOT_Product_Formulary_JO__c];
        
        //Test data validation
        system.assertEquals(lstProductFormulary[0].BOT_Plan_Product__c , objPlanProduct.Id);
        system.assertEquals(lstProductFormulary[0].BOT_Benefit_Design__c , objBenefitDesign.Id);
    }
    
    //Testing while creating the list of Product Formulary records
    static testMethod void createProductFormularyRecords()
    {
       	List<BOT_Plan_Product__c> lstPlanProduct;				//To store a list of Plan product records
        List<Benefit_Design_vod__c> lstBenefitDesign;			//To store a list of Benefit design records
        List<BOT_Product_Formulary_JO__c> lstProductFormulary;	//To store a list of Product formulary records returned by test data factory
        Integer intTemp = 0;
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create the list of Product Formulary record records
        lstProductFormulary = clsTestDataFactory.createProductFormularyRecords(5,5);
        
       	insert lstProductFormulary;
        
        //Querying the created test data
        lstPlanProduct = [SELECT Id FROM BOT_Plan_Product__c ORDER BY BOT_Product_ID__c];
        lstBenefitDesign = [SELECT Id FROM Benefit_Design_vod__c ORDER BY BOT_Benefit_Design_ID__c];
        lstProductFormulary = [SELECT Id, BOT_Plan_Product__c, BOT_Benefit_Design__c FROM BOT_Product_Formulary_JO__c ORDER BY BOT_Plan_Product_ID__c];
        
        //Test data validation
        system.assertEquals(lstPlanProduct.size(), 5);
        system.assertEquals(lstBenefitDesign.size(), 5);
        system.assertEquals(lstProductFormulary.size(), 25);
        for(Integer i = 0; i < 5; i++)
        {
            for(Integer j = 0; j < 5; j++)
            {
                system.assertEquals(lstProductFormulary[intTemp].BOT_Plan_Product__c , lstPlanProduct[i].Id);
        		system.assertEquals(lstProductFormulary[intTemp].BOT_Benefit_Design__c , lstBenefitDesign[j].Id);
                intTemp++;
            }
        }
    }
    
    //Testing while creating the Product Formulary record without Plan Product Id 
    static testMethod void createProductFormularyWithoutPrdouctId()
    {
        List<BOT_Product_Formulary_JO__c> lstProductFormulary;	//To store a list of Product formulary records returned by test data factory
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create the list of Product Formulary record Line records without Plan Product ID
        lstProductFormulary = clsTestDataFactory.createProductFormularyWithoutProductId(1,1);
        try {
        	insert lstProductFormulary;
        }
        catch(DMLException e) {
            system.assertEquals('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+
                                'Product Id and Benefit design Id fields are mandatory: []', e.getMessage());
        }
    }
    
    //Testing while creating a Product Formulary record without Benefit design Id 
    static testMethod void createProductFormularyWithoutBenefitDesignId()
    {
        List<BOT_Product_Formulary_JO__c> lstProductFormulary;	//To store a list of Product formulary records returned by test data factory
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        
        //To create a list of Product Formulary records without Benefit design ID
        lstProductFormulary = clsTestDataFactory.createProductFormularyWithoutBenefitDesignId(1,1);
        try {
        	insert lstProductFormulary;
        }
        catch(DMLException e) {
            system.assertEquals('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, '+
                                'Product Id and Benefit design Id fields are mandatory: []', e.getMessage());
        }
    }
}