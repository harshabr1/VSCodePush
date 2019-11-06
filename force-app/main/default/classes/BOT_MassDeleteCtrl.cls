/*
Name			: BOT_MassDeleteCtrl
Created By		: Sreenivasulu A
Created Date	: 09-JAN-2019
Overview		: This class is written by BusinessOne Technologies Inc. It is a controller class for BOT_MassDelete Page.
*/
public class BOT_MassDeleteCtrl {
    
    Integer intRecordCount = 0;								//To store the record count for a specified object
    Public Integer intAccountCount {get;set;}				//To store the Account records count
    Public Integer intAddressCount {get;set;}				//To store the Address records count
    Public Integer intBenefitDesignCount {get;set;}			//To store the Benefit design records count
    Public Integer intBenefitDesignLineCount {get;set;}		//To store the Benefit design Line records count
    Public Integer intPBMChildAccountCount {get;set;}		//To store the Child Account (MCO to PBM Linking) records count
    Public Integer intPersonChildAccountCount {get;set;}	//To store the Child Account (Person Account to Business Account) records count
    Public Integer intCoveragePolicyCount {get;set;}		//To store the Coverage Policy records count
    Public Integer intDrugAccessCount {get;set;}			//To store the Drug Access records count
    Public Integer intFormularyProductCount {get;set;}		//To store the Formulary Product records count
    Public Integer intPharmacyServiceCount {get;set;}		//To store the PharmacyService records count
    Public Integer intPlanProductCount {get;set;}			//To store the Plan product records count
    Public Integer intProductFormularyCount {get;set;}		//To store the Product Formulary records count
    Public Integer intSpecialtyProviderJOCount {get;set;}	//To store the Specialty Provider JO records count
    Public Integer intTheraClassCount {get;set;}			//To store the Thera class records count
    Public Boolean blnIncludeIDNAccount {get;set;}			//It indicates that Delete IDN, ACO & Hospitals along with Account records
    Public Boolean blnIncludePersonAccount {get;set;}		//It indicates that Delete Person Accounts along with Account records
    Public Boolean blnIncludeAccount {get;set;}				//It indicates that Delete Accounts while deleting All records
    Public Boolean blnIncludeAccountAddress {get;set;}		//It indicates that Delete Addresses while deleting All records
    Public Boolean blnIncludeFormularyProduct {get;set;}	//It indicates that Delete Formulary Product while deleting All records
    Public Boolean blnIncludeCoveragePolicy {get;set;}		//It indicates that Delete Coverage Policy while deleting All records
    Public Boolean blnRenderManageAccounts {get;set;}		//To display/hide the Manage Accounts section on the Visualforce page
    Public Integer intAccountsToBeInactive {get;set;}		//It holds the number of Accounts to be inactive after completed of data refresh
    Public Integer intAccountToBeDelete {get;set;}			//It holds the number of Accounts to be Delete after completed of data refresh
    Boolean blnIsDeleteAll = false;							//It will be true when the user opts for Delete All
    //Set<ID> setAccountIds;								//To store the Account Ids which are inactive/deleted in PBB
    //Set<ID> setAccountPlanAndCallIds;						//To store the Account Ids that are inactive/deleted in PBB and having associated Account plans or calls
    //String queryString;									//To hold the SOQL query
    //ID batchJobID;										//To store the batch job ID
    
