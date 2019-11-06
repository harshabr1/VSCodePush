/*
Name            : BOT_BenefitDesignLineTriggerHandler
Created By      : Sreenivasulu A
Created Date    : 07-SEP-2018
Overview        : It is implemented by BusinessOne Technologies Inc. It is a handler class of BOT_BenefitDesignLineTrigger trigger.
				  It is used to populate the SFDC Benefit Design ID (plan formulary ID) and SFDC Formulary Product ID (Drug ID) 
				  by using BOT Formulary ID and BOT Drug ID respectively.

Modified By 	:Harsha BR
Modified date 	:14-SEP-2018
Reason 			:Added comments and modified the code to follow the salesforce standard best practices.
*/

public with sharing class BOT_BenefitDesignLineTriggerHandler 
{
	public static void populateBenefitDesignAndProductIds(List<Benefit_Design_Line_vod__c> lstBenefitDesignLine, Set<Integer> setBOTBenefitDesignIds, Set<Integer> setBOTFormularyproductIds)
    {
        Map<Integer, ID> mapBenefitDesignIds = new Map<Integer, ID>();		//To store BOT Benefit design Ids and asssociated SFDC Benefit Design IDs
        Map<Integer, ID> mapFormularyProductIds = new Map<Integer, ID>();	//To store BOT Formulary product Ids and asssociated SFDC Formulary product IDs
        
        //To Retrieve SFDC Benefit design Ids by comparing BOT Benefit design Ids and put in the map   
        for(Benefit_Design_vod__c objBenefitDesign : [SELECT Id, BOT_Benefit_Design_ID__c FROM Benefit_Design_vod__c WHERE BOT_Benefit_Design_ID__c IN : setBOTBenefitDesignIds])
        {
        	mapBenefitDesignIds.put(Integer.valueOf(objBenefitDesign.BOT_Benefit_Design_ID__c), objBenefitDesign.Id);
        }
        
        //To Retrieve SFDC Formulary product Ids by comparing BOT Formulary product Ids and put in the map
        for(Formulary_Products_vod__c objFormularyProduct : [SELECT Id, BOT_Formulary_Product_ID__c FROM Formulary_Products_vod__c WHERE BOT_Formulary_Product_ID__c IN : setBOTFormularyproductIds])
        {
        	mapFormularyProductIds.put(Integer.valueOf(objFormularyProduct.BOT_Formulary_Product_ID__c), objFormularyProduct.Id);
        }
        
        //To populate Benefit_Design_vod__c and Product_vod__c fileds
        for(Benefit_Design_Line_vod__c objBenefitDesignLine : lstBenefitDesignLine)
        {
            objBenefitDesignLine.Benefit_Design_vod__c = mapBenefitDesignIds.get(Integer.valueOf(objBenefitDesignLine.BOT_Benefit_Design_ID__c));
            objBenefitDesignLine.Product_vod__c = mapFormularyProductIds.get(Integer.valueOf(objBenefitDesignLine.BOT_Formulary_Product_ID__c));
 		}
    }
}