package com.example.smarttodolist.ui;

import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;

import com.example.smarttodolist.R;

/**
 * Single-activity host. From Phase 2 on it hosts the fragments
 * (dashboard, task list, reports, settings) behind a bottom navigation bar.
 */
public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }
}
