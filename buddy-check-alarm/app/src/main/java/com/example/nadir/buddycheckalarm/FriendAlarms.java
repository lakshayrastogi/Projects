package com.example.nadir.buddycheckalarm;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;

import com.firebase.client.ChildEventListener;
import com.firebase.client.DataSnapshot;
import com.firebase.client.Firebase;
import com.firebase.client.FirebaseError;
import com.firebase.client.GenericTypeIndicator;
import com.firebase.client.Query;
import com.firebase.client.ValueEventListener;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by classykeyser on 5/17/16.
 */
public class FriendAlarms extends Fragment{
    ListView listViewFriend;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
    }

    @Override
    public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
        View view = inflater.inflate(R.layout.fragment_friend_alarms, container, false);
        return view;
    }

    @Override
    public void onActivityCreated(@Nullable Bundle savedInstanceState) {
        super.onActivityCreated(savedInstanceState);
        listViewFriend = (ListView) getActivity().findViewById(R.id.listViewFriend);
        String[] valuesFriend = new String[] {"Test Friend Alarm 1", "Test Friend Alarm 2"};
        final ArrayAdapter<String> adapterFriend = new ArrayAdapter<String>(getActivity(),
                android.R.layout.simple_list_item_1, android.R.id.text1);
        listViewFriend.setAdapter(adapterFriend);
        final Firebase firebaseRef = new Firebase(Globals.FIREBASE_REF);
        Firebase userFriendsRef = UserProfileManager.getInstance().getUserRef().child("friends");
        userFriendsRef.addChildEventListener(new ChildEventListener() {
            @Override
            public void onChildAdded(DataSnapshot dataSnapshot, String s) {
                String friendId = (String) dataSnapshot.getValue();
                Firebase friendUsernameRef = firebaseRef.child("users").child(friendId).child("username");
                friendUsernameRef.addListenerForSingleValueEvent(new ValueEventListener() {
                    @Override
                    public void onDataChange(DataSnapshot dataSnapshot) {
                        final String friendUsername = (String) dataSnapshot.getValue();
                        adapterFriend.add(friendUsername);
                    }

                    @Override
                    public void onCancelled(FirebaseError firebaseError) {

                    }
                });
            }
            @Override
            public void onChildChanged(DataSnapshot dataSnapshot, String s) {

            }
            @Override
            public void onChildRemoved(DataSnapshot dataSnapshot) {

            }
            @Override
            public void onChildMoved(DataSnapshot dataSnapshot, String s) {

            }
            @Override
            public void onCancelled(FirebaseError firebaseError) {

            }
        });

//        final SwipeDetector swipeDetector = new SwipeDetector();
//        listViewFriend.setOnTouchListener(swipeDetector);

        listViewFriend.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view,
                                    int position, long id) {

                // ListView Clicked item index
                int itemPosition     = position;

                // ListView Clicked item value
                String  itemValue    = (String) listViewFriend.getItemAtPosition(position);
                Intent intent = new Intent(getActivity(), ViewFriendAlarmsActivity.class);
                startActivity(intent);

            }
        });
    }
}
