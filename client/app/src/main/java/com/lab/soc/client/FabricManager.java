package com.lab.soc.client;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.logging.Handler;

public class FabricManager {
    private Callback mCallback;
    private android.os.Handler mHandler;
    private byte[] buffer;
    private final RandomAccessFile hashDevice = null;


    public FabricManager(FabricManager.Callback callback) {

        buffer = new byte[128];
        mHandler = new android.os.Handler();

        if (callback instanceof Callback) {
            this.mCallback = (Callback) callback;
        } else {
            throw new RuntimeException(callback.toString()
                    + " must implement NetworkManager.Callback interface");
        }
    }


    /**
     * Calculate HASH from file with the blake2b module
     *
     * @param filepath abs. filepath
     * @param driver   replace with "/proc/blake2b"
     * @return
     */
    String calculateHashFromFile(final String filepath, final String driver) {
        Runnable getHash = new Runnable() {
            @Override
            public void run() {
                try {
                    // open device driver
                    RandomAccessFile hashDriver = new RandomAccessFile(driver, "rws"); // will be replaced with the device driver
                    // write absolute bitstream filepath to device driver
                    hashDriver.writeChars(filepath);

                    //stall thread to wait for hardware calculation
                    Thread.currentThread();
                    Thread.sleep(100);

                    //read the calculated HASH
                    hashDriver.read(buffer, 0, 128);
                    // release driver
                    hashDriver.close();
                } catch (FileNotFoundException e) {
                    e.printStackTrace();
                } catch (IOException e) {
                    e.printStackTrace();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        };

        mHandler.post(getHash);

        return new String(buffer);
    }

    /**
     * load the bitstream into the fabric
     *
     * @param filepath abs. filepath
     * @param driver   replace with "/proc/..."
     */
    void reconfigureFabric(final String filepath, final String driver) {

        Runnable reconfigFabric = new Runnable() {
            @Override
            public void run() {
                try {
                    // open device driver
                    RandomAccessFile fabricDriver = new RandomAccessFile(driver, "rws");
                    // write absolute bitstream filepath to device driver
                    fabricDriver.writeChars(filepath);
                    // release driver
                    fabricDriver.close();
                } catch (FileNotFoundException e) {
                    e.printStackTrace();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        };

        mHandler.post(reconfigFabric);
    }

    /**
     * Apply filters on the image
     *
     * @param filepath abs. filepath
     * @param driver   replace with "/proc/simple_filter"
     */
    void applyFilter(final String filepath, final String driver) {

        Runnable applyFilter = new Runnable() {
            @Override
            public void run() {
                try {
                    // open device driver
                    RandomAccessFile filterDriver = new RandomAccessFile(driver, "rws");
                    // write absolute image filepath to device driver
                    filterDriver.writeChars(filepath);
                    // release driver
                    filterDriver.close();

                    Thread.currentThread();
                    Thread.sleep(200);


                } catch (FileNotFoundException e) {
                    e.printStackTrace();
                } catch (IOException e) {
                    e.printStackTrace();
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        };

        mHandler.post(applyFilter);
        // read the processed image back into the ui
        mCallback.onFilterApplied(filepath);
    }


    public interface Callback {
        public void onFilterApplied(String filepath);
    }
}
