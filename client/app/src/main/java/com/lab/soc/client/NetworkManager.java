package com.lab.soc.client;

import android.app.DownloadManager;
import android.content.Context;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.os.Environment;
import android.support.v4.app.Fragment;
import android.support.v4.os.AsyncTaskCompat;
import android.util.JsonReader;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONStringer;

import java.io.BufferedReader;
import java.io.EOFException;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import javax.net.ssl.HttpsURLConnection;


public class NetworkManager extends android.support.v4.app.Fragment {
    private Callback mCallback;
    private String serverURL = null;
    private String downloadURL = null;
    private String repo = null;
    private AsyncTask mAsync;

    public NetworkManager() {
        // Required empty public constructor
    }

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }


    @Override
    public void onAttach(Context context) {
        super.onAttach(context);
        if (context instanceof Callback) {
            mCallback = (Callback) context;
        } else {
            throw new RuntimeException(context.toString()
                    + " must implement NetworkManager.Callback interface");
        }
    }


    @Override
    public void onDetach() {
        super.onDetach();
        mCallback = null;
        mAsync = null;
    }


    public void configure(String url, String repo) {
        this.serverURL = url;
        this.repo = repo;
    }

    public void getUpdate() {
        mAsync = new AsyncTask() {
            String dump = null;
            JSONObject mJson = null;
            boolean connected = false;

            @Override
            protected Object doInBackground(Object[] objects) {
                try {
                    // set repository url
                    URL serverEndpoint = new URL(serverURL + repo);
                    // create connection
                    HttpURLConnection mConnection = (HttpURLConnection) serverEndpoint.openConnection();
                    // set who is connecting
                    mConnection.setRequestProperty("User-Agent", "Zedboard");

                    if (mConnection.getResponseCode() == 200) {
                        //everything went fine
                        connected = true;
                        InputStream mResponse = mConnection.getInputStream();
                        InputStreamReader mSR = new InputStreamReader(mResponse, "UTF-8");
                        BufferedReader reader = new BufferedReader(mSR, 8);

                        StringBuilder mStringBuilder = new StringBuilder();
                        String line = null;

                        while ((line = reader.readLine()) != null) {
                            mStringBuilder.append(line + "\n");
                        }

                        dump = mStringBuilder.toString();
//
                    } else {
                        mCallback.printToTextBox("Connection failed.\r\n");
                        debug("Connection failed.\r\n");
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                }

                try {
                    if (dump != null) {
                        mJson = new JSONObject(dump);
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }

                return null;
            }

            @Override
            protected void onPostExecute(Object o) {
                super.onPostExecute(o);
                if (dump != null) {
                    //mCallback.printToTextBox(dump);
                    mCallback.onDataAvailable(mJson);
                }

            }
        };
        mAsync.execute();
    }

    public void download(final Repository repo, String filepath) {
        mAsync = new AsyncTask() {
            @Override
            protected Object doInBackground(Object[] objects) {
                try {
                    // set download URL
                    URL serverEndpoint = new URL(serverURL + "download/" + repo.getFile());
                    // create connection
                    HttpURLConnection mConnection = (HttpURLConnection) serverEndpoint.openConnection();
                    // set who is connecting
                    mConnection.setRequestProperty("User-Agent", "Zedboard");


                    mConnection.connect();
                    // point to root directory on sd card

                    // create the bitstream file
                    File bitStream = new File(getContext().getFilesDir(), repo.getFile());
                    // create output stream to save data
                    FileOutputStream out = new FileOutputStream(bitStream);
                    // input stream to read data from the server
                    InputStream in = mConnection.getInputStream();

                    int fileSize = 0;

                    byte[] buffer = new byte[1024];
                    int bufferLength = 0;

                    // read and save
                    while ((bufferLength = in.read(buffer)) > 0) {
                        out.write(buffer, 0, bufferLength);
                        fileSize += bufferLength;
                    }
                    out.flush();
                    out.close();

                    return null;
                    // handle exceptions
                } catch (MalformedURLException e) {
                    e.printStackTrace();
                } catch (IOException e) {
                    e.printStackTrace();
                }
                return null;
            }

            @Override
            protected void onPostExecute(Object o) {
                super.onPostExecute(o);
                mCallback.onDownloadComplete(repo);

            }
        };
        mAsync.execute();
    }


    public void disconect() {

    }

    public void startDownload() {

    }


    public interface Callback {
        void printToTextBox(String text);

        void onDataAvailable(JSONObject json);

        void onDownloadComplete(Repository repo);
    }


    public void debug(Object o) {
        System.out.println(o.toString());
    }
}
