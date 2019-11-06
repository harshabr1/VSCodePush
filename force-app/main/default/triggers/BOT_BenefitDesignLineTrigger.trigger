/*
Name            : BOT_BenefitDesignLineTrigger
Created By      : Sreenivasulu A
Created Date    : 07-SEP-2018
Overview        : It is implemented by BusinessOne Technologies Inc.It is used to populate the SFDC Benefit Design ID (Formulary ID) 
                  and SFDC Formulary Product ID (Drug ID) by using BOT Formulary ID and BOT Drug ID respectively.
*/
trigger BOT_BenefitDesignLineTrigger on Benefit_Design_Line_vod__c (before insert) 
{
    if(trigger.isInsert && trigger.isBefore)
    {
        List<Benefit_Design_Line_vod__c> lstBenefitDesignLine = new List<Benefit_Design_Line_vod__c>();
        Set<Integer> setBOTBenefitDesignIds = new Set<Integer>();		//To store unique BOT Benefit design Ids
        Set<Integer> setBOTFormularyproductIds = new Set<Integer>();	//To store unique BOT Formulary product Ids
    	
        //Iterating Benefit design line records
        for(Benefit_Design_Line_vod__c objBenefitDesignLine : trigger.new)
        {
       		//Verifying the incomimg record whether it is created by BOT or Veeva
            if(objBenefitDesignLine.BOT_Is_BOT_Data__c == true)
            {
            	//Creating a set of BOT benefitdesign Ids and BOT formulary product Ids
                if(objBenefitDesignLine.BOT_Benefit_Design_ID__c != Null && objBenefitDesignLine.BOT_Formulary_Product_ID__c != Null)
            	{
            		setBOTBenefitDesignIds.add(Integer.valueOf(objBenefitDesignLine.BOT_Benefit_Design_ID__c));
            		setBOTFormularyproductIds.add(Integer.valueOf(objBenefitDesignLine.BOT_Formulary_Product_ID__c));
                	lstBenefitDesignLine.add(objBenefitDesignLine);
            	}
                else
            	{
            		objBenefitDesignLine.addError('Benefit Design Id and Formulary Product Id fields are mandatory for BOT records');
            	}
            }
        }
        
        //Calling a handler class method when the list is having at least 1 record.
        if(lstBenefitDesignLine.size() > 0)
        {
        	BOT_BenefitDesignLineTriggerHandler.populateBenefitDesignAndProductIds(lstBenefitDesignLine, setBOTBenefitDesignIds, setBOTFormularyproductIds);
        }   
    }
}