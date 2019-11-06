public class KMITriggerHandler {
    private Set<String> wordMatchList = new Set<String>();
    private Set<String> stringMatchList = new Set<String>();
    private String category = '';
    private final String MESSAGE_DELIMITER = ',';
    private final String ITEM_DELIMITER = ';;';

    public KMITriggerHandler() {
        Veeva_Settings_vod__c vsc = VeevaSettings.getVeevaSettings();
        for(String msgVal : getMultipleVeevaMessages(vsc.KMI_RESTRICTED_WORDS_MESSAGES_vod__c)){
            Set<String> words = new Set<String>();
            words.addAll(msgVal.split(ITEM_DELIMITER));
            for(String word : words){
                boolean isWordMatch = isExactWordMatch(word);
                if(isWordMatch) {
                    wordMatchList.add(word.toLowerCase().replaceAll('^\"|\"$', ''));
                } else {
                    stringMatchList.add(word.toLowerCase());
                }
            }
        }
    }

    public void validateRestrictedWords(List<Medical_Insight_vod__c> triggerObj) {
        String restrictedError = VOD_GET_ERROR_MSG.getErrorMsgWithDefault('MEDICAL_INSIGHTS_RESTRICTED_WORDS_ERROR', 'Medical', '"{0}" is a restricted word or phrase in the {1} field that cannot be captured in a Key Medical Insight.');
        String description = '';
        String summary = '';
        String summaryLabel = Medical_Insight_vod__c.Summary_vod__c.getDescribe().getLabel();
        String descriptionLabel = Medical_Insight_vod__c.Description_vod__c.getDescribe().getLabel();

        for (Medical_Insight_vod__c insight : triggerObj) {
            if (insight.Summary_vod__c != null){
                summary = insight.Summary_vod__c.normalizeSpace().stripHtmlTags().toLowerCase();
            }
            if (insight.Description_vod__c != null){
                description = insight.Description_vod__c.normalizeSpace().stripHtmlTags().toLowerCase();

            }
            for (String restrictedWord : stringMatchList) {
                if (summary.indexOf(restrictedWord) > -1) {
                    insight.addError(restrictedError.replace('{0}', restrictedWord).replace('{1}', summaryLabel));
                    break;
                } else if (description.indexOf(restrictedWord) > -1) {
                    insight.addError(restrictedError.replace('{0}', restrictedWord).replace('{1}', descriptionLabel));
                    break;
                }
            }
            for (String restrictedWord : wordMatchList) {
                Pattern p = Pattern.compile('^[\\p{P}|\\s]*' + restrictedWord + '[\\p{P}|\\s]|[\\p{P}|\\s]' + restrictedWord + '[\\p{P}|\\s]*$|[\\p{P}|\\s]'+ restrictedWord + '[\\p{P}|\\s]');
                if (!String.isEmpty(summary)) {
                    Matcher m1 = p.matcher(summary);
                    if(summary.equals(restrictedWord) || m1.find()) {
                        insight.addError(restrictedError.replace('{0}', restrictedWord).replace('{1}', summaryLabel));
                        break;
                    }
                }
                if (!String.isEmpty(description)) {
                    Matcher m2 = p.matcher(description);
                    if(restrictedWord.equals(description) || m2.find()) {
                        insight.addError(restrictedError.replace('{0}', restrictedWord).replace('{1}', descriptionLabel));
                        break;
                    }
                }
            }
            if (insight.Entity_Reference_Id_vod__c != null && insight.Entity_Reference_Id_vod__c != '') {
                insight.Account_vod__c = insight.Entity_Reference_Id_vod__c;
            }
        }
    }

    private boolean isExactWordMatch(String word) {
        return word.startsWith('\"') && word.endsWith('\"');
    }

    private Set<String> getMultipleVeevaMessages(String settingVal) {
        Set<String> messages = new Set<String>();
        // Process setting value
        for(String message : extractMessagesFromSetting(settingVal)){
            //Get text from the veeva message
            String msg = VOD_GET_ERROR_MSG.getErrorMsg(message, category);
            if(!String.isBlank(msg)){
                messages.add(msg);
            }
        }
        return messages;
    }

    private Set<String> extractMessagesFromSetting(String settingVal) {
        Set<String> messageVods = new Set<String>();
        //Setting value : Veeva_Msg1,Veeva_Msg2,Veeva_Msg3;;Category
        if (String.isNotBlank(settingVal)) {
            String[] subStrs = settingVal.split(ITEM_DELIMITER);
            if (subStrs.size() == 2) {
                category = subStrs[1];
                messageVods.addAll(subStrs[0].split(MESSAGE_DELIMITER));
            }
        }
        return messageVods;
    }
}