<?php

namespace App\Jobs;

use App\Models\Models\Submission;
use App\Models\Models\SubmissionEvent;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\DB;

class EvaluateSubmissionJob implements ShouldQueue
{
	use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

	public function __construct(public string $submissionId)
	{
	}

	public function handle(): void
	{
		$submission = Submission::query()->find($this->submissionId);
		if (!$submission) {
			return;
		}

		$submission->update(['status' => 'running']);
		$this->emit('compile_start');
		uSLEEP(200000);
		$this->emit('compile_end', ['ok' => true]);

		$total = 5; $passed = 0;
		for ($i = 1; $i <= $total; $i++) {
			$this->emit('testcase_start', ['index' => $i]);
			uSLEEP(150000);
			$ok = (bool) random_int(0, 1);
			$passed += $ok ? 1 : 0;
			$this->emit('testcase_end', ['index' => $i, 'status' => $ok ? 'AC' : 'WA']);
		}

		$score = round(($passed / $total) * 100, 2);

		$submission->update([
			'status' => 'completed',
			'total_tests' => $total,
			'passed_tests' => $passed,
			'weighted_score' => $score,
		]);

		$this->emit('final', ['score' => $score, 'passed' => $passed, 'total' => $total]);
	}

	private function emit(string $type, array $payload = []): void
	{
		SubmissionEvent::create([
			'submission_id' => $this->submissionId,
			'type' => $type,
			'payload' => $payload ? json_encode($payload) : null,
		]);
	}
}
