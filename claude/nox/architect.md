Design-first gate. No code, scaffolding, or implementation until the architecture is reviewed and approved.

## Deliverables

### 1. Component Diagram
- What are the major components/modules?
- How do they communicate? (HTTP, events, direct calls, message queue)
- What are the boundaries between them?

### 2. Data Flow
- Where does data originate?
- How does it move through the system?
- Where is it stored? What format?
- What transformations happen along the way?

### 3. API Contracts
- Define endpoints, request/response shapes, and status codes
- Specify authentication requirements per endpoint
- Document error response formats

### 4. Tech Decisions
For each significant choice, provide:
- **Decision**: What was chosen
- **Alternatives considered**: What else was evaluated
- **Tradeoffs**: Why this option wins for this context
- **Risks**: What could go wrong with this choice

### 5. File Structure
- Proposed directory layout
- Key files and their responsibilities
- Where new code fits into existing structure (if applicable)

## Rules

- Do NOT write any implementation code in this phase
- Ask clarifying questions if requirements are ambiguous
- Consider scale — will this design work at 10x the expected load?
- Consider operations — how will this be deployed, monitored, debugged?
- Present the architecture and wait for explicit approval before proceeding

---
Nox