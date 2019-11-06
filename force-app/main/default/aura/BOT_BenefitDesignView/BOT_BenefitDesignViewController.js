({
	doInit : function(component, event, helper) {
        helper.getBenefitDesignLine(component);
	},

    marketFilter : function(component, event, helper) {
        var lstBenefitDesignbackup = component.get("v.lstBenefitDesignbackup");
        var recordCount = lstBenefitDesignbackup.length;
        var selectedMarket = component.find("markets").get("v.value");
        var lstBenefitDesignFiltered = [];
        
        if(selectedMarket == 'All' || selectedMarket == null)
        {
        	component.set("v.lstBenefitDesignLine",lstBenefitDesignbackup);    
        }
        else if(selectedMarket == 'All Company Products')
        {
        	for(var i = 0; i < recordCount; i++)
        	{
            	if(lstBenefitDesignbackup[i].Product_vod__r.Competitor_vod__c == false)
            	{
     				lstBenefitDesignFiltered.push(lstBenefitDesignbackup[i]);
            	}
        	}
        	component.set("v.lstBenefitDesignLine",lstBenefitDesignFiltered);    
        }
        else
        {
        	for(var i = 0; i < recordCount; i++)
        	{
            	if(lstBenefitDesignbackup[i].BOT_Market__c == selectedMarket)
            	{
     				lstBenefitDesignFiltered.push(lstBenefitDesignbackup[i]);
            	}
        	}
        	component.set("v.lstBenefitDesignLine",lstBenefitDesignFiltered);    
        }
    }
})