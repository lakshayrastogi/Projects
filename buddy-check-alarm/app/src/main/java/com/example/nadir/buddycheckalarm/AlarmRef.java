package com.example.nadir.buddycheckalarm;

/**
 * Created by Nadir on 5/24/2016.
 */
public class AlarmRef {
    public AlarmRef(String alarmId, Alarm alarmData) {
        this.alarmId = alarmId;
        this.alarmData = alarmData;
        if (alarmData != null) {
            this.alarmStr = String.valueOf(alarmData.getTime().hour) + ":" +
                    String.valueOf(alarmData.getTime().minute);
        }
    }
    public String alarmId;
    public String alarmStr;
    public Alarm alarmData;

    @Override
    public String toString() {
        return alarmStr;
    }
}
