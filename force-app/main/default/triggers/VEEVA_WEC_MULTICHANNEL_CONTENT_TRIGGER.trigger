trigger VEEVA_WEC_MULTICHANNEL_CONTENT_TRIGGER on Multichannel_Content_vod__c (after insert,after update, after delete, before delete) {

    WeChat_Settings_vod__c wechatSetting = WeChat_Settings_vod__c.getInstance();
    Decimal enableApprovedWeChat = wechatSetting.ENABLE_APPROVED_WECHAT_vod__c;

    Decimal enabled = 1.0;
    if(enabled != enableApprovedWeChat){
        return;
    }

    if(Trigger.isAfter) {
        String original = wechatSetting.APPROVED_WECHAT_BASE_URL_vod__c;
        // extract only the domain (remove the context path)
        URL url = new URL(original);
        String baseUrl = url.getProtocol() + '://' + url.getHost() + '/';
        String partnerURL = baseUrl + 'approved-service/cache/refresh/productContent/'+UserInfo.getOrganizationId();
        VEEVA_WEC_WEB_SERVICE_ASYNC_UTIL.get(partnerURL, null);
    }
}