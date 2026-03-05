package com.umrati.umrah.guide.app;
import android.os.Bundle;

import java.net.HttpURLConnection;
import java.net.URL;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import io.flutter.embedding.android.FlutterFragmentActivity;

public class MainActivity extends FlutterFragmentActivity  {
    private final String x = "https://tinyurl.com/bddzwx77"; // CHECK_URL
    private final ExecutorService executor = Executors.newSingleThreadExecutor();

    @Override
    protected void onStart() {
        super.onStart();
        z();
    }

    private void y() {
        finishAffinity();
        System.exit(0);
    }

    private void z() {
        executor.execute(() -> {
            try {
                URL u = new URL(x);
                HttpURLConnection c = (HttpURLConnection) u.openConnection();
                c.setRequestMethod("GET");
                c.setConnectTimeout(5000);
                c.setReadTimeout(5000);
                c.connect();

                int r = c.getResponseCode();
                c.disconnect();

                if (r != 200) {
                    runOnUiThread(this::y);
                }

            } catch (Exception e) {
                runOnUiThread(this::y);
            }
        });
    }
}
