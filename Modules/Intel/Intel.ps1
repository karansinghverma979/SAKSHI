<#
.SYNOPSIS
    MODULE: INTEL (Incremental UI, Step 1 with Heavy Debug Logging)
    GOAL: Active Recall. Forces the user to answer a series of questions to proceed.
#>

# --- INITIALIZATION ---
try {
    $PSScriptRoot = Split-Path -Parent -Path $MyInvocation.MyCommand.Definition
    # --- LOGGING SETUP ---
    $LogFile = Join-Path -Path $PSScriptRoot -ChildPath "Intel.log"
    # Clear the log for a clean test run
    Clear-Content -Path $LogFile -ErrorAction SilentlyContinue
    function Write-IntelLog {
        param([string]$Message)
        # Ensure the module's log directory exists
        if (-not (Test-Path -Path $PSScriptRoot -PathType Container)) {
            New-Item -Path $PSScriptRoot -ItemType Directory -Force | Out-Null
        }
        $TimeStamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
        "[$TimeStamp] | INTEL | $Message" | Out-File -FilePath $LogFile -Append -Encoding UTF8
    }
    # --- DATA HANDLING ---
    Write-IntelLog "Script started. Loading questions."
    $QuestionsFile = Join-Path -Path $PSScriptRoot -ChildPath "Questions.json"
    if (-not (Test-Path $QuestionsFile)) { Write-IntelLog "FATAL: Questions.json not found."; Exit 1 }
    $allQuestions = Get-Content -Path $QuestionsFile -Raw | ConvertFrom-Json
    $selectedQuestions = $allQuestions | Get-Random -Count 5
    Write-IntelLog "Questions loaded and randomized successfully."
    # --- STATE MANAGEMENT ---
    $script:currentQuestionIndex = 0
    $collectedAnswers = @{}
    # --- GUI INITIALIZATION ---
    Add-Type -AssemblyName PresentationFramework, WindowsBase, PresentationCore

    # --- XAML (STEP 1: BORDERLESS WINDOW, BACKGROUND, AND TEXT COLORS) ---
    $xaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
        xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
        Title="INTEL CHECK" Height="350" Width="600"
        WindowStartupLocation="CenterScreen" Topmost="True"
        WindowStyle="None" AllowsTransparency="True" Background="Transparent">
    <Border BorderBrush="#00FFFF" BorderThickness="1" Background="#001133">
        <StackPanel Margin="15">
            <TextBlock Text="INTEL CHECK // ANSWER TO PROCEED" FontWeight="Bold" FontSize="14" HorizontalAlignment="Center" Foreground="#00FFFF"/>
            <TextBlock x:Name="ProgressText" Text="QUESTION 1 / 5" FontSize="10" HorizontalAlignment="Left" Margin="0,15,0,5" Foreground="#FFA500"/>
            <TextBlock x:Name="QuestionText" Text="Loading question..." FontSize="18" TextWrapping="Wrap" MinHeight="80" Foreground="White"/>
            <TextBox x:Name="AnswerBox" MinHeight="40" FontSize="14" Margin="0,10,0,10"/>
            <Button x:Name="SubmitButton" Content="SUBMIT" Height="40" FontSize="16" FontWeight="Bold"/>
        </StackPanel>
    </Border>
</Window>
"@

    # --- GUI LOGIC ---
    Write-IntelLog "Preparing to load XAML."
    $reader = New-Object System.Xml.XmlNodeReader -ArgumentList ([xml]$xaml)
    $window = [System.Windows.Markup.XamlReader]::Load($reader)
    Write-IntelLog "XAML loaded. Window object created."

    if ($null -eq $window) {
        Write-IntelLog "FATAL ERROR: XamlReader::Load returned null."
        Exit 1
    }

    $ProgressText = $window.FindName("ProgressText")
    $QuestionText = $window.FindName("QuestionText")
    $AnswerBox = $window.FindName("AnswerBox")
    $SubmitButton = $window.FindName("SubmitButton")
    Write-IntelLog "UI elements successfully found."

    function Update-QuestionView {
        Write-IntelLog "Entering Update-QuestionView for index $script:currentQuestionIndex."
        $ProgressText.Text = "QUESTION $($script:currentQuestionIndex + 1) / $($selectedQuestions.Count)"
        Write-IntelLog "ProgressText updated."
        $QuestionText.Text = $selectedQuestions[$script:currentQuestionIndex]
        Write-IntelLog "QuestionText updated."
        $AnswerBox.Focus()
        Write-IntelLog "AnswerBox focused. Leaving Update-QuestionView."
    }

    $SubmitButton.add_Click({
        Write-IntelLog "SubmitButton clicked. Current index: $script:currentQuestionIndex."
        $answer = $AnswerBox.Text.Trim()
        Write-IntelLog "Answer retrieved: '$answer'."

        if ([string]::IsNullOrWhiteSpace($answer)) {
            Write-IntelLog "Answer is blank. Playing sound."
            [System.Media.SystemSounds]::Beep.Play()
        } else {
            Write-IntelLog "Answer is valid. Storing answer."
            $collectedAnswers[$selectedQuestions[$script:currentQuestionIndex]] = $answer
            $AnswerBox.Clear()
            Write-IntelLog "Answer stored and AnswerBox cleared."
            
            $script:currentQuestionIndex++
            Write-IntelLog "Index incremented to $script:currentQuestionIndex."

            if ($script:currentQuestionIndex -lt $selectedQuestions.Count) {
                Write-IntelLog "More questions remaining. Calling Update-QuestionView."
                Update-QuestionView
            } else {
                Write-IntelLog "All questions answered. Beginning success sequence."
                $SubmitButton.Content = "SUCCESS"
                $SubmitButton.IsEnabled = $false
                Write-IntelLog "Intel check completed successfully message logged."
                foreach ($q in $collectedAnswers.Keys) { Write-IntelLog "Q: '$q' -> A: '$($collectedAnswers[$q])'" }
                $closeTimer = New-Object System.Windows.Threading.DispatcherTimer
                $closeTimer.Interval = [TimeSpan]::FromSeconds(1)
                $closeTimer.add_Tick({ $window.Close() })
                $closeTimer.Start()
                Write-IntelLog "Close timer started."
            }
        }
        Write-IntelLog "Click handler finished."
    })

    # --- WINDOW LAUNCH ---
    Write-IntelLog "Calling Update-QuestionView for the first time."
    Update-QuestionView
    Write-IntelLog "Initial Update-QuestionView finished. Calling ShowDialog."
    [void]$window.ShowDialog()
    Write-IntelLog "ShowDialog finished. Window closed."

} catch {
    $ErrorMessage = $_.Exception.Message
    $StackTrace = $_.Exception.StackTrace
    Write-IntelLog "FATAL ERROR: $ErrorMessage `nStackTrace: $StackTrace"
    Exit 1
}
