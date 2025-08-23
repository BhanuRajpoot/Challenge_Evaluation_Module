# Project Setup Guide (Laravel API + React Web)

This guide helps developers set up the Challenge Evaluation project locally on Windows (WAMP) or similar.

## 1) Overview
- Backend: Laravel 12 (PHP 8.3), MySQL, queues (sync), SSE for realtime
- Frontend: React (Vite) with proxy to Laravel
- DB name: unstop_assessment
- Paths:
  - Backend: C:\wamp64\www\unstop_assessment
  - Frontend: C:\wamp64\www\challenge-eval-web

## 2) Prerequisites
- PHP 8.2+ (8.3 recommended) and Composer
- MySQL running (WAMP or standalone) and a database named unstop_assessment
- Node.js 20.19+ (Vite 7 requires >= 20.19 or 22.12+)
- PowerShell or a terminal

## 3) Backend Setup (Laravel)
From C:\wamp64\www\unstop_assessment:

```powershell
composer install
if (!(Test-Path .env)) { Copy-Item .env.example .env }

# Ensure .env contains these values
# DB_CONNECTION=mysql
# DB_HOST=127.0.0.1
# DB_PORT=3306
# DB_DATABASE=unstop_assessment
# DB_USERNAME=root
# DB_PASSWORD=
# QUEUE_CONNECTION=sync

php artisan key:generate
php artisan migrate
```

Notes:
- Default string length is set in App\Providers\AppServiceProvider to avoid MySQL key-length issues.
- Queue is sync so jobs run immediately without a worker.

### Run backend server
```powershell
php artisan serve --host=127.0.0.1 --port=8000
```
Health check: open http://127.0.0.1:8000/up (should be 200).

## 4) Seed Demo Data (optional)
Create one Problem and one LanguageRuntime to use in the UI:
```powershell
php artisan tinker --execute "App\Models\Models\Problem::firstOrCreate(['slug'=>'two-sum'], ['title'=>'Two Sum','description'=>'Find indices','time_limit_ms'=>2000,'memory_limit_mb'=>256]); App\Models\Models\LanguageRuntime::firstOrCreate(['name'=>'python','version'=>'3.11'], ['run_cmd'=>'python main.py']);"
```

## 5) Frontend Setup (React)
From C:\wamp64\www\challenge-eval-web:
```powershell
npm install
npm run dev
```
- Dev server: http://localhost:5173 (or run `npx vite --host 127.0.0.1 --port 5174`)
- Proxy: requests to /api are forwarded to http://127.0.0.1:8000 (see vite.config.js).
- Optional: set VITE_API_BASE in a .env file (defaults to /api).

## 6) End-to-End Test
1. Open React app: http://localhost:5173 (or http://127.0.0.1:5174)
2. Select a Problem and Language
3. Enter code (e.g., print('hello'))
4. Click Submit → watch Events panel for compile/test events and final score

API test (PowerShell):
```powershell
Invoke-RestMethod -Uri http://127.0.0.1:8000/api/problems
Invoke-RestMethod -Uri http://127.0.0.1:8000/api/language-runtimes
$body = @{ problem_id = 1; language_runtime_id = 1; source_code = "print('hello')" } | ConvertTo-Json
Invoke-RestMethod -Method POST -Uri http://127.0.0.1:8000/api/submissions -ContentType application/json -Body $body
```

## 7) Useful Paths & Files
- API routes: routes/api.php
- SSE endpoint: SubmissionController::sse
- Job: app/Jobs/EvaluateSubmissionJob.php
- Models & migrations: app/Models/Models/*, database/migrations/*
- React UI: challenge-eval-web/src/App.jsx, styles in src/App.css

## 8) Troubleshooting
- Vite warns about Node version: upgrade Node to 20.19+ (nvm-windows recommended).
- Laravel migration error 1071 (key length): already fixed via Schema::defaultStringLength(191).
- 404 on API routes: ensure bootstrap/app.php includes api: __DIR__.'/../routes/api.php'.
- SSE not streaming: browser tab must stay open; check firewall/antivirus; ensure backend is reachable at 127.0.0.1:8000.
- CORS issues: use the Vite proxy (/api) instead of direct cross-origin calls.

## 9) Scripts Summary
Backend:
- composer install
- php artisan key:generate
- php artisan migrate
- php artisan serve --host=127.0.0.1 --port=8000

Frontend:
- npm install
- npm run dev

You’re ready to develop. See README.md for architecture, USER_GUIDE.md for end-user steps, and DEVELOPER.md for deep technical details.
