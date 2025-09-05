Add-Type -AssemblyName PresentationFramework

$script:AppRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
Import-Module "$AppRoot/HealthCenter.psm1" -Force

[xml]$xaml = Get-Content "$AppRoot/REACT.xaml"
$reader = (New-Object System.Xml.XmlNodeReader $xaml)
$window = [Windows.Markup.XamlReader]::Load($reader)

$RunSfcButton = $window.FindName('RunSfcButton')
$RunFullRepairButton = $window.FindName('RunFullRepairButton')
$UseLocalMediaCheckbox = $window.FindName('UseLocalMediaCheckbox')
$CreateRestorePointCheckbox = $window.FindName('CreateRestorePointCheckbox')
$LogBox = $window.FindName('LogBox')
$ProgressBar = $window.FindName('ProgressBar')
$StatusText = $window.FindName('StatusText')

$appendLog = {
    param($line)
    $LogBox.AppendText($line + "`n")
    $LogBox.ScrollToEnd()
}

$RunSfcButton.Add_Click({
    $StatusText.Text = 'Running SFC...'
    Invoke-SfcScan -LogAction $appendLog
    $StatusText.Text = 'SFC completed.'
})

$RunFullRepairButton.Add_Click({
    $StatusText.Text = 'Running DISM...'
    $source = if ($UseLocalMediaCheckbox.IsChecked) { 'WIM:???' } else { $null }
    Invoke-DismRestoreHealth -Source $source -LogAction $appendLog
    $StatusText.Text = 'Running SFC...'
    Invoke-SfcScan -LogAction $appendLog
    $StatusText.Text = 'Full repair completed.'
})

$window.ShowDialog() | Out-Null
