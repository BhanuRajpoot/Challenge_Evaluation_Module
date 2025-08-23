# Developer Guide — Challenge Evaluation Module

This document describes the technical architecture, setup, and implementation details for the Laravel + React evaluation demo.

## 1. Architecture Overview

- Backend: Laravel 12 (PHP 8.3), MySQL, Redis (optional), queues (sync for MVP)
- Frontend: React (Vite), dev proxy to Laravel
- Realtime: Server-Sent Events (SSE) endpoint per submission
- Storage: MySQL tables for problems, language runtimes, submissions, results, events
- Jobs: `EvaluateSubmissionJob` simulates compile + test execution and emits events

### Source layout
- `unstop_assessment/` (Laravel app)
  - `app/Http/Controllers/Api/SubmissionController.php`
  - `app/Jobs/EvaluateSubmissionJob.php`
  - `app/Models/Models/*` (Problem, TestCase, LanguageRuntime, Submission, ExecutionResult, SubmissionEvent)
  - `database/migrations/*` (schema)
  - `routes/api.php` (API + SSE routes)
  - `bootstrap/app.php` (loads `routes/api.php`)
- `challenge-eval-web/` (React app)
  - `vite.config.js` (proxy `/api` → Laravel)
  - `src/App.jsx` (MVP UI)

## 2. Local Setup

### Backend (Laravel)
- PHP 8.2+ (8.3 recommended) and Composer
- MySQL database: `unstop_assessment`
- `.env` essentials:
  - `DB_CONNECTION=mysql`
  - `DB_HOST=127.0.0.1`
  - `DB_PORT=3306`
  - `DB_DATABASE=unstop_assessment`
  - `DB_USERNAME=root`
  - `DB_PASSWORD=`
  - `QUEUE_CONNECTION=sync`
- Install + migrate:
  - `composer install`
  - `php artisan key:generate`
  - `php artisan migrate`
- Dev server:
  - `php artisan serve --host=127.0.0.1 --port=8000`

Compatibility note: `App\Providers\AppServiceProvider::boot()` sets `Schema::defaultStringLength(191)` to avoid MySQL key-length issues.

### Frontend (React)
- Node 20.19+ (Vite 7 requires >= 20.19 or 22.12+)
- Install + run:
  - `cd ../challenge-eval-web`
  - `npm install`
  - `npm run dev`
- Dev proxy is defined in `vite.config.js` (for `/api`).
- Optional env override: `VITE_API_BASE` (defaults to `/api`).

## 3. Data Model

Tables and key fields:
- `problems` (id, slug unique, title, description, time_limit_ms, memory_limit_mb, timestamps)
- `test_cases` (id, problem_id FK, visibility enum[public|hidden], weight, input_ref, expected_output_ref, timestamps)
- `language_runtimes` (id, name, version, image_ref?, compile_cmd?, run_cmd, timestamps)
- `submissions` (id UUID PK, user_id?, problem_id FK, language_runtime_id FK, source_code, status enum[queued|running|completed|failed], totals, weighted_score, idempotency_key, timestamps)
- `execution_results` (id, submission_id FK UUID, test_case_id FK, status enum[AC|WA|TLE|MLE|RE|CE], exec_time_ms, memory_kb, stderr_ref, timestamps)
- `submission_events` (id, submission_id FK UUID, type string, payload json, timestamps)

See `database/migrations/*` for exact definitions.

## 4. APIs

All routes are under `routes/api.php` and loaded via `bootstrap/app.php`.

- POST `/api/submissions`
  - Body (JSON): `{ problem_id: number, language_runtime_id: number, source_code: string, idempotency_key?: string }`
  - Validates foreign keys and source presence
  - Creates a UUID submission (status=queued) and dispatches `EvaluateSubmissionJob`
  - Returns: `{ submission_id: string }`

- GET `/api/submissions/{id}`
  - Returns summary: `{ id, status, total_tests, passed_tests, weighted_score, created_at }`

