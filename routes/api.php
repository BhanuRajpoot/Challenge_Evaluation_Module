<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\SubmissionController;
use App\Models\Models\Problem;
use App\Models\Models\LanguageRuntime;

Route::post('/submissions', [SubmissionController::class, 'store']);
Route::get('/submissions/{id}', [SubmissionController::class, 'show']);
Route::get('/submissions/{id}/events', [SubmissionController::class, 'sse']);

// Read-only lists for frontend selectors
Route::get('/problems', function () {
    return response()->json(Problem::query()->orderBy('id')->get());
});

Route::get('/language-runtimes', function () {
    return response()->json(LanguageRuntime::query()->orderBy('id')->get());
});
