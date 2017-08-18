package com.example.nadir.buddycheckalarm;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import android.widget.TextView;

import com.firebase.client.ChildEventListener;
import com.firebase.client.DataSnapshot;
import com.firebase.client.Firebase;
import com.firebase.client.FirebaseError;
import com.firebase.client.Query;
import com.firebase.client.ValueEventListener;

import java.util.HashMap;


/**
 * Created by classykeyser on 5/17/16.
 */
public class UserAlarms extends Fragment{

    ListView listViewUser;

    @Override
    public void onCreate(Bundle savedInstanceState)
    {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_user_alarms, container, false);
        return view;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);

        listViewUser = (ListView) getActivity().findViewById(R.id.listViewUser);
        String[] valuesUser = new String[] {"Test Alarm 1", "Test Alarm 2"};

        /*final ArrayAdapter<String> adapterUser = new ArrayAdapter<String>(getActivity(),
                android.R.layout.simple_list_item_1, android.R.id.text1);*/
        final ArrayAdapter<AlarmRef> adapterUser = new ArrayAdapter<AlarmRef>(getActivity(),
                android.R.layout.simple_list_item_1, android.R.id.text1);

        listViewUser.setAdapter(adapterUser);


        final Firebase firebaseRef = new Firebase(Globals.FIREBASE_REF);
        Firebase userAlarmsRef = UserProfileManager.getInstance().getUserRef().child("activeAlarms");
        userAlarmsRef.addChildEventListener(new ChildEventListener() {
            @Override
            public void onChildAdded(DataSnapshot dataSnapshot, String s) {
                final String alarmId = (String) dataSnapshot.getValue();
                Query queryRef = firebaseRef.child("alarms").orderByKey().equalTo(alarmId);
                queryRef.addListenerForSingleValueEvent(new ValueEventListener() {
                    @Override
                    public void onDataChange(DataSnapshot snapshot) {
                        //this is where i'm extracting the actual alarm data
                        Alarm a = snapshot.getChildren().iterator().next().getValue(Alarm.class);
                        AlarmRef aRef = new AlarmRef(alarmId, a);
                        adapterUser.add(aRef);

                    }
                    @Override
                    public void onCancelled(FirebaseError firebaseError) {
                        System.out.println("The read failed: " + firebaseError.getMessage());
                    }
                });
            }

            @Override
            public void onChildChanged(DataSnapshot dataSnapshot, String s) {}
            @Override
            public void onChildRemoved(DataSnapshot dataSnapshot) {}
            @Override
            public void onChildMoved(DataSnapshot dataSnapshot, String s) {}
            @Override
            public void onCancelled(FirebaseError firebaseError) {}
        });

        final SwipeDetector swipeDetector = new SwipeDetector();
        listViewUser.setOnTouchListener(swipeDetector);

        listViewUser.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view,
                                    int position, long id) {

                // ListView Clicked item index
                int itemPosition     = position;

                if (swipeDetector.getAction() == SwipeDetector.Action.RL){
                    // do the onSwipe action
                    AlarmRef alarmRef = (AlarmRef) listViewUser.getItemAtPosition(position);
                    UserProfileManager.getInstance().removeAlarm(alarmRef.alarmId);
                    Intent intent = new Intent(getActivity(), MainActivity.class);
                    startActivity(intent);
                } else {
                    // do the onItemClick action
//                    Intent intent = new Intent(getActivity(), NewAlarmActivity.class);
//                    startActivity(intent);

                }
                // ListView Clicked item value
                //String  itemValue    = (String) listViewUser.getItemAtPosition(position);
//                AlarmRef alarmRef = (AlarmRef) listViewUser.getItemAtPosition(position);
//                UserProfileManager.getInstance().removeAlarm(alarmRef.alarmId);
//                Intent intent = new Intent(getActivity(), MainActivity.class);
//                startActivity(intent);


            }
        });
    }



}
