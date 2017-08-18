package com.example.nadir.buddycheckalarm;

/**
 * Created by Nadir on 4/18/2016.
 */
public class Alarm {
    private Time time;
    private int snoozeCount;
    public Alarm() {}
    public Alarm(Time t) {
        time = t;
        snoozeCount = 0;
    }
    public Time getTime() {
        return time;
    }
    public int getSnoozeCount() {
        return snoozeCount;
    }
    public void incrementSnoozeCount() {
        snoozeCount++;
    }
}
