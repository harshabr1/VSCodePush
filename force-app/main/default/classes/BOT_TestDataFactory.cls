/*
Name            : BOT_TestDataFactory
Created By      : Sreenivasulu A
Created Date    : 15-OCT-2018
Overview        : It is implemented by BusinessOne Technologies Inc.It is a test data factory class and used to create the records for test classes.
*/
@isTest
public class BOT_TestDataFactory 
{
    //To create Account records
    public void createAccountRecords(Integer noOfAccounts, String Channel)
    {
        List<Account> lstAccount;       //To create a list of Account records
        Integer i = 0;					
        
        //To avoid duplication of Entity Ids start the Entity Id from 1000 for Specialty Provider Accounts
        if(Channel == 'Specialty Provider')
        {
            i = i + 1000;
            noOfAccounts = noOfAccounts + 1000;
        }
        //To avoid duplication of Entity Ids start the Entity Id from 2000 for PBM Accounts
        else if(Channel == 'PBM')
        {
            i = i + 2000;
            noOfAccounts = noOfAccounts + 2000;
        }
        
        //To avoid duplication of Entity Ids start the Entity Id from 3000 for Person Accounts
        /*
        else if(Channel == 'Person Account')
        {
            i = i + 3000;
            noOfAccounts = noOfAccounts + 3000;
        }
		*/

        //Creating a list of Account records
        lstAccount = new List<Account>();
        for(; i < noOfAccounts; i++)
        {
            lstAccount.add(new Account(Name = 'Test Parent Account '+ i, BOT_Entity_ID__c = i, Account_Type__c = Channel, BOT_Is_BOT_Data__c = true));            
        }
       	insert lstAccount;
    }
    
    //To create Person Account records
    public void createPersonAccountRecords(Integer noOfPersonAccounts)
    {
        List<Account> lstAccount;       //To create a list of PersonAccount records
        Integer i;
        
        //Creating a list of Person Account records
        lstAccount = new List<Account>();
        //To avoid duplication of Entity Ids start the Entity Id from 3000 for Person Accounts
        noOfPersonAccounts = noOfPersonAccounts + 3000;
        for(i = 3000; i < noOfPersonAccounts; i++)
        {
            lstAccount.add(new Account(Name = 'Test Person Account '+ i, BOT_Person_ID__c = i, Account_Type__c = 'Person Account'));            
        }
        insert lstAccount;
    }

	//To create test data for BOT_AccountTriggerHandlerTest
    //To create Account records with affiliates
    public List<Account> createAccountsWithParentId(Integer noOfParentAccounts, Integer noOfChildAccounts, String Channel)
    {
        List<Account> lstAccount;   //To create a list of Account records
        Integer intTemp = 4000;		//To avoid duplication of Entity Ids start the Entity Id from 4000 for Child Accounts
        
        //Creating a list of Affiliate Account records
        lstAccount = new List<Account>();
        for(Integer i = 0; i < noOfParentAccounts; i++)
        {
            for(Integer j = 0; j < noOfChildAccounts; j++)
            {
                lstAccount.add(new Account(Name = 'Test Affiliate Account '+ intTemp, BOT_Entity_ID__c = intTemp, Account_Type__c = Channel, 
                                           BOT_Entity_Level__c = 'Regional', BOT_Parent_Entity_ID__c = i, BOT_Is_BOT_Data__c = true));   
                intTemp++;
            }
        }
        return lstAccount;
    }
    
    //To create Child Account records
    public List<Child_Account_vod__c> createChildAccountRecords(Integer noOfParentAccounts, Integer noOfAffiliateAccounts)
    {
        List<Child_Account_vod__c> lstChildAccount = new List<Child_Account_vod__c>();	//To create a list of Child Accounts
        
        //Creating a list of Person Account records
        noOfParentAccounts = noOfParentAccounts + 2000;
        for(Integer i = 2000; i < noOfParentAccounts; i++)
        {
            for(Integer j = 0; j < noOfAffiliateAccounts; j++)
            {
                lstChildAccount.add(new Child_Account_vod__c(BOT_Parent_Account_ID__c = i, BOT_Affiliate_Account_ID__c = j));   
            }
        }
        //insert lstChildAccount;
        return lstChildAccount;
    }
    
    //To create Child Person Account records
    public List<Child_Account_vod__c> createChildPersonAccountRecords(Integer noOfParentAccounts, Integer noOfPersonAccounts)
    {
        List<Child_Account_vod__c> lstChildAccount = new List<Child_Account_vod__c>();	//To create a list of Child Accounts
        
        //Creating a list of Person Account records
        noOfPersonAccounts = noOfPersonAccounts + 3000;
        for(Integer i = 0; i < noOfParentAccounts; i++)
        {
            for(Integer j = 3000; j < noOfPersonAccounts; j++)
            {
                lstChildAccount.add(new Child_Account_vod__c(BOT_Parent_Account_ID__c = i, BOT_Person_ID__c = j));   
            }
        }
        //insert lstChildAccount;
        return lstChildAccount;
    }
    
