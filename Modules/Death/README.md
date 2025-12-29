# Module: Death (Memento Mori) v19.0

## 1. Philosophy: Memento Mori
"Memento Mori" is a Latin phrase that translates to "remember you must die." This module is not meant to be morbid, but rather a tool for perspective and motivation.

By presenting a stark, unavoidable reminder of mortality at regular intervals, it forces a conscious acknowledgment of the finite nature of time. The goal is to cut through the trivialities of daily distractions and encourage a focus on what is truly important. The terrifying aesthetic is intentional, designed to create a sense of urgency and desperation, compelling you to act meaningfully rather than letting time slip away.

## 2. Technical Implementation
The script generates a fullscreen, borderless WPF window that remains on top of all other applications, demanding the user's full attention.

### Key Visual Elements:
-   **Dynamic Background**: A random, heavily blurred and semi-transparent image from the `\Visuals` folder is loaded at launch and changes every few seconds. The image has a "glitch" animation and a CRT scanline overlay.
-   **Hierarchical Layout**: The UI is structured using a `DockPanel` to create distinct zones:
    -   **Top**: Displays the "SAKSHI" system tag, a live clock, and the main "MEMENTO MORI" header.
    -   **Center**: A `Viewbox` isolates and focuses all attention on the three-line mortality counter. This is the absolute focal point of the screen.
    -   **Bottom**: The "AWARE" button for user acknowledgment.
    -   **Absolute Bottom**: A perpetually scrolling canvas of desperate symbols and philosophical quotes about mortality.
-   **User Interaction**: The only action is to click the "AWARE" button, which logs the acknowledgment to `Death.log` and closes the window after a brief white flash and flatline sound.

## 3. How to Customize and Upgrade

This guide provides instructions for future modifications. All changes are made within the `Death.ps1` script.

### Changing the Background Image Effects
To change the blurriness and opacity of the background image, find the `<Image x:Name="BackgroundImage"...>` tag in the XAML.

```xml
<Image x:Name="BackgroundImage" Stretch="Uniform" Opacity="0.2">
    <Image.Effect>
        <BlurEffect Radius="2"/>
    </Image.Effect>
    ...
</Image>
```
-   **Opacity**: Change the `Opacity="0.2"` value. `0.0` is fully transparent, `1.0` is fully opaque.
-   **Blurriness**: Change the `Radius="2"` value inside the `<BlurEffect>`. Higher numbers create more blur.

### Editing the Central Counter Text
The three-line counter text is generated in the PowerShell section of the script. Find this block:

```powershell
$LifetimeString = "$($TimePassed.Years)y $($TimePassed.Months)m $($TimePassed.Days)d`nOF YOUR LIFE HAVE BEEN WASTED`nACT ACCORDINGLY"
```
You can change the text content here directly. The `\n` character creates a new line.

### Editing the Scrolling Text
The scrolling text is a single long string inside the `<TextBlock x:Name="BottomSymbols">` tag. You can add or remove quotes and symbols directly in the `Text="..."` attribute.

```xml
<TextBlock x:Name="BottomSymbols" Canvas.Left="0" Text="The worm is your emperor 🕯️ Your empire is of dust..." ... />
```

### Adding a New Text Block
To add new text, you must add a new `<TextBlock>` element to the XAML. The easiest place to add it is within the top `DockPanel` section.

**Example**: To add a new subtitle below the main header:
1. Find the top `StackPanel` inside the `DockPanel`.
2. Add a new `<TextBlock>` as shown below.

```xml
<StackPanel DockPanel.Dock="Top" ...>
    ...
    <TextBlock Text=" 💀 MEMENTO MORI 💀 " ...>
        ...
    </TextBlock>
    <!-- ADD YOUR NEW TEXTBLOCK HERE -->
    <TextBlock 
        Text="Your New Subtitle" 
        FontFamily="Courier New" 
        FontSize="20" 
        Foreground="#888888" 
        TextAlignment="Center" 
        Margin="0,10,0,0" />
</StackPanel>
```

### Changing Fonts and Colors
-   **Button Style**: The button's appearance (font, color, size) is controlled by the `<Style x:Key="PainfulButtonStyle" ...>` block in the `<Window.Resources>` section.
-   **Other Elements**: Most other text elements have their font, size, and color properties set directly on the tag, e.g., `<TextBlock FontSize="16" Foreground="#AA0000" ... />`.

## 4. Changelog
-   **v19.0 - 2025-12-27**:
    -   **Major Refactor**: Overhauled the UI to be more terrifying and focused.
    -   Removed the typewriter text effect to place absolute focus on the central counter.
    -   Restructured the layout using a `DockPanel` for better element isolation.
    -   The mortality counter is now a stark three-line message, centered in a `Viewbox`.
    -   Significantly expanded the scrolling text with more desperate quotes and symbols.
    -   Reordered bottom elements to ensure scrolling text is at the absolute bottom of the screen.
-   **v18.1 - 2025-12-27**:
    -   Standardized fonts and sizes for header, counter, and button.
    -   Adjusted layout for better vertical centering.
    -   Updated and expanded the scrolling text content.
-   **v2.1 and below**: Earlier versions with different UI structures and animations.
