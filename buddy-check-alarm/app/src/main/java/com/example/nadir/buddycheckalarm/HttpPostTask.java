package com.example.nadir.buddycheckalarm;

import android.os.AsyncTask;


import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;

/**
 * Created by Nadir on 5/9/2016.
 */
class HttpPostTask extends AsyncTask<Void,Void,String>
{

    HttpPostTask(String requestURL,
                 HashMap<String, String> requestProperties,
                 JSONObject postDataParams) {
        this.requestURL = requestURL;
        this.requestProperties = requestProperties;
        this.postDataParams = postDataParams;

    }
    private String requestURL;
    private HashMap<String, String> requestProperties;
    private JSONObject postDataParams;

    protected void onPreExecute() {
        //display progress dialog.

    }
    protected String doInBackground(Void... params) {
        URL url;
        String response = "";
        try {
            url = new URL(requestURL);

            HttpURLConnection conn = (HttpURLConnection) url.openConnection();
            conn.setReadTimeout(15000);
            conn.setConnectTimeout(15000);
            for (HashMap.Entry<String, String> entry : requestProperties.entrySet()) {
                conn.setRequestProperty(entry.getKey(), entry.getValue());
            }
            conn.setRequestMethod("POST");
            conn.setDoInput(true);
            conn.setDoOutput(true);
            OutputStream os = conn.getOutputStream();
            BufferedWriter writer = new BufferedWriter(
                    new OutputStreamWriter(os, "UTF-8"));
            writer.write(postDataParams.toString());
            writer.flush();
            writer.close();
            os.close();
            int responseCode=conn.getResponseCode();
            System.out.println("response code: "+responseCode);
            String line;
            BufferedReader br=new BufferedReader(new InputStreamReader(conn.getInputStream()));
            while ((line=br.readLine()) != null) {
                response+=line;
            }
                /*
                if (responseCode == HttpURLConnection.HTTP_OK) {
                    String line;
                    BufferedReader br=new BufferedReader(new InputStreamReader(conn.getInputStream()));
                    while ((line=br.readLine()) != null) {
                        response+=line;
                    }
                }
                else {
                    response="http connection failed with response code: " + responseCode;
                }
                */
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println(e.getMessage());
        }

        return response;
    }



    protected void onPostExecute(String result) {
        System.out.println(result);
    }
}