    //To create Benefit Design records
    public void createBenefitDesignRecords(Integer noOfAccounts, Integer noOfBenefitDesign, String Channel)
    {
        //system.debug('***Calling this method***');
        List<Benefit_Design_vod__c> lstBenefitDesign = new List<Benefit_Design_vod__c>();
        Benefit_Design_vod__c objBenefitDesign;
        Integer i, j, intTemp = 0;
        
        if(Channel == 'Employer')
        {
            for(i = 0; i < noOfAccounts; i++)
            {
                for(j = 0; j < noOfBenefitDesign; j++)
                {
                    objBenefitDesign = new Benefit_Design_vod__c();
                    objBenefitDesign.BOT_Entity_ID__c = i;
                    objBenefitDesign.BOT_Benefit_Design_ID__c = intTemp;
                    objBenefitDesign.BOT_Formulary_Name__c = 'BOT Test Formulary Name '+ intTemp;
                    objBenefitDesign.Type_vod__c = channel;
                    objBenefitDesign.BOT_Is_BOT_Data__c = true;
                    
                    if(j==1)
                    {
                         objBenefitDesign.Lives_vod__c=null;   
                    }
                    else
                    {
                        objBenefitDesign.Lives_vod__c=998+j;   
                    }
                   
                    lstBenefitDesign.add(objBenefitDesign);  
                    intTemp++;
                }
            }
        }
        else
        {
            for(i = 0; i < noOfAccounts; i++)
            {
                for(j = 0; j < noOfBenefitDesign; j++)
                {
                    objBenefitDesign = new Benefit_Design_vod__c();
                    objBenefitDesign.BOT_Entity_ID__c = i;
                    objBenefitDesign.BOT_Benefit_Design_ID__c = intTemp;
                    objBenefitDesign.BOT_Formulary_Name__c = 'BOT Test Formulary Name where name is morethan 80 Characters BOT Test Formulary Name 2';
                    objBenefitDesign.Type_vod__c = channel;
                    objBenefitDesign.BOT_Is_BOT_Data__c = true;
                    //objBenefitDesign.Lives_vod__c=999+j;
                    if(j==0)
                    {
                         objBenefitDesign.Lives_vod__c=null;   
                    }
                    else
                    {
                        objBenefitDesign.Lives_vod__c=998+j;   
                    }
                    lstBenefitDesign.add(objBenefitDesign);  
                    intTemp++;
                }
            }    
        }                
		insert lstBenefitDesign;
	}
    
    //To create Benefit Design record with out BOT Entity Id
    public List<Benefit_Design_vod__c> benefitDesignRecordsWithoutEntityID(Integer noOfAccounts, Integer noOfBenefitDesign)
    {
        List<Benefit_Design_vod__c> lstBenefitDesign;
        Benefit_Design_vod__c objBenefitDesign;
        Integer i, j, intTemp = 0;
        
        lstBenefitDesign = new List<Benefit_Design_vod__c>();
        for(i = 0; i < noOfAccounts; i++)
        {
            for(j = 0; j < noOfBenefitDesign; j++)
            {
                objBenefitDesign = new Benefit_Design_vod__c();
                //objBenefitDesign.BOT_Entity_ID__c = i;
                objBenefitDesign.BOT_Benefit_Design_ID__c = intTemp;
                objBenefitDesign.BOT_Formulary_Name__c = 'BOT Test Formulary Name '+ intTemp;
                //objBenefitDesign.Type_vod__c = channel;
                objBenefitDesign.BOT_Is_BOT_Data__c = true;
                lstBenefitDesign.add(objBenefitDesign);  
                intTemp++;
            }
        }                
        return lstBenefitDesign;
    }
    
    //To create formulary product records
    public void createFormularyProductRecords(Integer noOfFormularyProducts)
    {
        List<Formulary_Products_vod__c> lstFormularyProduct = new List<Formulary_Products_vod__c>();    //To create list of Formulary product records
        Formulary_Products_vod__c objFormularyProduct;          										//To create a formulary product record
        
        for(Integer i = 0; i < noOfFormularyProducts; i++)
        {
            objFormularyProduct = new Formulary_Products_vod__c();
            objFormularyProduct.Name = 'Test Drug '+i;
            objFormularyProduct.Market_vod__c = 'Test Market '+ i;
            objFormularyProduct.BOT_Formulary_Product_ID__c = i;
            objFormularyProduct.BOT_Is_BOT_Data__c = true;
            lstFormularyProduct.add(objFormularyProduct);
        }
		insert lstFormularyProduct;
    }

