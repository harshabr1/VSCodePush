/*
Name            : BOT_BenefitDesignTrigger
Created By      : Sreenivasulu A
Created Date    : 28-AUG-2018
Overview        : This trigger is written by BusinessOne Technologies Inc. 
1. It is used to truncate the name of the Benefit Design if the characters are more than 80 and Append the channel at the end of the name.
2. It also populate the related SFDC Account ID into BOT_Account__c filed by comparing BOT_Entity_ID__c.
3. It calculates roll up lives of parent account and updates on Plan_Lives_Rx__c field of Account object.
*/
trigger BOT_BenefitDesignTrigger on Benefit_Design_vod__c (before insert, after insert, after update) 
{
    if(trigger.isBefore)
    {
        if(trigger.isInsert)
        {
            List<Benefit_Design_vod__c> lstBenefitDesign = new List<Benefit_Design_vod__c>();   //To store the list of valid benefit design records
            Set<Integer> setAccountIds = new Set<Integer>();            //To store Account BOT Entity Ids
            
            for(Benefit_Design_vod__c objBenefitDesign : trigger.new)
            {
                //Verifying the incomimg record, whether it is created by BOT or Veeva
                if(objBenefitDesign.BOT_Is_BOT_Data__c == true)
                {
                    //Creating the set of BOT Entity Ids and list of valid benefit design records
                    if(objBenefitDesign.BOT_Entity_ID__c != null && objBenefitDesign.BOT_Benefit_Design_ID__c != null)               
                    {
                        setAccountIds.add(Integer.valueOf(objBenefitDesign.BOT_Entity_ID__c));       
                        lstBenefitDesign.add(objBenefitDesign);
                    }
                    else
                    {
                        objBenefitDesign.addError('Entity ID and Benefit Design Id fields are mandatory for BOT records');
                    }
                }
            }
            
            //Calling a handler class method when the list is having at least 1 record.
           	if(lstBenefitDesign.size() > 0)
            {
            	BOT_BenefitDesignTriggerHandler.manageNameAndPopulateAccountId(lstBenefitDesign, setAccountIds);
            }
        }
        
        //To calculate Plan Lives associated to An Account and update the Plan_Lives_Rx__c field of Account object
        /*
        else if(trigger.isDelete)
        {
        	Set<ID> setAccountIds = new Set<ID>();            //To store SFDC Account Ids
            for(Benefit_Design_vod__c objBenefitDesign : trigger.old)
            {
            	//Verifying the incomimg record, whether it is created by BOT or Veeva
            	if(objBenefitDesign.BOT_Is_BOT_Data__c == true)
                {
                	//Creating the set of BOT Entity Ids
                    if(objBenefitDesign.BOT_Entity_ID__c != null && objBenefitDesign.BOT_Benefit_Design_ID__c != null)               
                    {
                    	setAccountIds.add(objBenefitDesign.Account_vod__c);
                    }
               	}
         	}
                
            //Calling a handler class method when the list is having at least 1 record.
            if(setAccountIds.size() > 0)
            {
               BOT_BenefitDesignTriggerHandler.updatePlanLivesOnAccount(setAccountIds);
            }    
        }
		*/
    }
    
    //To calculate Plan Lives associated to An Account and update the Plan_Lives_Rx__c field of Account object
    else if(trigger.isAfter)
    {
    	if(trigger.isInsert || trigger.isUpdate)
        {
        	Set<ID> setAccountIds = new Set<ID>();            //To store SFDC Account Ids
            for(Benefit_Design_vod__c objBenefitDesign : trigger.new)
            {
            	//Verifying the incomimg record, whether it is created by BOT or Veeva
            	if(objBenefitDesign.BOT_Is_BOT_Data__c == true)
                {
                	//Creating the set of BOT Entity Ids
                    if(objBenefitDesign.BOT_Entity_ID__c != null && objBenefitDesign.BOT_Benefit_Design_ID__c != null)               
                    {
                    	setAccountIds.add(objBenefitDesign.Account_vod__c);
                    }
               	}
         	}
                
            //Calling a handler class method when the list is having at least 1 record.
            if(setAccountIds.size() > 0)
            {
               BOT_BenefitDesignTriggerHandler.updatePlanLivesOnAccount(setAccountIds);
            }
        }
    }
}