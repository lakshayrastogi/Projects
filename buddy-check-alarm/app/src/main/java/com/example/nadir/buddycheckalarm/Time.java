package com.example.nadir.buddycheckalarm;

/**
 * Created by Nadir on 4/18/2016.
 */
public class Time {
    public Time() {}
    public Time(long h, long m, long s) {
        hour = h;
        minute = m;
        second = s;
    }
    protected long hour;
    protected long minute;
    protected long second;
}