    //To create test data for BOT_AddressTriggerHandlerTest
    //To create Address records with Account Ids for business Accounts
    public List<Address_vod__c> createAddressRecords(Integer noOfAccounts, Integer noOfAddress)
    {
        List<Address_vod__c> lstAddress = new List<Address_vod__c>();   //To create a list of Address records
        Address_vod__c objAddress;          							//To create an address record
        
        //Creating a list of Address records
        for(Integer i = 0; i < noOfAccounts; i++)
        {
            for(Integer j = 0; j < noOfAddress; j++)
            {
                objAddress = new Address_vod__c();
                objAddress.Name = 'Test Address Line '+ i + j;
                objAddress.Address_line_2_vod__c = 'Test Address Line 2';
                objAddress.BOT_Entity_ID__c = i;
                objAddress.City_vod__c = 'Test city';
                objAddress.Phone_vod__c = '1234567890';
                lstAddress.add(objAddress);
            }
        }
        return lstAddress;
    }
    
    //To create Address records with Person Ids for person Accounts
    public List<Address_vod__c> createPersonAddressRecords(Integer noOfAccounts, Integer noOfAddress)
    {
        List<Address_vod__c> lstAddress = new List<Address_vod__c>();   //To create a list of Address records
        Address_vod__c objAddress;          							//To create an address record
        
        //Creating a list of Address records
        for(Integer i = 3000; i < 3000 + noOfAccounts; i++)
        {
            for(Integer j = 0; j < noOfAddress; j++)
            {
                objAddress = new Address_vod__c();
                objAddress.Name = 'Test Address Line '+ j;
                objAddress.Address_line_2_vod__c = 'Test Address Line 2';
                objAddress.BOT_Person_ID__c = i;
                objAddress.City_vod__c = 'Test city';
                objAddress.Phone_vod__c = '1234567890';
                lstAddress.add(objAddress);
            }
        }
        return lstAddress;
    }

    
    //To create Address records without Entity Id
    public List<Address_vod__c> createAddressRecordsWithoutEntityId(Integer noOfAccounts, Integer noOfAddress)
    {
        List<Address_vod__c> lstAddress;    //To create a list of Address records
        Address_vod__c objAddress;          //To create an address record
        
        //Creating a list of Address records
        lstAddress = new List<Address_vod__c>();
        for(Integer i = 0; i < noOfAccounts; i++)
        {
            for(Integer j = 0; j < noOfAddress; j++)
            {
                objAddress = new Address_vod__c();
                objAddress.Name = 'Test Address Line '+ i + j;
                objAddress.Address_line_2_vod__c = 'Test Address Line 2';
                //objAddress.BOT_Entity_ID__c = i;
                objAddress.City_vod__c = 'Test city';
                objAddress.Phone_vod__c = '1234567890';
                lstAddress.add(objAddress);
            }
        }
        return lstAddress;
    }
    
    //To create test data for BOT_PlanProductTriggerHandlerTest
    //To create plan product records with related account
    public void createPlanProductRecords(Integer noOfAccounts, Integer noOfPlanProducts, String Channel)
    {
        List<BOT_Plan_Product__c> lstPlanProduct;   //To create a list of Plan product records
        BOT_Plan_Product__c objPlanProduct;         //To create a Plan product record
        Integer i, j, intTemp;
        
        if(Channel == 'Employer')
        {
            lstPlanProduct = new List<BOT_Plan_Product__c>();
            intTemp = 0;
            for(i = 0; i < noOfAccounts; i++)
            {
                for(j = 0; j < noOfPlanProducts; j++)
                {
                    objPlanProduct = new BOT_Plan_Product__c();
                    objPlanProduct.BOT_Entity_ID__c = i;
                    objPlanProduct.BOT_Medical_Admin_ID__c = i;
                    objPlanProduct.BOT_Product_Name__c = 'BOT Test Product Name '+ intTemp;
                    objPlanProduct.BOT_Channel__c = Channel;
                    objPlanProduct.BOT_Product_ID__c = intTemp;
                    lstPlanProduct.add(objPlanProduct);
                    intTemp++;
                }
            }
            insert lstPlanProduct;
        }
        else
        {
            lstPlanProduct = new List<BOT_Plan_Product__c>();
            intTemp = 0;
            for(i = 0; i < noOfAccounts; i++)
            {
                for(j = 0; j < noOfPlanProducts; j++)
                {
                    objPlanProduct = new BOT_Plan_Product__c();
                    objPlanProduct.BOT_Entity_ID__c = i;
                    objPlanProduct.BOT_Product_Name__c = 'BOT Test Product Name Where product name is having more than 80 characters are here '+ intTemp;
                    objPlanProduct.BOT_Product_ID__c = intTemp;
                    lstPlanProduct.add(objPlanProduct);
                    intTemp++;
                }
            }
			insert lstPlanProduct;
        }        
    }
    
