package com.lab.soc.client;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.support.v4.content.res.TypedArrayUtils;
import android.util.Log;

import java.io.EOFException;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.math.BigInteger;
import java.nio.ByteBuffer;
import java.nio.IntBuffer;
import java.util.Arrays;
import java.util.Collection;
import java.util.Collections;

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
                            RandomAccessFile bitmap = new RandomAccessFile(filepath, "rw");

                            // write to file
                            for (int i : buffer) {
                            //for (int i=0; i<=buffer.length -1; i++) {
                                bitmap.writeInt(i);
                            }
                            bitmap.close();


                        } catch (IOException e) {
                            e.printStackTrace();
                        }

                        mCallback.onBitmapProcessed(mBitmap);
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

                        int[] data = new int[height * width];

                        Bitmap fBitmap = null;

                        //wait until file exists
                        File file = new File(filepath);
                        while (!file.exists());

                        try {
                            RandomAccessFile bitmap = new RandomAccessFile(filepath, "r");

                            for (int i=0; i<=data.length -1; i++) {
                                data[i] = bitmap.readInt() -16777216; //read int value and apply alpha correction
                            }

                            bitmap.close();

                            fBitmap = Bitmap.createBitmap(data, width, height, Bitmap.Config.ARGB_8888);

                        } catch (IOException e) {
                            e.printStackTrace();
                        }
                        mCallback.onBitmapLoaded(fBitmap);
                    }
                });
    }


    public interface Callback {
        public void onBitmapProcessed(Bitmap mBitmap);

        public void onBitmapLoaded(Bitmap fBitmap);
    }

}