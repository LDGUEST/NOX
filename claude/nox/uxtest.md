---
name: uxtest
description: Performs comprehensive UX testing via Playwright — user journeys, responsive design, WCAG 2.1 AA accessibility audit, and interaction bugs. Use when verifying UI quality before a release, after major frontend changes, or auditing accessibility compliance.
argument-hint: "[url-or-component]"
context: fork
agent: general-purpose
metadata:
  author: nox
  version: "2.0"
---

Perform comprehensive interactive UX testing using Playwright. This goes far beyond screenshot checks — it simulates real user journeys, tests responsive behavior, validates accessibility, and catches interaction bugs that static analysis and unit tests miss entirely.

## When to Use

- After building or modifying any user-facing feature
- Before any production deploy of UI changes
- When the user says "test the UX", "check the frontend", "does this look right?"
- As part of `/nox:full-phase` when deeper visual testing is needed beyond the UX Gate screenshot
- When debugging a reported UI bug — reproduce it systematically

## Testing Protocol

### Phase 1: Discovery

Before testing, understand what you're testing:

1. **Identify the app URL** — `localhost:3000`, `$DEPLOY_URL`, or ask the user
2. **Detect the stack** — Next.js, React, Vue, Svelte, plain HTML (check package.json, framework markers)
3. **Map the routes** — Read the router config, sitemap, or crawl from the homepage
4. **Identify critical user flows** — login, signup, checkout, main dashboard, CRUD operations
5. **Check for existing test fixtures** — seed data, test accounts, mock APIs

### Phase 2: Visual Audit (every affected page)

For each page/route affected by recent changes:

**Responsive breakpoints** — Screenshot at:
- Mobile: 375×812 (iPhone SE / small)
- Tablet: 768×1024 (iPad)
- Desktop: 1280×800 (standard)
- Wide: 1920×1080 (full HD)

**Visual checks per breakpoint:**
- [ ] Layout doesn't break — no horizontal scroll, no overlapping elements
- [ ] Text is readable — no truncation, no overflow, proper contrast
- [ ] Images load and are sized correctly — no broken images, no layout shift
- [ ] Navigation is accessible — hamburger menu works on mobile, all links visible
- [ ] Interactive elements are tappable — buttons have adequate touch targets (min 44×44px)
- [ ] Forms are usable — labels visible, inputs not cut off, error states shown
- [ ] Dark mode (if applicable) — check both themes
- [ ] Loading states — skeleton screens, spinners, or progressive loading visible
- [ ] Empty states — what does the page look like with no data?
- [ ] Error states — what does the page look like when the API fails?

### Phase 3: Interaction Testing (critical flows)

Use Playwright to simulate real user behavior. For each critical flow:

**Navigation:**
- Click every link on the page — verify no dead links (404s)
- Test browser back/forward — does state persist correctly?
- Test deep linking — can you land directly on a sub-route and have it work?

**Forms:**
- Submit with valid data — verify success state
- Submit with empty required fields — verify validation messages appear
- Submit with invalid data (wrong email format, too-short password) — verify inline errors
- Tab through all fields — verify focus order is logical
- Test paste into fields — verify it works (some custom inputs break this)
- Test autofill — verify browser autofill doesn't break the layout

**Interactive elements:**
- Click every button — verify it does something (no dead buttons)
- Test dropdowns, modals, tooltips — verify they open, position correctly, and close
- Test keyboard navigation — can you reach every interactive element with Tab?
- Test Escape key — does it close modals, dropdowns, popovers?
- Test double-click prevention — does clicking "Submit" twice cause duplicate submissions?

**Dynamic content:**
- Scroll to bottom — does infinite scroll / pagination work?
- Test search — does it filter results, handle empty results, clear properly?
- Test sorting — does it sort correctly, persist across navigation?
- Test real-time updates — if applicable, do WebSocket/SSE updates render correctly?

### Phase 4: Accessibility Audit (WCAG 2.1 AA)

Run these checks on every affected page. Detect the UI framework (React, Vue, Svelte, Angular, plain HTML) and adjust checks accordingly.

**4a. Automated scanning:**
- Run Axe accessibility scanner via Playwright (`@axe-core/playwright`)
- Check for: missing alt text, low contrast, missing form labels, missing ARIA roles, heading hierarchy violations

**4b. Semantic HTML:**
- Heading hierarchy — `h1` through `h6` used in order, no skipped levels
- Landmark regions — `<main>`, `<nav>`, `<header>`, `<footer>`, `<aside>` used appropriately
- Lists — Related items use `<ul>`/`<ol>`/`<li>`, not `<div>` chains
- Buttons vs links — `<button>` for actions, `<a>` for navigation. No `<div onClick>` without a role
- Tables — Data tables use `<th>`, `scope`, and `<caption>`

