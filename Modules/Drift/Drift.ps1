
<#
.SYNOPSIS
    Anti-Distraction Module to combat time wastage on YouTube.

.DESCRIPTION
    This script detects if browser processes have a "YouTube" window title. If so, it presents a
    sophisticated, animated WPF GUI to the user, forcing a conscious decision.

.NOTES
    Author: Gemini
    Date: 2025-12-13
    Version: 3.1 (XAML Fix)
#>

#region --- Setup & Configuration ---
$PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
$LogFilePath = Join-Path -Path $PSScriptRoot -ChildPath "Drift.log"

# Add necessary assemblies for UI and interaction
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName Microsoft.VisualBasic
Add-Type -AssemblyName System.Windows.Forms

function Write-Log {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message
    )
    # Ensure the module's log directory exists
    if (-not (Test-Path -Path $PSScriptRoot -PathType Container)) {
        New-Item -Path $PSScriptRoot -ItemType Directory -Force | Out-Null
    }
    
    $Timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "[$Timestamp] | DRIFT | $Message" | Out-File -FilePath $LogFilePath -Append
}

# List of browsers to check
$BrowserProcesses = @("chrome", "msedge", "firefox", "brave")
$TargetProcess = $null
#endregion

#region --- Core Logic ---
function Close-YouTubeTab {
    param([Parameter(Mandatory=$true)] $Process)
    try {
        Write-Log "Attempting to close YouTube tab in process $($Process.ProcessName) (PID: $($Process.Id))."
        [Microsoft.VisualBasic.Interaction]::AppActivate($Process.Id)
        Start-Sleep -m 100
        [System.Windows.Forms.SendKeys]::SendWait("^{w}")
        Write-Log "Sent 'Ctrl+W' keystroke."
        Start-Sleep -Seconds 1
    } catch {
        Write-Log "Failed to send keystroke. Error: $_"
    }
}

$Processes = Get-Process
foreach ($ProcessName in $BrowserProcesses) {
    $TargetProcess = $Processes | Where-Object { $_.ProcessName -eq $ProcessName -and $_.MainWindowTitle -like "*YouTube*" } | Select-Object -First 1
    if ($null -ne $TargetProcess) {
        break
    }
}

if ($null -eq $TargetProcess) {
    Exit
}
#endregion

