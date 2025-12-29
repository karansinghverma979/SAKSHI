# SHAKSHI OVERWATCH: AUTOMATION DOCTRINE

> **STATUS:** ACTIVE SERVICE  
> **TYPE:** BACKGROUND DAEMON // DISCIPLINE ENFORCER  
> **ARCHITECT:** KARAN SINGH VERMA

---

## 1. THE PHILOSOPHY
This system is not "software." It is a **Digital Nervous System**.
Its purpose is to act as the **"Shakshi" (Witness)**—the higher consciousness that observes the user's actions without judgment but with absolute awareness. It exists to counter "Onanism" (the wasting of potential) by enforcing discipline through "Overwatch" protocols.

---

## 2. HOW IT WORKS (The Architecture)

### The Brain: `Shakshi.ps1`
* **What is it?** A PowerShell script running in an infinite loop.
* **Where is it?** Hidden in the background.
* **How does it start?** It is registered as a **Windows Scheduled Task** named `Shakshi Overwatch`. It starts automatically when the user logs on and runs 24/7 with `Highest` privileges.

### The Limbs: `/Modules`
Shakshi does not contain the logic for tasks. It acts as a Commander. It checks the time or system state, and if a condition is met, it **triggers** a specific Module located in the `Modules` folder.

**Example Chain of Command:**
1.  **Shakshi** checks clock: *It is XX:00.*
2.  **Shakshi** sends signal: *Execute Protocol 'Death'.*
3.  **Death Module** wakes up: *Calculates mortality % and freezes screen.*
4.  **Shakshi** records event: *Writes to `Logs\Witness.log`.*

---

## 3. DEVELOPMENT PROTOCOL (CRITICAL)
**⚠ WARNING:** This system is LIVE. Do not edit files while the Service is running.

To modify the brain or add new weapons, you must follow the **Surgical SOP**:

### Step 1: HALT THE WATCH

### Check is it running :

Get-ScheduledTask -TaskName "Shakshi Overwatch" | Select-Object TaskName, State

### You must stop the heart before operating.

Stop-ScheduledTask -TaskName "Shakshi Overwatch"

### Restart After Editing

Start-ScheduledTask -TaskName "Shakshi Overwatch"

### 5. DATA MANAGEMENT

Isolation: The Automation sector is self-contained. It uses relative paths ($PSScriptRoot). It can be moved to any drive and will self-repair.

Logs: Every Module manages its own data.

Shakshi records triggers.

Drift records distractions.

Death records acknowledgments.