- GET `/api/submissions/{id}/events` (SSE)
  - Streams events for a submission
  - Event types: `compile_start`, `compile_end`, `testcase_start`, `testcase_end`, `final`, `message`, `error`
  - Payload is JSON string (or `{}`)

- GET `/api/problems` (UI list)
- GET `/api/language-runtimes` (UI list)

## 5. Jobs & Queueing

- Job: `app/Jobs/EvaluateSubmissionJob.php`
  - Implements `ShouldQueue`
  - Constructor arg: `submissionId: string`
  - Flow:
    1) Set submission.status = `running`
    2) Emit `compile_start` → wait → `compile_end`
    3) Loop 5 tests: emit `testcase_start` → wait → `testcase_end` (random AC/WA)
    4) Compute `weighted_score` = `passed/total * 100`
    5) Update submission to `completed` and emit `final` with score
- Queue connection: `sync` (runs immediately on dispatch); can switch to `database`/`redis` later.

## 6. Realtime (SSE)

- Controller method: `SubmissionController::sse(string $id)`
- Implementation: `response()->stream(...)` loop fetching new `submission_events` by incremental id, flushing output
- Headers: `Content-Type: text/event-stream`, `Cache-Control: no-cache`, `Connection: keep-alive`
- Client usage: `new EventSource('/api/submissions/{id}/events')`

## 7. Frontend (Vite React) UI

- `src/App.jsx` provides:
  - Fetch lists from `${VITE_API_BASE}/problems` and `/language-runtimes`
  - Simple `<textarea>` for source code (default `print(1)`) 
  - POST to `${VITE_API_BASE}/submissions`, capture `submission_id`
  - SSE stream from `${VITE_API_BASE}/submissions/{id}/events`
  - Displays basic status and a running event log

## 8. Error Handling & Validation

- Laravel validation in `SubmissionController::store()` ensures required fields
- 404s on missing submissions
- SSE stream is best-effort (client reconnects on network breaks)
- For production, add auth (tokens), rate limits (`Throttle` middleware), and structured error responses

## 9. Observability (MVP)

- Laravel logs in `storage/logs/`
- Basic request timing visible in dev server output
- Future: integrate with OpenTelemetry + centralized logs/metrics

## 10. Security Considerations (Beyond MVP)

- Replace simulated job with sandboxed execution (Firecracker/gVisor/rootless Docker)
- Enforce strict time/memory/CPU limits per run
- Deny egress networking by default; read-only images; tmpfs scratch
- Sign runtime images and pin toolchain versions
- Secret management via env/KMS

## 11. Testing & Tooling

- Quick smoke tests:
  - `POST /api/submissions` with known `problem_id` + `language_runtime_id`
  - `GET /api/submissions/{id}` should transition to `completed`
  - SSE should deliver a `final` event
- Add feature tests (`phpunit`) for controllers and job (mock event emitter) as follow-up work

## 12. Deployment Notes

- Backend
  - Serve via Nginx/Apache → php-fpm
  - Set `APP_ENV=production`, `APP_DEBUG=false`, cache config/routes
  - Migrate on deploy
- Frontend
  - `npm run build` → static assets served via web server/CDN
  - Configure reverse proxy from `/api` to backend

## 13. Known Limitations (MVP)

- Evaluation is simulated; no actual container/VM execution
- No authentication/rate-limiting
- SSE stream uses a simple polling loop; switch to DB listeners/Redis pub-sub for scale
- Minimal validation and error surfaces

## 14. Next Steps

- Implement real execution workers and orchestrator
- Add hidden test cases and weighted scoring per `test_cases`
- Add submission history and leaderboards
- WebSocket gateway for realtime with fanout and backpressure controls
- CI/CD, unit/feature tests, linting, and pre-commit hooks

---
This guide should provide enough detail to understand, run, and extend the current demo implementation.
