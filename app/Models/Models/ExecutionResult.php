<?php

namespace App\Models\Models;

use Illuminate\Database\Eloquent\Model;

class ExecutionResult extends Model
{
    protected $table = 'execution_results';

    protected $fillable = [
        'submission_id', 'test_case_id', 'status', 'exec_time_ms', 'memory_kb', 'stderr_ref',
    ];
}
