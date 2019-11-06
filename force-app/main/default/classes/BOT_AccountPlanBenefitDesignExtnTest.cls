/*
Name            : BOT_AccountPlanBenefitDesignExtnTest
Created date    : 18-Dec-2018
Created by      : Harsha B R
Description     : This class is written by BusinessOne Technologies Inc. 
					It is test class for BOT_AccountPlanBenefitDesignExtn class.
*/
@isTest(seeAllData=false)
private class BOT_AccountPlanBenefitDesignExtnTest {
    
	static testMethod void BOT_APBenefitDesignLine_Extn()
    {
        List<Benefit_Design_Line_vod__c> lstBenefitDesignLine=new List<Benefit_Design_Line_vod__c>();
        List<Account_Plan_vod__c> lstAccountPlan=new List<Account_Plan_vod__c>();
        ID accountId;
        
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(1,'MCO');
        accountId=[SELECT Id,Name FROM Account].Id;
        
        lstAccountPlan=clsTestDataFactory.createAccountPlanRecords(accountId, 1);
        insert lstAccountPlan;
        
        clsTestDataFactory.createBenefitDesignRecords(1,3,'Commercial');
        List<Benefit_Design_vod__c> lstBD=[SELECT Id,Lives_vod__c FROM Benefit_Design_vod__c];
        clsTestDataFactory.createFormularyProductRecords(5);
        lstBenefitDesignLine = clsTestDataFactory.createBenefitDesignLineRecords(1,5); 
        insert lstBenefitDesignLine;
        
        test.startTest();
        ApexPages.StandardController controller = new ApexPages.StandardController(lstAccountPlan[0]);
        BOT_AccountPlanBenefitDesignExtn clsAPBenefitDesign= new BOT_AccountPlanBenefitDesignExtn(controller);
        clsAPBenefitDesign.getPullMarket(); 
        clsAPBenefitDesign.getPullBenefitDesign();
        
        //Calling marketFilterRetrieve method with selected market as 'ALL'
        clsAPBenefitDesign.strSelectedMarket = 'All';
        clsAPBenefitDesign.marketFilterRetrieve();
        system.assertEquals(lstBenefitDesignLine.size(), 5);
       
        //Calling marketFilterRetrieve method with selected market as 'All Company Products'
        clsAPBenefitDesign.strSelectedMarket = 'All Company Products';
        clsAPBenefitDesign.marketFilterRetrieve();
        system.assertEquals(lstBenefitDesignLine.size(), 5);
        
        test.stopTest(); 
    }

}