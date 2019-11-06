/* 
Name            : BOT_ClonePersonAccountExtn
Created by      : Sreenivasulu Adipudi
Created Date    : 20-MAR-2019
Description     : This class is written by BusinessOne Technologies Inc. It is a extension class of BOT_ClonePersonAccount Visualforce page.
*/
public class BOT_ClonePersonAccountExtn 
{
	public String strPersonAccountId;
    Account objAccount;
    Contact objContact;
    public BOT_ClonePersonAccountExtn(ApexPages.StandardController controller)
    {
        strPersonAccountId = controller.getId();
        objAccount = [SELECT Id, FirstName, LastName, Suffix_vod__c, BOT_Suffix1__c, PersonMailingStreet, PersonMailingCity, 
                      PersonMailingState, PersonMailingPostalCode, Phone from Account WHERE Id =: strPersonAccountId];
        objContact.AccountId = objAccount.Id;
        objContact.FirstName = objAccount.FirstName;
        objContact.LastName = objAccount.LastName;
    }
}