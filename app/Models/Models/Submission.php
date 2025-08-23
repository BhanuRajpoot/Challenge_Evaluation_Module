<?php

namespace App\Models\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Concerns\HasUuids;

class Submission extends Model
{
    use HasUuids;

    protected $table = 'submissions';

    protected $fillable = [
        'id', 'user_id', 'problem_id', 'language_runtime_id', 'source_code',
        'status', 'total_tests', 'passed_tests', 'weighted_score', 'idempotency_key'
    ];

    public $incrementing = false;
    protected $keyType = 'string';
}
