package com.example.nadir.buddycheckalarm;

import android.app.AlarmManager;
import android.app.PendingIntent;
import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBar.Tab;
import android.support.v7.app.ActionBarActivity;
import android.view.View.OnClickListener;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.v4.content.LocalBroadcastManager;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.TimePicker;

import com.firebase.client.ChildEventListener;
import com.firebase.client.DataSnapshot;
import com.firebase.client.Firebase;
import com.firebase.client.FirebaseError;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;

import java.util.Calendar;

public class MainActivity extends ActionBarActivity {
    //private static final int PLAY_SERVICES_RESOLUTION_REQUEST = 9000;
    private static final String TAG = "MainActivity";
    //private BroadcastReceiver mRegistrationBroadcastReceiver;
    //private boolean isReceiverRegistered;
    ListView listViewFriend;
    ListView listViewUser;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        //setUpTabs(savedInstanceState);
        Firebase.setAndroidContext(this);
        //UserProfileManager.getInstance().setContext(this);
        if (!UserProfileManager.getInstance().isLoggedIn()) {
            Intent intent = new Intent(this, LoginActivity.class);
            startActivity(intent);
            return;
        }
        //listViewUser = (ListView) findViewById(R.id.listViewUser);
        //listViewUser.deferNotifyDataSetChanged();
        //((ArrayAdapter) listViewUser.getAdapter()).notifyDataSetChanged();
        //setContentView(R.layout.activity_main);
        setUpTabs(savedInstanceState);

        Button addAlarm = (Button) findViewById(R.id.addAlarm);


/*
        listViewFriend.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view,
                                    int position, long id) {

                // ListView Clicked item index
                int itemPosition     = position;

                // ListView Clicked item value
                String  itemValue    = (String) listViewFriend.getItemAtPosition(position);

            }
        });

        listViewUser.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view,
                                    int position, long id) {

                // ListView Clicked item index
                int itemPosition     = position;

                // ListView Clicked item value
                String  itemValue    = (String) listViewUser.getItemAtPosition(position);

            }
        });*/
        //Broadcast Receiver for GCM Registration
        //TODO: create login activity and move this code there
        /*
        mRegistrationBroadcastReceiver = new BroadcastReceiver() {
            @Override
            public void onReceive(Context context, Intent intent) {
                //mRegistrationProgressBar.setVisibility(ProgressBar.GONE);
                SharedPreferences sharedPreferences =
                        PreferenceManager.getDefaultSharedPreferences(context);
                boolean sentToken = sharedPreferences
                        .getBoolean(GcmPreferences.SENT_TOKEN_TO_SERVER, false);
                if (sentToken) {
                    //mInformationTextView.setText(getString(R.string.gcm_send_message));
                    Log.i(TAG, "GCM Registration Success");
                    //after successful registration, start main activity
                    UserProfileManager.getInstance().test();
                } else {
                    //mInformationTextView.setText(getString(R.string.token_error_message));
                    Log.e(TAG, "GCM Registration Error");
                }
            }
        };
        */
        //mInformationTextView = (TextView) findViewById(R.id.informationTextView);
        // Registering BroadcastReceiver
        //registerReceiver();

        //firebaseTest();

    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        outState.putInt("tabIndex", getSupportActionBar().getSelectedNavigationIndex());
    }

    private void setUpTabs(Bundle savedInstanceState)
    {
        ActionBar actionBar = getSupportActionBar();
        actionBar.setNavigationMode(actionBar.NAVIGATION_MODE_TABS);
        actionBar.setDisplayShowTitleEnabled(true);

        Tab tab_one = actionBar.newTab();
        Tab tab_two = actionBar.newTab();

        UserAlarms userAlarms = new UserAlarms();
        FriendAlarms friendAlarms = new FriendAlarms();


        tab_one.setText("My Alarms").setContentDescription("Alarms of users").setTabListener(new TabListener<UserAlarms>(userAlarms));

        tab_two.setText("Friend Alarms").setContentDescription("Alarms of friends").setTabListener(new TabListener<FriendAlarms>(friendAlarms));
        actionBar.addTab(tab_one);
        actionBar.addTab(tab_two);

        if(savedInstanceState != null)
        {
            actionBar.setSelectedNavigationItem(savedInstanceState.getInt("tabIndex", 0));
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }

    public void addView(View v) {
        Intent intent = new Intent(this, NewAlarmActivity.class);
        startActivity(intent);
    }

    public void addFriend(View v) {
        Intent intent = new Intent(this, NewFriendActivity.class);
        startActivity(intent);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }


}
