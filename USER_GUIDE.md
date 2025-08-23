# End User Guide — Challenge Evaluation (Demo)

This guide explains how to use the Challenge Evaluation app to write code, submit it for evaluation, and view real-time results.

Note: This demo simulates evaluation (compile + 5 tests) to showcase the experience. A production version runs submissions in secure sandboxes per language.

## What you need

- A modern browser (Chrome, Edge, Firefox, Safari).
- Backend running: http://127.0.0.1:8000
- Frontend running: http://localhost:5173 (or http://127.0.0.1:5174)

If you see connection errors, ensure both servers are started:
- Backend: in `unstop_assessment/` → `php artisan serve --host=127.0.0.1 --port=8000`
- Frontend: in `challenge-eval-web/` → `npm run dev`

## Quick start

1) Open the app
- Visit http://localhost:5173 (or http://127.0.0.1:5174).

2) Choose a Problem
- Use the “Select Problem” dropdown. If you don’t see any items, ask an admin to add problems or run the demo seed (admins only).

3) Choose a Language
- Use the “Select Language” dropdown (e.g., “python 3.11”).

4) Write Your Code
- Type or paste code in the editor text area.
- For the demo, any code text is accepted.

5) Submit
- Click “Submit”. You’ll see a new submission ID and the status (starts as queued, then running).

6) Watch Live Events
- The Events panel streams progress in real time:
  - compile_start, compile_end
  - testcase_start, testcase_end
  - final (contains the score)

7) Read the Result
- When the stream shows event: final, check the score (for example, score: 60, passed: 3, total: 5).

## Understanding statuses
- queued: submission is waiting to start
- running: evaluation in progress
- completed: evaluation finished; see final score
- failed: something went wrong (rare in the demo)

## Tips
- Submitting again will create a new submission with a different ID.
- Keep the Events panel visible while the run is in progress.
- If the Events stream stalls, refresh the page and submit again.

## Troubleshooting

- “This site can’t be reached” (frontend)
  - Ensure the Vite server is running and use http://localhost:5173.
  - Alternatively use http://127.0.0.1:5174 (if started with `npx vite --host 127.0.0.1 --port 5174`).

- No problems or languages in dropdowns
  - Ask an admin to add data or run the demo seed (admin/dev step).

- Submission doesn’t change from queued
  - Ensure the backend is running at http://127.0.0.1:8000.
  - The queue is configured to run inline (no separate worker needed) in this demo.

- Events do not appear
  - Make sure your browser tab stays open; SSE requires an active connection.
  - Check that your firewall or antivirus isn’t blocking localhost connections.

## What’s included in the demo
- A simple UI to:
  - Select a problem and language runtime
  - Enter code and submit
  - View real-time evaluation events
- Simulated evaluation that produces realistic progress and a final score

## What’s next (beyond the demo)
- Real code execution in secure sandboxes (per language)
- Support for hidden test cases and weighted scoring
- Submission history, leaderboards, and authentication
- WebSocket realtime for at-scale fanout

If you need help, share your browser URL, what you clicked, and any messages you see in the Events panel.
