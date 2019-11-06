/* 
Name            : BOT_AccountPharmacyServiceExtnTest
Created by      : Sreenivasulu Adipudi
Created Date    : 11-MAR-2019
Description     : This class is written by BusinessOne Technologies Inc. It is a test class for BOT_AccountPharmacyServiceExtn and 
                  BOT_AccountPharmacyServicePBMExtn classes.
*/
@isTest(seeAllData=false)
public class BOT_AccountPharmacyServiceExtnTest 
{
    //To create the test data
    @testSetup static void createTestData()
    {
        BOT_TestDataFactory clsTestDataFactory = new BOT_TestDataFactory();
        clsTestDataFactory.createAccountRecords(1,'MCO');
        clsTestDataFactory.createAccountRecords(1,'PBM');
        clsTestDataFactory.createPharmacyServices(1,10,'Formulary development/Admin');
        clsTestDataFactory.createPharmacyServices(1,10,'Mail order');
    }
    
    //Testing BOT_AccountPharmacyServiceExtn standard controller class
    public static testMethod void BOT_AccountPharmacyServiceExtnTest()
    {
        Account objAccount;								//To store an account record
		
        objAccount = [SELECT Id FROM Account WHERE Account_Type__c = 'MCO' LIMIT 1];
        
        test.startTest();
        //Creating an instance for Account Pharmacy Service Extension class
        ApexPages.StandardController controller = new ApexPages.StandardController(objAccount);
        BOT_AccountPharmacyServiceExtn clsAccountPharmacyService = new BOT_AccountPharmacyServiceExtn(controller);
        
        //Test data validation
        system.assert(clsAccountPharmacyService.getDynamicList().size() == 2);
        system.assert(clsAccountPharmacyService.lstPharmacyService.size() == 10);
        
        //Calling getPharmacyService method with selected market as 'All'
        clsAccountPharmacyService.strSelectedPharmacyService = 'All';
        clsAccountPharmacyService.getPharmacyService();
        
        //Test data validation
        system.assert(clsAccountPharmacyService.lstPharmacyService.size() == 20);
        
        //Calling getPharmacyService method with selected market as 'Mail order'
        clsAccountPharmacyService.strSelectedPharmacyService = 'Mail order';
        clsAccountPharmacyService.getPharmacyService();
        
        //Test data validation
        system.assert(clsAccountPharmacyService.lstPharmacyService.size() == 10);
        test.stopTest();
    }
    
    //Testing BOT_AccountPharmacyServicePBMExtn standard controller class
    public static testMethod void BOT_AccountPharmacyServicePBMExtnTest()
    {
        Account objAccount;								//To store an account record
		
        objAccount = [SELECT Id FROM Account WHERE Account_Type__c = 'PBM' LIMIT 1];
        
        test.startTest();
        //Creating an instance for Account Pharmacy Service PBM Extension class
        ApexPages.StandardController controller = new ApexPages.StandardController(objAccount);
        BOT_AccountPharmacyServicePBMExtn clsAccountPharmacyService = new BOT_AccountPharmacyServicePBMExtn(controller);
        
        //Test data validation
        system.assert(clsAccountPharmacyService.getDynamicList().size() == 2);
        system.assert(clsAccountPharmacyService.lstPharmacyService.size() == 10);
        
        //Calling getPharmacyService method with selected market as 'All'
        clsAccountPharmacyService.strSelectedPharmacyService = 'All';
        clsAccountPharmacyService.getPharmacyService();
        
        //Test data validation
        system.assert(clsAccountPharmacyService.lstPharmacyService.size() == 20);
        
        //Calling getPharmacyService method with selected market as 'Mail order'
        clsAccountPharmacyService.strSelectedPharmacyService = 'Mail order';
        clsAccountPharmacyService.getPharmacyService();
        
        //Test data validation
        system.assert(clsAccountPharmacyService.lstPharmacyService.size() == 10);
        test.stopTest();
    }
}