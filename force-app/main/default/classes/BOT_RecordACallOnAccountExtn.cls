public class BOT_RecordACallOnAccountExtn 
{
    Public Account objAccount {get;set;}
    List<Address_vod__c> lstAddress {get;set;}
    Public List<String> lstAddressString {get;set;}
    String strAddressString;
    Public String strSelectedAddress {get;set;}
    Public String strSelectedCallStatus {get;set;}
    Public Datetime dtScheduledTime {get;set;}
    Public List<String> lstContacts {get;set;}
    Public List<BOT_Contact__c> lstBOTContacts {get;set;}
    Public List<Formulary_Products_vod__c> lstFormularyProduct {get;set;}
    //Public List<Formulary_Products_vod__c> lstSelectedFormularyProduct {get;set;}
    ID accountId;
    public BOT_RecordACallOnAccountExtn(ApexPages.StandardController controller)
    {
   		accountId = '001m000000mukrY';
        lstAddressString = new List<String>();
        objAccount = [SELECT Id, Name FROM Account WHERE Id =: accountId];
        lstAddress = [SELECT Id, Name, Address_line_2_vod__c, City_vod__c, State_vod__c, Zip_vod__c FROM Address_vod__c WHERE Account_vod__c =: accountId];
 		for(Address_vod__c objAddress : lstAddress)
        {
        	if(objAddress.Name != 'N/A' && objAddress.Name != null)
            {
            	strAddressString = objAddress.Name + ', ';
            }
            if(objAddress.Address_line_2_vod__c != 'N/A' && objAddress.Address_line_2_vod__c != null)
            {
                strAddressString = strAddressString + objAddress.Address_line_2_vod__c + ', ';
            }
            if(objAddress.City_vod__c != 'N/A' && objAddress.City_vod__c != null)
            {
            	strAddressString = strAddressString + objAddress.City_vod__c + ', ';
            }
            if(objAddress.State_vod__c != 'N/A' && objAddress.City_vod__c != null)
            {
            	strAddressString = strAddressString + objAddress.State_vod__c + ', ';
            }
            if(objAddress.Zip_vod__c != 'N/A' && objAddress.Zip_vod__c != null)
            {
            	strAddressString = strAddressString + objAddress.Zip_vod__c;
            }
        	lstAddressString.add(strAddressString);
        }
        lstBOTContacts = [SELECT Id, Name FROM BOT_Contact__c WHERE BOT_Account__c =: accountId];
        
        lstFormularyProduct = [SELECT Id, Name, Market_vod__c FROM Formulary_Products_vod__c WHERE BOT_Is_BOT_Data__c = true AND Competitor_vod__c = false];
    }
    
    //To create dynamic address picklist
    public List<selectOption> getDynamicAddressList()
    {
    	List<selectOption> options = new List<selectOption>();
        if(lstAddressString.size() > 0 && lstAddressString != null)
        {
            options.add(new selectOption('--None--','--None--'));
        	for(String addressString : lstAddressString)
        	{
        		options.add(new selectOption(addressString,addressString));
        	}            
        }
        return options;
    }
    
    //To create dynamic call status picklist
    public List<selectOption> getDynamicCallStatusList()
    {
    	List<selectOption> options = new List<selectOption>();
        if(lstAddressString.size() > 0 && lstAddressString != null)
        {
            options.add(new selectOption('--None--','--None--'));
        	Schema.DescribeFieldResult fieldResult = Call2_vod__c.Status_vod__c.getDescribe();
            List<Schema.PicklistEntry> lstPicklistEntry = fieldResult.getPicklistValues(); 
            for(Schema.PicklistEntry picklistEntry : lstPicklistEntry)
        	{
        		options.add(new selectOption(picklistEntry.getValue(),picklistEntry.getValue()));
        	}            
        }
        return options;
    }
}