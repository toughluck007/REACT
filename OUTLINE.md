# REACT
REACT – Reboot Error Analysis &amp; Checkup Tool

Windows Health Center (SFC/DISM + CBS parser)
---------------------------------------------
MVP Goals:
- One-click SFC → (optional) DISM RestoreHealth → SFC again.
- Local install media support.
- Parse CBS.log for issues in plain English.
- Export branded report (HTML/PDF).
Tech & Structure:
- PowerShell 7 + WPF XAML (or WinUI 3/.NET).
- Shared libraries for elevation, logging, reporting.
UI:
- Buttons: Run SFC Only, Run Full Repair.
- Options: Use local media, Create restore point.
- Status: live log + progress bar.
- Export: HTML/PDF report.
Core Workflows:
- Invoke-SfcScan
- Invoke-DismRestoreHealth
- Parse-CbsLog
Roadmap:
- Local WinSxS auto-detection, error knowledge base, history charts, in-place upgrade.
---------------------------------------------
Event Log Detective (Event Viewer + Hints)
---------------------------------------------
MVP Goals:
- Curated filters: BSOD, Disk, Windows Update, Bad Shutdowns, RDP Security.
- Timeline view (24h, 7d, 30d).
- Hints: map EventIDs to plain English.
- Export case bundles (EVTX + reports).
Tech & Structure:
- PowerShell 7 + WPF XAML.
- Modules: EventProfiles, EventQuery, Hints, Exporter.
UI:
- Profiles on left, time selector top, results center, hints right.
- Export and case bundle buttons.
Core Queries:
- BSOD: EventID 41, 1001
- Disk: EventID 7, 11, 51, 55, 153
- Updates: EventID 19, 20, 25, 31
- RDP Security: EventID 4624, 4625
Roadmap:
- Inline GPT-style summaries, correlation timeline, live alerts, remediation scripts, integration with
Health Center.
---------------------------------------------
Shared Components
---------------------------------------------
- Start-LoggedProcess: wrapper for running processes with elevation.
- Logger: rolling log under %ProgramData%.
- Elevation Helper: ensure admin rights.