    //To create plan product records without Entity ID
    public List<BOT_Plan_Product__c> createPlanProductWithoutEntityID(Integer noOfAccounts, Integer noOfPlanProducts)
    {
        List<BOT_Plan_Product__c> lstPlanProduct = new List<BOT_Plan_Product__c>();   	//To create a list of Plan product records
        BOT_Plan_Product__c objPlanProduct;         									//To create a Plan product record
        Integer intTemp = 0;
        
        for(Integer i = 0; i < noOfAccounts; i++)
        {
            for(Integer j = 0; j < noOfPlanProducts; j++)
            {
                objPlanProduct = new BOT_Plan_Product__c();
                //objPlanProduct.BOT_Entity_ID__c = i;
                objPlanProduct.BOT_Medical_Admin_ID__c = i;
                objPlanProduct.BOT_Product_Name__c = 'BOT Test Product Name '+ intTemp;
                objPlanProduct.BOT_Product_ID__c = intTemp;
                lstPlanProduct.add(objPlanProduct);
                intTemp++;
            }
        }
        return lstPlanProduct;
    }    
    
    //To create test data for BOT_BenefitDesignLineTriggerHandlerTest
    //To create Benefit design Line records with related Benefit design Id and Formulary Product Id
    public List<Benefit_Design_Line_vod__c> createBenefitDesignLineRecords(Integer noOfBenefitDesigns, Integer noOfFormularyProducts)
    {
        List<Benefit_Design_Line_vod__c> lstBenefitDesignLine = new List<Benefit_Design_Line_vod__c>();	//To create list of Benefit design line records
        Benefit_Design_Line_vod__c objBenefitDesignLine;        										//To create a Benefit desig record
        
        //Creating a list of benefit design line records
        for(Integer i = 0; i < noOfBenefitDesigns; i++)
        {
            for(Integer j = 0; j < noOfFormularyProducts; j++)
            {
                objBenefitDesignLine = new Benefit_Design_Line_vod__c();
 				objBenefitDesignLine.BOT_Benefit_Design_ID__c = i;
                objBenefitDesignLine.BOT_Formulary_Product_ID__c = j;
                objBenefitDesignLine.Status_Source_vod__c = 'Test Status 1';
                objBenefitDesignLine.Restrictions_Source_vod__c = 'PA';
                objBenefitDesignLine.Notes_Source_vod__c = 'Test Notes';
                objBenefitDesignLine.Copay_Source_vod__c = '$10 - $20';
                objBenefitDesignLine.BOT_Is_BOT_Data__c = true;
                lstBenefitDesignLine.add(objBenefitDesignLine);
            }
        }
        return lstBenefitDesignLine;
    }
    
    //To create Benefit design Line records without BOT Formulary Product Id
    public List<Benefit_Design_Line_vod__c> benefitDesignLineWithoutFormularyProductId(Integer noOfBenefitDesigns, Integer noOfFormularyProducts)
    {
        List<Benefit_Design_Line_vod__c> lstBenefitDesignLine = new List<Benefit_Design_Line_vod__c>();	//To create list of Benefit design line records
        Benefit_Design_Line_vod__c objBenefitDesignLine;        										//To create a Benefit design record
        
        //Creating a list of benefit design line records
        for(Integer i = 0; i < noOfBenefitDesigns; i++)
        {
            for(Integer j = 0; j < noOfFormularyProducts; j++)
            {
                objBenefitDesignLine = new Benefit_Design_Line_vod__c();
                objBenefitDesignLine.BOT_Benefit_Design_ID__c = i;
                //objBenefitDesignLine.BOT_Formulary_Product_ID__c = i;
                objBenefitDesignLine.Status_Source_vod__c = 'Test Status 1';
                objBenefitDesignLine.Restrictions_Source_vod__c = 'PA';
                objBenefitDesignLine.Notes_Source_vod__c = 'Test Notes';
                objBenefitDesignLine.Copay_Source_vod__c = '$10 - $20';
                objBenefitDesignLine.BOT_Is_BOT_Data__c = true;
                lstBenefitDesignLine.add(objBenefitDesignLine);
            }
        }
        return lstBenefitDesignLine;
    }
    
    //To create Benefit design Line records without BOT Benefit design Id
    public List<Benefit_Design_Line_vod__c> benefitDesignLineWithoutBenefitDesignId(Integer noOfBenefitDesigns, Integer noOfFormularyProducts)
    {
        List<Benefit_Design_Line_vod__c> lstBenefitDesignLine = new List<Benefit_Design_Line_vod__c>();	//To create list of Benefit design line records
        Benefit_Design_Line_vod__c objBenefitDesignLine;        										//To create a Benefit desig record
        
        //Creating a list of benefit design line records
        for(Integer i = 0; i < noOfBenefitDesigns; i++)
        {
            for(Integer j = 0; j < noOfFormularyProducts; j++)
            {
                objBenefitDesignLine = new Benefit_Design_Line_vod__c();
                //objBenefitDesignLine.BOT_Benefit_Design_ID__c = i;
                objBenefitDesignLine.BOT_Formulary_Product_ID__c = i;
                objBenefitDesignLine.Status_Source_vod__c = 'Test Status 1';
                objBenefitDesignLine.Restrictions_Source_vod__c = 'PA';
                objBenefitDesignLine.Notes_Source_vod__c = 'Test Notes';
                objBenefitDesignLine.Copay_Source_vod__c = '$10 - $20';
                objBenefitDesignLine.BOT_Is_BOT_Data__c = true;
                lstBenefitDesignLine.add(objBenefitDesignLine);
            }
        }
        return lstBenefitDesignLine;
    }
    
