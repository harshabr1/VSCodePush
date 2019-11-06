/*
Name			: BOT_BenefitDesignTriggerHandler
Created By		: Sreenivasulu A
Created Date	: 28-AUG-2018
Overview		: This class is written by BusinessOne Technologies Inc. It is a handler class of BOT_BenefitDesignTrigger trigger.
				  1. It is used to truncate the name of the Benefit Design if the characters are more than 80 and Append the channel at the end of the name.
                  2. It also populate the related SFDC Account ID into BOT_Account__c filed by comparing BOT_Entity_ID__c.
				  3. It calculates roll up lives of parent account and updates on Plan_Lives_Rx__c field of Account object.
*/
public with sharing class BOT_BenefitDesignTriggerHandler 
{
	public static void manageNameAndPopulateAccountId(List<Benefit_Design_vod__c> lstBenefitDesign, Set<Integer> setAccountIds)
    {
        Integer intChannelLength = 0;								//To store length of channel value
        Map<Integer, ID> mapAccountIds = new Map<Integer, ID>();	//To store BOT Entity Ids and SFDC Ids of Account object
        
        //To Retrieve SFDC Account Ids by comparing BOT Entity Ids and put in the map
        for(Account objAccount : [SELECT Id, BOT_Entity_ID__c FROM Account WHERE BOT_Entity_ID__c in : setAccountIds])
        {
            mapAccountIds.put(Integer.valueOf(objAccount.BOT_Entity_ID__c), objAccount.Id);
        }
		
        for(Benefit_Design_vod__c objBenefitDesign : lstBenefitDesign)
        {
            //To populate related SFDC Account ID into Account_vod__c field of Benefit design object
            objBenefitDesign.Account_vod__c = mapAccountIds.get(Integer.valueOf(objBenefitDesign.BOT_Entity_ID__c));
            
            /*
            //To handle name field
            if(objBenefitDesign.BOT_Formulary_Name__c != Null && objBenefitDesign.Type_vod__c != Null)
            {
                //To append ' - ' and channel to the BOT_Formulary_Name field make channelLength as 80 - (3 + channel value length)
                intChannelLength = 77 - objBenefitDesign.Type_vod__c.length();
                
                //Check weather BOT_Formulary_Name field value length is lessthan or equal to channelLength
                //If it is true then append channel to BOT_Formulary_Name field value and store it in name field
                if(objBenefitDesign.BOT_Formulary_Name__c.length() <= intChannelLength)
                {
                	objBenefitDesign.Name = objBenefitDesign.BOT_Formulary_Name__c + ' - '+ objBenefitDesign.Type_vod__c;   
                }
                
                //If name field more than channelLength trim the BOT_Formulary_Name field value
                //Append '.. - ' + channel to BOT_Formulary_Name field value and store it in name field 
                else
                {
                    intChannelLength = intChannelLength - 2;
                	objBenefitDesign.Name = objBenefitDesign.BOT_Formulary_Name__c.subString(0,intChannelLength) + '.. - '+ objBenefitDesign.Type_vod__c;  
                }
            }
			*/
        }
    }
    
    //To calculate Plan Lives and update on Plan_Lives_Rx__c field of Account object
    public static void updatePlanLivesOnAccount(Set<ID> setAccountIds)
    {
        Map<String, Decimal> lstPlanLives = new Map<String, Decimal>();	//To store the Entity Id and total formulary lives
        List<Account> lstAccount;										//To store the list of Account records to update Plan lives
        
        //Query of total lives associated to each entity and put it in the map
        for(AggregateResult res : [SELECT Account_vod__c accountId, SUM(Lives_vod__c) total FROM Benefit_Design_vod__c 
                                   GROUP BY Account_vod__c HAVING Account_vod__c IN : setAccountIds LIMIT 2000])
        {
            lstPlanLives.put(String.valueOf(res.get('accountId')), Integer.valueOf(res.get('total')));
        }
		
        //Query of Accounts whih are require to be update the lvies
        //SOQL query limit set to 10000, because salesforce allows a maximum 10000 reocrds for a DML operation
        lstAccount = [SELECT Id, BOT_Plan_Lives_Rx__c FROM Account WHERE Id IN : setAccountIds LIMIT 10000];
        for(Account objAccount : lstAccount)
        {
            //To update the plan lives on Account
            objAccount.BOT_Plan_Lives_Rx__c = lstPlanLives.get(objAccount.Id);
        }
        try{
        	update lstAccount; 
        }
        catch(Exception e) 
        {
            system.debug('Exception '+e.getMessage()+ ' found in class BOT_BenefitDesignTriggerHandler at line number '+e.getLineNumber());
        }
    }
}