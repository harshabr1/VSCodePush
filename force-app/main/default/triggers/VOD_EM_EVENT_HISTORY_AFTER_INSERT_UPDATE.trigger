trigger VOD_EM_EVENT_HISTORY_AFTER_INSERT_UPDATE on EM_Event_History_vod__c (after insert, after update) {
    if (VOD_Utils.hasObject('EM_Event_History_vod__Share')) {
        List<SObject> newShares = new List<SObject>();
        Set<Id> eventIds = new Set<Id>();
        for (EM_Event_History_vod__c history : Trigger.new) {
            eventIds.add(history.Event_vod__c);
        }

        Set<String> groupNameSet = new Set<String>();
        for(EM_Event_Team_Member_vod__c member : [SELECT Group_Name_vod__c FROM EM_Event_Team_Member_vod__c WHERE Event_vod__c IN :eventIds AND Group_Name_vod__c != null]) {
            groupNameSet.add(member.Group_Name_vod__c);
        }

        Map<String, Id> groupNameToGroupId = new Map<String, Id>();
        for(Group publicGroup : [SELECT Id, DeveloperName FROM Group WHERE DeveloperName IN :groupNameSet]) {
            groupNameToGroupId.put(publicGroup.DeveloperName, publicGroup.Id);
        }

        List<EM_Event_Team_Member_vod__c> members = [SELECT Id, Event_vod__c, Team_Member_vod__c, Group_Name_vod__c FROM EM_Event_Team_Member_vod__c WHERE Event_vod__c IN : eventIds];
        Map<Id, Set<Id>> eventToMembers = new Map<Id, Set<Id>>();
        for (EM_Event_Team_Member_vod__c member : members) {
            if (eventToMembers.get(member.Event_vod__c) == null) {
                eventToMembers.put(member.Event_vod__c, new Set<Id>());
            }
            if(member.Team_Member_vod__c != null) {
                eventToMembers.get(member.Event_vod__c).add(member.Team_Member_vod__c);
            } else if(member.Group_Name_vod__c != null) {
                Id groupUserId = groupNameToGroupId.get(member.Group_Name_vod__c);
                if(groupUserId != null) {
                    eventToMembers.get(member.Event_vod__c).add(groupUserId);
                }
            }
        }

        if (Trigger.isUpdate) {
            Map<Id, EM_Event_History_vod__c> historyMap = new Map<Id, EM_Event_History_vod__c>();
            for (EM_Event_History_vod__c history : Trigger.new) {
                if (history.Event_vod__c != Trigger.oldMap.get(history.Id).Event_vod__c) {
                    historyMap.put(history.Id, history);
                }
            }
            if (!historyMap.isEmpty()) {
                Set<Id> historySet = historyMap.keySet();
                List<SObject> historyShares = Database.query('SELECT Id FROM EM_Event_History_vod__Share WHERE ParentId IN : historySet');
                List<Database.DeleteResult> results = Database.delete(historyShares, false);
                for (Database.DeleteResult result: results) {
                    if (!result.isSuccess()) {
                     system.debug('Delete error: ' + result.getErrors()[0]);
                   }
                }
            }

            for (Id historyId : historyMap.keySet()) {
                EM_Event_History_vod__c history = historyMap.get(historyId);
                if (eventToMembers.get(history.Event_vod__c) != null) {
                    for (Id memberId : eventToMembers.get(history.Event_vod__c)) {
                        SObject historyShare = Schema.getGlobalDescribe().get('EM_Event_History_vod__Share').newSObject();
                        historyShare.put('ParentId', historyId);
                        historyShare.put('UserOrGroupId', memberId);
                        historyShare.put('AccessLevel', 'edit');
                        historyShare.put('RowCause', 'Event_Team_Member_vod__c');
                        newShares.add(historyShare);
                    }
                }
            }
        } else {
            for (EM_Event_History_vod__c history : Trigger.new) {
                if (eventToMembers.get(history.Event_vod__c) != null) {
                    for (Id memberId : eventToMembers.get(history.Event_vod__c)) {
                        SObject historyShare = Schema.getGlobalDescribe().get('EM_Event_History_vod__Share').newSObject();
                        historyShare.put('ParentId', history.Id);
                        historyShare.put('UserOrGroupId', memberId);
                        historyShare.put('AccessLevel', 'edit');
                        historyShare.put('RowCause', 'Event_Team_Member_vod__c');
                        newShares.add(historyShare);
                    }
                }
            }
        }
        List<Database.SaveResult> results = Database.insert(newShares, false);
        for (Database.SaveResult result: results) {
            if (!result.isSuccess()) {
             system.debug('Insert error: ' + result.getErrors()[0]);
           }
        }
    }
}