    //To create test data for BOT_PharmacyServicesHandlerTest class
    //To create Pharmacy Service records with related account
    public void createPharmacyServices(Integer noOfAccounts, Integer noOfPharmacyServices, String pharmacyServiceName)
    {
        List<BOT_Pharmacy_Service__c> lstPharmacyService = new List<BOT_Pharmacy_Service__c>(); //To create list of pharmacy service records
        BOT_Pharmacy_Service__c objPharmacyService;                                             //To create a pharmacy service record
        
        //Creating a list of Pharmacy Services
        for(Integer i = 0; i < noOfAccounts; i++)
        {
            for(Integer j = 0; j < noOfPharmacyServices; j++)
            {
                objPharmacyService = new BOT_Pharmacy_Service__c();
                objPharmacyService.BOT_SubChannel__c = 'Commercial';
                objPharmacyService.BOT_Entity_ID__c = i;
                objPharmacyService.BOT_PBM_ID__c = i + 2000;
                objPharmacyService.Name = pharmacyServiceName;
                lstPharmacyService.add(objPharmacyService);
            }
        }
		insert lstPharmacyService;
    }
    
    //To create Pharmacy Service records without Entity Id
    public void createPharmacyServicesWithoutEntityID(Integer noOfAccounts, Integer noOfPharmacyServices, String pharmacyServiceName)
    {
        List<BOT_Pharmacy_Service__c> lstPharmacyService = new List<BOT_Pharmacy_Service__c>(); //To create list of pharmacy service records
        BOT_Pharmacy_Service__c objPharmacyService;                                             //To create a pharmacy service record
        
        //Creating a list of Pharmacy Services
        for(Integer i = 0; i < noOfAccounts; i++)
        {
            for(Integer j = 0; j < noOfPharmacyServices; j++)
            {
                objPharmacyService = new BOT_Pharmacy_Service__c();
                objPharmacyService.BOT_SubChannel__c = 'Commercial';
                //objPharmacyService.BOT_Entity_ID__c = i;
                objPharmacyService.BOT_PBM_ID__c = i + 2000;
                objPharmacyService.Name = pharmacyServiceName;
                lstPharmacyService.add(objPharmacyService);
            }
        }
		insert lstPharmacyService;
    }
    
    //To create test data for BOT_TheraClassTriggerHandlerTest
    //To create Thera class records with parent Specialty provider Id
    public List<BOT_Thera_Class__c> createTheraClassWithSpecialtyId(Integer noOfSpecialtyProviders, Integer noOfTheraClass)
    {
        List<BOT_Thera_Class__c> lstTheraClass = new List<BOT_Thera_Class__c>(); //To create a list of Thera class records
        
        //Creating a list of Thera class records
        for(Integer i = 1000; i < noOfSpecialtyProviders + 1000; i++)           //Specialty provider Entity Ids starts from 1000
        {
            for(Integer j = 0; j < noOfTheraClass; j++)
            {
                lstTheraClass.add(new BOT_Thera_Class__c(BOT_Thera_Name__c = 'Test Thera ' + i + j, BOT_Specialty_Provider_ID__c = i));
            }
        }
        return lstTheraClass;
    }
    
    //To create Thera class records without Specialty provider Id
    public List<BOT_Thera_Class__c> createTheraClassWithoutSpecialtyId(Integer noOfSpecialtyProviders, Integer noOfTheraClass)
    {
        List<BOT_Thera_Class__c> lstTheraClass = new List<BOT_Thera_Class__c>(); //To create a list of Thera class records
        
        //Creating a list of Thera class records
        for(Integer i = 1000; i < noOfSpecialtyProviders + 1000; i++)           //Specialty provider Entity Ids starts from 1000
        {
            for(Integer j = 0; j < noOfTheraClass; j++)
            {
                lstTheraClass.add(new BOT_Thera_Class__c(BOT_Thera_Name__c = 'Test Thera ' + i + j));
            }
        }
        return lstTheraClass;
    }
    
