<#
.SYNOPSIS
    MODULE: PROXIMITY
    GOAL: Hardware Discipline. Detects Bluetooth audio sinks and forces justification.
.DESCRIPTION
    This script scans for active Bluetooth audio devices. If one is found,
    it presents a WPF notification window to the user, demanding they either
    disconnect or justify their continued use. The interaction is logged.
#>

# --- LOGGING SETUP ---
# Moved to the top to be available globally and immediately.
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$LogFile = Join-Path -Path $PSScriptRoot -ChildPath "Proximity.log"
function Write-ProximityLog {
    param([string]$Message)
    # Ensure the module's log directory exists
    if (-not (Test-Path -Path $PSScriptRoot -PathType Container)) {
        New-Item -Path $PSScriptRoot -ItemType Directory -Force | Out-Null
    }
    $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[$TimeStamp] | PROXIMITY | $Message" | Out-File -FilePath $LogFile -Append -Encoding UTF8
}

# --- SCRIPT ENTRY LOG ---
Write-ProximityLog "Module invoked. Starting execution."

try {
    # --- DETECTION LOGIC ---
    Write-ProximityLog "Scanning for Bluetooth audio devices..."
    # We look for AudioEndpoint devices that are present and enabled.
    # The key is filtering the InstanceId for 'BTHENUM\', which is characteristic of Bluetooth devices managed by Windows.
    $BluetoothAudioDevice = Get-PnpDevice -Class 'AudioEndpoint' -Status 'OK' -ErrorAction SilentlyContinue | Where-Object { 
        $_.Present -eq $true -and $_.FriendlyName -like '*Airdopes*' 
    } | Select-Object -First 1

    # If no device is found, log and exit. This is now a logged action.
    if (-not $BluetoothAudioDevice) {
        Write-ProximityLog "No active Bluetooth audio device found. Exiting."
        Exit
    }

    $DeviceName = $BluetoothAudioDevice.FriendlyName
    Write-ProximityLog "Device found: '$DeviceName'. Proceeding to launch GUI."

    # --- GUI INITIALIZATION ---
    Add-Type -AssemblyName PresentationFramework, WindowsBase, PresentationCore

    # --- XAML DEFINITION ---
    $xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="Proximity Module" Height="280" Width="450"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent"
        ShowInTaskbar="False" Topmost="True" WindowStartupLocation="Manual">

    <Window.Resources>
        <Style x:Key="ActionButton" TargetType="Button">
            <Setter Property="Background" Value="Transparent"/>
            <Setter Property="Foreground" Value="#FF00FF"/>
            <Setter Property="BorderBrush" Value="#FF00FF"/>
            <Setter Property="BorderThickness" Value="1"/>
            <Setter Property="Padding" Value="15,8"/>
            <Setter Property="FontWeight" Value="Bold"/>
            <Setter Property="Template">
                <Setter.Value>
                    <ControlTemplate TargetType="Button">
                        <Border Background="{TemplateBinding Background}" BorderBrush="{TemplateBinding BorderBrush}" BorderThickness="{TemplateBinding BorderThickness}" CornerRadius="3">
                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                        </Border>
                    </ControlTemplate>
                </Setter.Value>
            </Setter>
            <Style.Triggers>
                <Trigger Property="IsMouseOver" Value="True">
                    <Setter Property="Background" Value="#FF00FF"/>
                    <Setter Property="Foreground" Value="Black"/>
                </Trigger>
            </Style.Triggers>
        </Style>
    </Window.Resources>

    <Border CornerRadius="8" BorderThickness="1">
        <Border.BorderBrush>
            <LinearGradientBrush StartPoint="0,0" EndPoint="1,1">
                <GradientStop Color="#FF00FF" Offset="0.0" />
                <GradientStop Color="#00FFFF" Offset="1.0" />
            </LinearGradientBrush>
        </Border.BorderBrush>
        <Border.Effect>
            <DropShadowEffect ShadowDepth="0" Color="#FF00FF" Opacity="0.8" BlurRadius="15"/>
        </Border.Effect>

        <Grid>
            <Grid.Background>
                <LinearGradientBrush StartPoint="0.5,0" EndPoint="0.5,1">
                    <GradientStop Color="#2C003E" Offset="0.0" />
                    <GradientStop Color="#000000" Offset="1.0" />
                </LinearGradientBrush>
            </Grid.Background>

            <!-- Initial View: The main prompt -->
            <StackPanel x:Name="InitialView" Margin="20">
                <TextBlock Text="(( ᯤ ))" FontFamily="Segoe UI Symbol" FontSize="20" Foreground="#FF00FF" HorizontalAlignment="Center"/>
                <TextBlock Text="PROXIMITY MODULE" Foreground="White" FontSize="12" HorizontalAlignment="Center" Margin="0,5,0,10"/>
                <TextBlock x:Name="DeviceDetected" TextWrapping="Wrap" Text="Shakshi Detects: ..." Foreground="#CCCCCC" FontSize="14" HorizontalAlignment="Center" Margin="0,0,0,15"/>
                <TextBlock Text="Karan, you are using a Bluetooth device. Remember your days are numbered. Life is fragile. You cannot waste a minute on stupid consumption. Focus on Mock Tests and Active Learning." TextWrapping="Wrap" Foreground="#A9A9A9" FontSize="13" TextAlignment="Center" LineHeight="20"/>
                
                <StackPanel Orientation="Horizontal" HorizontalAlignment="Center" Margin="0,20,0,0">
                    <Button x:Name="DisconnectButton" Content="DISCONNECT &amp; LEARN" Style="{StaticResource ActionButton}"/>
                    <Button x:Name="DecayButton" Content="CONTINUE DECAY" Style="{StaticResource ActionButton}" Margin="15,0,0,0"/>
                </StackPanel>
            </StackPanel>

            <!-- Justification View: Hidden by default -->
            <StackPanel x:Name="JustificationView" Margin="20" Visibility="Collapsed">
                <TextBlock Text="Why have you chosen self-destruction?" TextWrapping="Wrap" Foreground="White" FontSize="16" HorizontalAlignment="Center" Margin="0,20,0,15"/>
                <TextBox x:Name="JustificationBox" Height="100" TextWrapping="Wrap" VerticalScrollBarVisibility="Auto" Background="#1A1A1A" Foreground="White" BorderBrush="#FF00FF" BorderThickness="1" CaretBrush="White" Padding="5"/>
                <Button x:Name="SubmitButton" Content="SUBMIT JUSTIFICATION" Style="{StaticResource ActionButton}" Margin="0,20,0,0"/>
            </StackPanel>
        </Grid>
    </Border>
</Window>
"@

    # --- GUI LOGIC ---
    $reader = New-Object System.Xml.XmlNodeReader -ArgumentList ([xml]$xaml)
    $window = [System.Windows.Markup.XamlReader]::Load($reader)
    $InitialView = $window.FindName("InitialView")
    $JustificationView = $window.FindName("JustificationView")

    # Set dynamic content
    $window.FindName("DeviceDetected").Text = "Shakshi Detects: $DeviceName"

    # --- EVENT HANDLERS ---
    
    # Button: DISCONNECT & LEARN
    $DisconnectButton = $window.FindName("DisconnectButton")
    $DisconnectButton.add_Click({
        Write-ProximityLog "Choice: Disconnect. User committed to learning."
        $window.Close()
    })

    # Button: CONTINUE DECAY
    $DecayButton = $window.FindName("DecayButton")
    $DecayButton.add_Click({
        $InitialView.Visibility = 'Collapsed'
        $JustificationView.Visibility = 'Visible'
    })

    # Button: SUBMIT JUSTIFICATION
    $SubmitButton = $window.FindName("SubmitButton")
    $JustificationBox = $window.FindName("JustificationBox")
    $SubmitButton.add_Click({
        $justification = $JustificationBox.Text.Trim()
        if ([string]::IsNullOrWhiteSpace($justification)) {
            $justification = "No reason provided."
        }
        Write-ProximityLog "Choice: Continue Decay. Justification: `"$justification`""
        $window.Close()
    })

    # --- WINDOW POSITIONING & LAUNCH ---
    $WorkArea = [System.Windows.SystemParameters]::WorkArea
    $window.Left = $WorkArea.Right - $window.Width - 20
    $window.Top = $WorkArea.Bottom - $window.Height - 20

    Write-ProximityLog "Hardware Discipline Initiated. Launching window."
    [void]$window.ShowDialog()

} catch {
    # If any part of the script fails, it logs the error and exits gracefully.
    $ErrorMessage = $_.Exception.Message
    Write-ProximityLog "FATAL ERROR: $ErrorMessage"
    Exit 1
}