**4c. ARIA:**
- Missing roles — Interactive custom elements without `role` attribute
- Missing labels — `aria-label` or `aria-labelledby` absent on icon buttons, inputs, regions
- Invalid ARIA — `aria-*` attributes that don't match the element's role
- Redundant ARIA — `role="button"` on a `<button>` (unnecessary)
- Live regions — Dynamic content updates without `aria-live` announcement
- Dialog/modal — Missing `aria-modal`, `role="dialog"`, or focus trap

**4d. Keyboard navigation:**
- [ ] Tab order — Interactive elements reachable via Tab in logical order
- [ ] Focus indicators — `:focus-visible` styles present, not removed with `outline: none` without replacement
- [ ] Keyboard handlers — `onClick` without corresponding `onKeyDown`/`onKeyUp` for custom elements
- [ ] Skip links — "Skip to main content" link present on pages with navigation
- [ ] Escape to close — Modals, dropdowns, and popovers close on `Escape` key
- [ ] Focus trapping — Modals trap focus within the dialog while open
- [ ] Focus restoration — Focus returns to trigger element when modal/popover closes

**4e. Images & media:**
- All `<img>` elements have `alt` attribute. Decorative images use `alt=""`
- Alt text describes content, not "image" or the filename
- SVGs have `role="img"` and `aria-label`, or `aria-hidden="true"` if decorative
- Video/audio — Captions or transcript available

**4f. Forms:**
- Every input has an associated `<label>` (via `htmlFor`/`for` or wrapping)
- Error messages linked to inputs via `aria-describedby`
- Required fields marked with `aria-required="true"` or `required`
- Related inputs (radio groups, checkbox groups) wrapped in `<fieldset>` with `<legend>`
- Common fields have appropriate `autoComplete` attribute

**4g. Color & contrast:**
- Text contrast meets WCAG AA (4.5:1 for normal text, 3:1 for large text)
- Information not conveyed by color alone (error states, status indicators need text/icon too)
- Focus indicators have sufficient contrast against the background

**4h. Motion & animation:**
- Animations respect `prefers-reduced-motion` media query
- No auto-playing video/audio without user control
- No content that flashes more than 3 times per second

**Accessibility severity levels:**
| Level | Definition | Examples |
|-------|-----------|----------|
| **Critical** | Blocks access for users with disabilities | Missing form labels, no keyboard access, images without alt text |
| **Major** | Significant barrier, workaround may exist | Broken tab order, missing focus indicators, no skip link |
| **Minor** | Inconvenience, doesn't block access | Redundant ARIA, suboptimal heading hierarchy |
| **Enhancement** | Beyond AA requirements | Missing `prefers-reduced-motion`, no live region for toasts |

### Phase 5: Performance Snapshot

While Playwright is running, capture:
- **Page load time** — `performance.timing` via `page.evaluate()`
- **Largest Contentful Paint** — via Performance Observer
- **Cumulative Layout Shift** — how much does the page jump during load?
- **JavaScript errors** — capture all `console.error` events during the test run
- **Network failures** — any failed API calls, 4xx/5xx responses, CORS errors
- **Bundle observations** — count total network requests, total transfer size

## Output Format

```
UX TEST REPORT — [app name] — [date]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

PAGES TESTED: [count]
FLOWS TESTED: [count]
BREAKPOINTS: 4 (375px / 768px / 1280px / 1920px)

CRITICAL ISSUES (must fix):
  1. [page] — [description] — [screenshot reference]
  2. ...

WARNINGS (should fix):
  1. [page] — [description]
  2. ...

ACCESSIBILITY:
  Violations: [count]
  [list of violations with severity]

PERFORMANCE:
  LCP: [time]ms
  CLS: [score]
  JS Errors: [count]
  Failed Requests: [count]

FLOW RESULTS:
  ✅ Login flow — passed (3 steps, 1.2s)
  ✅ Dashboard load — passed (2.1s)
  ❌ Checkout flow — FAILED at step 3 (payment form doesn't submit)
  ⚠️ Search — works but slow (4.3s for results)

SCREENSHOTS: [list of saved screenshots with descriptions]
```

## Rules

- **Always test on at least 2 breakpoints** — desktop and mobile minimum. Most UI bugs are responsive bugs.
- **Test the actual app, not assumptions** — don't skip testing because "it should work." Run the test.
- **Save screenshots** — every visual issue should have a screenshot for reference. Save to project root or `/tmp/`.
- **Report honestly** — if something looks off but isn't technically broken, still flag it. UX is about feel, not just function.
- **Don't fix during testing** — complete the full audit first, then fix. Fixing mid-test causes you to miss things.
- **Test with real-ish data** — empty states are important but also test with realistic content lengths, image sizes, and data volumes.

---
Nox