    public BOT_MassDeleteCtrl() {
    	intAccountCount = [SELECT count() FROM Account WHERE BOT_Is_BOT_Data__c = true];
        intAddressCount = [SELECT count() FROM Address_vod__c WHERE BOT_Is_BOT_Data__c = true];
        intBenefitDesignCount = [SELECT count() FROM Benefit_Design_vod__c WHERE BOT_Is_BOT_Data__c = true];
        intBenefitDesignLineCount = [SELECT count() FROM Benefit_Design_Line_vod__c WHERE BOT_Is_BOT_Data__c = true];
        intPBMChildAccountCount = [SELECT count() FROM Child_Account_vod__c WHERE Parent_Account_vod__r.Account_Type__c = 'PBM' 
                                AND Parent_Account_vod__r.BOT_Is_BOT_Data__c = true 
                                AND Child_Account_vod__r.Account_Type__c NOT IN ('Person Account','IDN','ACO','Hospital')];
        intPersonChildAccountCount = [SELECT count() FROM Child_Account_vod__c WHERE Child_Account_vod__r.Account_Type__c = 'Person Account' 
                                AND Child_Account_vod__r.BOT_Is_BOT_Data__c = true];
        intCoveragePolicyCount = [SELECT count() FROM BOT_Coverage_Policy__c];
        intDrugAccessCount = [SELECT count() FROM BOT_Drug_Access__c];
        intFormularyProductCount = [SELECT count() FROM Formulary_Products_vod__c WHERE BOT_Is_BOT_Data__c = true];
        intPharmacyServiceCount = [SELECT count() FROM BOT_Pharmacy_Service__c];
        intPlanProductCount = [SELECT count() FROM BOT_Plan_Product__c];
        intProductFormularyCount = [SELECT Count() FROM BOT_Product_Formulary_JO__c];
        intSpecialtyProviderJOCount = [SELECT count() FROM BOT_Specialty_Provider_JO__c];
		intTheraClassCount = [SELECT count() FROM BOT_Thera_Class__c];
        blnIncludeIDNAccount = false;
        blnIncludePersonAccount = false;
        blnIsDeleteAll = false;
        
        //getInactiveAccountsCount();
    }
    
    //To delete Account records
    public void deleteAccount() {
        String strQueryString;
        if(blnIncludeIDNAccount == false)
        {
            if(blnIncludePersonAccount == false)
            {
                strQueryString = 'Account WHERE BOT_Is_BOT_Data__c = true AND Account_Type__c NOT IN (\'IDN\',\'ACO\',\'Hospital\',\'Person Account\')'; 
            }
            else
            {
                strQueryString = 'Account WHERE BOT_Is_BOT_Data__c = true AND Account_Type__c NOT IN (\'IDN\',\'ACO\',\'Hospital\')'; 
            }
        }
        else if(blnIncludePersonAccount == false)
        {
            strQueryString = 'Account WHERE BOT_Is_BOT_Data__c = true AND Account_Type__c NOT IN (\'Person Account\')';
        }
        else
        {
            strQueryString = 'Account WHERE BOT_Is_BOT_Data__c = true';
        }
       	executeBatchJob(strQueryString, 'Account');
    }
    
    //To delete Address records
    public void deleteAddress() {
        executeBatchJob('Address_vod__c WHERE BOT_Is_BOT_Data__c = true', 'Address');
    }
    
    //To delete Benefit Design records
    public void deleteBenefitDesign() {
        executeBatchJob('Benefit_Design_vod__c WHERE BOT_Is_BOT_Data__c = true', 'Benefit Design');
    }
    
    //To delete Benefit Design Line records
    public void deleteBenefitDesignLine() {
        executeBatchJob('Benefit_Design_Line_vod__c WHERE BOT_Is_BOT_Data__c = true', 'Benefit Design Line');
    }
    
    //To delete Child Account (MCO to PBM Linking) records
    public void deleteChildAccount() {
  		executeBatchJob('Child_Account_vod__c WHERE Parent_Account_vod__r.Account_Type__c = \'PBM\' AND Parent_Account_vod__r.BOT_Is_BOT_Data__c = true AND Child_Account_vod__r.Account_Type__c NOT IN (\'Person Account\',\'IDN\',\'ACO\',\'Hospital\')', 'PBM Child Account');
        executeBatchJob('Child_Account_vod__c WHERE Child_Account_vod__r.Account_Type__c = \'Person Account\' AND Child_Account_vod__r.BOT_Is_BOT_Data__c = true', 'Person Child Account');
    }
    
    //To delete Coverage Policy records
    public void deleteCoveragePolicy() {
        executeBatchJob('BOT_Coverage_Policy__c', 'Coverage Policy');
    }
    
    //To delete Drug Access records
    public void deleteDrugAccess() {
        executeBatchJob('BOT_Drug_Access__c', 'Drug Access');
    }
    
    //To delete Formulary Product records
    public void deleteFormularyProduct() {
        executeBatchJob('Formulary_Products_vod__c WHERE BOT_Is_BOT_Data__c = true', 'Formulary Product');
    }
    
