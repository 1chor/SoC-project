package com.lab.soc.client;

import android.Manifest;
import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.provider.Settings;
import android.support.annotation.RequiresApi;
import android.support.v4.app.ActivityCompat;
import android.support.v4.app.FragmentManager;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.method.ScrollingMovementMethod;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import org.json.JSONObject;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.HashMap;
import java.util.function.ToDoubleBiFunction;


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

    private String path = Environment.getExternalStorageDirectory() + "/SoC";
    private String bitmapFilename;
    private String fbitmapFilename;
    private String filterDriver;
    private String reconfigDriver;
    private String blake2bDriver;
    private String blake2bHash;

    private static final int INTERNET_REQUEST = 1;
    private static final int WRITE_EXTERNAL_REQUEST = 2;
    private static final int NETWORK_REQUEST = 3;
    private static final int READ_EXTERNAL_REQUEST = 4;

    private boolean storagePermissionGranted;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

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

        mButtonConnect.setOnClickListener(this);
        mButtonFilter.setOnClickListener(this);

        download = false;

        //Set filenames
        bitmapFilename = "bitmapARGB.bin";
        fbitmapFilename = "fBitmap.bin";
        filterDriver = "filter.txt";
        blake2bDriver = "blake2b.txt";
        blake2bHash = "hash.txt";
        reconfigDriver = "partial.txt";

        //Check for android permissions
        checkPermissions();
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
        //Check for android permissions
        checkPermissions();

        if (storagePermissionGranted){

            switch (v.getId()) {
                //Connect button
                case R.id.button:
                    if (mServerIP.getText().toString().isEmpty())
                        mNetworkFragment.configure("http://192.168.2.3:5000/api/", "SOC-LAB-IOT");
                    else
                        mNetworkFragment.configure("http://" + mServerIP.getText() + ":5000/api/", "SOC-LAB-IOT");

                    if (!download) {
                        mNetworkFragment.getUpdate();
                    }
                    break;

                //Use filter button
                case R.id.button2:
                    mConsole.append("\r\nProcess bitmap...\r\n");
                    mUtil.processBitmap(mBitmap, path + "/" + bitmapFilename);
                    mFabricManager.applyFilter(path + "/" + bitmapFilename, path + "/" + filterDriver);
                    break;

                default:
                    break;
            }
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
        mNetworkFragment.download(repo, path);
    }

    @Override
        public byte[] calculateHash(String file) {
        return mFabricManager.calculateHashFromFile(path + "/" + file, path + "/" + blake2bDriver, path + "/" + blake2bHash);
    }


    @Override
    public void onVerifiedBitstream(Repository repo, boolean valid) {
        if (valid) {
            mConsole.append("Bitstream verified\r\n");
            mConsole.append("Reconfigure fabric\r\n");
            mFabricManager.reconfigureFabric(path + "/" + repo.getFile(), path + "/" + reconfigDriver);
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
    public void onFilterApplied() {
        mUtil.loadBitmap(mBitmap, path + "/" + fbitmapFilename);
    }


    // UTILITY CALLBACKS:
    @Override
    public void onBitmapProcessed(final Bitmap mBitmap) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Drawable drawable = new BitmapDrawable(getResources(), mBitmap);
                mImageView.setImageDrawable(drawable);
                mConsole.append("Bitmap processed\r\n");
                mConsole.append("Bitmap saved\r\n");
            }
        });
    }


    @Override
    public void onBitmapLoaded(final Bitmap fBitmap) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Drawable drawable = new BitmapDrawable(getResources(), fBitmap);
                mImageView.setImageDrawable(drawable);
                mConsole.append("Bitmap loaded\n");
            }
        });
    }


    public void checkPermissions() {
        // check for WRITE_EXTERNAL_STORAGE permission
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.WRITE_EXTERNAL_STORAGE) != PackageManager.PERMISSION_GRANTED) {
            // permission not granted

            if (ActivityCompat.shouldShowRequestPermissionRationale(this, Manifest.permission.WRITE_EXTERNAL_STORAGE)) {
                //Can ask user for permission
                ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, WRITE_EXTERNAL_REQUEST);
            } else {
                boolean userAskedPermissionBefore = mSharedPref.getBoolean(Constants.USER_ASKED_STORAGE_PERMISSION_BEFORE, false);

                if (userAskedPermissionBefore) {
                    //If user was asked permission before and denied
                    AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(this);

                    alertDialogBuilder.setTitle("Permission needed");
                    alertDialogBuilder.setMessage("Storage permission needed for app execution");
                    alertDialogBuilder.setPositiveButton("Open Setting", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialogInterface, int i) {
                            Intent intent = new Intent();
                            intent.setAction(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
                            Uri uri = Uri.fromParts("package", MainActivity.this.getPackageName(), null);
                            intent.setData(uri);
                            MainActivity.this.startActivity(intent);
                        }
                    });
                    alertDialogBuilder.setNegativeButton("Cancel", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialogInterface, int i) {
                            Log.d("MainActivity", "onClick: Cancelling");
                        }
                    });

                    AlertDialog dialog = alertDialogBuilder.create();
                    dialog.show();
                } else {
                    //If user is asked permission for first time
                    ActivityCompat.requestPermissions(this, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, WRITE_EXTERNAL_REQUEST);

                    SharedPreferences.Editor editor = mSharedPref.edit();
                    editor.putBoolean(Constants.USER_ASKED_STORAGE_PERMISSION_BEFORE, true);
                    editor.apply();
                }
            }
        } else {
            storagePermissionGranted = true;
        }
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, String permissions[], int[] grantResults) {

        super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        storagePermissionGranted = false;

        switch (requestCode) {
            case INTERNET_REQUEST:
                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    //permission was granted
                } else {
                    Toast.makeText(getApplicationContext(), "The INTERNET permission is needed!\n Please allow it", Toast.LENGTH_LONG).show();
                }

            case WRITE_EXTERNAL_REQUEST:
                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    //permission was granted
                    storagePermissionGranted = true;
                } else {
                    Toast.makeText(getApplicationContext(), "The WRITE_EXTERNAL_STORAGE permission is needed!\n Please allow it", Toast.LENGTH_LONG).show();
                }

            case NETWORK_REQUEST:
                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    //permission was granted
                } else {
                    Toast.makeText(getApplicationContext(), "The ACCESS_NETWORK_STATE permission is needed!\n Please allow it", Toast.LENGTH_LONG).show();
                }

            case READ_EXTERNAL_REQUEST:
                // If request is cancelled, the result arrays are empty.
                if (grantResults.length > 0 && grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                    //permission was granted
                } else {
                    Toast.makeText(getApplicationContext(), "The READ_EXTERNAL_STORAGE permission is needed!\n Please allow it", Toast.LENGTH_LONG).show();
                }

            default:

        }
    }
}
