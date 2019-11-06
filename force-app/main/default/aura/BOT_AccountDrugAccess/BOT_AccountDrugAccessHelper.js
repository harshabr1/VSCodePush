({
	getMarkets : function(component) {
    	var accountId = component.get("v.recordId");
    	var action = component.get("c.getMarkets");
    	if(accountId != null)
    	{
    		action.setParams({accountId:accountId});            
    	}
        action.setCallback(this,function(a){
    		var result = a.getReturnValue();
        	component.set("v.strMarkets",result.lstMarkets);
    	})
    	$A.enqueueAction(action);
	}
})