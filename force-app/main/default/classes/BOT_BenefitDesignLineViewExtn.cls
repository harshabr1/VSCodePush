/*
Name            : BOT_BenefitDesignLineViewExtn
Created date    : 28/08/2018
Created by      : Sreenivasulu Adipudi
Description     : This class is written by BusinessOne Technologies Inc. It is an extension of BOT_BenefitDesignLineView Visualforce page.
*/
public with sharing class BOT_BenefitDesignLineViewExtn 
{
    ID benefitDesignID;                         							//To store the current record ID
    Public string strSelectedMarket {get;set;}             					//To store user selected maket from dropdown
    List<String> lstMarkets = new List<String>();         					//To store uniquee market values
    Public List<Benefit_Design_Line_vod__c> lstBenefitDesignLine {get;set;}	//To store the list of Benefit Design line records
    Public Integer intMarketCount {get;set;}								//To store number of market values present in the list
    String strFilter;                                   					//To store the condition to run the query
    String strExeQuery;                                 					//To store the query to get the details of the drugs
    ID documentId {get;set;}												//To store the Id of BOT logo document
    Public String strLogoUrl {get;set;}										//To store the URL of BOT logo with document Id
    
    //Controller
    public BOT_BenefitDesignLineViewExtn(ApexPages.StandardController controller)
    {
        benefitDesignID = controller.getId();
        
        try 
        {
            //To create a list of markets associated with seleted Benefit design
        	for(AggregateResult res : [SELECT Product_vod__r.Market_vod__c market FROM Benefit_Design_Line_vod__c 
                                       GROUP BY Product_vod__r.Market_vod__c, Benefit_Design_vod__c HAVING Benefit_Design_vod__c =: benefitDesignID 
                                       ORDER BY Product_vod__r.Market_vod__c])
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
            system.debug('Exception '+e.getMessage()+ ' found in class BOT_BenefitDesignLineViewExtn at line number '+e.getLineNumber());
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
        	getBenefitDesignLineFilteredByMarket(); 
        }
    }
    
 	//To get list of benefit design records associated with selected formulary filtered by selected market or All markets.
    public void getBenefitDesignLineFilteredByMarket()
    {
        if(strSelectedMarket == 'All')
        {
            strFilter = 'Benefit_Design_vod__c =: benefitDesignID';
        }
        else if(strSelectedMarket == 'All Company Products')
        {
            strFilter = 'Benefit_Design_vod__c =: benefitDesignID AND Competitor_vod__c = false';
        }
        else
        {
            strFilter = 'Benefit_Design_vod__c =: benefitDesignID AND Product_vod__r.Market_vod__c =: strSelectedMarket';
        }
        
        strExeQuery = 'SELECT Id, Product_vod__r.Market_vod__c, Product_vod__r.Name, Status_Source_vod__c, Restrictions_Source_vod__c, Copay_Source_vod__c, Notes_Source_vod__c, Competitor_vod__c FROM Benefit_Design_Line_vod__c WHERE '+ strFilter +' ORDER BY Product_vod__r.Name LIMIT 1000';
        lstBenefitDesignLine= database.query(strExeQuery);
    }
    
    //To create dynamic picklist with market values
    public List<selectOption> getDynamicList()
    {
        List<selectOption> options = new List<selectOption>();
        if(intMarketCount > 0 && lstMarkets != null)
        {
            if(intMarketCount > 1)
            {
                options.add(new selectOption('All','All'));
                options.add(new selectOption('All Company Products','All Company Products'));
            }
            for(String m : lstMarkets)
            {
                options.add(new selectOption(m,m));
            }
            //options.sort();
        }
        return options;
    }    
}