global class BOT_customIterable implements Iterator<SObject> {
    List<SObject> lstSObject {get;set;}
    Integer i {get;set;}
    
    public BOT_customIterable() {
        lstSObject = new List<SObject>();
        
        List<Account> lstAccount = [SELECT Id FROM Account];
        for(Account objAccount : lstAccount) {
            lstSObject.add(objAccount);
        }
        i = 0;
    }
    global boolean hasNext(){ 
       if(i >= lstSObject.size()) 
           return false; 
       else 
           return true; 
   }    
   global SObject next(){ 
       if(i == 8){ i++; return null;} 
       i=i+1; 
       return lstSObject[i-1]; 
   } 
}