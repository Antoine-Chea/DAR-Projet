package com.navitia.util;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import com.google.appengine.labs.repackaged.org.json.JSONException;
import com.google.appengine.labs.repackaged.org.json.JSONObject;

public class GetURL {
	
	private JSONObject json;
	private String res;
	
	public GetURL(String url) {
		res = getURLContent(url);
		try {
			json = new JSONObject(getURLContent(url));
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

	private String getURLContent(String httpsURL){
		try {
			URL url = new URL(httpsURL);
			HttpURLConnection con = (HttpURLConnection) url.openConnection();
			//con.setConnectTimeout(30000);  //30 Seconds
			//con.setReadTimeout(30000);
			con.addRequestProperty("Authorization", "c126d319-2656-449b-bf60-ab8c76927c48");
			
			return getcontent(con);
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return "";
	}
		 
	private String getcontent(HttpURLConnection con){
		if(con!=null) {
			try {		
				BufferedReader br = new BufferedReader(new InputStreamReader(con.getInputStream()));
				
				String input;
				String content = "";
				while ((input = br.readLine()) != null) {
					content += input;
				}
				br.close();
				return content;
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return null;
	}

	public JSONObject getJson() {
		return json;
	}
	
	public String getRes() {
		return res;
	}
}