    //To delete Plan product records
    public void deletePlanProduct() {
        executeBatchJob('BOT_Plan_Product__c', 'Plan Product');
	}
    
    //To delete Pharmacy Service records
    public void deletePharmacyService() {
        executeBatchJob('BOT_Pharmacy_Service__c', 'Pharmacy Service');
	}
    
    //To delete Specialty Provider JO records
    public void deleteSpecialtyProviderJO() {
        executeBatchJob('BOT_Specialty_Provider_JO__c', 'Specialty Provider JO');
	}
    
    //To delete Thera class records
    public void deleteTheraClass() {
        executeBatchJob('BOT_Thera_Class__c', 'Thera Class');
    }
    
    //To delete Plan-Product Formulary records
    public void deleteProductFormulary() {
        executeBatchJob('BOT_Product_Formulary_JO__c', 'Plan-Product Formulary JO');
    }
    
    //To delete all the records from the org
    public void deleteAll() {
    	blnIsDeleteAll = true;
        
        //To clear the previos data from the BOT_Maintenance_page_data custom settings object.
        BOT_MassDeleteEmailAlert.clearMaintenancePageData();
        
        deleteTheraClass();
        deleteDrugAccess();
        deleteSpecialtyProviderJO();
        deleteChildAccount();
        deletePharmacyService();
        deleteBenefitDesign();
        //deletePlanProduct();
        
        if(blnIncludeCoveragePolicy == true)
        {
        	deleteCoveragePolicy();
            //executeBatchJob('BOT_Coverage_Policy__c');    
        }
        
        if(blnIncludeFormularyProduct == true)
        {
        	deleteFormularyProduct();
            //executeBatchJob('Formulary_Products_vod__c WHERE BOT_Is_BOT_Data__c = true');    
        }
        
        if(blnIncludeAccountAddress == true)
        {
        	deleteAddress();
            //executeBatchJob('Address_vod__c WHERE Account_vod__r.BOT_Is_BOT_Data__c = true');    
        }
        
        if(blnIncludeAccount == true)
        {
        	deleteAccount();
            //executeBatchJob('Account WHERE BOT_Is_BOT_Data__c = true');    
        }
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING, 'Deletion inprogress, It a may take maximum 10 Min to Complete. Don\'t refresh the page.'));
    }
    
    //Calling batch class to process the delete operation
    @testVisible void executeBatchJob(String strQueryString, String strObjectLabel)
    {
    	String strExecuteQuery;			//To store the dynamic query
        strExecuteQuery = 'SELECT count() FROM '+strQueryString;
        
        try {
            //To calculate record count
            intRecordCount = Database.countQuery(strExecuteQuery);
        }
        catch(Exception e)
        {
            system.debug('Exception '+e.getMessage()+ ' found in class BOT_MassDeleteCtrl at line number '+e.getLineNumber());
        }
        
        //Validate record count 
        if(intRecordCount > 0)
        {
        	if(blnIsDeleteAll == true)
            {
                //To create the Detail object details while deleting its Master parent
                if(strObjectLabel == 'Benefit Design')
                {
                	BOT_MassDeleteEmailAlert.insertObjectDetails('Benefit Design Line', intBenefitDesignLineCount);    
                    BOT_MassDeleteEmailAlert.insertObjectDetails('Plan-Product Formulary JO', intProductFormularyCount);
                    BOT_MassDeleteEmailAlert.insertObjectDetails('Plan Product', intPlanProductCount);
                }
                //To create the current object details on BOT_Maintenance_page_data custom settings object.
        		BOT_MassDeleteEmailAlert.insertObjectDetails(strObjectLabel, intRecordCount);
            }            
            
            //Preparing the query string
            strExecuteQuery = 'SELECT Id FROM '+strQueryString;
            
            //Calling the Batch Apex to delete the records
            BOT_MassDeleteBatch clsMassDeleteBatch = new BOT_MassDeleteBatch(strExecuteQuery, blnIsDeleteAll, intRecordCount, strObjectLabel);
        	Database.executeBatch(clsMassDeleteBatch);
        }
    }
}