# Forensics & Reporting Tools

> **Legal Notice:** Only perform forensic analysis on systems and data you are authorized to examine.

Digital forensics involves the collection, preservation, and analysis of digital evidence. Reporting is the final deliverable of any penetration test.

---

## Autopsy — Digital Forensics Platform

GUI-based digital forensics platform built on The Sleuth Kit.

```bash
# Launch Autopsy
autopsy

# Access at: http://localhost:9999/autopsy
# Create new case > add evidence (disk image) > analyze
```

### Key Features
- File system analysis (FAT, NTFS, ext2/3/4)
- Deleted file recovery
- Keyword search
- Web history, email, recent documents
- Hash database (NSRL known good)
- Timeline analysis
- Registry analysis

---

## The Sleuth Kit (TSK) — CLI Forensics

```bash
# List partitions in disk image
mmls disk.img

# List files in filesystem
fls -r -l disk.img

# Extract a specific file by inode
icat disk.img 128 > recovered_file

# Get file metadata
istat disk.img 128

# Recover deleted files
tsk_recover -a disk.img recovered/

# Create timeline
fls -r -m "/" disk.img > timeline_body.txt
mactime -b timeline_body.txt > timeline.txt

# Search for specific string
srch_strings disk.img | grep "password"
```

---

## Foremost — File Carving

Recovers files based on header/footer signatures, regardless of filesystem.

```bash
# Carve all file types from image
foremost -i disk.img -o output/

# Carve specific types
foremost -t jpg,pdf,doc -i disk.img -o output/

# Verbose output
foremost -v -i disk.img -o output/
```

---

## Binwalk — Firmware Analysis & Extraction

```bash
# Scan for embedded files
binwalk firmware.bin

# Extract embedded files
binwalk -e firmware.bin

# Recursive extraction
binwalk -Me firmware.bin

# Entropy analysis (high entropy = encrypted/compressed)
binwalk -E firmware.bin

# Search for strings
binwalk -R "password" firmware.bin
```

---

## Volatility — Memory Forensics

```bash
# Identify OS profile from memory dump
volatility -f memory.dump imageinfo

# List running processes
volatility -f memory.dump --profile=Win7SP1x64 pslist
volatility -f memory.dump --profile=Win7SP1x64 pstree

# List network connections
volatility -f memory.dump --profile=Win7SP1x64 netscan

# Dump process memory
volatility -f memory.dump --profile=Win7SP1x64 memdump -p 1234 -D output/

# Extract registry hives
volatility -f memory.dump --profile=Win7SP1x64 hivelist
volatility -f memory.dump --profile=Win7SP1x64 printkey -K "SOFTWARE\Microsoft\Windows\CurrentVersion"

# Extract password hashes
volatility -f memory.dump --profile=Win7SP1x64 hashdump

# Scan for malware (malfind)
volatility -f memory.dump --profile=Win7SP1x64 malfind

# Command history
volatility -f memory.dump --profile=Win7SP1x64 cmdscan
volatility -f memory.dump --profile=Win7SP1x64 consoles

# Browser history
volatility -f memory.dump --profile=Win7SP1x64 iehistory
```

---

## ExifTool — Metadata Extraction

```bash
# Extract all metadata
exiftool image.jpg

# Extract from multiple files
exiftool *.jpg

# Extract specific tag
exiftool -GPS:All image.jpg
exiftool -Author document.pdf

# Remove all metadata
exiftool -all= image.jpg

# Batch process directory
exiftool -r /path/to/photos/

# Output as CSV
exiftool -csv *.jpg > metadata.csv
```

---

## Steghide — Steganography

```bash
# Hide data in image
steghide embed -cf image.jpg -sf secret.txt
# Enter passphrase when prompted

# Extract hidden data
steghide extract -sf image.jpg
# Enter passphrase when prompted

# Show info (without extracting)
steghide info image.jpg

# Brute force passphrase (using stegcracker)
stegcracker image.jpg /usr/share/wordlists/rockyou.txt
```

---

## Wireshark for Forensics

```bash
# Open captured pcap file
wireshark capture.pcap

# Useful forensic filters:
# Extract HTTP objects: File > Export Objects > HTTP
# Follow TCP stream: Right-click > Follow > TCP Stream
# I/O graph: Statistics > I/O Graphs
# Protocol hierarchy: Statistics > Protocol Hierarchy

# CLI analysis with tshark
tshark -r capture.pcap -T fields -e http.request.uri | sort | uniq
tshark -r capture.pcap -Y http.request.method==POST -T fields -e http.file_data
```

---

## Penetration Test Report Writing

### Report Structure

```
1. Executive Summary (non-technical, for management)
   - Scope and objectives
   - Overall risk rating
   - Key findings summary
   - Recommendations overview

2. Technical Summary
   - Methodology (reconnaissance, scanning, exploitation, post-exploitation)
   - Tools used
   - Timeline

3. Findings (one section per vulnerability)
   - Vulnerability title
   - Risk rating (Critical/High/Medium/Low/Info)
   - Description
   - Evidence (screenshots, commands, output)
   - Impact
   - Remediation recommendation
   - References (CVE, OWASP, etc.)

4. Appendices
   - Scan results (nmap, nikto, etc.)
   - Tool outputs
   - Network diagrams
```

### Risk Rating Scale

| Rating | CVSS Score | Description |
|--------|-----------|-------------|
| Critical | 9.0-10.0 | Immediate exploitation, severe impact |
| High | 7.0-8.9 | Significant impact, easily exploitable |
| Medium | 4.0-6.9 | Limited impact or requires special conditions |
| Low | 0.1-3.9 | Minimal impact |
| Informational | N/A | Best practice issues |

### Useful Tools for Reporting

```bash
# CherryTree (notes during assessment)
cherrytree

# Dradis (collaborative reporting)
dradis

# Faraday (automated report aggregation)
faraday

# Screenshot tool
scrot screenshot.png
import -window root screenshot.png   # ImageMagick
```

---

## Hash Verification (Evidence Integrity)

```bash
# Generate MD5 hash of evidence
md5sum disk.img > disk.img.md5
sha256sum disk.img > disk.img.sha256

# Verify integrity
md5sum -c disk.img.md5

# Hash a directory recursively
find /evidence -type f -exec sha256sum {} \; > manifest.txt
```

---

## Resources
- [Volatility Documentation](https://github.com/volatilityfoundation/volatility/wiki)
- [Digital Forensics with Kali — SANS Reading Room](https://www.sans.org/white-papers/)
- [TryHackMe — Digital Forensics](https://tryhackme.com/room/digitalforensiccase001b)
- [HackTheBox — Forensics Challenges](https://app.hackthebox.com/challenges)
- [CyberDefenders — Forensics Labs](https://cyberdefenders.org/)
