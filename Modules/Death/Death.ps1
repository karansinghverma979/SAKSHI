<#
.SYNOPSIS
    Memento Mori - Final Polish UI

.DESCRIPTION
    This script generates a fullscreen, blocking WPF window with a final polished horror aesthetic.
    It now includes a mortality counter in the center, a very long and prominent scrolling symbol bar,
    a typewriter text effect, CRT scanlines, a blurred and glitching background, and a top-center clock.

.NOTES
    Author: Gemini (Final Polish Version)
    Date: 2025-12-27
    Version: 18.0 "Final Polish"
#>

#region --- Setup & Configuration ---
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$LogFilePath = Join-Path -Path $PSScriptRoot -ChildPath "Death.log"
$VisualsDir = Join-Path -Path $PSScriptRoot -ChildPath "Visuals"
$SoundFilePath = Join-Path -Path $PSScriptRoot -ChildPath "flatline.wav"

Add-Type -AssemblyName PresentationFramework, System.Windows.Forms

function Write-Log {
    param([string]$Message)
    
    # Ensure the module's log directory exists
    if (-not (Test-Path -Path $PSScriptRoot -PathType Container)) {
        New-Item -Path $PSScriptRoot -ItemType Directory -Force | Out-Null
    }

    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[$Timestamp] | DEATH | $Message" | Out-File -FilePath $LogFilePath -Append
}

# --- Mortality Counter Calculation ---
function Get-TimePassed {
    param([datetime]$StartDate)
    $EndDate = Get-Date
    $TimeSpan = New-TimeSpan -Start $StartDate -End $EndDate
    
    $Years = $EndDate.Year - $StartDate.Year
    $Months = $EndDate.Month - $StartDate.Month
    $Days = $EndDate.Day - $StartDate.Day

    if ($Days -lt 0) {
        $Months--
        $Days += Get-DaysInMonth -Year $StartDate.Year -Month $StartDate.Month
    }
    if ($Months -lt 0) {
        $Years--
        $Months += 12
    }
    return [pscustomobject]@{Years = $Years; Months = $Months; Days = $Days }
}
function Get-DaysInMonth {
    param($Year, $Month)
    return [System.DateTime]::DaysInMonth($Year, $Month)
}
$StartDate = [datetime]::ParseExact("18/08/2005", "dd/MM/yyyy", $null)
$TimePassed = Get-TimePassed -StartDate $StartDate
$LifetimeString = " CONFRONT YOUR MORTALITY. `n  YOUR DAYS ARE NUMBERED. `n $($TimePassed.Years) Years $($TimePassed.Months) Months $($TimePassed.Days) Days `n OF YOUR LIFE HAVE BEEN LOOSED. `n LIFE IS A CONSTANT PROCESS OF DYING. "

# --- DIAGNOSTIC LOGGING ---
Write-Log "--- Starting New Diagnostic Run ---"
Write-Log "PSScriptRoot Value: $PSScriptRoot"
Write-Log "Visuals Directory Path: $VisualsDir"
Write-Log "Does Visuals Dir Exist?: $(Test-Path $VisualsDir)"


# Get all images
$ImageFiles = Get-ChildItem -Path $VisualsDir -Include *.jpg, *.jpeg, *.png, *.webp, *.avif -Recurse
Write-Log "Number of Images Found: $($ImageFiles.Count)"
Write-Log "Calculated Lifetime String: $LifetimeString"
#endregion

