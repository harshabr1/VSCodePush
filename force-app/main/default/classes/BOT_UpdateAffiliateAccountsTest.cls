/*
Name            : BOT_UpdateAffiliateAccountsTest 
Created By      : Sreenivasulu A
Created Date    : 26-JUN-2019
Overview        : This class is written by BusinessOne Technologies Inc. It is a test class for BOT_UpdateAffiliateAccounts.
*/
@isTest
class BOT_UpdateAffiliateAccountsTest 
{
	//Testing while creating a Parent Account with one Affiliated record
    static TestMethod void createParentAndAffiliateAccount()
    {
        List<Account> lstAccount = new List<Account>();		//To store a Parent Account record and an Affiliate Account record
        Account objAffiliatedAccount = new Account();		//to store an Affiliated Account record
        
        //To create a Parent Account reocrd
        lstAccount.add(new Account(Name = 'Test Parent Account '+ 10000, BOT_Entity_ID__c = 10000, Account_Type__c = 'MCO', BOT_Is_BOT_Data__c = true));
        //To create an Affiliate Account reocrd
        lstAccount.add(new Account(Name = 'Test Child Account '+ 20000, BOT_Entity_ID__c = 20000, Account_Type__c = 'MCO', BOT_Is_BOT_Data__c = true, BOT_Parent_Entity_ID__c = 10000));
    	insert lstAccount;
        
        //To update affiliate Account with SFDC parent Account Id by using BOT_Parent_Entity_ID__c field
        BOT_UpdateAffiliateAccounts.updateAffiliateAccounts();
        
        //Querying the created test data
        objAffiliatedAccount = [SELECT Primary_Parent_vod__c, ParentId FROM Account WHERE BOT_Parent_Entity_ID__c != Null LIMIT 1];
        //Test data validation
        System.assertEquals(objAffiliatedAccount.Primary_Parent_vod__c , lstAccount[0].Id);
    }
    
    //Testing while creating the list of Parent Account with Affiliated records
    static TestMethod void createParentAndAffiliateAccounts()
    {
        List<Account> lstAccount = new List<Account>();				//To store the list of Parent Account records
        List<Account> lstAffliatedAccounts = new List<Account>();	//To store the list of Affiliated Account records
        Integer i, j, temp = 20000;
        
        //To create the list of Parent Account reocrds
        for(i = 10000; i < 10005; i++)
        {
        	lstAccount.add(new Account(Name = 'Test Parent Account '+ i, BOT_Entity_ID__c = i, Account_Type__c = 'MCO', BOT_Is_BOT_Data__c = true));    
        }
        
        //To create the list of Affiliated Account reocrds
        for(i = 10000; i < 10005; i++)
        {
            for(j = 20000; j < 20005; j++)
            {
        		lstAccount.add(new Account(Name = 'Test Child Account '+ temp, BOT_Entity_ID__c = temp, Account_Type__c = 'MCO', BOT_Is_BOT_Data__c = true, BOT_Parent_Entity_ID__c = i));
                temp++;
            }
        }        
    	insert lstAccount;
        
        //To update affiliate Accounts with SFDC parent Account Id by using BOT_Parent_Entity_ID__c field
        BOT_UpdateAffiliateAccounts.updateAffiliateAccounts();
        
        //Querying the created test data
        lstAccount = [SELECT Id FROM Account WHERE BOT_Parent_Entity_ID__c = Null ORDER BY BOT_Entity_ID__c];
        lstAffliatedAccounts = [SELECT Primary_Parent_vod__c, ParentId FROM Account WHERE BOT_Parent_Entity_ID__c != Null ORDER BY BOT_Parent_Entity_ID__c, BOT_Entity_ID__c];
        
        temp = 0;
        //Test data validation
        for(i = 0; i < 5; i++)
        {
            for(j = 0; j < 5; j++)
            {
            	System.assertEquals(lstAffliatedAccounts[temp].Primary_Parent_vod__c , lstAccount[i].Id);
                temp++;
            }
        }
    }
}