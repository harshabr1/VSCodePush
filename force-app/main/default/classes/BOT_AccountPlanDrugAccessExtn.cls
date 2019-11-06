/*
Name            : BOT_AccountPlanDrugAccessExtn
Created by      : Sreenivasulu Adipudi
Created date    : 14-DEC-2018
Description     : This class is created by BusinessOneTechnologies Inc.
				  It is an externsion class for BOT_AccountPlanDrugAccess visualforce page.
*/
public with sharing class BOT_AccountPlanDrugAccessExtn {
	Public ID accountId {get;set;}					//To store Account Id
    Public ID accountPlanId {get;set;}				//To store Account Plan Id
    Public String strSelectedMarket {get;set;}		//To store user selected market
    Public Boolean blnRenderChart {get;set;}		//Used to render the dashboard
    List<String> lstMarkets = new List<String>();	//To store unique markets
    Public Integer intMarketCount {get;set;}		//To store number of market values present in the list
    ID documentId {get;set;}						//To store the Id of BOT logo document
    Public String strLogoUrl {get;set;}				//To store the URL of BOT logo with document Id
    
    //Constructor
    public BOT_AccountPlanDrugAccessExtn(Apexpages.StandardController controller) 
    {
        accountPlanId = controller.getId();
        //Getting assoicated Paret Account Id of Account plan
        accountId = [SELECT Account_vod__c FROM Account_Plan_vod__c WHERE Id =: accountPlanId].Account_vod__c;
    	
        try{
        	//To create a list of markets associated with seleted Account's Drug Access records
        	for(AggregateResult res : [SELECT Name FROM BOT_Drug_Access__c GROUP BY Name, BOT_Account__c HAVING BOT_Account__c =: accountId ORDER BY Name])
        	{
        		lstMarkets.add(String.valueOf(res.get('Name')));    
        	}
            //To get BOT logo document Id and Logo URL
            documentId = [SELECT Id FROM Document WHERE name = 'BusinessOne Logo' LIMIT 1].Id;
            strLogoUrl = [SELECT BOT_Value__c FROM BOT_Configuration_Value__mdt WHERE DeveloperName = 'BOT_Logo_URL' LIMIT 1].BOT_Value__c;
            strLogoUrl = strLogoUrl + documentId;
        }
        catch(Exception e) 
        {
            system.debug('Exception '+e.getMessage()+ ' found in class BOT_AccountPlanDrugAccessExtn at line number '+e.getLineNumber());
        }
        
        intMarketCount = lstMarkets.size();
        
        //Setting Default market value
        if(intMarketCount > 0)
        {
            //To get default market value from the custom label
        	//String strDefaultMarket = Label.BOT_DefaultMarket;
        	
            //To get default market value from the custom metadata object
            String strDefaultMarket = [SELECT BOT_Value__c FROM BOT_Configuration_Value__mdt WHERE DeveloperName = 'BOT_Default_Market' LIMIT 1].BOT_Value__c;

        	//If lstMarkets contains default maket value then set it as default
        	if(lstMarkets.contains(strDefaultMarket))
        	{
        		strSelectedMarket = strDefaultMarket;    
        	}
        	//else set the first value from the lstMarkets as default market
        	else
        	{
            	strSelectedMarket = lstMarkets[0];
        	}
       		getDrugAccessFilteredByMarket();
        }
	}
    
    public void getDrugAccessFilteredByMarket()
    {
        if(strSelectedMarket == 'All')
        {
            blnRenderChart = true;
        }
        else
        {
            blnRenderChart = false;
        }
    }
    
    //To create dynamic picklist values
    public List<selectOption> getDynamicList()
    {
    	//return BOT_CreatePickListValues.getDynamicList(lstMarkets);
    	List<selectOption> options = new List<selectOption>();
        if(intMarketCount>0 && lstMarkets != null)
        {
            if(intMarketCount>1)
        	{
        		options.add(new selectOption('All','All'));
            }
            for(String c : lstMarkets)
        	{
        		options.add(new selectOption(c,c));
        	}
        }
        return options;
    }   
}