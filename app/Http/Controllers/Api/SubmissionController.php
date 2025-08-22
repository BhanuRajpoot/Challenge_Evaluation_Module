<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Jobs\EvaluateSubmissionJob;
use App\Models\Models\Submission;
use App\Models\Models\SubmissionEvent;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Response;
use Illuminate\Support\Str;

class SubmissionController extends Controller
{
	/**
	 * Store a newly created submission.
	 */
	public function store(Request $request)
	{
		$validated = $request->validate([
			'problem_id' => 'required|integer|exists:problems,id',
			'language_runtime_id' => 'required|integer|exists:language_runtimes,id',
			'source_code' => 'required|string',
			'idempotency_key' => 'nullable|string|max:100',
		]);

		$submissionId = (string) Str::uuid();

		$submission = DB::transaction(function () use ($validated, $submissionId) {
			return Submission::create([
				'id' => $submissionId,
				'user_id' => auth()->id(),
				'problem_id' => $validated['problem_id'],
				'language_runtime_id' => $validated['language_runtime_id'],
				'source_code' => $validated['source_code'],
				'status' => 'queued',
				'idempotency_key' => $validated['idempotency_key'] ?? null,
			]);
		});

		EvaluateSubmissionJob::dispatch($submission->id);

		return response()->json(['submission_id' => $submission->id], 201);
	}

	/**
	 * Display the submission summary.
	 */
	public function show(string $id)
	{
		$submission = Submission::query()->findOrFail($id);
		return response()->json([
			'id' => $submission->id,
			'status' => $submission->status,
			'total_tests' => $submission->total_tests,
			'passed_tests' => $submission->passed_tests,
			'weighted_score' => $submission->weighted_score,
			'created_at' => $submission->created_at,
		]);
	}

	/**
	 * Stream events for a submission via SSE (simple demo)
	 */
	public function sse(string $id)
	{
		return response()->stream(function () use ($id) {
			header('Content-Type: text/event-stream');
			header('Cache-Control: no-cache');
			header('Connection: keep-alive');

			$lastId = 0;
			while (true) {
				$events = SubmissionEvent::query()
					->where('submission_id', $id)
					->where('id', '>', $lastId)
					->orderBy('id')
					->limit(50)
					->get();

				foreach ($events as $event) {
					$lastId = $event->id;
					echo "id: {$event->id}\n";
					echo "event: {$event->type}\n";
					echo 'data: ' . ($event->payload ?: '{}') . "\n\n";
					@ob_flush(); flush();
				}

				usleep(300000); // 300ms
			}
		}, 200, [
			'Content-Type' => 'text/event-stream',
			'Cache-Control' => 'no-cache',
			'Connection' => 'keep-alive',
		]);
	}
}