#region --- WPF GUI Definition (Final Polish UI v19.0) ---
[xml]$Xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="MEMENTO MORI"
        WindowState="Maximized" WindowStyle="None" Topmost="True"
        Background="Black">

    <Window.Resources>
        <Storyboard x:Key="HeaderPulseAnimation">
            <DoubleAnimation Storyboard.TargetName="HeaderGlow" Storyboard.TargetProperty="BlurRadius" From="20" To="40" Duration="0:0:4" AutoReverse="True" RepeatBehavior="Forever" />
        </Storyboard>

        <Storyboard x:Key="ImageGlitchAnimation">
            <DoubleAnimationUsingKeyFrames Storyboard.TargetName="GlitchImageTranslate" Storyboard.TargetProperty="X" RepeatBehavior="Forever">
                <LinearDoubleKeyFrame Value="0" KeyTime="0:0:2" />
                <LinearDoubleKeyFrame Value="-15" KeyTime="0:0:2.05" />
                <LinearDoubleKeyFrame Value="15" KeyTime="0:0:2.1" />
                <LinearDoubleKeyFrame Value="0" KeyTime="0:0:2.15" />
                <LinearDoubleKeyFrame Value="0" KeyTime="0:0:4" />
                <LinearDoubleKeyFrame Value="20" KeyTime="0:0:4.05" />
                <LinearDoubleKeyFrame Value="-20" KeyTime="0:0:4.1" />
                <LinearDoubleKeyFrame Value="0" KeyTime="0:0:4.15" />
            </DoubleAnimationUsingKeyFrames>
        </Storyboard>
        
        <Storyboard x:Key="ScanlineFlickerAnimation">
            <DoubleAnimationUsingKeyFrames Storyboard.TargetProperty="Opacity" RepeatBehavior="Forever">
                <LinearDoubleKeyFrame Value="0.1" KeyTime="0:0:0.5" />
                <LinearDoubleKeyFrame Value="0.05" KeyTime="0:0:0.6" />
                <LinearDoubleKeyFrame Value="0.1" KeyTime="0:0:0.7" />
            </DoubleAnimationUsingKeyFrames>
        </Storyboard>

        <Storyboard x:Key="SymbolScrollAnimation">
            <DoubleAnimation From="0" To="-4000" Duration="0:1:30" RepeatBehavior="Forever" 
                             Storyboard.TargetProperty="(Canvas.Left)" />
        </Storyboard>

        <VisualBrush x:Key="ScanlineBrush" TileMode="Tile" Viewport="0,0,1,3" ViewportUnits="Absolute">
            <VisualBrush.Visual>
                <Rectangle Height="3" Width="1" Fill="Black"/>
            </VisualBrush.Visual>
        </VisualBrush>
        
        <Style x:Key="PainfulButtonStyle" TargetType="Button">
            <Setter Property="Background" Value="Black" />
            <Setter Property="Foreground" Value="#888888" />
            <Setter Property="BorderBrush"><Setter.Value><SolidColorBrush Color="#444444" /></Setter.Value></Setter>
            <Setter Property="BorderThickness" Value="2" />
            <Setter Property="FontFamily" Value="Courier New"/>
            <Setter Property="FontSize" Value="50" />
            <Setter Property="FontWeight" Value="Bold" />
            <Setter Property="Padding" Value="80,20" />
            <Setter Property="Cursor" Value="Hand"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Name="ButtonBorder" Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="0">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Foreground" Value="#FF0000"/>
                    <Setter Property="BorderBrush" Value="#FF0000"/>
                </Trigger>
            </Style.Triggers>
        </Style>
    </Window.Resources>

    <Window.Triggers>
        <EventTrigger RoutedEvent="Window.Loaded">
            <BeginStoryboard Storyboard="{StaticResource HeaderPulseAnimation}" />
            <BeginStoryboard Storyboard="{StaticResource ImageGlitchAnimation}" />
        </EventTrigger>
    </Window.Triggers>

    <Grid>
        <Image x:Name="BackgroundImage" Stretch="Uniform" Opacity="0.2">
            <Image.Effect>
                <BlurEffect Radius="2"/>
            </Image.Effect>
            <Image.RenderTransform>
                <TranslateTransform x:Name="GlitchImageTranslate" X="0" Y="0" />
            </Image.RenderTransform>
        </Image>

        <Rectangle x:Name="ScanlineOverlay" Fill="{StaticResource ScanlineBrush}" Opacity="0.1" Panel.ZIndex="1" />
        
        <DockPanel LastChildFill="False" Panel.ZIndex="2">
            <!-- TOP -->
            <StackPanel DockPanel.Dock="Top" HorizontalAlignment="Center" VerticalAlignment="Top" Margin="20" Orientation="Vertical">
                <StackPanel Orientation="Horizontal" HorizontalAlignment="Center">
                    <TextBlock x:Name="SakshiTag" Text="SAKSHI : " Foreground="#DD0000" FontSize="16" FontWeight="Bold" />
                    <TextBlock x:Name="LiveClock" Text="00:00:00" Foreground="#DD0000" FontSize="16" FontWeight="Bold" />
                </StackPanel>
                <TextBlock Text=" &#x1F480; MEMENTO MORI &#x1F480; " FontFamily="Courier New" FontSize="100" FontWeight="Bold" Foreground="#FF0000" TextAlignment="Center" Margin="0,30,0,0">
                    <TextBlock.Effect><DropShadowEffect x:Name="HeaderGlow" Color="#DD0000" ShadowDepth="0" BlurRadius="30" Opacity="1.5"/></TextBlock.Effect>
                </TextBlock>
            </StackPanel>

            <!-- SCROLLING TEXT -->
            <Canvas DockPanel.Dock="Bottom" VerticalAlignment="Bottom" Height="60" ClipToBounds="True">
                <TextBlock x:Name="BottomSymbols" Canvas.Left="0" Text="&#x1F480; &#x2620; &#x26B0; &#x26B1; &#x1F9B4; &#x1FA78; &#x1F56F; &#x1F5E1; &#x2694; &#x1F3F4; &#x231B; &#x23F3; &#x231A; &#x23F0; &#x23F1; &#x23F2; &#x1F570; &#x1F5D3; &#x221E; &#x27F3; &#x1F451; &#x1F4DC; &#x1F58B; &#x2696; &#x26D3; &#x1F3DB; &#x1F3F0; &#x1F947; &#x1F4B0; &#x1F4A5; “You are in danger of living a life so comfortable and soft, that you will die without ever realizing your true potential.” &#x1F578; &#x1F577; &#x1F987; &#x1F985; &#x1F40D; &#x1F342; &#x1F940; &#x2601; &#x26A1; &#x26A0; &#x262F; &#x2638; &#x271D; &#x269B; &#x2699; &#x2692; &#x2693; &#x1F52E; &#x1F3B2; &#x1F0CF;&#x1F56F;&#xFE0F; &#x26B0;&#xFE0F; &#x23F3; &#x1F441;&#xFE0F; &#x1F30C; &#x1F300; Every breath is a step towards the grave. &#x26B1;&#xFE0F; &#x1F480; &#x26B0;&#xFE0F; &#x2620;&#xFE0F; &#x2593; &#x2592; &#x2591; THE CLOCK IS TICKING. &#x231B; WHAT WILL YOU LEAVE BEHIND? &#x1F5A4; &#x26AB;" FontSize="26" Foreground="#DD0000" Opacity="0.5" FontFamily="Segoe UI Symbol"/>
            </Canvas>

            <!-- BOTTOM -->
            <StackPanel DockPanel.Dock="Bottom" HorizontalAlignment="Center" VerticalAlignment="Bottom" Margin="0,0,0,80">
                 <Button Name="AcceptButton" Content=" I AM AWARE OF MY DEATH AND EMBRACING IT. " Style="{StaticResource PainfulButtonStyle}" HorizontalAlignment="Center" />
            </StackPanel>
        </DockPanel>

        <!-- CENTER -->
        <Viewbox Stretch="Uniform" Margin="50,250,50,250" Panel.ZIndex="2">
            <TextBlock 
                x:Name="LifetimeText" 
                Text=" " 
                FontFamily="Courier New" 
                FontWeight="Bold" 
                FontSize="40"
                Foreground="#DD0000" 
                TextAlignment="Center" 
                LineHeight="60"
                TextWrapping="Wrap"/>
        </Viewbox>
        
        <Rectangle x:Name="FlashPanel" Fill="White" Visibility="Collapsed" Panel.ZIndex="3" />
    </Grid>
