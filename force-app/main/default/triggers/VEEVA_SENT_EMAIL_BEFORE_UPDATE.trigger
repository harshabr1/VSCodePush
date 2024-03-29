trigger VEEVA_SENT_EMAIL_BEFORE_UPDATE on Sent_Email_vod__c (before update) {
    //ordered enum of status values as they progress
    private enum EmailStatus{Scheduled_vod, Saved_vod, Pending_vod, Sent_vod,Failed_vod, Delivered_vod, Dropped_vod, Bounced_vod, Marked_Spam_vod, Unsubscribed_vod, Group_vod}
    for(Sent_Email_vod__c newEmail: Trigger.new){
        String newStatus = newEmail.Status_vod__c;
        String oldStatus = Trigger.oldMap.get(newEmail.Id).Status_vod__c;
        EmailStatus newStatusE;
        EmailStatus oldStatusE;
        //go through and find the enum value for each status
        for(EmailStatus e: EmailStatus.values()){
            if(e.name() == newStatus){
                newStatusE = e;
            }
            if(e.name() == oldStatus){
                oldStatusE = e;
            }
        }
        //if this new status comes before the old status in our enum, keep the old status
        if(newStatusE.ordinal() < oldStatusE.ordinal()){
            newEmail.Status_vod__c = oldStatus;
        }
        //clear message when status is set to Sent or Delivered
        if(newEmail.Status_vod__c == EmailStatus.Sent_vod.name() || newEmail.Status_vod__c == EmailStatus.Delivered_vod.name()) {
            newEmail.Failure_Msg_vod__c = null;
        }
        //do not overwrite sent date if value already exists
        DateTime newSentDate = newEmail.Email_Sent_Date_vod__c;
        Datetime oldSentDate = Trigger.oldMap.get(newEmail.Id).Email_Sent_Date_vod__c;
        if (newSentDate == null && oldSentDate != null) {
            newEmail.Email_Sent_Date_vod__c = oldSentDate;
        }
    }

}