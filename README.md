# SHAKSHI OVERWATCH: AUTOMATION DOCTRINE

![Status](https://img.shields.io/badge/STATUS-ACTIVE%20SERVICE-brightgreen)
![Clearance](https://img.shields.io/badge/CLEARANCE-ARCHITECT%20ONLY-red)
![System](https://img.shields.io/badge/SYSTEM-POWERSHELL%20CORE-blue)

> **"The Witness sees all. The Witness does not judge. The Witness records."**

---

## 1. THE PHILOSOPHY
**IDENTIFIER:** `SHAKSHI` (The Witness)  
**CLASSIFICATION:** Digital Nervous System // Behavior Enforcer

This system is not mere software. It is a **higher consciousness daemon** designed to run on the host machine. Its purpose is to act as the **"Shakshi"**—an observer that counters "Onanism" (the wasting of potential) and entropy.

It operates on **Zero-Trust Principles**: The user (Karan) is human and fallible. The System (Sakshi) is cold, logical, and absolute.

---

## 2. SYSTEM ARCHITECTURE

### The Brain: `Shakshi.ps1`
* **Role:** Central Command / Scheduler
* **Vector:** Hidden Background Process
* **Privilege Level:** `NT AUTHORITY\SYSTEM` (Highest)
* **Mechanism:** Registered as a **Windows Scheduled Task** that initiates upon user logon. It runs in an infinite loop, monitoring the temporal and system state.

### The Limbs: `/Modules`
Shakshi is the Commander; the Modules are the Soldiers. Shakshi does not execute tasks directly; it triggers **Payloads** based on conditional logic.

**Operational Chain of Command:**
1.  **SURVEILLANCE:** Shakshi checks the clock (e.g., `Time == XX:00`).
2.  **SIGNAL:** Shakshi executes the specific Protocol (e.g., `Start-Process "Modules\Death.ps1"`).
3.  **EXECUTION:** The Module wakes up, performs the action (locks screen, displays mortality stats), and terminates.
4.  **TELEMETRY:** Event is written to `Logs\Witness.log`.

---

## 3. MAINTENANCE SOP & SURGICAL PROTOCOLS

> [!WARNING]
> **CRITICAL SAFETY NOTICE**
> This system is **LIVE**. Attempting to edit source files while the Service is running may result in file corruption or system instability. You must perform a "Heart Stop" before surgery.

### PHASE 1: RECON (Verify Status)
Check if the daemon is currently active.

```powershell
Get-ScheduledTask -TaskName "Shakshi Overwatch" | Select-Object TaskName, State

```

### PHASE 2: HEART STOP (Halt System)

**Mandatory** before editing any `.ps1` files in the directory.

```powershell
Stop-ScheduledTask -TaskName "Shakshi Overwatch"

```

### PHASE 3: RESUSCITATION (Restart System)

After edits are saved, bring the system back online.

```powershell
Start-ScheduledTask -TaskName "Shakshi Overwatch"

```

---

## 4. DATA INTELLIGENCE

**Isolation Protocol:**
The system is self-contained. It utilizes relative paths (`$PSScriptRoot`), allowing the directory to be moved to any drive without breaking the neural pathways.

**Logistics:**
| Log File | Purpose |
| :--- | :--- |
| `Logs\Witness.log` | **Master Ledger.** Records every trigger event initiated by Shakshi. |
| `Logs\Drift.log` | **Failure Record.** Logs instances of distraction or time-wasting. |
| `Logs\Death.log` | **Reality Check.** Records user acknowledgments of mortality reminders. |

---

*Architect: Karan Singh Verma*
*System Version: 1.0.0 (Genesis)*

***

### Why this version is better for you:

1.  **Shield Badges:** I added the `[STATUS]` and `[CLEARANCE]` badges at the top. This immediately signals to anyone viewing the repo that this is a structured, serious project.
2.  **Syntax Highlighting:** The PowerShell commands are now inside ` ```powershell ` blocks. GitHub will color-code them (keywords in blue, strings in brown), making them easier to read and copy.
3.  **Tables:** The "Data Intelligence" section uses a Markdown table for the logs. It looks cleaner and more scientific.
4.  **Alert Block:** The `> [!WARNING]` syntax creates a visual alert box on GitHub, emphasizing the danger of editing live files.

**Action:** Copy the code block above, paste it into your `README.md`, save, commit, and push. Then look at your repo. It will look professional.
