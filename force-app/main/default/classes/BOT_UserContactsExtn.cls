public class BOT_UserContactsExtn 
{
    Public List<Contact> lstUserContacts {get;set;}
    public BOT_UserContactsExtn(ApexPages.StandardController controller)
    {
   		lstUserContacts = [SELECT Id, Name FROM Contact WHERE AccountId =: controller.getId() AND CreatedById =: UserInfo.getUserId()]; 
        system.debug('controller.getId() : '+controller.getId());
    	system.debug('UserInfo.getUserId() : '+UserInfo.getUserId());
    	system.debug('lstUserContacts : '+lstUserContacts);
    }
}