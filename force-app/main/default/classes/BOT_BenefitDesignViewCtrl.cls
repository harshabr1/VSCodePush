/*
Name            : BOT_BenefitDesignViewCtrl
Created by      : Sreenivasulu Adipudi
Created date    : 05/22/2019
Description     : It is a controller class for BOT_BenefitDesignView lightning component. It is used to pull the benefitdesignLine data for the selected Benefitdesign.
*/
public class BOT_BenefitDesignViewCtrl {
    @AuraEnabled
    public static WrapperClass getBenefitDesignLine(Id benefitDesignId){
        Set<String> setMarket = new Set<String>();
        WrapperClass lstRecords = new WrapperClass();
        
        lstRecords.strDefaultMarket = [SELECT BOT_Value__c FROM BOT_Configuration_Value__mdt WHERE DeveloperName = 'BOT_Default_Market' LIMIT 1].BOT_Value__c;
           
        lstRecords.lstBenefitDesignLine = [SELECT Id, BOT_Market__c, Product_vod__r.Name, Product_vod__r.Competitor_vod__c, Status_Source_vod__c, 
                                           Restrictions_Source_vod__c, Copay_Source_vod__c, Notes_Source_vod__c FROM Benefit_Design_Line_vod__c 
                                           WHERE Benefit_Design_vod__c =: benefitDesignId ORDER BY Product_vod__r.Name];

        for(Benefit_Design_Line_vod__c objBenefitDesignLine : lstRecords.lstBenefitDesignLine)
        {
            setMarket.add(objBenefitDesignLine.BOT_Market__c);
        }
        
        if(setMarket.contains(lstRecords.strDefaultMarket))
        {
        	lstRecords.lstBenefitDesignLineFiltered = [SELECT Id, BOT_Market__c, Product_vod__r.Name, Product_vod__r.Competitor_vod__c, Status_Source_vod__c, 
                                           Restrictions_Source_vod__c, Copay_Source_vod__c, Notes_Source_vod__c FROM Benefit_Design_Line_vod__c 
                                           WHERE Benefit_Design_vod__c =: benefitDesignId AND BOT_Market__c =: lstRecords.strDefaultMarket 
                                           ORDER BY Product_vod__r.Name];
        }
        else
        {
        	lstRecords.lstBenefitDesignLineFiltered.addAll(lstRecords.lstBenefitDesignLine);
        }
        
        lstRecords.lstMarket = new List<String>();
        if(setMarket.size() > 1)
        {
            lstRecords.lstMarket.add('All');
            lstRecords.lstMarket.add('All Company Products');
        }
        lstRecords.lstMarket.addAll(setMarket);
        lstRecords.lstMarket.sort();
        
        return lstRecords;
    }
    
    public class WrapperClass {
        @AuraEnabled public List<String> lstMarket {get;set;}
        @AuraEnabled public String strDefaultMarket {get;set;}
        @AuraEnabled public List<Benefit_Design_Line_vod__c> lstBenefitDesignLine {get;set;}
        @AuraEnabled public List<Benefit_Design_Line_vod__c> lstBenefitDesignLineFiltered {get;set;}
    }
}