#region --- WPF GUI Definition (Animated UI v3.1) ---
[xml]$Xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="SHAKSHI INTERVENTION" Height="380" Width="700"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent"
        WindowStartupLocation="CenterScreen" Topmost="True" ShowInTaskbar="False">

    <Window.Resources>
        <Storyboard x:Key="PulseAnimation">
            <DoubleAnimation Storyboard.TargetName="GlowEffect" Storyboard.TargetProperty="Opacity" From="0.5" To="1.0" Duration="0:0:2" AutoReverse="True" RepeatBehavior="Forever" />
            <DoubleAnimation Storyboard.TargetName="GlowEffect" Storyboard.TargetProperty="BlurRadius" From="15" To="30" Duration="0:0:2" AutoReverse="True" RepeatBehavior="Forever" />
        </Storyboard>
        <Storyboard x:Key="FadeInElements">
            <DoubleAnimation Storyboard.TargetName="ShakshiEye" Storyboard.TargetProperty="Opacity" From="0.0" To="1.0" Duration="0:0:1.5" />
            <DoubleAnimation Storyboard.TargetName="ShakshiText" Storyboard.TargetProperty="Opacity" From="0.0" To="1.0" Duration="0:0:1.5" BeginTime="0:0:0.5" />
            <DoubleAnimation Storyboard.TargetName="MainContent" Storyboard.TargetProperty="Opacity" From="0.0" To="1.0" Duration="0:0:2" BeginTime="0:0:1" />
            <DoubleAnimation Storyboard.TargetName="ActionPanel" Storyboard.TargetProperty="Opacity" From="0.0" To="1.0" Duration="0:0:1.5" BeginTime="0:0:2.5" />
        </Storyboard>
        <Storyboard x:Key="GradientAnimation">
             <DoubleAnimation Storyboard.TargetName="GradientAngle" Storyboard.TargetProperty="Angle" By="360" Duration="0:0:25" RepeatBehavior="Forever" />
        </Storyboard>
    </Window.Resources>

    <Window.Triggers>
        <EventTrigger RoutedEvent="Window.Loaded">
            <BeginStoryboard Storyboard="{StaticResource PulseAnimation}" />
            <BeginStoryboard Storyboard="{StaticResource FadeInElements}" />
            <BeginStoryboard Storyboard="{StaticResource GradientAnimation}" />
        </EventTrigger>
    </Window.Triggers>

    <Border CornerRadius="15" BorderThickness="2">
         <Border.BorderBrush>
            <SolidColorBrush Color="#FF3333" />
        </Border.BorderBrush>
        <Border.Effect>
            <DropShadowEffect x:Name="GlowEffect" Color="#FF3333" ShadowDepth="0" BlurRadius="20" Opacity="0.7" />
        </Border.Effect>
        <Border.Background>
            <LinearGradientBrush StartPoint="0,0" EndPoint="1,1">
                <GradientStop Color="#000000" Offset="0.0" />
                <GradientStop Color="#220033" Offset="1.0" />
                 <LinearGradientBrush.Transform>
                    <RotateTransform x:Name="GradientAngle" Angle="0" CenterX="0.5" CenterY="0.5" />
                </LinearGradientBrush.Transform>
            </LinearGradientBrush>
        </Border.Background>

        <Grid>
            <Grid.RowDefinitions>
                <RowDefinition Height="Auto"/>
                <RowDefinition Height="*"/>
                <RowDefinition Height="Auto"/>
            </Grid.RowDefinitions>

            <!-- TOP BAR -->
            <StackPanel Grid.Row="0" Orientation="Horizontal" Margin="20,15">
                <TextBlock Name="ShakshiEye" Text="👁" FontFamily="Segoe UI Symbol" FontSize="22" Foreground="#EAEAEA" VerticalAlignment="Center" Opacity="0">
                    <TextBlock.Effect>
                         <DropShadowEffect Color="#FF3333" ShadowDepth="0" Opacity="1" BlurRadius="15"/>
                    </TextBlock.Effect>
                </TextBlock>
                <TextBlock Name="ShakshiText" Text="SHAKSHI" Foreground="#EAEAEA" FontSize="18" FontWeight="SemiBold" Margin="15,0,0,0" VerticalAlignment="Center" Opacity="0"/>
            </StackPanel>

            <!-- MAIN CONTENT -->
             <TextBlock Name="MainContent" Grid.Row="1" TextWrapping="Wrap" Foreground="#D0D0D0" FontSize="22" FontWeight="Light"
                       TextAlignment="Center" VerticalAlignment="Center" Margin="40,10" Opacity="0">
                <Run FontWeight="Bold" Foreground="#FFFFFF">Mr. Verma, You Must Accept...</Run><LineBreak/>You are not just exploring. You are wasting precious time, destroying yourself with garbage instead of working toward your responsibility.
             </TextBlock>

            <!-- ACTION PANEL -->
            <StackPanel Grid.Row="2" x:Name="ActionPanel" Orientation="Vertical" Margin="30" Opacity="0">
                <Button x:Name="GoodChoiceButton" Content="Choose the Right Direction" FontWeight="Bold" Margin="5" Padding="15,12">
                     <Button.Style>
                        <Style TargetType="Button">
                            <Setter Property="Background" Value="#FFD700"/>
                            <Setter Property="Foreground" Value="#111111"/>
                            <Setter Property="BorderThickness" Value="0"/>
                            <Setter Property="Cursor" Value="Hand"/>
                            <Setter Property="Template">
                                <Setter.Value>
                                    <ControlTemplate TargetType="Button">
                                        <Border Name="BtnBorder" Background="{TemplateBinding Background}" CornerRadius="5" Padding="{TemplateBinding Padding}">
                                             <Border.Effect>
                                                <DropShadowEffect Color="Black" ShadowDepth="2" BlurRadius="5" Opacity="0.4"/>
                                            </Border.Effect>
                                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                        </Border>
                                    </ControlTemplate>
                                </Setter.Value>
                            </Setter>
                            <Style.Triggers>
                                <Trigger Property="IsMouseOver" Value="True">
                                    <Setter Property="Background" Value="#B8860B"/>
                                </Trigger>
                            </Style.Triggers>
                        </Style>
                    </Button.Style>
                </Button>
                <Button x:Name="BadChoiceButton" Content="Accept Mental Masturbation" FontWeight="Normal" Margin="5" Padding="15,12">
                      <Button.Style>
                        <Style TargetType="Button">
                            <Setter Property="Background" Value="#FF3333"/>
                            <Setter Property="Foreground" Value="#EAEAEA"/>
                            <Setter Property="BorderThickness" Value="0"/>
                            <Setter Property="Cursor" Value="Hand"/>
                             <Setter Property="Template">
                                <Setter.Value>
                                    <ControlTemplate TargetType="Button">
                                        <Border Name="BtnBorder" Background="{TemplateBinding Background}" CornerRadius="5" Padding="{TemplateBinding Padding}">
                                             <Border.Effect>
                                                <DropShadowEffect Color="Black" ShadowDepth="2" BlurRadius="5" Opacity="0.4"/>
                                            </Border.Effect>
                                            <ContentPresenter HorizontalAlignment="Center" VerticalAlignment="Center"/>
                                        </Border>
                                    </ControlTemplate>
                                </Setter.Value>
                            </Setter>
                            <Style.Triggers>
                                <Trigger Property="IsMouseOver" Value="True">
                                    <Setter Property="Background" Value="#C00000"/>
                                </Trigger>
                            </Style.Triggers>
                        </Style>
                    </Button.Style>
                </Button>
            </StackPanel>

            <!-- JUSTIFICATION PANEL (Initially Hidden) -->
            <StackPanel Grid.Row="2" x:Name="JustificationPanel" Orientation="Vertical" Margin="30" Visibility="Collapsed">
                <TextBox x:Name="JustificationBox" MinHeight="50" TextWrapping="Wrap" Background="#1A1A1A" Foreground="#EAEAEA" BorderBrush="#FF3333" BorderThickness="1" Margin="5" Padding="8"/>
                <Button x:Name="SubmitButton" Content="Submit Justification" FontWeight="Bold" Margin="5" Padding="15,12">
                     <Button.Style>
                        <Style TargetType="Button">
                            <Setter Property="Background" Value="#555555"/>
                            <Setter Property="Foreground" Value="#EAEAEA"/>
                            <Setter Property="BorderThickness" Value="0"/>
                            <Setter Property="Cursor" Value="Hand"/>
                            <Style.Triggers>
                                <Trigger Property="IsMouseOver" Value="True">
                                    <Setter Property="Background" Value="#333333"/>
                                </Trigger>
                            </Style.Triggers>
                        </Style>
                    </Button.Style>
                </Button>
            </StackPanel>
        </Grid>
    </Border>
