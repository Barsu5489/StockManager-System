# Technical Decisions

| # | Decision | Choice | Rationale |
|---|----------|--------|-----------|
| 1 | Database | SQLite | Rails 8 default, zero config, portable |
| 2 | Authentication | Rails 8 built-in | Simple, no gems, full control |
| 3 | Frontend | Hotwire (Turbo + Stimulus) | Required by spec, native Rails |
| 4 | CSS | Tailwind CSS | Required by spec, Rails 8 default |
| 5 | Real-time | Turbo Streams | No JS needed, server-rendered HTML fragments |
| 6 | Image Upload | Active Storage | Built-in, works with local/cloud storage |
| 7 | CSV Export | Ruby CSV stdlib | No dependencies, streams to browser |
| 8 | Testing | Minitest + fixtures | Rails default, fast, simple |
| 9 | Multi-tenancy | User-scoped queries | Data isolation, prevents IDOR attacks |

## Key Implementation Details

**Stock Adjustment**: Dedicated `increase_stock`/`decrease_stock` actions with atomic `increment!`/`decrement!` operations.

**Low Stock Threshold**: Constant (10 units) in model, not DB field. Simple, can be made configurable later.

**Search**: Server-side SQL LIKE queries. URL-based, shareable, scales with pagination.

**User Registration**: Custom controller matching Rails 8 auth pattern with auto-login after signup.
