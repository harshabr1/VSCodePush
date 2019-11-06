/*
Name 		 : BOT_CoveragePolicyCalloutMock
Created Date : 05-MAR-2019
Created By   : Sreenivasulu Adipudi
Overview 	 : It is written by BusinessOne Technologies Inc. It is a Callout Mock class for BOT_CoveragePolicyViewExtnTest class.
               It is used to generate test response.
*/
@isTest
global class BOT_CoveragePolicyCalloutMock implements HttpCalloutMock 
{
	global HttpResponse respond(HttpRequest request)
    {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setHeader('Content-Encoding','gzip');
        response.setHeader('document-api-key','2c424b79e3ed255105ffe57ffb4e2c8c2c424b79e3ed25');
        //response.setBody('[{\"FILENAME\":\"Humira.pdf\",\"FILEURL\":\"http:\\/\\/b1maestro.com\\/Documents\\/\\/18d9bd6e-20e3-4971-afa4-8dc8368eca10.pdf\"}]');
        //response.setBody('[{\"FILENAME\":\"Cimzia_20190621_0945244524.pdf\",\"FILEURL\":\"https://pacpdocumentstorage.blob.core.windows.net/testcontainer/Cimzia_20190621_0945244524.pdf\"}]');
        String strjsonResponseBody = '{'+
		'   \"timeStamp\": \"2019-06-20_11-14-36\",'+
		'   \"fileURL\": \"https://pacpdocumentstorage.blob.core.windows.net/testcontainer/Enbrel_20190620_1114331433.pdf\",'+
		'   \"fileName\": \"Enbrel_20190620_1114331433.pdf\"'+
		'}';
        response.setBody(strjsonResponseBody);
        response.setStatusCode(200);
        return response;
    }
}