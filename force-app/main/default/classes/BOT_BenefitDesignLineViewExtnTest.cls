/*
Name            : BOT_BenefitDesignLineViewExtnTest
Created date    : 29/08/2018
Created by      : Sreenivasulu Adipudi
Description     : This class is written by BusinessOne Technologies Inc. It is test class of BOT_BenefitDesignLineViewExtn class.
*/
@isTest(seeAllData=false)
class BOT_BenefitDesignLineViewExtnTest
{
    //Testing BOT_BenefitDesignLineViewExtn standard controller class
    static testMethod void BOT_BenefitDesignLineViewExtnTest()
    {
        Benefit_Design_vod__c objBenefitDesign;           		//To store a Benefit design record
        Benefit_Design_Line_vod__c objBenefitDesignLine;  		//To store a Benefit design line record
        List<Benefit_Design_Line_vod__c> lstBenefitDesignLine;	//To store a list if Benefit design records
        
        //To create Benefit design Line records
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(1,'MCO');
        clsTestDataFactory.createBenefitDesignRecords(1,1,'Commercial');
        clsTestDataFactory.createFormularyProductRecords(5);
        lstBenefitDesignLine = clsTestDataFactory.createBenefitDesignLineRecords(1,5);
        try{
        	insert lstBenefitDesignLine;
        }
        catch(Exception e) 
        {
            system.debug('Exception '+e.getMessage()+ ' found in class BOT_BenefitDesignLineViewExtnTest at line number '+e.getLineNumber());
        }
        
        //Querying the created test data
        objBenefitDesign = [SELECT Id FROM Benefit_Design_vod__c LIMIT 1];
        
        test.startTest();
        //Creating instance for Benefit design standard controller class
        ApexPages.StandardController controller = new ApexPages.StandardController(objBenefitDesign);
        BOT_BenefitDesignLineViewExtn clsBenefitDesignLine= new BOT_BenefitDesignLineViewExtn(controller);
        
        //Test data validation
        system.assertEquals(clsBenefitDesignLine.getDynamicList().size(), 7);
        
        //Calling getBenefitDesignLineFilteredByMarket method with selected market as 'Market 1'
        clsBenefitDesignLine.strSelectedMarket = 'Test Market 1';
        clsBenefitDesignLine.getBenefitDesignLineFilteredByMarket();
        system.assertEquals(clsBenefitDesignLine.lstBenefitDesignLine.size(), 1);
        
        //Calling getBenefitDesignLineFilteredByMarket method with selected market as 'ALL'
        clsBenefitDesignLine.strSelectedMarket = 'ALL';
        clsBenefitDesignLine.getBenefitDesignLineFilteredByMarket();
        system.assertEquals(clsBenefitDesignLine.lstBenefitDesignLine.size(), 5);
        
        //Calling getBenefitDesignLineFilteredByMarket method with selected market as 'All Company Products'
        clsBenefitDesignLine.strSelectedMarket = 'All Company Products';
        clsBenefitDesignLine.getBenefitDesignLineFilteredByMarket();
        system.assertEquals(clsBenefitDesignLine.lstBenefitDesignLine.size(), 5);
        test.stopTest();
    }
}