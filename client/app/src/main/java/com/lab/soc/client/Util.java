package com.lab.soc.client;

import android.graphics.Bitmap;
import android.util.Log;

import java.io.IOException;
import java.io.RandomAccessFile;

public class Util {
    private Callback mCallback;
    private AppExecutors exec;

    public Util(Util.Callback callback) {
        exec = new AppExecutors();

        if (callback instanceof Callback) {
            this.mCallback = (Callback) callback;
        } else {
            throw new RuntimeException(callback.toString()
                    + " must implement NetworkManager.Callback interface");
        }
    }

    /**
     * Load the bitmap from the user interface and convert it to an intermediate format the device
     * driver can read. In our case, 32 bit integer ARGB for every pixel.
     *
     * @param mBitmap
     * @param filepath
     */
    public void processBitmap(final Bitmap mBitmap, final String filepath) {
        exec.diskIO().execute(
                new Runnable() {
                    @Override
                    public void run() {
                        int height = mBitmap.getHeight();
                        int width = mBitmap.getWidth();

                        int[] buffer = new int[height * width];

                        // write pixels from bitmap (32bit ARGB) to buffer
                        mBitmap.getPixels(buffer, 0, width, 0, 0, width, height);

                        try {
                            RandomAccessFile bitmap = new RandomAccessFile(filepath, "rws");

                            // write to file
                            for (int i : buffer) {
                                bitmap.writeInt(i);
                            }
                            bitmap.close();


                        } catch (IOException e) {
                            e.printStackTrace();
                        }

                        mCallback.onBitmapProcessed();
                    }
                });
    }

    /**
     * Load the intermediate format and update the user interface
     *
     * @param mBitmap
     * @param filepath
     */
    public void loadBitmap(final Bitmap mBitmap, final String filepath) {
        exec.diskIO().execute(
                new Runnable() {
                    @Override
                    public void run() {
                        int height = mBitmap.getHeight();
                        int width = mBitmap.getWidth();

                        int[] buffer = new int[height * width];

                        try {
                            RandomAccessFile bitmap = new RandomAccessFile(filepath, "rws");

                            for (int i : buffer) {
                                i = bitmap.readInt();
                            }

                            bitmap.close();
                            Log.i("Bitmap", "Here");

                            mBitmap.setPixels(buffer, 0, width, 0, 0, width, height);

                            Log.i("Bitmap", "Fail");
                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                        mCallback.onBitmapLoaded();
                    }
                });
    }


    public interface Callback {
        public void onBitmapProcessed();

        public void onBitmapLoaded();
    }

}