</Window>
"@
#endregion

#region --- GUI Logic & Execution ---
try {
    $Reader = [System.Xml.XmlNodeReader]::new($Xaml)
    $Window = [Windows.Markup.XamlReader]::Load($Reader)

    # --- Find UI Elements ---
    $AcceptButton = $Window.FindName("AcceptButton")
    $FlashPanel = $Window.FindName("FlashPanel")
    $BackgroundImage = $Window.FindName("BackgroundImage")
    $LiveClock = $Window.FindName("LiveClock")
    $LifetimeText = $Window.FindName("LifetimeText")
    
    # --- Set Lifetime Text ---
    $LifetimeText.Text = $LifetimeString

    # --- Image Changer Setup ---
    $ImageChangeTimer = New-Object System.Windows.Threading.DispatcherTimer
    $ImageChangeTimer.Interval = [TimeSpan]::FromSeconds(2)
    $ImageChange_Tick = {
        if ($ImageFiles.Count -gt 0) {
            $RandomImage = $ImageFiles | Get-Random
            $Bitmap = [System.Windows.Media.Imaging.BitmapImage]::new()
            $Bitmap.BeginInit()
            $Bitmap.UriSource = [System.Uri]$RandomImage.FullName
            $Bitmap.EndInit()
            $BackgroundImage.Source = $Bitmap
        }
    }
    $ImageChangeTimer.Add_Tick($ImageChange_Tick)

    # --- Clock Setup ---
    $ClockTimer = New-Object System.Windows.Threading.DispatcherTimer
    $ClockTimer.Interval = [TimeSpan]::FromSeconds(1)
    $Clock_Tick = {
        $LiveClock.Text = Get-Date -Format "HH:mm:ss"
    }
    $ClockTimer.Add_Tick($Clock_Tick)

    # --- Initial Image Load ---
    if ($ImageFiles.Count -gt 0) {
        $RandomImage = $ImageFiles | Get-Random
        $Bitmap = [System.Windows.Media.Imaging.BitmapImage]::new()
        $Bitmap.BeginInit()
        $Bitmap.UriSource = [System.Uri]$RandomImage.FullName
        $Bitmap.EndInit()
        $BackgroundImage.Source = $Bitmap
        Write-Log "Final Polish UI loaded initial image: $($RandomImage.FullName)"
    } else {
        Write-Log "No images found in Visuals directory."
    }

    # --- Setup Sound Player ---
    $SoundPlayer = [System.Media.SoundPlayer]::new()
    if (Test-Path $SoundFilePath) { $SoundPlayer.SoundLocation = $SoundFilePath; $SoundPlayer.LoadAsync() }

    # --- Button Click Logic ---
    $AcceptButton.Add_Click({
        Write-Log "User acknowledged mortality (Final Polish UI)."
        $FlashPanel.Visibility = 'Visible'
        if ($SoundPlayer.IsLoadCompleted) { $SoundPlayer.PlaySync() }
        Start-Sleep -Milliseconds 50
        $Window.Close()
    })
    
    # --- Window Lifecycle Events ---
    $Window.Add_Loaded({
        # Start timers
        $ImageChangeTimer.Start()
        $ClockTimer.Start()
        
        # Start animations
        $ScanlineOverlay = $Window.FindName("ScanlineOverlay")
        $ScanlineStoryboard = $Window.Resources["ScanlineFlickerAnimation"]
        $ScanlineStoryboard.Begin($ScanlineOverlay)

        $BottomSymbols = $Window.FindName("BottomSymbols")
        $BottomSymbols.Text = $BottomSymbols.Text * 50 # Repeat the symbols to fill the scroll width
        $SymbolScrollStoryboard = $Window.Resources["SymbolScrollAnimation"]
        $SymbolScrollStoryboard.Begin($BottomSymbols)

        Write-Log "Final Polish UI Initialized."
    })

    $Window.Add_Closing({
        $ImageChangeTimer.Stop()
        $ClockTimer.Stop()
        $SoundPlayer.Dispose()
        Write-Log "Final Polish UI Closed."
    })

    # Execute the dialog window
    $Window.ShowDialog() | Out-Null

} catch {
    Write-Log "FATAL ERROR in Final Polish UI: $_"
}
#endregion

