({
	getBenefitDesignLine : function(component) {
        
    	var benefitDesignId = component.get("v.recordId");
        var action = component.get("c.getBenefitDesignLine");
        if(benefitDesignId != null)
        {
            action.setParams({benefitDesignId:benefitDesignId});            
        }
        action.setCallback(this,function(a){
        	var result = a.getReturnValue();
            component.set("v.strMarkets",result.lstMarket);
            component.set("v.lstBenefitDesignLine",result.lstBenefitDesignLineFiltered);
            component.set("v.lstBenefitDesignbackup",result.lstBenefitDesignLine);
 			window.setTimeout(
                $A.getCallback( function() {
                    // Now set our preferred value
                    component.find('markets').set("v.value",result.strDefaultMarket);
                }));
           
        })
        $A.enqueueAction(action);
	}
})