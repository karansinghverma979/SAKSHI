# Proximity Module

This module enforces "Hardware Discipline" by detecting the use of Bluetooth audio devices.

## Logic

1.  **Detection**: The script scans for `AudioEndpoint` Plug-and-Play devices that are active and present on the system. It specifically filters for devices whose `InstanceId` begins with `BTHENUM\`, which is the standard identifier for Windows Bluetooth devices.
2.  **Invocation**: If a Bluetooth audio device is detected, the module launches a WPF (Windows Presentation Foundation) notification window.
3.  **Interaction**: The user is presented with a choice:
    *   **DISCONNECT & LEARN**: Logs the user's intent to disconnect and closes.
    *   **CONTINUE DECAY**: Prompts for a textual justification, logs it, and then closes.
4.  **Logging**: All interactions and errors are logged to `Proximity.log` within this module's directory.
5.  **Silent Exit**: If no relevant device is found, the script exits silently to avoid unnecessary noise when the user is compliant.