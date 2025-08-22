# Challenge Evaluation Module (Laravel + React)

Brief overview of a multi-language code evaluation module with real-time feedback. Backend is Laravel (MySQL, queues, SSE). Frontend is a Vite React app that submits code and streams events.

## Architecture

- Backend (Laravel)
  - REST API: create/poll submissions, list problems and language runtimes
  - Queue job simulates evaluation and emits events (SSE)
  - MySQL storage for problems, test cases, runtimes, submissions, results, events
- Frontend (React)
  - Simple UI to choose problem & language, enter code, submit, and stream live events
- Realtime
  - SSE endpoint streams compile/testcase/final events per submission

## Prerequisites

- PHP 8.2+ (8.3 recommended) and Composer
- MySQL (WAMP or local server) with a database named `unstop_assessment`
- Node.js 20.19+ and npm (for Vite React app)

## Backend (Laravel)

Location: `unstop_assessment/`

### Install & Configure

1. Install dependencies:
   ```bash
   composer install
   ```
2. Copy environment file and configure DB (already set by setup):
   ```bash
   cp .env.example .env
   # Ensure the following entries exist
   # DB_CONNECTION=mysql
   # DB_HOST=127.0.0.1
   # DB_PORT=3306
   # DB_DATABASE=unstop_assessment
   # DB_USERNAME=root
   # DB_PASSWORD=
   # QUEUE_CONNECTION=sync
   ```
3. Generate key and run migrations:
   ```bash
   php artisan key:generate
   php artisan migrate
   ```

Notes:
- Default string length is limited to 191 for MySQL compatibility in `AppServiceProvider`.
- Queue connection is `sync` so evaluation runs immediately on submit.

### Seed Demo Data (optional)

```bash
php artisan tinker --execute "App\Models\Models\Problem::firstOrCreate(['slug'=>'two-sum'], ['title'=>'Two Sum','description'=>'Find indices','time_limit_ms'=>2000,'memory_limit_mb'=>256]); App\Models\Models\LanguageRuntime::firstOrCreate(['name'=>'python','version'=>'3.11'], ['run_cmd'=>'python main.py']);"
```

### Run Server

```bash
php artisan serve --host=127.0.0.1 --port=8000
```

### API Endpoints (MVP)

- POST `/api/submissions`
  - body: `{ problem_id, language_runtime_id, source_code, idempotency_key? }`
  - returns: `{ submission_id }`
- GET `/api/submissions/{id}`
  - returns: `{ id, status, total_tests, passed_tests, weighted_score, created_at }`
- GET `/api/submissions/{id}/events` (SSE stream)
- GET `/api/problems` (list for UI)
- GET `/api/language-runtimes` (list for UI)

## Frontend (React)

Location: `challenge-eval-web/`

### Dev Setup

```bash
cd ../challenge-eval-web
npm install
npm run dev
```

The Vite dev server runs at `http://localhost:5173` (or `http://127.0.0.1:5174` if started explicitly). A proxy is configured so `/api` requests go to `http://127.0.0.1:8000`.

### Using the App

1. Start Laravel (`:8000`) and Vite (`:5173`).
2. Open the React app in a browser.
3. Pick a Problem and Language, write code, and click Submit.
4. Watch live events (compile/testcase/final) stream in the Events panel.

## Data Model (simplified)

- problems: slug, title, description, time_limit_ms, memory_limit_mb
- language_runtimes: name, version, image_ref?, compile_cmd?, run_cmd
- submissions: id (UUID), user_id?, problem_id, language_runtime_id, source_code, status, totals, score
- submission_events: submission_id, type, payload (json)
- execution_results: submission_id, test_case_id, status, timings, memory

## Notes & Next Steps

- This MVP simulates evaluation; replace the job with real sandboxed execution when ready (e.g., containers/VMs).
- Add authentication, rate limiting, and RBAC as needed.
- Add hidden test cases and weighted scoring per problem.
- Swap SSE with WebSockets for richer realtime fanout.

<p align="center"><a href="https://laravel.com" target="_blank"><img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400" alt="Laravel Logo"></a></p>

<p align="center">
<a href="https://github.com/laravel/framework/actions"><img src="https://github.com/laravel/framework/workflows/tests/badge.svg" alt="Build Status"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/dt/laravel/framework" alt="Total Downloads"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/v/laravel/framework" alt="Latest Stable Version"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/l/laravel/framework" alt="License"></a>
</p>

## About Laravel

Laravel is a web application framework with expressive, elegant syntax. We believe development must be an enjoyable and creative experience to be truly fulfilling. Laravel takes the pain out of development by easing common tasks used in many web projects, such as:

- [Simple, fast routing engine](https://laravel.com/docs/routing).
- [Powerful dependency injection container](https://laravel.com/docs/container).
- Multiple back-ends for [session](https://laravel.com/docs/session) and [cache](https://laravel.com/docs/cache) storage.
- Expressive, intuitive [database ORM](https://laravel.com/docs/eloquent).
- Database agnostic [schema migrations](https://laravel.com/docs/migrations).
- [Robust background job processing](https://laravel.com/docs/queues).
- [Real-time event broadcasting](https://laravel.com/docs/broadcasting).

Laravel is accessible, powerful, and provides tools required for large, robust applications.

## Learning Laravel

Laravel has the most extensive and thorough [documentation](https://laravel.com/docs) and video tutorial library of all modern web application frameworks, making it a breeze to get started with the framework.

You may also try the [Laravel Bootcamp](https://bootcamp.laravel.com), where you will be guided through building a modern Laravel application from scratch.

If you don't feel like reading, [Laracasts](https://laracasts.com) can help. Laracasts contains thousands of video tutorials on a range of topics including Laravel, modern PHP, unit testing, and JavaScript. Boost your skills by digging into our comprehensive video library.

## Laravel Sponsors

We would like to extend our thanks to the following sponsors for funding Laravel development. If you are interested in becoming a sponsor, please visit the [Laravel Partners program](https://partners.laravel.com).

### Premium Partners

- **[Vehikl](https://vehikl.com)**
- **[Tighten Co.](https://tighten.co)**
- **[Kirschbaum Development Group](https://kirschbaumdevelopment.com)**
- **[64 Robots](https://64robots.com)**
- **[Curotec](https://www.curotec.com/services/technologies/laravel)**
- **[DevSquad](https://devsquad.com/hire-laravel-developers)**
- **[Redberry](https://redberry.international/laravel-development)**
- **[Active Logic](https://activelogic.com)**

## Contributing

Thank you for considering contributing to the Laravel framework! The contribution guide can be found in the [Laravel documentation](https://laravel.com/docs/contributions).

## Code of Conduct

In order to ensure that the Laravel community is welcoming to all, please review and abide by the [Code of Conduct](https://laravel.com/docs/contributions#code-of-conduct).

## Security Vulnerabilities

If you discover a security vulnerability within Laravel, please send an e-mail to Taylor Otwell via [taylor@laravel.com](mailto:taylor@laravel.com). All security vulnerabilities will be promptly addressed.

## License

The Laravel framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).
