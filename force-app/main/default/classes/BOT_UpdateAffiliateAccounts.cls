/*
Name            : BOT_UpdateAffiliateAccounts 
Created By      : Sreenivasulu A
Created Date    : 29-MAY-2019
Overview        : This class is written by BusinessOne Technologies Inc. 
It updates the Primary_Parent_vod__c field of Affiliate Account with SFDC parent Id where Primary_Parent_vod__c is blank.
*/
public class BOT_UpdateAffiliateAccounts 
{
    @InvocableMethod
    public static void updateAffiliateAccounts()
    {
        List<Account> lstAffiliateAccounts;                             //To store the list of affiliate Accounts which are need to update
        Set<Integer> setParentEntityIds = new Set<Integer>();           //To store BOT Parent Account IDs
        Map<Integer, Id> mapParentAccountIds = new Map<Integer, Id>();  //To store the BOT entity Ids with associated SFDC Ids
        
        //To get the affiliate Accounts which are need to update
        lstAffiliateAccounts = [SELECT Id, ParentId, Primary_Parent_vod__c, BOT_Parent_Entity_ID__c FROM Account 
                                WHERE BOT_Parent_Entity_ID__c != null AND Primary_Parent_vod__c = Null];
        
        if(lstAffiliateAccounts != null && lstAffiliateAccounts.size() > 0)
        {
            //To get the BOT Parent Account IDs
            for(Account objAffiliateAccount : lstAffiliateAccounts)
            {
                setParentEntityIds.add(Integer.valueOf(objAffiliateAccount.BOT_Parent_Entity_ID__c));
            }

            //To get the BOT entity Ids with associated SFDC Ids
            for(Account objAccount : [SELECT Id, BOT_Entity_Id__c FROM Account WHERE BOT_Entity_Id__c IN : setParentEntityIds])
            {
                mapParentAccountIds.put(Integer.valueOf(objAccount.BOT_Entity_Id__c), objAccount.Id);
            }
        
            //To update the SFDC Parent Account Ids and update the affiliate Accounts
            for(Account objAffiliateAccount : lstAffiliateAccounts)
            {
                objAffiliateAccount.Primary_Parent_vod__c = mapParentAccountIds.get(Integer.valueOf(objAffiliateAccount.BOT_Parent_Entity_ID__c));
                objAffiliateAccount.ParentId = objAffiliateAccount.Primary_Parent_vod__c;
            }
            
            try {
                update lstAffiliateAccounts;
            }
            catch(Exception e) {
                system.debug('Exception '+e.getMessage()+ ' found in class BOT_UpdateAffiliateAccounts at line number '+e.getLineNumber());
            }
        }
    }
}