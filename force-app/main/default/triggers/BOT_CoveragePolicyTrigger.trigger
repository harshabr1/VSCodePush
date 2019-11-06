/*
Name            : BOT_CoveragePolicyTrigger
Created By      : Sreenivasulu A
Created Date    : 04-FEB-2019
Overview        : It is implemented by BusinessOne Technologies Inc.It is used to populate the SFDC Account ID and SFDC Formulary Product ID 
                  by comparing BOT Entity ID and BOT Drug ID respectively.
*/
trigger BOT_CoveragePolicyTrigger on BOT_Coverage_Policy__c (before insert) 
{
    if(trigger.isInsert && trigger.isBefore)
    {
        Set<Integer> setBOTEntityIds = new Set<Integer>();                                      //To store the BOT Entity IDs
        Set<Integer> setBOTFormularyproductIds = new Set<Integer>();                            //To store the Formulary Product IDs
        List<BOT_Coverage_Policy__c> lstCoveragePolicy = new List<BOT_Coverage_Policy__c>();    //To store the list of Coverage Policy records
       
        for(BOT_Coverage_Policy__c objCoveragePolicy : trigger.new)
        {
            //Validating the required field values 
            if(objCoveragePolicy.BOT_Entity_ID__c != Null && objCoveragePolicy.BOT_Formulary_Product_ID__c != Null)
            {
                //Creating set of BOT entity Ids and set of BOT Formulary Products Ids
                setBOTEntityIds.add(Integer.valueOf(objCoveragePolicy.BOT_Entity_ID__c));
                setBOTFormularyproductIds.add(Integer.valueOf(objCoveragePolicy.BOT_Formulary_Product_ID__c));
                
                //Creating a list of valid Coverage policy records
                lstCoveragePolicy.add(objCoveragePolicy);
            }
            else
            {
                objCoveragePolicy.addError('Entity Id and Formulary Product Id fields are required to save the record');
            }
        }
        
        //Calling a handler class method when the list is having at least 1 record.
        if(lstCoveragePolicy.size() > 0)
        {
            BOT_CoveragePolicyTriggerHandler.populateAccountAndProductIds(lstCoveragePolicy, setBOTEntityIds, setBOTFormularyproductIds);    
        }           
    }
}