package com.example.nadir.buddycheckalarm;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

/**
 * Created by classykeyser on 4/28/16.
 * This will start the service to play alarm song/alarm sounds
 * Intended to be activated when alarm time is found to be the same
 * as the time of phone.  Will start RingtonePlayingService to create
 * alarm sounds.
 */
public class Alarm_Receiver extends BroadcastReceiver
{
    @Override
    public void onReceive(Context context, Intent intent) {
        //statement should show in the log/terminal
        Log.e("We are in the receiver.", "Yay!");

        //Extra bool from intent
        boolean extra = intent.getExtras().getBoolean("extra");

        //create an intent to the ringtone service
        Intent serviceIntent = new Intent(context, RingtonePlayingService.class);

        serviceIntent.putExtra("extra", extra);

        //start the ringtone service
        context.startService(serviceIntent);
    }
}