    //To create test data for BOT_SPPJoTriggerHandlerTest
    //To create a list of Specialty provider JO records
    public List<BOT_Specialty_Provider_JO__c> createSPPToAccountRecords(Integer noOfAccounts, Integer noOfSpecialtyproviders)
    {
        List<Account> lstAccount;                                   //To create a list of Specialty provider Account records
        List<BOT_Specialty_Provider_JO__c> lstSpecialtyProviderJO = new List<BOT_Specialty_Provider_JO__c>();  	//To create a list of Junction object records
        BOT_Specialty_Provider_JO__c objSpecialtyProviderJO;        											//To create a Junction object record
        
        //Creating a list of juntion object records
        lstSpecialtyProviderJO = new List<BOT_Specialty_Provider_JO__c>();
        for(Integer i = 0; i < noOfAccounts; i++)
        {
            for(Integer j = 0; j < noOfAccounts; j++)
            {
                objSpecialtyProviderJO = new BOT_Specialty_Provider_JO__c();
                objSpecialtyProviderJO.BOT_Entity_ID__c = i;
                objSpecialtyProviderJO.BOT_Specialty_Provider_ID__c = j + 1000;
                lstSpecialtyProviderJO.add(objSpecialtyProviderJO);
            }
        }
        return lstSpecialtyProviderJO;
    }
    
    //To create a list of Account to Specialty provider records without Entity ID
    public List<BOT_Specialty_Provider_JO__c> createSPPToAccountWithoutEntityID(Integer noOfAccounts, Integer noOfSpecialtyproviders)
    {
        List<Account> lstAccount;                                   //To create a list of Specialty provider Account records
        List<BOT_Specialty_Provider_JO__c> lstSpecialtyProviderJO;  //To create a list of Junction object records
        BOT_Specialty_Provider_JO__c objSpecialtyProviderJO;        //To create a Junction object record
        
        //Creating a list of juntion object records
        lstSpecialtyProviderJO = new List<BOT_Specialty_Provider_JO__c>();
        for(Integer i = 0; i < noOfAccounts; i++)
        {
            for(Integer j = 0; j < noOfAccounts; j++)
            {
                objSpecialtyProviderJO = new BOT_Specialty_Provider_JO__c();
                //objSpecialtyProviderJO.BOT_Entity_ID__c = i;
                objSpecialtyProviderJO.BOT_Specialty_Provider_ID__c = j + 1000;
                lstSpecialtyProviderJO.add(objSpecialtyProviderJO);
            }
        }
        return lstSpecialtyProviderJO;
    }
    
    //To create test data for BOT_DrugAccessTriggerHandlerTest
    //To create a list of Drug access records
    public List<BOT_Drug_Access__c> createDrugAccessRecords(Integer noOfAccounts, Integer noOfFormualryProducts)
    {
        List<BOT_Drug_Access__c> lstDrugAccess;                 //To create a list of drug access records
        BOT_Drug_Access__c objDrugAccess;                       //To create a drug Access record
        
        //Creating a list of Drug access records
        lstDrugAccess = new List<BOT_Drug_Access__c>();
        for(Integer i = 0; i < noOfAccounts; i++)
        {
            for(Integer j = 0; j < noOfFormualryProducts; j++)
            {
                objDrugAccess = new BOT_Drug_Access__c();
                objDrugAccess.BOT_Entity_ID__c = i;
                objDrugAccess.BOT_Formulary_Product_ID__c = j;
                objDrugAccess.BOT_Total_Plan_Rx_Lives__c = j + 10000;
                objDrugAccess.BOT_Formulary_Drug_Rx_Lives__c = j + 1000;
                objDrugAccess.BOT_Access_Percentage__c = j + 90;
                objDrugAccess.BOT_Drug_Status__c = 'PA';
                lstDrugAccess.add(objDrugAccess);    
            }
        }
        return lstDrugAccess;
    }
    
    //To create a list of Drug access records without Entity ID
    public List<BOT_Drug_Access__c> createDrugAccessWithoutEntityID(Integer noOfAccounts, Integer noOfFormualryProducts)
    {
        List<BOT_Drug_Access__c> lstDrugAccess = new List<BOT_Drug_Access__c>();	//To create a list of drug access records
        BOT_Drug_Access__c objDrugAccess;                       					//To create a drug Access record
        
        //Creating a list of Drug access records
        for(Integer i = 0; i < noOfAccounts; i++)
        {
            for(Integer j = 0; j < noOfFormualryProducts; j++)
            {
                objDrugAccess = new BOT_Drug_Access__c();
                //objDrugAccess.BOT_Entity_ID__c = i;
                objDrugAccess.BOT_Formulary_Product_ID__c = j;
                objDrugAccess.BOT_Total_Plan_Rx_Lives__c = j + 10000;
                objDrugAccess.BOT_Formulary_Drug_Rx_Lives__c = j + 1000;
                objDrugAccess.BOT_Access_Percentage__c = j + 90;
                objDrugAccess.BOT_Drug_Status__c = 'PA';
                lstDrugAccess.add(objDrugAccess);    
            }
        }
        return lstDrugAccess;
    }
    
