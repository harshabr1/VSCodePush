trigger VEEVA_WEC_SENT_ACTIVITY_AFTER_INSERT_TRIGGER on Sent_Message_vod__c (after insert) {
    WeChat_Settings_vod__c wechatSetting = WeChat_Settings_vod__c.getInstance();
    Decimal enableApprovedWeChat = wechatSetting.ENABLE_APPROVED_WECHAT_vod__c;

    Decimal enabled = 1.0;
    if(enabled != enableApprovedWeChat) {
        return;
    }
    List<Account> acctList = new List<Account>();
    for(Sent_Message_vod__c activity : trigger.new) {

        Account ac = [Select Id,Total_Sent_Message_vod__c from Account where Id=:activity.Account_vod__c];

        if(ac.Total_Sent_Message_vod__c==null) {
            ac.Total_Sent_Message_vod__c = 0;
        }
        ac.Total_Sent_Message_vod__c = ac.Total_Sent_Message_vod__c + 1;
        acctList.add(ac);
    }
    update acctList;
}