/*
Name 		 : BOT_CPFormResponse
Created Date : 15-Feb-2019
Created By   : Harsha BR
Overview 	 : It is written by BusinessOne Technologies Inc. It is response class to store the Coverage Policy Form PDF.
*/
public class BOT_CPFormResponse {

	public String timeStamp;
	public String fileURL;
	public String fileName;

	public static BOT_CPFormResponse parse(String json) {
		return (BOT_CPFormResponse) System.JSON.deserialize(json, BOT_CPFormResponse.class);
	}  
}