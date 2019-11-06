/*
Name            : BOT_DrugAccessTrigger
Created By      : Sreenivasulu A
Created Date    : 07-SEP-2018
Overview        : It is implemented by BusinessOne Technologies Inc.It is used to populate the SFDC Account ID and SFDC Formulary Product ID 
                  by comparing BOT Entity ID and BOT Drug ID respectively.
*/
trigger BOT_DrugAccessTrigger on BOT_Drug_Access__c (before insert) 
{
    if(trigger.isInsert && trigger.isBefore)
    {
        Set<Integer> setBOTEntityIds = new Set<Integer>();                          //To store the list of unique BOT Entity IDs
        Set<Integer> setBOTFormularyproductIds = new Set<Integer>();                //To store the list of unique Formulary Product IDs
        List<BOT_Drug_Access__c> lstDrugAccess = new List<BOT_Drug_Access__c>();    //To store a list of Drug Access records
        
        for(BOT_Drug_Access__c objDrugAccess : trigger.new)
        {
            //Validating the required field values 
            if(objDrugAccess.BOT_Entity_ID__c != Null && objDrugAccess.BOT_Formulary_Product_ID__c != Null)
            {
                //Creating set of BOT entity Ids and set of BOT Formulary Products Ids
                setBOTEntityIds.add(Integer.valueOf(objDrugAccess.BOT_Entity_ID__c));
                setBOTFormularyproductIds.add(Integer.valueOf(objDrugAccess.BOT_Formulary_Product_ID__c));
                //Creating a list of valid drug access records
                lstDrugAccess.add(objDrugAccess);
            }
            else
            {
                objDrugAccess.addError('Entity Id and Formulary Product Id fields are required to save the record');
            }
        }
        
        //Calling a handler class method when the list is having at least 1 record.
        if(lstDrugAccess.size() > 0)
        {
            BOT_DrugAccessTriggerHandler.populateAccountAndProductIds(lstDrugAccess, setBOTEntityIds, setBOTFormularyproductIds);    
        }           
    }
}