/*
Name			: BOT_Account_Summary_Extn
Created date	: 08/08/2018
Created by		: Sreenivasulu Adipudi
Description		: This class is written by BusinessOne Technologies Inc. It is an extension for BOT_Account_Summary_View Visualforce page.
*/
public with sharing class BOT_Account_Summary_Extn 
{
	ID accountId;														//To store the ID of selected Account
    //Public String selectedChannel {get;set;}							//To store channel selected by the user
    //Public List<BOT_Plan_Product__c> lstPlanProducts {get;set;}			//To store the plan product records
    //Public List<Benefit_Design_vod__c> lstPlanFormulary {get;set;}		//To store the formulary records
    //Public List<BOT_Pharmacy_Service__c> lstPharmacyService {get;set;}	//To store the pharmacy services records
    Public List<BOT_Coverage_Policy__c> lstCoveragePolicy {get;set;}	//To store the coverage policy records
    //Set<String> setChannels = new Set<String>();						//To store uniquee channels
    
    //Constructor
    public BOT_Account_Summary_Extn(ApexPages.StandardController controller)
    {
    	accountId = controller.getId();    
    	//To get all the plan product, plan formulary records associated with selected Account
        //if(accountId != Null)
        {
        	initialRetrieve();
        }
		/*if(lstPlanProducts.size() > 0 && lstPlanProducts != null)
        {
            //Eliminating repeated channels
            for(BOT_Plan_Product__c objPlanProduct : lstPlanProducts)
            {
            	setChannels.add(objPlanProduct.BOT_Channel__c);    
            }
        }*/
	}
    
    public void initialRetrieve()
    {
    	//To get Plan products records
        /*
        lstPlanProducts = [SELECT Id, BOT_Channel__c, BOT_Product_Name__c, BOT_Product_Type__c, BOT_Product_Type_ID__c, BOT_Formulary_Type_Used__c, BOT_Product_Lives_Rx__c 
                           FROM BOT_Plan_Product__c 
                           WHERE BOT_Account__c =: accountId ORDER BY BOT_Channel__c, BOT_Product_Type_ID__c, BOT_Product_Lives_Rx__c DESC NULLS LAST 
                           LIMIT 50000];
        
        //To get Plan formulary records
        lstPlanFormulary = [SELECT Id, Type_vod__c, BOT_Formulary_Name__c, Lives_vod__c 
                            FROM Benefit_Design_vod__c 
                            WHERE Account_vod__c =: accountId ORDER BY Type_vod__c, Lives_vod__c DESC NULLS LAST 
                            LIMIT 50000];
        
        //To get Pharmacy Service records
        lstPharmacyService = [SELECT Id, Name, BOT_Channel__c, BOT_Account__c, BOT_PBM_Name__r.Name, BOT_Provider_Name__c 
                              FROM BOT_Pharmacy_Service__c 
                              WHERE BOT_Account__c =: accountId ORDER BY BOT_Channel__c, Name
                              LIMIT 50000];
		*/
        //To get Coverage policy records related to selected account
        lstCoveragePolicy = [select Id, BOT_Channel__c, Name, BOT_Score__c, BOT_Indication__c, (select Id, name from Attachments limit 2) 
                             from BOT_Coverage_Policy__c where BOT_Account__c =: accountId ORDER BY Name];
    }
    
    /*
    public void channelFilterRetrieve()
    {
        if(selectedChannel != Null)
        {
            //If the selected channel is All then get all records
            if(selectedChannel == '--ALL--')
            {
        		initialRetrieve();	
            }
            else
            {
        		//To get Plan products records filtered by selected channel
	        	lstPlanProducts = [SELECT Id, BOT_Channel__c, BOT_Product_Name__c, BOT_Product_Type__c, BOT_Product_Type_ID__c, BOT_Formulary_Type_Used__c, BOT_Product_Lives_Rx__c 
                                   FROM BOT_Plan_Product__c 
                                   WHERE BOT_Account__c =: accountId and BOT_Channel__c =: selectedChannel ORDER BY BOT_Product_Type_ID__c, BOT_Product_Lives_Rx__c DESC NULLS LAST 
                                   LIMIT 50000];
        		
                //To get Plan formulary records filtered by selected channel
        		lstPlanFormulary = [SELECT Id, Type_vod__c, BOT_Formulary_Name__c, Lives_vod__c 
                                    FROM Benefit_Design_vod__c 
                                    WHERE Account_vod__c =: accountId and Type_vod__c =: selectedChannel ORDER BY Type_vod__c, Lives_vod__c DESC NULLS LAST 
                                    LIMIT 50000];
                
                //To get Pharmacy Service records filtered by selected channel
        		lstPharmacyService = [SELECT Id, Name, BOT_Channel__c, BOT_Account__c, BOT_PBM_Name__r.Name, BOT_Provider_Name__c 
                              		  FROM BOT_Pharmacy_Service__c 
                              		  WHERE BOT_Account__c =: accountId and BOT_Channel__c =: selectedChannel ORDER BY Name
                              		  LIMIT 50000];
            }
        }
    }
    
    //Creating a dynamic picklist with channels
    public List<selectOption> getDynamicList()
    {
        List<selectOption> options = new List<selectOption>();
        if(setChannels.size()>0 && setChannels != null)
        {
        	if(setChannels.size()>1)
        	{
        		options.add(new selectOption('--ALL--','--ALL--'));
        	}
            for(String c : setChannels)
        	{
        		options.add(new selectOption(c,c));
        	}
        }
        return options;
    }
	*/
}