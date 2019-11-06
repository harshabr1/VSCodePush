trigger VEEVA_WEC_INS_TERRITORY_DEVELOPER_NAME_TRIGGER on Sent_Message_vod__c (before insert) {
    WeChat_Settings_vod__c wechatSetting = WeChat_Settings_vod__c.getInstance();
    Decimal enableApprovedWeChat = wechatSetting.ENABLE_APPROVED_WECHAT_vod__c;

    Decimal enabled = 1.0;
    if(enabled != enableApprovedWeChat) {
        return;
    }

    for (Integer i = 0 ;  i < Trigger.new.size(); i++) {
      if ((Trigger.new[i].Territory_vod__c == null || Trigger.new[i].Territory_vod__c== '')
          && Trigger.new[i].User_vod__c != null) {
            List <String> UserTerrIds = new List<String> ();
            List<UserTerritory> Userterr =
            [SELECT TerritoryId from UserTerritory where UserId = :Trigger.new[i].User_vod__c AND IsActive = true Limit 1];

            for (UserTerritory ut : Userterr) {
                UserTerrIds.add(ut.TerritoryId);
            }

            List<Territory> terr = null;

            if (UserTerrIds.size() > 0)
                terr = [Select DeveloperName From Territory where Id in :UserTerrIds];
            if (terr != null && terr.size() == 1) {
                Territory myTerr = terr.get(0);
                Trigger.new[i].Territory_vod__c = myTerr.DeveloperName;
            }
       }
     }
}