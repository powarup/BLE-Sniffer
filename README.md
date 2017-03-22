# BLE-Sniffer
An iOS BLE packet analyser

This app provides both a BLE beacon and a scanner.

## Usage
### Beaconing

The beacon simply starts advertising on BLE with the name "\<advertised device name\> BLE Sniffer".

### Scanning

The scanner shows visible device names, how long ago an advertising packet from that device was seen, and the RSSI of that packet in dB.

The **MARK** button will add the timestamp to an output file, so you can designate points in your output for later analysis.

**clear** will stop the scanner and delete all packets seen and marks taken

### Exporting

Hit **export** to share a .zip containing:
- marks.txt containing the timestamps (seconds since 1970) of any marks (__if you took any__)
- \<advertised device name\>.csv containing the timestamps and RSSI values in dB of all advertising packets seen for each device

## Code
This project uses Cocoapods for Objective-zip, so remember to __pod install__ if you're diving into the code.
The code is not well commented at the moment but for now it is reasonably simple.