    //To create a list of Drug access records without Formulary Product ID
    public List<BOT_Drug_Access__c> createDrugAccessWithoutFormualryProductID(Integer noOfAccounts, Integer noOfFormualryProducts)
    {
        List<BOT_Drug_Access__c> lstDrugAccess = new List<BOT_Drug_Access__c>();	//To create a list of drug access records
        BOT_Drug_Access__c objDrugAccess;           								//To create a drug Access record
        
        //Creating a list of Drug access records
        for(Integer i = 0; i < noOfAccounts; i++)
        {
            for(Integer j = 0; j < noOfFormualryProducts; j++)
            {
                objDrugAccess = new BOT_Drug_Access__c();
                objDrugAccess.BOT_Entity_ID__c = i;
                //objDrugAccess.BOT_Formulary_Product_ID__c = j;
                objDrugAccess.BOT_Total_Plan_Rx_Lives__c = j + 10000;
                objDrugAccess.BOT_Formulary_Drug_Rx_Lives__c = j + 1000;
                objDrugAccess.BOT_Access_Percentage__c = j + 90;
                objDrugAccess.BOT_Drug_Status__c = 'PA';
                lstDrugAccess.add(objDrugAccess);    
            }
        }
        return lstDrugAccess;
    }
    
    //To create test data for BOT_ProductFormularyTriggerHandlerTest
    //To create a list of Product Formulary records
    public List<BOT_Product_Formulary_JO__c> createProductFormularyRecords(Integer noOfPlanProductRecords, Integer noOfBenefitDesignRecords)
    {
        List<BOT_Product_Formulary_JO__c> lstProductFormulary = new List<BOT_Product_Formulary_JO__c>();	//To create a list of Product formulary records
        BOT_Product_Formulary_JO__c objProductFormulary;        											//To create a product formulary record
        
        //Creating a list of Product Formaulary records
        for(Integer i = 0; i < noOfPlanProductRecords; i++)
        {
            for(Integer j = 0; j < noOfBenefitDesignRecords; j++)
            {
                objProductFormulary = new BOT_Product_Formulary_JO__c();
                objProductFormulary.BOT_Plan_Product_ID__c = i;
                objProductFormulary.BOT_Benefit_Design_ID__c = j;
                //objProductFormulary.BOT_Total_Formulary_Lives__c = 1000;
                lstProductFormulary.add(objProductFormulary);
            }
        }
        return lstProductFormulary;
    }
    
    //To create a list of Product Formulary records without product ID
    public List<BOT_Product_Formulary_JO__c> createProductFormularyWithoutProductId(Integer noOfPlanProductRecords, Integer noOfBenefitDesignRecords)
    {
        List<BOT_Product_Formulary_JO__c> lstProductFormulary;  //To create a list of Product formulary records
        BOT_Product_Formulary_JO__c objProductFormulary;        //To create a product formulary record
        
        //Creating a list of Product Formaulary records
        lstProductFormulary = new List<BOT_Product_Formulary_JO__c>();
        for(Integer i = 0; i < noOfPlanProductRecords; i++)
        {
            for(Integer j = 0; j < noOfBenefitDesignRecords; j++)
            {
                objProductFormulary = new BOT_Product_Formulary_JO__c();
                //objProductFormulary.BOT_Plan_Product_ID__c = i;
                objProductFormulary.BOT_Benefit_Design_ID__c = j;
                //objProductFormulary.BOT_Total_Formulary_Lives__c = 1000;
                lstProductFormulary.add(objProductFormulary);
            }
        }
        return lstProductFormulary;
    }
    
    //To create a list of Product Formulary records without Benefit design ID
    public List<BOT_Product_Formulary_JO__c> createProductFormularyWithoutBenefitDesignId(Integer noOfPlanProductRecords, Integer noOfBenefitDesignRecords)
    {
        List<BOT_Product_Formulary_JO__c> lstProductFormulary;  //To create a list of Product formulary records
        BOT_Product_Formulary_JO__c objProductFormulary;        //To create a product formulary record
                
        //Creating a list of Product Formaulary records
        lstProductFormulary = new List<BOT_Product_Formulary_JO__c>();
        for(Integer i = 0; i < noOfPlanProductRecords; i++)
        {
            for(Integer j = 0; j < noOfBenefitDesignRecords; j++)
            {
                objProductFormulary = new BOT_Product_Formulary_JO__c();
                objProductFormulary.BOT_Plan_Product_ID__c = i;
                //objProductFormulary.BOT_Benefit_Design_ID__c = j;
                //objProductFormulary.BOT_Total_Formulary_Lives__c = 1000;
                lstProductFormulary.add(objProductFormulary);
            }
        }
        return lstProductFormulary;
    }
    
    //To create the list of Account plan records
    public List<Account_Plan_vod__c> createAccountPlanRecords(Id accountId, Integer noOfAccountPlanRecords)
    {
        List<Account_Plan_vod__c> lstAccountPlans = new List<Account_Plan_vod__c>();
        for(Integer i = 0; i < noOfAccountPlanRecords; i++)
        {
            lstAccountPlans.add(new Account_Plan_vod__c(Name = 'Test Account Plan '+ i, Account_vod__c = accountId, Type__c = 'National'));    
        }
        return lstAccountPlans;
    }
    
