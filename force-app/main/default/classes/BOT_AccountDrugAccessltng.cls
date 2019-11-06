/*
Name 			: BOT_AccountDrugAccessltng
Created by 		: Sreenivasulu Adipudi
Created date 	: 06/03/2019
Description 	: It is a controller class for BOT_AccountDrugAccess lightning component. It is used to get the markets dynamically.
*/
public class BOT_AccountDrugAccessltng {
	@AuraEnabled
    public static List<String> getMarkets(Id accountId){
        List<String> lstMarkets = new List<String>();
       	AggregateResult[] aggRes = [SELECT Name FROM BOT_Drug_Access__c GROUP BY Name, BOT_Account__c HAVING BOT_Account__c =: accountId ORDER BY Name]; 
        system.debug('accountId : '+accountId);
        system.debug('Before loop : '+aggRes);
        
        for(AggregateResult res : aggRes)
        {
        	lstMarkets.add(String.valueOf(res.get('Name')));
        }
        system.debug('outside loop : '+lstMarkets);
        if(lstMarkets != null && lstMarkets.size() > 1)
        {
            lstMarkets.add(0,'All');
        }
        system.debug('lstMarkets : '+lstMarkets);
        return lstMarkets;
    }
}