</Window>
"@
#endregion

#region --- GUI Event Handling ---
try {
    Write-Log "YouTube detected in process $($TargetProcess.ProcessName). Launching SHAKSHI Intervention (v3.1)."
    $Reader = (New-Object System.Xml.XmlNodeReader $Xaml)
    $Window = [Windows.Markup.XamlReader]::Load($Reader)

    # Get UI Elements
    $GoodChoiceButton = $Window.FindName("GoodChoiceButton")
    $BadChoiceButton = $Window.FindName("BadChoiceButton")
    $SubmitButton = $Window.FindName("SubmitButton")
    $ActionPanel = $Window.FindName("ActionPanel")
    $JustificationPanel = $Window.FindName("JustificationPanel")
    $JustificationBox = $Window.FindName("JustificationBox")

    # Event Handler for the "Good Choice"
    $GoodChoiceButton.Add_Click({
        Write-Log "User chose the Right Direction (v3.1 UI)."
        Close-YouTubeTab -Process $TargetProcess
        Start-Process "https://www.selectionway.com/user/batches/selection-batch-1/68dbd603f975d67976534e12"
        $Window.Close()
    })

    # Event Handler for the "Bad Choice"
    $BadChoiceButton.Add_Click({
        Write-Log "User chose to Accept Mental Masturbation (v3.1 UI). Awaiting justification."
        $ActionPanel.Visibility = 'Collapsed'
        $JustificationPanel.Visibility = 'Visible'
    })

    # Event Handler for the "Submit" button
    $SubmitButton.Add_Click({
        $Justification = $JustificationBox.Text.Trim()
        if ([string]::IsNullOrWhiteSpace($Justification)) {
            $JustificationBox.BorderBrush = "#FF0000"
            return
        }
        Write-Log "User submitted justification: `"$Justification`" (v3.1 UI)."
        $Window.Close()
    })

    # Make the window blocking
    $Window.ShowDialog() | Out-Null
    Write-Log "SHAKSHI Intervention session ended (v3.1 UI)."

} catch {
    Write-Log "An error occurred in the GUI section (v3.1): $_"
}
#endregion
