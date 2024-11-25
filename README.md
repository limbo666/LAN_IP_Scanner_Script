# LAN IP Scanner Script
## Overview

This Windows batch script is designed to scan and analyze devices on a local network. It identifies active devices, resolves hostnames, and determines device vendors based on MAC address prefixes. The results can be optionally saved to a timestamped text file.

## Features

-   **Network Scanning**: Utilizes native Windows commands to discover devices on the local network.
-   **Device Information Extraction**:
    -   Captures IP and MAC addresses.
    -   Resolves hostnames using the  `ping`  command.
    -   Identifies device vendors from MAC address prefixes.
-   **Vendor Identification**: Includes mappings for common vendors such as TP-Link, Samsung, Intel, Dell, and others.
-   **Results Logging**: Optionally saves the scan results to a text file in a  `results`  directory with a timestamped filename.
-   **User Interaction**: Prompts the user to decide whether to save the results after scanning.

## Usage

1.  **Run the Script**: Execute the batch file in a command prompt with administrative privileges.
2.  **Network Scanning**: The script will automatically scan the network and display active devices.
3.  **Save Results**: After scanning, the user is prompted to save the results. If 'yes' is chosen, the results are saved to a file in the  `results`  directory.

## Dependencies

-   Requires Windows operating system with command prompt access.
-   Utilizes native Windows networking commands such as  `ipconfig`,  `arp`, and  `ping`.

## Limitations

-   Windows-specific implementation.
-   Relies on ARP cache and PING for device discovery.
-   Requires local network access.

## Security Considerations

-   Ensure the script is used only on networks you own or manage.
-   Be mindful of privacy when logging device information.

## Future Improvements

-   Expand vendor MAC prefix database.
-   Enhance hostname resolution techniques.
-   Add network interface selection.
