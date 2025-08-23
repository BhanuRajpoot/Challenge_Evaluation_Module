<?php

namespace App\Models\Models;

use Illuminate\Database\Eloquent\Model;

class Problem extends Model
{
    protected $table = 'problems';

    protected $fillable = [
        'slug', 'title', 'description', 'time_limit_ms', 'memory_limit_mb',
    ];

    public function testCases()
    {
        return $this->hasMany(TestCase::class);
    }
}
