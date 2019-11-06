/*
Name 		 : BOT_CPFormPDFExtn
Created Date : 15-Feb-2019
Created By   : Harsha BR
Overview 	 : It is written by BusinessOne Technologies Inc. It is used to get the coverage policy form from the External system.
*/
Public class BOT_CPFormPDFExtn {
    
    Public BOT_CPFormPDFExtn(ApexPages.StandardController controller)
    {
        
    }
    
    Public PageReference retrieveCPformPDF()
    {
        Http h=new Http();
		HttpRequest req=new HttpRequest();
		req.setEndpoint('http://b1maestro.com/salesforceservices/salesforceservice.svc/getFileurljson');
		req.setMethod('GET');
		HttpResponse res = h.send(req);
		system.debug('*** Response Body***'+res.getBody());
        List<BOT_CPFormResponse> lstCPFormResponse = BOT_CPFormResponse.parse(res.getBody());
        system.debug('***lstCPFormResponse***'+lstCPFormResponse[0]);
        PageReference pgref = new PageReference(lstCPFormResponse[0].FILEURL);
		return pgref;
       // return null;
    }

}