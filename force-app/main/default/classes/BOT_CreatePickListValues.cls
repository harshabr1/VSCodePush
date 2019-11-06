/*
Name			: BOT_CreatePickListValues
Created date	: 12/20/2018
Created by		: Sreenivasulu Adipudi
Description		: This class is written by BusinessOne Technologies Inc. It is used to create pick list values.
*/
public with sharing class BOT_CreatePickListValues 
{
	public static List<selectOption> getDynamicList(Set<String> setMarkets)
    {
        Integer marketsCount = setMarkets.size();
        List<selectOption> options = new List<selectOption>();
        if(marketsCount > 0 && setMarkets != null)
        {
            if(marketsCount > 1)
        	{
        		options.add(new selectOption('ALL','ALL'));
        	}
            for(String c : setMarkets)
        	{
        		options.add(new selectOption(c,c));
        	}            
        }
        return options;
    }
}