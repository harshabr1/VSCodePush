public class BOT_DrugAccessDashboardDynamicExtn 
{
    public static ID accountID;
    public static Map<String, Map<String,Decimal>> data {get;set;}
        
    public BOT_DrugAccessDashboardDynamicExtn(ApexPages.StandardController controller)
    {
        accountID = '001m000000mukrc';	//controller.getId();
    }

    public static Map<String, Map<String,Decimal>> getChartData(){
    	
        data = new Map<String, Map<String,Decimal>>();
    	
    	for(BOT_Drug_Access__c objDrugAccess : [SELECT Id, BOT_Formulary_Product__r.Name, BOT_Drug_Status__c, BOT_Access_Percentage__c FROM BOT_Drug_Access__c WHERE BOT_Account__c =: accountID]) 
        {
            //data.putData(objDrugAccess.BOT_Formulary_Product__r.Name, objDrugAccess.BOT_Drug_Status__c, objDrugAccess.BOT_Access_Percentage__c);
        }
        return data;
	}
 
	private static void putData(String drugName, String status, Decimal accessPercentage){
    	Map<String,Decimal> statusGroup = new Map<String,Decimal>();
    	if(data.containsKey(drugName)){
        	statusGroup = data.get(drugName);
    	}
    	statusGroup.put(status, accessPercentage);
    	data.put(drugName, statusGroup);
    }
}