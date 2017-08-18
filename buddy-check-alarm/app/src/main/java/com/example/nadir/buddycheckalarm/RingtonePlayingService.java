package com.example.nadir.buddycheckalarm;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Intent;
import android.media.MediaPlayer;
import android.os.IBinder;
import android.support.annotation.Nullable;
import android.util.Log;
import android.widget.Toast;

import java.security.Provider;
import java.util.List;
import java.util.Map;

/**
 * Created by classykeyser on 4/28/16.
 * This will be the service that plays the audio for the alarm clocks
 */
public class RingtonePlayingService extends Service {

    MediaPlayer songPlayed;
    int startId;
    boolean isRunning;

    @Nullable
    @Override
    public IBinder onBind(Intent intent) {

        return null;
    }

    @Override
    public int onStartCommand(Intent intent, int flags, int startId) {
        Log.i("LocalService", "Received start id " + startId + ": " + intent);

        boolean extra = intent.getExtras().getBoolean("extra");

        if(extra)
        {
            startId = 1;
        }
        else if(!extra)
        {
            startId = 0;
        }
        else
        {
            startId = 0;
        }

        if(!this.isRunning && startId == 1)
        {
            //create an instance of the media player
            songPlayed = MediaPlayer.create(this, R.raw.test);
            songPlayed.start();

            this.isRunning = true;
            this.startId = 0;

            ///////////////////
            // Notifications //
            ///////////////////
            NotificationManager notifyManager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);

            // set up intent & pendingIntent to open Main activity from notification
            Intent intentAlarmActivity = new Intent(this.getApplicationContext(), NewAlarmActivity.class);
            PendingIntent pendingIntentAlarmActivity = PendingIntent.getActivity(this, 0, intentAlarmActivity, 0);

            // create notification parameters
            Notification notificationPopup = new Notification.Builder(this)
                    .setContentTitle("An alarm is going off!")
                    .setContentText("Click me!")
                    .setSmallIcon(R.drawable.cast_ic_notification_0)
                    .setContentIntent(pendingIntentAlarmActivity)
                    .setAutoCancel(true)
                    .build();

            // set up notification call command
            notifyManager.notify(0, notificationPopup);
        }
        else if(this.isRunning && startId == 0)
        {
            songPlayed.stop();
            songPlayed.reset();
            this.isRunning = false;
            this.startId = 0;
        }


        return START_NOT_STICKY;
    }

    @Override
    public void onDestroy() {

        // Tell the user we stopped.
        Toast.makeText(this, "on Destroy called", Toast.LENGTH_SHORT).show();
    }

}
