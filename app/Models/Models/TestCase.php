<?php

namespace App\Models\Models;

use Illuminate\Database\Eloquent\Model;

class TestCase extends Model
{
    protected $table = 'test_cases';

    protected $fillable = [
        'problem_id', 'visibility', 'weight', 'input_ref', 'expected_output_ref',
    ];

    public function problem()
    {
        return $this->belongsTo(Problem::class);
    }
}
