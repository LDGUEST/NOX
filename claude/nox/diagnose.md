Run a full system health check across all configured machines and services. Report status without attempting fixes.

## Configuration

Define your infrastructure in environment variables or pass as arguments:

```bash
# Example: export FORGE_MACHINES='["web:192.168.1.10:deploy", "gpu:192.168.1.20:admin"]'
```

## Check Sequence

### For each machine in `$FORGE_MACHINES`:

1. **Connectivity** — SSH reachable, latency
2. **System Resources** — CPU load, memory usage, disk space on all volumes
3. **Running Services** — Docker containers (`docker ps`), systemd/launchd services
4. **GPU Status** (if applicable) — Utilization, memory, temperature via `nvidia-smi`
5. **Key Ports** — Check if expected ports are listening

### Service-Specific Checks

If the project has known services, verify each:
- **Web servers**: HTTP 200 on configured endpoints
- **Databases**: Connection test, replication lag
- **Message queues**: Queue depth, consumer status
- **AI/ML services**: Model endpoint health (`/health`, `/api/tags`, `/v1/models`)
- **Containers**: Running state, restart count, resource usage

## Output Format

Present results as a clean status table:

```
┌──────────┬───────────────┬────────┬─────────┐
│ Machine  │ Service       │ Status │ Details │
├──────────┼───────────────┼────────┼─────────┤
│ server-1 │ nginx         │ ✓ UP   │ 200 OK  │
│ server-1 │ postgres      │ ✓ UP   │ 0ms lag │
│ server-2 │ ollama        │ ✗ DOWN │ timeout │
└──────────┴───────────────┴────────┴─────────┘
```

Flag anything that is down, degraded, or unexpected. Do NOT attempt to fix anything — diagnosis only.

---
Nox