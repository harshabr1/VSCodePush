public class VEEVA_WEC_WEB_SERVICE_ASYNC_UTIL {

    
    @future(callout=true)
    public static void get(String url, Map<String,String> headers)
    {
        VEEVA_WEC_WEB_SERVICE_UTIL.get(url, headers);
    }
}