package com.navipilot.obf;

import android.content.Context;
import android.content.res.ColorStateList;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.GradientDrawable;
import android.graphics.drawable.RippleDrawable;
import android.text.TextUtils;
import android.view.Gravity;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

final class WideUi {
    static final int INK = 0xfff2f6fc;
    static final int MUTED = 0xffa6b7c9;
    static final int BG = 0xff0b1321;
    static final int SURFACE = 0xff121e30;
    static final int EDGE = 0xff2b3d54;
    static final int BLUE = 0xff91c5ff;
    static final int AMBER = 0xffffcb79;
    static final int TEAL = 0xff7ce2cb;

    static int dp(Context context, float value) {
        return Math.round(context.getResources().getDisplayMetrics().density * value);
    }

    static GradientDrawable shape(Context context, int fill, int edge, int radius) {
        GradientDrawable drawable = new GradientDrawable();
        drawable.setColor(fill);
        drawable.setCornerRadius(dp(context, radius));
        if (edge != 0) drawable.setStroke(dp(context, 1), edge);
        return drawable;
    }

    static TextView text(Context context, String value, int size, int color, boolean bold) {
        TextView text = new TextView(context);
        text.setText(value);
        text.setTextSize(size);
        text.setTextColor(color);
        text.setTypeface(Typeface.create(bold ? "sans-serif-medium" : "sans-serif", Typeface.NORMAL));
        return text;
    }

    static LinearLayout toolbar(Context context) {
        LinearLayout bar = new LinearLayout(context);
        bar.setGravity(Gravity.CENTER_VERTICAL);
        bar.setPadding(dp(context, 9), 0, dp(context, 4), 0);
        bar.setBackgroundColor(SURFACE);
        return bar;
    }

    static TextView identity(LinearLayout bar, String caption, String label, int accent) {
        Context context = bar.getContext();
        View mark = new View(context);
        mark.setBackground(shape(context, accent, 0, 2));
        LinearLayout.LayoutParams markParams = new LinearLayout.LayoutParams(dp(context, 3), dp(context, 24));
        markParams.rightMargin = dp(context, 8);
        bar.addView(mark, markParams);
        LinearLayout name = new LinearLayout(context);
        name.setOrientation(LinearLayout.VERTICAL);
        name.setGravity(Gravity.CENTER_VERTICAL);
        TextView category = text(context, caption, 10, accent, true);
        category.setLetterSpacing(0.05f);
        category.setSingleLine(true);
        name.addView(category);
        TextView title = text(context, label, 15, INK, true);
        title.setSingleLine(true);
        title.setAutoSizeTextTypeUniformWithConfiguration(11, 15, 1, android.util.TypedValue.COMPLEX_UNIT_SP);
        title.setEllipsize(TextUtils.TruncateAt.END);
        name.addView(title);
        bar.addView(name, new LinearLayout.LayoutParams(0, -1, 1));
        return title;
    }

    static Button button(Context context, String label, int accent, View.OnClickListener listener) {
        Button button = new Button(context);
        button.setText(label);
        button.setAllCaps(false);
        button.setTextColor(accent);
        button.setTypeface(Typeface.create("sans-serif-medium", Typeface.NORMAL));
        button.setTextSize(13);
        button.setMinWidth(0);
        button.setMinimumWidth(0);
        button.setMinHeight(0);
        button.setMinimumHeight(0);
        button.setPadding(dp(context, 6), 0, dp(context, 6), 0);
        button.setBackground(new RippleDrawable(ColorStateList.valueOf(0x29ffffff),
                shape(context, 0xff1b2a40, EDGE, 10), shape(context, Color.WHITE, 0, 10)));
        button.setOnClickListener(listener);
        return button;
    }

    static Button tool(LinearLayout bar, String label, int accent, View.OnClickListener listener) {
        Context context = bar.getContext();
        Button button = button(context, label, accent, listener);
        button.setSingleLine();
        button.setAutoSizeTextTypeUniformWithConfiguration(10, 13, 1, android.util.TypedValue.COMPLEX_UNIT_SP);
        LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(dp(context, 44), dp(context, 40));
        lp.leftMargin = dp(context, 3);
        bar.addView(button, lp);
        return button;
    }
}
