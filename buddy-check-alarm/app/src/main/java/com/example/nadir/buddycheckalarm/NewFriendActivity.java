package com.example.nadir.buddycheckalarm;

import android.app.AlertDialog;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.EditText;

/**
 * Created by classykeyser on 5/24/16.
 */
public class NewFriendActivity extends AppCompatActivity
{
    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_new_friend);
    }

    //This will be used to add the new friend to the user's list
    //of friends
    public void addNewFriend(View v) {
        final EditText editText = (EditText) findViewById(R.id.editText);
        String friendUsername = editText.getText().toString();
        //System.out.println("Add friend: " + friendUsername);
        UserProfileManager.getInstance().addFriend(friendUsername);
    }
}
