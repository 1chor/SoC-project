package com.lab.soc.client;

import android.Manifest;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.support.v4.app.FragmentManager;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.method.ScrollingMovementMethod;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONObject;

import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.HashMap;


public class MainActivity extends AppCompatActivity implements NetworkManager.Callback, MsgProcessor.Callback, FabricManager.Callback, Util.Callback, View.OnClickListener {
    private FragmentManager mFragManager;
    private NetworkManager mNetworkFragment;
    private MsgProcessor mMsgProcessor;
    private FabricManager mFabricManager;
    private Util mUtil;
    private TextView mConsole;
    private TextView mServerIP;
    private Button mButtonConnect;
    private Button mButtonFilter;

    private ImageView mImageView;
    private Bitmap mBitmap;
    private SharedPreferences mSharedPref;
    private boolean download;

    private String bitmapFilename;
    private String filterDriver;
    private String reconfigDriver;
    private String blake2bDriver;
    private String filesDir;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        //checkPermissions();

        //if (ContextCompat.checkSelfPermission(this, Manifest.permission.INTERNET) == PackageManager.PERMISSION_GRANTED) {

        //}



        mSharedPref = this.getPreferences(Context.MODE_PRIVATE);

        mConsole = (TextView) findViewById(R.id.textView);
        mConsole.setMovementMethod(new ScrollingMovementMethod());
        mServerIP = (TextView) findViewById(R.id.serverIP);
        mButtonConnect = (Button) findViewById(R.id.button);
        mButtonFilter = (Button) findViewById(R.id.button2);
        mImageView = (ImageView) findViewById(R.id.imageView);
        mBitmap = ((BitmapDrawable) mImageView.getDrawable()).getBitmap();

        mNetworkFragment = new NetworkManager();
        mMsgProcessor = new MsgProcessor(this);
        mFabricManager = new FabricManager(this);
        mUtil = new Util(this);
        mFragManager = getSupportFragmentManager();
        mFragManager.beginTransaction().add(mNetworkFragment, "NetworkManager").commit();

        //mNetworkFragment.configure("http://192.168.2.3:5000/api/", "SOC-LAB-IOT");

        mButtonConnect.setOnClickListener(this);
        mButtonFilter.setOnClickListener(this);

        download = false;
        //filterDriver = this.getFilesDir() + "//simple_filter.txt";
        //reconfigDriver = this.getFilesDir() + "//reconfig_driver.txt";
        //blake2bDriver = this.getFilesDir() + "//blake2b_driver.txt";
        //filesDir = this.getFilesDir() + "/";
        //bitmapFilename = "bitmapARGB.bin";

        filterDriver = "/proc/simple_filters";
        reconfigDriver = this.getFilesDir() + "//reconfig_driver.txt";
        blake2bDriver = "/proc/blake2b";
        filesDir = "/";
        bitmapFilename = "/data/bitmapARGB.bin";

    }


    @Override
    protected void onResume() {
        super.onResume();
    }


    @Override
    protected void onStop() {
        super.onStop();
    }


    @Override
    protected void onDestroy() {
        super.onDestroy();
        mNetworkFragment.onDetach();
        mNetworkFragment = null;
        mMsgProcessor = null;
        mFragManager = null;
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.button:
                mNetworkFragment.configure("http://" + mServerIP.getText() + ":5000/api/", "SOC-LAB-IOT");
                if (!download) {
                    mNetworkFragment.getUpdate();
                }
                break;
            case R.id.button2:
                checkPermissions();
                mConsole.append("\r\nProcess bitmap...\r\n");
                mUtil.processBitmap(mBitmap, filesDir + bitmapFilename);
                mFabricManager.applyFilter(filesDir + bitmapFilename, filterDriver);
                break;
            default:
                break;
        }
    }

    /**
     * save information to persistence storage
     *
     * @param repository
     */
    private void saveConfig(Repository repository) {
        SharedPreferences.Editor editor = mSharedPref.edit();
        editor.putString(Constants.JSON.INDEX, repository.getIndex());
        editor.putString(Constants.JSON.VERSION, repository.getVersion());
        editor.putString(Constants.JSON.DATE, repository.getDate());
        editor.putString(Constants.JSON.CHECKSUM, repository.getChecksum());
        editor.commit();
    }

    /**
     * load information from persistence storage
     *
     * @return
     */
    private HashMap<String, String> getConfig() {
        HashMap<String, String> dict = new HashMap<String, String>();
        dict.put(Constants.JSON.INDEX, mSharedPref.getString(Constants.JSON.INDEX, null));
        dict.put(Constants.JSON.VERSION, mSharedPref.getString(Constants.JSON.VERSION, null));
        dict.put(Constants.JSON.DATE, mSharedPref.getString(Constants.JSON.DATE, null));
        dict.put(Constants.JSON.CHECKSUM, mSharedPref.getString(Constants.JSON.CHECKSUM, null));

        return dict;
    }

    /**
     * print message to user interface
     *
     * @param text
     */
    private void printDebug(String text) {
        mConsole.append(text);
    }


    //NETWORK MANAGER CALLBACKS:
    @Override
    public void onDataAvailable(JSONObject json) {
        mMsgProcessor.process(json);
    }


    @Override
    public void printToTextBox(String text) {
        printDebug(text);
    }


    @Override
    public void onDownloadComplete(Repository repo) {
        download = false;
        Toast.makeText(this.getApplicationContext(), "Download complete", Toast.LENGTH_LONG).show();
        mConsole.append("\r\nDownload Complete\r\n");
        mMsgProcessor.verifyBitstream(repo);
    }


    //MESSAGE PROCESSOR CALLBACKS:
    @Override
    public void onUpdateAvailable(Repository repo) {
        //init download
        download = true;
        mConsole.append("\r\n" + repo.toString());

        saveConfig(repo);   // disable for debugging
        mNetworkFragment.download(repo, repo.getFile());
    }

    @Override
    public String calculateHash(String path) {
        return mFabricManager.calculateHashFromFile(filesDir + path, blake2bDriver);
    }


    @Override
    public void onVerifiedBitstream(Repository repo, boolean valid) {
        if (valid) {
            mConsole.append("Bitstream verified\r\n");
            mConsole.append("Reconfigure fabric\r\n");
            mFabricManager.reconfigureFabric(filesDir + repo.getFile(), reconfigDriver);
        } else {
            mConsole.append("Bitstream invalid\r\n");

        }
    }


    @Override
    public void updateDB() {

    }


    @Override
    public HashMap<String, String> getCurrentConfig() {
        return getConfig();
    }


    /// FABRIC MANAGER CALLBACKS:
    @Override
    public void onFilterApplied(String filepath) {
        mUtil.loadBitmap(mBitmap, filepath);
    }


    // UTILITY CALLBACKS:
    @Override
    public void onBitmapProcessed() {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mConsole.append("Bitmap processed\r\n");
                mConsole.append("Bitmap saved\r\n");
            }
        });
    }


    @Override
    public void onBitmapLoaded() {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                mConsole.append("Bitmap loaded\n");
            }
        });
    }


    public boolean checkPermissions() {
        try {
            PackageInfo info = getPackageManager().getPackageInfo(this.getPackageName(), PackageManager.GET_PERMISSIONS);
            if (info.requestedPermissions != null) {
                for (String p : info.requestedPermissions) {
                    mConsole.append("\r\n" + p + "\r\n");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {
        switch (requestCode) {
            case 1:
                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    //permission was granted
                } else {

                }
        }
    }
}
