Perform an OWASP Top 10 focused security scan on this codebase. Identify vulnerabilities and provide actionable remediation.

## Scan Checklist

### A01: Broken Access Control
- [ ] Missing authorization checks on endpoints
- [ ] IDOR (Insecure Direct Object Reference) vulnerabilities
- [ ] Missing CORS configuration or overly permissive origins
- [ ] Privilege escalation paths

### A02: Cryptographic Failures
- [ ] Sensitive data transmitted without TLS
- [ ] Weak hashing algorithms (MD5, SHA1 for passwords)
- [ ] Hardcoded secrets, API keys, credentials in source code
- [ ] Secrets in client-side code or public environment variables

### A03: Injection
- [ ] SQL injection (raw string interpolation in queries)
- [ ] Command injection (unsanitized input in shell commands)
- [ ] XSS (unescaped user input in HTML/templates)
- [ ] Path traversal (user input in file paths)

### A04: Insecure Design
- [ ] Missing rate limiting on auth endpoints
- [ ] No account lockout after failed attempts
- [ ] Missing CSRF protection on state-changing operations

### A05: Security Misconfiguration
- [ ] Debug mode enabled in production config
- [ ] Default credentials or configurations
- [ ] Unnecessary features, ports, or services exposed
- [ ] Missing security headers (CSP, HSTS, X-Frame-Options)

### A06: Vulnerable Components
- [ ] Run `npm audit` / `pip audit` / equivalent for known CVEs
- [ ] Outdated dependencies with known vulnerabilities
- [ ] Unmaintained or abandoned dependencies

### A07: Auth Failures
- [ ] Weak password policies
- [ ] Missing MFA options
- [ ] Session tokens in URLs
- [ ] JWT misconfiguration (alg:none, weak secrets, no expiry)

### A08: Data Integrity Failures
- [ ] Unsigned updates or deployments
- [ ] Missing integrity checks on critical data

### A09: Logging & Monitoring Gaps
- [ ] Sensitive data logged (tokens, passwords, PII)
- [ ] Missing audit logs for critical operations
- [ ] No alerting on suspicious activity

### A10: SSRF
- [ ] User-supplied URLs fetched server-side without validation
- [ ] Internal service endpoints exposed

## Output Format

For each finding:
```
[CRITICAL|HIGH|MEDIUM|LOW] Category — Brief description
  Location: file.ts:42
  Risk: What an attacker could do
  Fix: Specific remediation steps
```

---
Nox