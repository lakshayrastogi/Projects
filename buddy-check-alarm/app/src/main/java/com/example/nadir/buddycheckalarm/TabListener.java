package com.example.nadir.buddycheckalarm;

import android.support.v4.app.Fragment;
import android.support.v4.app.FragmentTransaction;
import android.support.v7.app.ActionBar;
import android.support.v7.app.ActionBar.Tab;
import android.util.Log;

/**
 * Created by classykeyser on 5/17/16.
 */
public class TabListener<T extends Fragment> implements ActionBar.TabListener {
    private Fragment fragment;

    public TabListener(Fragment fragment)
    {
        this.fragment = fragment;
    }

    @Override
    public void onTabSelected(ActionBar.Tab tab, FragmentTransaction ft) {
        ft.replace(R.id.main, fragment, null);
    }

    @Override
    public void onTabUnselected(ActionBar.Tab tab, FragmentTransaction ft) {
        if(fragment != null)
        {
            ft.remove(fragment);
        }
    }

    @Override
    public void onTabReselected(ActionBar.Tab tab, FragmentTransaction ft) {

    }
}
