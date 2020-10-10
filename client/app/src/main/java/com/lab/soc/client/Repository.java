package com.lab.soc.client;

import java.util.ArrayList;
import java.util.List;

public class Repository {
    String index;
    String title;
    String version;
    String description;
    List<String> changelogs;
    String file;
    String date;
    String checksum;

    public Repository(String index, String title, String version, String description, List<String> changelogs, String file, String date, String checksum) {
        changelogs = new ArrayList<String>();
        this.index = index;
        this.title = title;
        this.version = version;
        this.description = description;
        this.changelogs = changelogs;
        this.file = file;
        this.date = date;
        this.checksum = checksum;
    }

    @Override
    public String toString() {
        StringBuilder strBuilder = new StringBuilder();
        strBuilder.append(Constants.JSON.INDEX + ": " +index+ "\r\n");
        strBuilder.append(Constants.JSON.TITLE + ": " +title+ "\r\n");
        strBuilder.append(Constants.JSON.VERSION + ": " +version+ "\r\n");
        strBuilder.append(Constants.JSON.DESCRIPTION + ": " +description+ "\r\n");
        strBuilder.append(Constants.JSON.CHANGELOG + ": " + "\r\n");

        for(String change:changelogs){
            strBuilder.append(change + "\r\n");

        }

        strBuilder.append(Constants.JSON.FILENAME + ": " +file+ "\r\n");
        strBuilder.append(Constants.JSON.DATE + ": " +date+ "\r\n");
        strBuilder.append(Constants.JSON.CHECKSUM + ": " +checksum+ "\r\n");

        return strBuilder.toString();

    }

    public String getIndex() {
        return index;
    }

    public void setIndex(String index) {
        this.index = index;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public List<String> getChangelogs() {
        return changelogs;
    }

    public void setChangelogs(List<String> changelogs) {
        this.changelogs = changelogs;
    }

    public String getFile() {
        return file;
    }

    public void setFile(String file) {
        this.file = file;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getChecksum() {
        return checksum;
    }

    public void setChecksum(String checksum) {
        this.checksum = checksum;
    }
}
