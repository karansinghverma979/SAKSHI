# Module: Drift (v3.1)

## Purpose
**Drift** is an anti-distraction mechanism integrated into the SHAKSHI automation system. Its primary function is to detect when the user is engaging with YouTube and to present a forced, conscious choice via a sophisticated, animated user interface.

## Logic Flow
1.  **Detection**: The script scans the window titles of browser processes (`chrome`, `msedge`, `firefox`, `brave`).
2.  **Trigger**: If "YouTube" is found, the intervention GUI is launched, targeting the specific browser process.
3.  **Silent Exit**: If no YouTube activity is detected, the script terminates silently.

## The Intervention GUI (v3.1 - Animated Overhaul)
The GUI is a borderless, "dark mode" WPF window, significantly enhanced with animations to be more graceful, beautiful, and visually arresting.

### UI Animations & Effects:
-   **Pulsating Glow**: The red outer border emits a slow, rhythmic "heartbeat" glow.
-   **Rotating Gradient**: The background features a slowly rotating, deep purple gradient, creating a dynamic, mesmerizing effect.
-   **Graceful Fade-In**: All UI elements, from the SHAKSHI icon to the text and buttons, fade in sequentially, providing a more polished and less jarring user experience.

### User Choices:
-   **"Choose the Right Direction"**: This option is for immediate course correction.
    -   **Action**: Attempts to close the active YouTube tab by sending a `Ctrl+W` keystroke to the browser window. It then opens the default web browser to: `https://www.selectionway.com/user/batches/selection-batch-1/68dbd603f975d67976534e12`
    -   **Result**: The choice is logged, and the intervention window closes.

-   **"Accept Mental Masturbation"**: This option acknowledges the choice to be distracted but requires accountability.
    -   **Action**: It reveals a textbox and a "Submit" button.
    -   **Requirement**: The user **must** type a justification. The input box will be highlighted in red if submitted empty.
    -   **Result**: The justification is logged, and the window closes.

## Logging
All actions are timestamped in `Drift.log`, including trigger events, user choices, and justifications.

## Changelog
- **v3.1 - 2025-12-13**:
    - **Fix**: Corrected a XAML error where the `Background` property was set twice on the main border, causing the UI to fail.
- **v3.0 - 2025-12-13**:
    -   **Major UI Overhaul**: Replaced the static UI with a fully animated version.
    -   Added a pulsating border glow, a rotating gradient background, and a staggered fade-in animation for all UI elements.
    -   Refined button templates and text effects for a more premium, graceful appearance.
- **v2.1 - 2025-12-13**:
    -   **Fix**: Corrected a XAML error to prevent GUI loading failures.
- **v1.0 - 2025-12-13**: Initial creation.