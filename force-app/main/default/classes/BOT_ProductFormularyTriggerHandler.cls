/*
Name			: BOT_ProductFormularyTriggerHandler
Created by		: Sreenivasulu A
Created date	: 05-NOV-2018
Overview        : It is implemented by BusinessOne Technologies Inc. It is a handler class of BOT_ProductFormularyTrigger trigger.
*/
public with sharing class BOT_ProductFormularyTriggerHandler
{
	public static void populateProductIdAndFormularyId(List<BOT_Product_Formulary_JO__c> lstProductFormulary, Set<Double> setPlanProductIds, Set<Double> setBenefitDesignIds)
    {
        Map<Double, ID> mapPlanProductIds = new Map<Double, ID>();		//Map of BOT Plan product Ids and asssociated SFDC Plan Product IDs
        Map<Double, ID> mapBenefitDesignIds = new Map<Double, ID>();	//Map of BOT Benefit design Ids and asssociated SFDC Benefit design IDs
        
        //To Retrieve SFDC Plan product Ids by comparing BOT Plan product Ids and put in the map   
        for(BOT_Plan_Product__c objPlanProduct : [select Id, BOT_Product_ID__c from BOT_Plan_Product__c where BOT_Product_ID__c in : setPlanProductIds])
        {
            mapPlanProductIds.put(objPlanProduct.BOT_Product_ID__c, objPlanProduct.Id);
        }
        
        //To Retrieve SFDC Benefit Design Ids by comparing BOT Benefit Design Ids and put in the map 
        for(Benefit_Design_vod__c objBenefitDesign : [select Id, BOT_Benefit_Design_ID__c from Benefit_Design_vod__c where BOT_Benefit_Design_ID__c in : setBenefitDesignIds])
        {
        	mapBenefitDesignIds.put(objBenefitDesign.BOT_Benefit_Design_ID__c, objBenefitDesign.Id);
        }
        
        //To populate BOT_Plan_Product__c and BOT_Benefit_Design__c fileds
        for(BOT_Product_Formulary_JO__c objProductFormulary : lstProductFormulary)
        {
            objProductFormulary.BOT_Plan_Product__c = mapPlanProductIds.get(objProductFormulary.BOT_Plan_Product_ID__c);
            objProductFormulary.BOT_Benefit_Design__c = mapBenefitDesignIds.get(objProductFormulary.BOT_Benefit_Design_ID__c);
        }
    }
}