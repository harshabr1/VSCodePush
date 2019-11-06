public class VEEVA_WEC_WEB_SERVICE_UTIL {

    public static String get(String url, Map<String,String> headers)
    {
        System.debug('request url: '+url);
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        if(headers!=null&& !headers.isEmpty())
        {
            for(String key:headers.keySet())
            {
                req.setHeader(key, headers.get(key));
            }
        }        
        // Send the request, and return a response
        HttpResponse res = new Http().send(req);
        return res.getBody();
    }
}