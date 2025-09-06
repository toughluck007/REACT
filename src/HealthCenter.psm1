function Start-LoggedProcess {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$FilePath,
        [string[]]$ArgumentList = @(),
        [ScriptBlock]$LogAction
    )

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName = $FilePath
    $psi.Arguments = $ArgumentList -join ' '
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError = $true
    $psi.UseShellExecute = $false
    $psi.CreateNoWindow = $true

    $proc = New-Object System.Diagnostics.Process
    $proc.StartInfo = $psi
    $proc.Start() | Out-Null

    while (-not $proc.HasExited) {
        $line = $proc.StandardOutput.ReadLine()
        if ($line -ne $null -and $LogAction) {
            & $LogAction $line
        }
    }
    $proc.WaitForExit()

    while (($line = $proc.StandardOutput.ReadLine()) -ne $null) {
        if ($LogAction) {
            & $LogAction $line
        }
    }
    while (($line = $proc.StandardError.ReadLine()) -ne $null) {
        if ($LogAction) {
            & $LogAction $line
        }
    }

    return $proc.ExitCode
}

function Invoke-SfcScan {
    [CmdletBinding()]
    param(
        [ScriptBlock]$LogAction
    )
    if ($LogAction) { & $LogAction 'Running: sfc /scannow' }
    Start-LoggedProcess -FilePath "sfc.exe" -ArgumentList '/scannow' -LogAction $LogAction | Out-Null
    if ($LogAction) { & $LogAction 'SFC scan complete. Parsing CBS log...' }
    foreach ($line in Parse-CbsLog) {
        if ($LogAction) { & $LogAction $line }
    }
}

function Invoke-DismRestoreHealth {
    [CmdletBinding()]
    param(
        [string]$Source,
        [ScriptBlock]$LogAction
    )
    $args = @('/Online','/Cleanup-Image','/RestoreHealth')
    if ($Source) {
        $args += "/Source:$Source"
        $args += '/LimitAccess'
    }
    Start-LoggedProcess -FilePath 'DISM.exe' -ArgumentList $args -LogAction $LogAction | Out-Null
}

function Parse-CbsLog {
    [CmdletBinding()]
    param(
        [string]$LogPath = "$env:windir\\Logs\\CBS\\CBS.log"
    )
    if (-not (Test-Path $LogPath)) {
        return @()
    }
    Get-Content $LogPath | Where-Object { $_ -like '*[SR]*' }
}

Export-ModuleMember -Function Start-LoggedProcess,Invoke-SfcScan,Invoke-DismRestoreHealth,Parse-CbsLog
