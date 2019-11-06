public class BOT_TestREST {
    
    Public BOT_TestREST()
    {
        Http h=new Http();
    HttpRequest req=new HttpRequest();
    req.setEndpoint('https://ws2-was-dev-001.azurewebsites.net/api/Document/GetDocumentURL?UserEmail=bot.superuser@businessonetech.com&DrugID=2894&ChannelIDs=1,2,5&VersionNumber=1.0&AppName=VeevaCRM');
    req.setMethod('GET');
    req.setHeader('Content-Type','application/json');
    req.setHeader('Content-Encoding','gzip'); 
    req.setHeader('document-api-key','2c424b79e3ed255105ffe57ffb4e2c8c2c424b79e3ed25'); 
    HttpResponse res = h.send(req);
    system.debug('*** Response Body***'+res.getBody());  
    }

}