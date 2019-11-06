/*
Name 		 : BOT_CoveragePolicyViewExtn
Created Date : 12-Nov-2018
Created By   : Harsha BR
Overview 	 : It is written by BusinessOne Technologies Inc. It is used to fetch the coverage policy details. 
			   It pulls the PA or Covera policy form the external system based on user input.
			   
Modified by		: Sreenivasulu A
Modified Date	: 19-JUN-2019
Overview		: 1. Replaced the BOT_End_Point_PDF Custom label with custom metadata type field BOT_EndPoint_URL.
				  2. Added aditional parameters(client Id and Sub indication) to the end point URL.

Reviewed by		: Shridhar S
Modified Date	: 20-JUN-2019
Overview		: Added all Missing Parameters and also integrated with EndPoint URL to this.

*/
public class BOT_CoveragePolicyViewExtn
{   
    Public List<BOT_Coverage_Policy__c> lstCoveragePolicy{get;set;}	//To store the coverage policy records
    Public String type {get; set;}									//To store the form type PA/CP

    Public BOT_CoveragePolicyViewExtn(ApexPages.StandardController controller)
    {

        //To get the details of selected coverage policy
        lstCoveragePolicy=[SELECT Id, BOT_STDetail__c, BOT_DRC__c, BOT_DRI__c, BOT_PADetail__c, BOT_CP_Form_Available__c, BOT_PA_Form_Available__c, 
                           BOT_Entity_ID__c, BOT_Drug_Policy_ID__c, BOT_Formulary_Product_Id__c, BOT_Indication__c, BOT_Formulary_Product__r.Name,
                           BOT_Poly_Therapy_Details__c, BOT_Sub_Indication__c, BOT_Channel__c, BOT_SubChannel__c FROM BOT_Coverage_Policy__c
                           WHERE ID=:controller.getId() LIMIT 1];
    }
    
    //To get the PA Form or Coverage Policy From from the external system
    Public PageReference retrieveCPformPDF()
    {
        Decimal entityID=0;
        Decimal policyID=0;
        Decimal drugId=0;
        String indication;
        String subIndication ='';
        String channel;
        String subChannel;
        //Decimal clientId=0;
        //String baseURL;
        //String drugName;
        //String appName;
        //String versionNumber;
        //String secretKey;
        
        //System.debug('***type***: '+type);
        //String type = Apexpages.currentPage().getParameters().get('node');
		//System.debug('***type***: '+type);
        
        //String baseURL = Label.BOT_EndPointPDF;
        //baseURL = [SELECT BOT_Value__c FROM BOT_Configuration_Value__mdt WHERE DeveloperName = 'BOT_EndPoint_URL' LIMIT 1].BOT_Value__c;
        //clientId = Integer.valueOf([SELECT BOT_Value__c FROM BOT_Configuration_Value__mdt WHERE DeveloperName = 'BOT_Client_Id' LIMIT 1].BOT_Value__c);
        //appName = [SELECT BOT_Value__c FROM BOT_Configuration_Value__mdt WHERE DeveloperName = 'BOT_AppName' LIMIT 1].BOT_Value__c;
        //versionNumber = [SELECT BOT_Value__c FROM BOT_Configuration_Value__mdt WHERE DeveloperName = 'BOT_VersionNumber' LIMIT 1].BOT_Value__c;
        //secretKey = [SELECT BOT_Value__c FROM BOT_Configuration_Value__mdt WHERE DeveloperName = 'BOT_SecretKey' LIMIT 1].BOT_Value__c;
        
        /*
        if(lstCoveragePolicy[0].BOT_Formulary_Product__r.Name!=null)
        {
        	drugName=lstCoveragePolicy[0].BOT_Formulary_Product__r.Name;
            if(drugName.contains(' '))
            {
             	drugName=drugName.replaceAll(' ','%20');
            }
        }
		*/
        
        if(lstCoveragePolicy[0].BOT_Formulary_Product_Id__c!=null)
        {
        	drugId=lstCoveragePolicy[0].BOT_Formulary_Product_Id__c;
        }
        
        if(lstCoveragePolicy[0].BOT_Entity_ID__c!=null)
        {
         	entityID=lstCoveragePolicy[0].BOT_Entity_ID__c;  
        }
        if(lstCoveragePolicy[0].BOT_Channel__c!=null)
        {
         	channel=lstCoveragePolicy[0].BOT_Channel__c;
            if(channel.contains(' '))
            {
             	channel=channel.replaceAll(' ','%20');
            }
        }
        
        if(lstCoveragePolicy[0].BOT_SubChannel__c!=null)
        {
         	subChannel=lstCoveragePolicy[0].BOT_SubChannel__c;
            if(subChannel.contains(' '))
            {
             	subChannel=subChannel.replaceAll(' ','%20');
            }   
        }
        
        if(lstCoveragePolicy[0].BOT_Drug_Policy_ID__c!=null)
        {
         	policyID=lstCoveragePolicy[0].BOT_Drug_Policy_ID__c;   
          }
        
        if(lstCoveragePolicy[0].BOT_Indication__c!=null)
        {
         	indication=lstCoveragePolicy[0].BOT_Indication__c;
            if(indication.contains(' '))
            {
             	indication=indication.replaceAll(' ','%20');
            }   
        }
        
        if(lstCoveragePolicy[0].BOT_Sub_Indication__c!=null)
        {
         	subIndication=lstCoveragePolicy[0].BOT_Sub_Indication__c;
            if(subIndication.contains(' '))
            {
             	subIndication=subIndication.replaceAll(' ','%20');
            }   
        }
        
        //To get the configuration values from custom meta data object
        BOT_PA_CP_From_CofigValues__mdt objConfigValues = [SELECT Id, BOT_AppName__c, BOT_Client_Id__c, BOT_EndPoint_URL__c, BOT_SecretKey__c, 
                                                           BOT_VersionNumber__c FROM BOT_PA_CP_From_CofigValues__mdt
                                                           WHERE DeveloperName = 'Config_Values' LIMIT 1];
        
        Http h=new Http();
		HttpRequest req=new HttpRequest();
        String endPointURL = objConfigValues.BOT_EndPoint_URL__c+'?clientId='+Integer.valueOf(objConfigValues.BOT_Client_Id__c)+'&entityID='+entityID+
       						'&channel='+channel+'&subChannel='+subChannel+'&drugId='+drugId+'&documentType='+type+
            				'&drugpolicyid='+policyID+'&indicationname='+indication+'&subIndication='+subIndication+
        					'&VersionNumber='+objConfigValues.BOT_VersionNumber__c+'&AppName='+objConfigValues.BOT_AppName__c;
    	
        system.debug('***EndPoint***'+endPointURL);
        req.setEndpoint(endPointURL);
        req.setHeader('Content-Type','application/json');
    	req.setHeader('Content-Encoding','gzip'); 
        req.setHeader('document-api-key',objConfigValues.BOT_SecretKey__c); 
    	req.setMethod('GET');
        req.setTimeout(120000);
		HttpResponse res = h.send(req);
		system.debug('*** Response Body***'+res.getBody());
        BOT_CPFormResponse lstCPFormResponse = BOT_CPFormResponse.parse(res.getBody());
        system.debug('***lstCPFormResponse***'+lstCPFormResponse);
        PageReference pgref = new PageReference(lstCPFormResponse.fileURL);
		return pgref;
    }
}