/*
Name            : BOT_AccountCoveragePolicyExtn
Created date    : 20-DEC-2018
Created by      : Sreenivasulu Adipudi
Description     :  This class is written by BusinessOne Technologies Inc. It is an extension of BOT_AccountCoveragePolicy Visualforce page.
*/
public with sharing class BOT_AccountCoveragePolicyExtn 
{
    ID accountId;                                                       //To store the ID of selected Account
    Public List<BOT_Coverage_Policy__c> lstCoveragePolicy {get;set;}    //To store the coverage policy records
    Public String strSelectedMarket {get; set;}                         //To store user selected market
    List<String> lstMarkets = new List<String>();                       //To store unique markets
    Public Integer intMarketCount {get;set;}							//To store number of market values present in the list
    ID documentId {get;set;}											//To store the Id of BOT logo document
    Public String strLogoUrl {get;set;}									//To store the URL of BOT logo with document Id
    
    //Constructor
    public BOT_AccountCoveragePolicyExtn(ApexPages.StandardController controller)
    {
        accountId = controller.getId();

        try 
        {
            //To create a list of markets associated with seleted Account's coverage policy
        	for(AggregateResult res : [SELECT BOT_Formulary_Product__r.Market_vod__c market FROM BOT_Coverage_Policy__c 
                                   	   GROUP BY BOT_Formulary_Product__r.Market_vod__c, BOT_Account__c HAVING BOT_Account__c =: accountId
                                       ORDER BY BOT_Formulary_Product__r.Market_vod__c])
        	{
        		lstMarkets.add(String.valueOf(res.get('market')));        
        	}
            //To get BOT logo document Id and Logo URL
            documentId = [SELECT Id FROM Document WHERE name = 'BusinessOne Logo' LIMIT 1].Id;
            strLogoUrl = [SELECT BOT_Value__c FROM BOT_Configuration_Value__mdt WHERE DeveloperName = 'BOT_Logo_URL' LIMIT 1].BOT_Value__c;
            strLogoUrl = strLogoUrl + documentId;
        }
        catch(Exception e) 
        {
        	system.debug('Exception '+e.getMessage()+ ' found in class BOT_AccountCoveragePolicyExtn at line number '+e.getLineNumber());
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
        	//To get Coverage policy records related to selected account
        	getCoveragePolicyFilteredByMarket();
        }
    }
    
    public void getCoveragePolicy()
    {
        if(strSelectedMarket == 'All' || strSelectedMarket == null)
        {
            //To get Coverage policy records related to selected account
            lstCoveragePolicy = [SELECT Id, BOT_Channel__c, BOT_SubChannel__c, BOT_Formulary_Product__r.Name, BOT_Score__c, BOT_Indication__c, BOT_Sub_Indication__c 
                                 FROM BOT_Coverage_Policy__c WHERE BOT_Account__c =: accountId ORDER BY BOT_Formulary_Product__r.Name LIMIT 1000];
        }
        else
        {
            getCoveragePolicyFilteredByMarket();    
        }
    }
    
    public void getCoveragePolicyFilteredByMarket()
    {
        //To get Coverage policy records filtered by selected market
        lstCoveragePolicy = [SELECT Id, BOT_Channel__c, BOT_SubChannel__c,BOT_Formulary_Product__r.Name, BOT_Score__c, BOT_Indication__c, BOT_Sub_Indication__c 
                             FROM BOT_Coverage_Policy__c WHERE BOT_Account__c =: accountId AND BOT_Formulary_Product__r.Market_vod__c =: strSelectedMarket 
                             ORDER BY BOT_Formulary_Product__r.Name LIMIT 1000];
    }
    
    //To create dynamic market picklist values
    public list<selectOption> getDynamicList()
    {
        //return BOT_CreatePickListValues.getDynamicList(lstMarkets);
        List<selectOption> options = new List<selectOption>();
        if(intMarketCount > 0 && lstMarkets != null)
        {
            if(intMarketCount > 1)
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