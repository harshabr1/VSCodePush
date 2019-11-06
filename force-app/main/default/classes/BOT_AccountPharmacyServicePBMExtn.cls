/* 
Name            : BOT_AccountPharmacyServicePBMExtn
Created by      : Sreenivasulu Adipudi
Created Date    : 08-MAR-2019
Description     : This class is written by BusinessOne Technologies Inc. It is an extension class for BOT_AccountPharmacyServicePBM Visualforce page.
*/
public class BOT_AccountPharmacyServicePBMExtn 
{
    ID accountId;                                                       //To store the ID of selected Account
    Public List<BOT_Pharmacy_Service__c> lstPharmacyService {get;set;}  //To store the Pharmacy Service records
    Public String strSelectedPharmacyService {get; set;}                //To store user selected market
    List<String> lstPharmacyServiceName = new List<String>();           //To store unique pharmacy service names
    Public Integer intPharmacyServiceCount {get;set;}					//To store number of Phamacy Service records present in the list
	ID documentId {get;set;}											//To store the Id of BOT logo document
    Public String strLogoUrl {get;set;}									//To store the URL of BOT logo with document Id
    
    //Constructor
    public BOT_AccountPharmacyServicePBMExtn(ApexPages.StandardController controller)
    {
        accountId = controller.getId();
        
        try 
        {
            //To create a list of Pharmacy Service names associated with seleted Account
        	for(AggregateResult res : [SELECT Name FROM BOT_Pharmacy_Service__c GROUP BY Name, BOT_PBM_Name__c HAVING BOT_PBM_Name__c =: accountId ORDER BY Name])
        	{
        		lstPharmacyServiceName.add(String.valueOf(res.get('Name')));        
        	}
            //To get BOT logo document Id and Logo URL
            documentId = [SELECT Id FROM Document WHERE name = 'BusinessOne Logo' LIMIT 1].Id;
            strLogoUrl = [SELECT BOT_Value__c FROM BOT_Configuration_Value__mdt WHERE DeveloperName = 'BOT_Logo_URL' LIMIT 1].BOT_Value__c;
            strLogoUrl = strLogoUrl + documentId;
        }
        catch(Exception e) 
        {
        	system.debug('Exception '+e.getMessage()+ ' found in class BOT_AccountPharmacyServiceExtn at line number '+e.getLineNumber());
        }
        
        intPharmacyServiceCount = lstPharmacyServiceName.size();
        
        //Setting Default Pharmacy Service Name
        if(intPharmacyServiceCount > 0)
        {
            //To get default Pharmacy Service Name from the custom label
        	//String strPharmacyServiceName = Label.BOT_DefaultPharmacyServiceName;
        	
            //To get default pharmacy service value from the custom metadata object
            String strPharmacyServiceName = [SELECT BOT_Value__c FROM BOT_Configuration_Value__mdt WHERE DeveloperName = 'BOT_Default_Pharmacy_Service' LIMIT 1].BOT_Value__c;
        
        	//If lstPharmacyServiceName contains default Pharmacy Service Name then set it as default
        	if(lstPharmacyServiceName.contains(strPharmacyServiceName))
        	{
        		strSelectedPharmacyService = strPharmacyServiceName;    
        	}
        	//else set the first value from the lstPharmacyServiceName as default market
        	else
        	{
            	strSelectedPharmacyService = lstPharmacyServiceName[0];
        	}
            
            //To get Pharmacy Service records related to selected account filtered by service name
        	getPharmacyServiceFilteredByServiceName();
        }
    }
    
    public void getPharmacyService()
    {
        if(strSelectedPharmacyService == 'All')
        {
            //To get Pharmacy Service records related to selected account
            lstPharmacyService = [SELECT Name, BOT_Channel__c, BOT_SubChannel__c, BOT_Account__c, BOT_Account__r.Name, BOT_Provider_Name__c 
                                  FROM BOT_Pharmacy_Service__c WHERE BOT_PBM_Name__c =: accountId ORDER BY Name LIMIT 1000];
        }
        else
        {
            getPharmacyServiceFilteredByServiceName();    
        }
    }
    
    public void getPharmacyServiceFilteredByServiceName()
    {
        //To get Pharmacy Service records related to selected account filtered by service name
        lstPharmacyService = [SELECT Name, BOT_Channel__c, BOT_SubChannel__c, BOT_Account__c, BOT_Account__r.Name, BOT_Provider_Name__c 
                              FROM BOT_Pharmacy_Service__c WHERE BOT_PBM_Name__c =: accountId AND Name =: strSelectedPharmacyService 
                              ORDER BY BOT_Channel__c, BOT_SubChannel__c LIMIT 1000];
    }
    
    //To create dynamic Pharmacy Service name picklist values
    public list<selectOption> getDynamicList()
    {
        List<selectOption> options = new List<selectOption>();
        if(intPharmacyServiceCount > 0 && intPharmacyServiceCount != null)
        {
            for(String serviceName : lstPharmacyServiceName)
            {
                options.add(new selectOption(serviceName,serviceName));
            }            
        }
        return options;
    }
}