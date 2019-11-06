/*
Name			: BOT_MassDeleteQueueable 
Created By		: Sreenivasulu A
Created Date	: 17-JUN-2019
Overview		: This class is written by BusinessOne Technologies Inc. It performs delete operation on Benefit Design, Benefit Desing Line, 
				  Plan-product Formulary and Plan Product object. Plan-product Formulary is a junction object between Benefit Design and Plan Product.
				  While deleting Benefit Design or Plan product records, their might be a chance to get and error like 'Unable to lock the record'. 
				  This Queueable class will delete these object records in a queue order.
*/
public class BOT_MassDeleteQueueable implements Queueable {
    Integer intBenefitDesignCount;
    Integer intPlanProductCount;
    public BOT_MassDeleteQueueable(Integer benefitDesignCount, Integer planProductCount){
    	intBenefitDesignCount = benefitDesignCount;
        intPlanProductCount = planProductCount;
    }
    public void execute(QueueableContext qc){
        if(intBenefitDesignCount != 0){
            System.debug('Benefit Design Queueable');
        	BOT_MassDeleteBatch clsMassDeleteBatch = new BOT_MassDeleteBatch('SELECT ID FROM Benefit_Design_vod__c WHERE BOT_Is_BOT_Data__c = true LIMIT 1000', true, intBenefitDesignCount, 'Benefit Design');
        	System.enqueueJob(clsMassDeleteBatch);      
        }
        
        if(intPlanProductCount != 0){
            System.debug('Plan Product Queueable');
        	BOT_MassDeleteBatch clsMassDeleteBatch = new BOT_MassDeleteBatch('SELECT ID FROM BOT_Plan_Product__c LIMIT 1000', true, intPlanProductCount, 'Plan Product');
        	System.enqueueJob(clsMassDeleteBatch);      
        }        
    }
}