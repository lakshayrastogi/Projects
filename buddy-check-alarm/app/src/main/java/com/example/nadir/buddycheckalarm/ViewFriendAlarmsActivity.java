package com.example.nadir.buddycheckalarm;

import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.widget.ArrayAdapter;

import com.firebase.client.ChildEventListener;
import com.firebase.client.DataSnapshot;
import com.firebase.client.Firebase;
import com.firebase.client.FirebaseError;
import com.firebase.client.Query;
import com.firebase.client.ValueEventListener;

/**
 * Created by classykeyser on 5/24/16.
 */
public class ViewFriendAlarmsActivity extends AppCompatActivity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_view_friend_alarms);
        final ArrayAdapter<String> adapterFriend = new ArrayAdapter<String>(this,
                android.R.layout.simple_list_item_1, android.R.id.text1);
    }
}
