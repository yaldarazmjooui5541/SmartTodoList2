# Creates the full SmartTodoList project in the CURRENT folder.
$ErrorActionPreference = 'Stop'
$utf8 = New-Object System.Text.UTF8Encoding($false)

$p = '.github\workflows\build.yml'
New-Item -ItemType Directory -Path (Split-Path $p) -Force | Out-Null
$c = @'
name: Build APK

on:
  push:
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: actions/setup-java@v4
        with:
          distribution: temurin
          java-version: 17

      - uses: gradle/actions/setup-gradle@v4
        with:
          gradle-version: 8.7

      - name: Build debug APK
        run: |
          set +e
          gradle assembleDebug --console=plain --stacktrace > build.log 2>&1
          code=$?
          if [ $code -ne 0 ]; then
            echo "===== ERROR SUMMARY ====="
            grep -n -E "error:|What went wrong|Could not|FAILED|Execution failed|AAPT|Caused by" build.log | head -40 | while read -r l; do echo "::error::$l"; done
            grep -A12 "What went wrong" build.log | head -30
          fi
          exit $code

      - name: Upload build log
        if: always()
        uses: actions/upload-artifact@v4
        with:
          name: build-log
          path: build.log

      - uses: actions/upload-artifact@v4
        with:
          name: SmartTodoList-debug-apk
          path: app/build/outputs/apk/debug/*.apk
'@
[System.IO.File]::WriteAllText((Join-Path (Get-Location) $p), $c + "`n", $utf8)
Write-Host 'created .github\workflows\build.yml'

$p = '.gitignore'
New-Item -ItemType Directory -Path (Split-Path $p -Parent) -Force | Out-Null
$c = @'
.gradle/
build/
local.properties
.idea/
*.iml
'@
[System.IO.File]::WriteAllText((Join-Path (Get-Location) $p), $c + "`n", $utf8)
Write-Host 'created .gitignore'

$p = 'app\build.gradle'
New-Item -ItemType Directory -Path (Split-Path $p) -Force | Out-Null
$c = @'
plugins {
    id 'com.android.application'
}

android {
    namespace 'com.example.smarttodolist'
    compileSdk 34

    defaultConfig {
        applicationId "com.example.smarttodolist"
        minSdk 24
        targetSdk 34
        versionCode 1
        versionName "1.0"

        javaCompileOptions {
            annotationProcessorOptions {
                arguments += ["room.schemaLocation": "$projectDir/schemas".toString()]
            }
        }
    }

    buildTypes {
        release {
            minifyEnabled false
            proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
        }
    }

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_17
        targetCompatibility JavaVersion.VERSION_17
    }

    buildFeatures {
        viewBinding true
    }
}

dependencies {
    implementation 'androidx.appcompat:appcompat:1.7.0'
    implementation 'com.google.android.material:material:1.12.0'
    implementation 'androidx.constraintlayout:constraintlayout:2.1.4'
    implementation 'androidx.recyclerview:recyclerview:1.3.2'
    implementation 'androidx.fragment:fragment:1.8.2'
    implementation 'androidx.navigation:navigation-fragment:2.7.7'
    implementation 'androidx.navigation:navigation-ui:2.7.7'

    implementation 'androidx.room:room-runtime:2.6.1'
    annotationProcessor 'androidx.room:room-compiler:2.6.1'

    implementation 'androidx.lifecycle:lifecycle-viewmodel:2.8.4'
    implementation 'androidx.lifecycle:lifecycle-livedata:2.8.4'

    implementation 'androidx.work:work-runtime:2.9.1'

    implementation 'com.github.PhilJay:MPAndroidChart:v3.1.0'
}
'@
[System.IO.File]::WriteAllText((Join-Path (Get-Location) $p), $c + "`n", $utf8)
Write-Host 'created app\build.gradle'

$p = 'app\proguard-rules.pro'
New-Item -ItemType Directory -Path (Split-Path $p) -Force | Out-Null
$c = @'
# Project-specific ProGuard rules (minification is disabled for now).
'@
[System.IO.File]::WriteAllText((Join-Path (Get-Location) $p), $c + "`n", $utf8)
Write-Host 'created app\proguard-rules.pro'

$p = 'app\src\main\AndroidManifest.xml'
New-Item -ItemType Directory -Path (Split-Path $p) -Force | Out-Null
$c = @'
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
    <uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />

    <application
        android:allowBackup="true"
        android:label="@string/app_name"
        android:supportsRtl="true"
        android:theme="@style/Theme.SmartTodoList">

        <activity
            android:name=".ui.MainActivity"
            android:exported="true">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity>
    </application>
</manifest>
'@
[System.IO.File]::WriteAllText((Join-Path (Get-Location) $p), $c + "`n", $utf8)
Write-Host 'created app\src\main\AndroidManifest.xml'

$p = 'app\src\main\java\com\example\smarttodolist\ui\MainActivity.java'
New-Item -ItemType Directory -Path (Split-Path $p) -Force | Out-Null
$c = @'
package com.example.smarttodolist.ui;

import android.os.Bundle;

import androidx.appcompat.app.AppCompatActivity;

import com.example.smarttodolist.R;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }
}
'@
[System.IO.File]::WriteAllText((Join-Path (Get-Location) $p), $c + "`n", $utf8)
Write-Host 'created MainActivity.java'

$p = 'app\src\main\res\layout\activity_main.xml'
New-Item -ItemType Directory -Path (Split-Path $p) -Force | Out-Null
$c = @'
<?xml version="1.0" encoding="utf-8"?>
<FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@color/background"
    android:layoutDirection="rtl">

    <TextView
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_gravity="center"
        android:text="@string/app_name"
        android:textColor="@color/primary"
        android:textSize="24sp"
        android:textStyle="bold" />
</FrameLayout>
'@
[System.IO.File]::WriteAllText((Join-Path (Get-Location) $p), $c + "`n", $utf8)
Write-Host 'created activity_main.xml'

$p = 'app\src\main\res\values\colors.xml'
New-Item -ItemType Directory -Path (Split-Path $p) -Force | Out-Null
$c = @'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="primary">#7E57C2</color>
    <color name="primary_dark">#5E35B1</color>
    <color name="primary_container">#EDE7F6</color>
    <color name="background">#FAF8FF</color>
    <color name="surface">#FFFFFF</color>
    <color name="on_surface">#1F1B2D</color>
    <color name="on_surface_variant">#6B6580</color>

    <color name="priority_high">#E53935</color>
    <color name="priority_medium">#FB8C00</color>
    <color name="priority_low">#43A047</color>
</resources>
'@
[System.IO.File]::WriteAllText((Join-Path (Get-Location) $p), $c + "`n", $utf8)
Write-Host 'created colors.xml'

$p = 'app\src\main\res\values\strings.xml'
New-Item -ItemType Directory -Path (Split-Path $p) -Force | Out-Null
$c = @'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">فهرست کارهای هوشمند</string>
</resources>
'@
[System.IO.File]::WriteAllText((Join-Path (Get-Location) $p), $c + "`n", $utf8)
Write-Host 'created strings.xml'

$p = 'app\src\main\res\values\themes.xml'
New-Item -ItemType Directory -Path (Split-Path $p) -Force | Out-Null
$c = @'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="Theme.SmartTodoList" parent="Theme.Material3.Light.NoActionBar">
        <item name="colorPrimary">@color/primary</item>
        <item name="colorPrimaryContainer">@color/primary_container</item>
        <item name="colorSurface">@color/surface</item>
        <item name="android:colorBackground">@color/background</item>
        <item name="colorOnSurface">@color/on_surface</item>
        <item name="android:statusBarColor">@color/background</item>
        <item name="android:windowLightStatusBar">true</item>
    </style>
</resources>
'@
[System.IO.File]::WriteAllText((Join-Path (Get-Location) $p), $c + "`n", $utf8)
Write-Host 'created themes.xml'

$p = 'build.gradle'
New-Item -ItemType Directory -Path (Split-Path $p -Parent) -Force | Out-Null
$c = @'
plugins {
    id 'com.android.application' version '8.5.2' apply false
}
'@
[System.IO.File]::WriteAllText((Join-Path (Get-Location) $p), $c + "`n", $utf8)
Write-Host 'created build.gradle'

$p = 'gradle.properties'
New-Item -ItemType Directory -Path (Split-Path $p -Parent) -Force | Out-Null
$c = @'
org.gradle.jvmargs=-Xmx2048m -Dfile.encoding=UTF-8
android.useAndroidX=true
android.nonTransitiveRClass=true
'@
[System.IO.File]::WriteAllText((Join-Path (Get-Location) $p), $c + "`n", $utf8)
Write-Host 'created gradle.properties'

$p = 'gradle\wrapper\gradle-wrapper.properties'
New-Item -ItemType Directory -Path (Split-Path $p) -Force | Out-Null
$c = @'
distributionBase=GRADLE_USER_HOME
distributionPath=wrapper/dists
distributionUrl=https\://services.gradle.org/distributions/gradle-8.7-bin.zip
zipStoreBase=GRADLE_USER_HOME
zipStorePath=wrapper/dists
'@
[System.IO.File]::WriteAllText((Join-Path (Get-Location) $p), $c + "`n", $utf8)
Write-Host 'created gradle-wrapper.properties'

$p = 'settings.gradle'
New-Item -ItemType Directory -Path (Split-Path $p -Parent) -Force | Out-Null
$c = @'
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
        maven { url 'https://jitpack.io' }
    }
}
rootProject.name = "SmartTodoList"
include ':app'
'@
[System.IO.File]::WriteAllText((Join-Path (Get-Location) $p), $c + "`n", $utf8)
Write-Host 'created settings.gradle'

Write-Host 'DONE - all files created.'
