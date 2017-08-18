package com.example.nadir.buddycheckalarm;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.PersistableBundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.TimePicker;

import java.util.Calendar;

/**
 * Created by classykeyser on 5/17/16.
 */
public class NewAlarmActivity extends AppCompatActivity {
    // create UI variables
    AlarmManager alarm_manager;
    TimePicker alarm_timePicker;
    TextView alarm_status;
    Context context;
    PendingIntent myPendingIntent;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_alarm);
        this.context = this;

        // initialise alarmManager
        alarm_manager = (AlarmManager) getSystemService(ALARM_SERVICE);

        // initialise timepicker
        alarm_timePicker = (TimePicker) findViewById(R.id.timePicker);

        // initialise alarmStatus
        alarm_status = (TextView) findViewById(R.id.alarm_status);

        // create calendar instance
        final Calendar calendar = Calendar.getInstance();

        //create an intent to the alarm receiver class
        final Intent myIntent = new Intent(this.context, Alarm_Receiver.class);

        // intialise alarmOn button and onClick listener
        Button alarm_on = (Button) findViewById(R.id.alarm_on);

        final Intent mainActivityIntent = new Intent(this, MainActivity.class);

        alarm_on.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                calendar.set(Calendar.HOUR_OF_DAY, alarm_timePicker.getHour());
                calendar.set(Calendar.MINUTE, alarm_timePicker.getMinute());

                //Get hour
                int hour = alarm_timePicker.getHour();
                int minute = alarm_timePicker.getMinute();

                //add new alarm to firebase
                UserProfileManager.getInstance().addAlarm(new Alarm(new Time(hour, minute, 0)));

                //Convert to string
                String hourS = String.valueOf(hour);
                String minuteS = String.valueOf(minute);

                if (hour > 12) {
                    hourS = String.valueOf(hour - 12);
                }

                if (minute < 10) {
                    minuteS = "0" + minuteS;
                }

                // change alarmStatus
                set_alarm_status("Alarm set to: " + hourS + ":" + minuteS);

                //put in string into intent (tell clock we pressed alarm on button)
                myIntent.putExtra("extra", true);

                //Create pending intent that delays the intent until the specified calendar time
                myPendingIntent = PendingIntent.getBroadcast(NewAlarmActivity.this, 0, myIntent, PendingIntent.FLAG_UPDATE_CURRENT);

                //set the alarm manager
                alarm_manager.set(AlarmManager.RTC_WAKEUP, calendar.getTimeInMillis(), myPendingIntent);

                // go back to Main Activity
                startActivity(mainActivityIntent);
            }
        });

        // initialise alarmOff button and onClick listener
        Button alarm_off = (Button) findViewById(R.id.alarm_off);
        alarm_off.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                set_alarm_status("Alarm Off!");
                //Cancel alarm
                alarm_manager.cancel(myPendingIntent);

                myIntent.putExtra("extra", false);

                //stop the ringtone
                sendBroadcast(myIntent);

                // go back to Main Activity
                startActivity(mainActivityIntent);
            }
        });
    }


    private void set_alarm_status(String output) {
        alarm_status.setText(output);
    }
}
