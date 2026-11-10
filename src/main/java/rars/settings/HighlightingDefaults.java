package rars.settings;

import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;
import rars.venus.editors.TokenStyle;

import java.awt.*;
import javax.swing.UIManager;

public final class HighlightingDefaults {
    public static final @NotNull TokenStyle DEFAULT_TEXT_SEGMENT_STYLE = fromBackground(new Color(0xFFFF99));
    public static final @NotNull TokenStyle DEFAULT_DATA_SEGMENT_STYLE = fromBackground(new Color(0x99CCFF));
    public static final @NotNull TokenStyle DEFAULT_REGISTER_STYLE = fromBackground(new Color(0x99CC55));

    private HighlightingDefaults() {
    }

    private static @NotNull TokenStyle fromBackground(final @NotNull Color color) {
        // Foreground is left null so it can be derived from the background (or the
        // current theme/LAF) instead of forcing black, which breaks on dark
        // backgrounds. See {@link #bestForeground(Color)}.
        return new TokenStyle(null, color, false, false, false);
    }

    /**
     * Returns a foreground color that contrasts with the given background. Used
     * when a highlighting style does not specify an explicit foreground.
     */
    public static @NotNull Color bestForeground(final @Nullable Color background) {
        if (background == null) {
            final var lafColor = UIManager.getColor("Label.foreground");
            return lafColor != null ? lafColor : Color.BLACK;
        }
        final double luminance = 0.2126 * background.getRed()
            + 0.7152 * background.getGreen()
            + 0.0722 * background.getBlue();
        return luminance > 127.5 ? Color.BLACK : Color.WHITE;
    }
}
