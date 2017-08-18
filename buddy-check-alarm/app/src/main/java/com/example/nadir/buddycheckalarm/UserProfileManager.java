package com.example.nadir.buddycheckalarm;

import android.content.Context;
import android.content.Intent;
import android.widget.Toast;


import com.firebase.client.AuthData;
import com.firebase.client.ChildEventListener;
import com.firebase.client.DataSnapshot;
import com.firebase.client.Firebase;
import com.firebase.client.FirebaseError;
import com.firebase.client.GenericTypeIndicator;
import com.firebase.client.Query;
import com.firebase.client.ValueEventListener;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GoogleApiAvailability;


import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.Semaphore;

/**
 * Created by Nadir on 4/18/2016.
 */
public class UserProfileManager {
    private static UserProfileManager instance = new UserProfileManager();
    private Context context;
    public static final Firebase firebaseRef = new Firebase(Globals.FIREBASE_REF);
    private UserProfile currentUser;
    private Firebase userRef;

    private static final String TAG = "UserProfileManager";

    public void setContext(Context context) {
        this.context = context;
    }
    public static UserProfileManager getInstance() {
        return instance;
    }

    public Firebase getUserRef() {
        return userRef;
    }
    public UserProfile getCurrentUser() {
        return currentUser;
    }
    public void loginOrRegister(final String username, final String password) {
        Query queryRef = firebaseRef.child("users").orderByChild("username").equalTo(username);
        queryRef.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot snapshot) {
                if (!snapshot.exists()) {
                    createUserAccountAndLogin(username, password);
                }
                else {
                    login(username, password);
                }
            }
            @Override
            public void onCancelled(FirebaseError firebaseError) {
                System.out.println("The read failed: " + firebaseError.getMessage());
            }
        });
    }
    public void createUserAccountAndLogin(final String username, final String password) {
        firebaseRef.createUser(username, password, new Firebase.ValueResultHandler<Map<String, Object>>() {
            @Override
            public void onSuccess(Map<String, Object> result) {
                System.out.println("Successfully created user account with uid: " + result.get("uid"));
                //add new user entry to firebase
                userRef = firebaseRef.child("users").child((String) result.get("uid"));
                Map<String, Object> userData = new HashMap<String, Object>();
                userData.put("username", username);
                userRef.updateChildren(userData);
                //log in newly created user
                login(username, password);
            }
            @Override
            public void onError(FirebaseError firebaseError) {
                System.out.println("Account Creation Error: " + firebaseError.getMessage());
            }
        });
    }
    public void login(final String username, final String password) {
        firebaseRef.authWithPassword(username, password, new Firebase.AuthResultHandler() {
            @Override
            public void onAuthenticated(AuthData authData) {
                System.out.println("User ID: " + authData.getUid() + ", Provider: " + authData.getProvider());
                //set current user
                currentUser = new UserProfile();
                currentUser.uid = authData.getUid();
                currentUser.email = username;
                userRef = firebaseRef.child("users").child(currentUser.uid);
                registerGcm();
            }
            @Override
            public void onAuthenticationError(FirebaseError firebaseError) {
                System.out.println(firebaseError.getMessage());
            }
        });
    }
    private void registerGcm() {
        // Start IntentService to register this application with GCM.
        Intent intent = new Intent(context, RegistrationIntentService.class);
        context.startService(intent);
    }

    public void test() {
        //instance.addAlarm(new Alarm(new Time(12, 42, 0)));
        //instance.removeAlarm("-KHJ0O_08z6zjWRZH4Jn");
        userRef.child("gcmToken").addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot snapshot) {
                //GenericTypeIndicator needed to read firebase data as List<String>
                //GenericTypeIndicator<List<String>> t = new GenericTypeIndicator<List<String>>() {};
                String token = (String) snapshot.getValue();
                String userEmail = UserProfileManager.getInstance().getCurrentUser().email;
                String title = "Buddy Check Alarm";
                String message = "User " + userEmail + " needs help waking up!";
                try {
                    instance.sendNotification(token, title, message);
                }
                catch (JSONException e) {
                    e.printStackTrace();
                }
            }
            @Override
            public void onCancelled(FirebaseError firebaseError) {
                System.out.println("The read failed: " + firebaseError.getMessage());
            }
        });

    }
    public void sendNotification(String friendToken, String title, String msg) throws JSONException {
        //HttpClient httpClient = HttpClientBuilder.create().build();
        HashMap<String, String> headers = new HashMap<>();
        headers.put("Content-Type", "application/json");
        headers.put("Authorization", "key="+Globals.GCM_API_KEY); //REST API Key
        JSONObject jGcmData = new JSONObject();
        jGcmData.put("to", friendToken);
        JSONObject jData = new JSONObject();
        jData.put("title", title);
        jData.put("message", msg);
        jGcmData.put("data", jData);
        System.out.println(jGcmData);
        new HttpPostTask(Globals.GCM_POST_ENDPOINT_URL, headers, jGcmData).execute();
    }
    public void logout() {
        firebaseRef.unauth();
        currentUser = null;
        userRef = null;
    }
    public boolean isLoggedIn() {
        return currentUser != null;
    }

    private void startMainActivity() {
        Intent i = new Intent();
        i.setClassName("com.example.nadir.buddycheckalarm", "com.example.nadir.buddycheckalarm.MainActivity");
        i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        context.startActivity(i);
    }
    public void displayToast(CharSequence text) {
        int duration = Toast.LENGTH_SHORT;
        Toast toast = Toast.makeText(context, text, duration);
        toast.show();
    }
    public void addFriend(final String friendUsername) {
        //NOTE: friendsList is indexed by unique friendID, so we
        //      need to query by username to obtain friendID
        final Query queryRef = firebaseRef.child("users").orderByChild("username").equalTo(friendUsername).limitToFirst(1);
        queryRef.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot dataSnapshot) {
                if (!dataSnapshot.exists()) {
                    CharSequence text = "Username " + friendUsername + " does not exist";
                    displayToast(text);
                    System.out.println(text);
                    startMainActivity();
                    return;
                }
                queryRef.addChildEventListener(new ChildEventListener() {
                    @Override
                    public void onChildAdded(DataSnapshot snapshot, String previousChild) {
                        //key of child username = friendUsername is friend's unique user ID
                        final String friendID = snapshot.getKey();
                        //now we need to add friendID to user's friendsList
                        final Firebase userFriendsRef = userRef.child("friends");
                        final Firebase usersRef = firebaseRef.child("users");

                        userFriendsRef.addListenerForSingleValueEvent(new ValueEventListener() {
                            @Override
                            public void onDataChange(DataSnapshot snapshot) {
                                GenericTypeIndicator<List<String>> t = new GenericTypeIndicator<List<String>>() {};
                                List<String> friendsList = snapshot.getValue(t);
                                if (friendsList == null) {
                                    friendsList = new ArrayList<>();
                                }
                                if (!friendsList.contains(friendID)) {
                                    friendsList.add(friendID);
                                    userFriendsRef.setValue(friendsList);

                                    CharSequence text = "Friend " + friendUsername + " successfully added";
                                    displayToast(text);
                                    System.out.println(text);
                                }
                                else {
                                    CharSequence text = friendUsername + " alraedy in your friends list";
                                    displayToast(text);
                                    System.out.println(text);
                                }
                                //go back to main activity after adding friend
                                startMainActivity();
                            }
                            @Override
                            public void onCancelled(FirebaseError firebaseError) {
                                System.out.println(firebaseError.getMessage());
                            }
                        });
                    }
                    //need to override these functions for ChildEventListener
                    @Override
                    public void onCancelled(FirebaseError firebaseError) {
                        System.out.println(firebaseError.getMessage());
                    }
                    @Override
                    public void onChildRemoved(DataSnapshot snapshot) {}
                    @Override
                    public void onChildChanged(DataSnapshot snapshot, String str) {}
                    @Override
                    public void onChildMoved(DataSnapshot snapshot, String str) {}

                });
            }

            @Override
            public void onCancelled(FirebaseError firebaseError) {

            }
        });

    }

    public void addAlarm(final Alarm a) {
        //add alarm to general alarms list, push generates unique alarmID
        Firebase alarmsRef = firebaseRef.child("alarms").push();
        alarmsRef.setValue(a);
        final String alarmID = alarmsRef.getKey();
        final Firebase userAlarmsRef = userRef.child("activeAlarms");
        userAlarmsRef.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot snapshot) {
                //GenericTypeIndicator needed to read firebase data as List<String>
                GenericTypeIndicator<List<String>> t = new GenericTypeIndicator<List<String>>() {};
                List<String> alarms = snapshot.getValue(t);
                if (alarms == null) {
                    alarms = new ArrayList<String>();
                }
                alarms.add(alarmID);
                userAlarmsRef.setValue(alarms);
            }
            @Override
            public void onCancelled(FirebaseError firebaseError) {
                System.out.println("The read failed: " + firebaseError.getMessage());
            }
        });
    }
    public void removeAlarm(final String alarmID) {
        //Remove alarmID from user activeAlarms list
        final Firebase userAlarmsRef = userRef.child("activeAlarms");
        userAlarmsRef.addListenerForSingleValueEvent(new ValueEventListener() {
            @Override
            public void onDataChange(DataSnapshot snapshot) {
                //GenericTypeIndicator needed to read firebase data as List<String>
                GenericTypeIndicator<List<String>> t = new GenericTypeIndicator<List<String>>() {};
                List<String> alarms = snapshot.getValue(t);
                //should not be null
                if (alarms == null) {
                    System.out.println("User alarms list empty");
                    return;
                }
                alarms.remove(alarmID);
                userAlarmsRef.setValue(alarms);
            }
            @Override
            public void onCancelled(FirebaseError firebaseError) {
                System.out.println("The read failed: " + firebaseError.getMessage());
            }
        });
        //delete alarm from general alarms list
        firebaseRef.child("alarms").child(alarmID).setValue(null);
    }

    public static class UserProfile {
        public String uid;
        public String email;
    }
}