    //To create the list of Coverage Policy records
    public List<BOT_Coverage_Policy__c> createCoveragePolicyRecords(Integer noOfAccountRecords, Integer noOfFormularyProductRecords)
    {
        List<BOT_Coverage_Policy__c> lstCoveragePolicy = new List<BOT_Coverage_Policy__c>();
        BOT_Coverage_Policy__c objCoveragePolicy;
        
        for(Integer i = 0; i < noOfAccountRecords; i++)
        {
            for(Integer j = 0; j < noOfFormularyProductRecords; j++)
            {
                objCoveragePolicy = new BOT_Coverage_Policy__c();
                if(noOfFormularyProductRecords == 1)
                {
                	objCoveragePolicy.BOT_Policy_Name_Source__c = 'BOT Test Policy Name '+ i;
                }
                else
                {
                    objCoveragePolicy.BOT_Policy_Name_Source__c = 'BOT Test Policy Name Where product name is having more than 80 characters are here '+ i;
                }
                objCoveragePolicy.BOT_Entity_ID__c = i;
                objCoveragePolicy.BOT_Formulary_Product_ID__c = j;
                objCoveragePolicy.BOT_Channel__c = 'State Medicaid';
                objCoveragePolicy.BOT_SubChannel__c = 'State Medicaid';
                objCoveragePolicy.BOT_Score__c = 'Test Score ' + i;
                objCoveragePolicy.BOT_Indication__c = 'Test Indication ' + i;
                objCoveragePolicy.BOT_Sub_Indication__c = 'Test Sub Indication ' + i;
                objCoveragePolicy.BOT_STDetail__c = 'Test Step therapy detail ' + i;
                objCoveragePolicy.BOT_DRC__c = 'Test Diagnostic requirements for continued therapy ' + i;
                objCoveragePolicy.BOT_DRI__c = 'Test Diagnostic requirements for initial therapy ' + i;
                objCoveragePolicy.BOT_PADetail__c = 'Test Prior autharization detail ' + i;
				objCoveragePolicy.BOT_CP_Form_Available__c = true;
                objCoveragePolicy.BOT_PA_Form_Available__c = true;
                objCoveragePolicy.BOT_Drug_Policy_ID__c = i;
                objCoveragePolicy.BOT_Poly_Therapy_Details__c = 'Test Poly therapy details ' + i;
                lstCoveragePolicy.add(objCoveragePolicy);    
            }            
        }
        return lstCoveragePolicy;
    }
    
    //To create a list of Coverage policy records without Entity ID
    public List<BOT_Coverage_Policy__c> createCoveragePolicyWithoutEntityID(Integer noOfAccountRecords, Integer noOfFormularyProductRecords)
    {
        List<BOT_Coverage_Policy__c> lstCoveragePolicy = new List<BOT_Coverage_Policy__c>();
        BOT_Coverage_Policy__c objCoveragePolicy;
        
        for(Integer i = 0; i < noOfAccountRecords; i++)
        {
            for(Integer j = 0; j < noOfFormularyProductRecords; j++)
            {
                objCoveragePolicy = new BOT_Coverage_Policy__c();
                //objCoveragePolicy.BOT_Entity_ID__c = i;
                objCoveragePolicy.BOT_Formulary_Product_ID__c = j;
                objCoveragePolicy.BOT_Policy_Name_Source__c = 'Test Policy ' + i;
                objCoveragePolicy.BOT_Channel__c = 'Commercial';
                objCoveragePolicy.BOT_SubChannel__c = 'MCO';
                objCoveragePolicy.BOT_Score__c = 'Test Score ' + i;
                objCoveragePolicy.BOT_Indication__c = 'Test Indication ' + i;
                objCoveragePolicy.BOT_Sub_Indication__c = 'Test Sub Indication ' + i;
                objCoveragePolicy.BOT_STDetail__c = 'Test Step therapy detail ' + i;
                objCoveragePolicy.BOT_Drug_Policy_ID__c = i;
                lstCoveragePolicy.add(objCoveragePolicy);    
            }            
        }
        return lstCoveragePolicy;    
    }
    
    //To create a user with 'BOT Custom Profile'
    public user createTestUser()
    {
    	//To create user role
        UserRole testRole = new UserRole(DeveloperName = 'TestCustomRole', Name = 'Test Role');
		insert testRole;
        
        //To create the user with 'BOT Custom Profile'
        User testUser = new User(
     	ProfileId = [SELECT Id FROM Profile WHERE Name = 'BOT Custom Profile'].Id,
     	LastName = 'Test last Name',
     	Email = 'testuser01@test.com',
     	Username = 'testuser01@test.com' + System.currentTimeMillis(),
     	CompanyName = 'TEST Company',
     	Title = 'Test title',
     	Alias = 'alias',
     	TimeZoneSidKey = 'America/Los_Angeles',
     	EmailEncodingKey = 'UTF-8',
     	LanguageLocaleKey = 'en_US',
     	LocaleSidKey = 'en_US',
     	UserRoleId = testRole.Id
		);
        return testUser;
    }
}