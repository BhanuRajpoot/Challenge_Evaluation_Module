<?php

namespace App\Models\Models;

use Illuminate\Database\Eloquent\Model;

class SubmissionEvent extends Model
{
    protected $table = 'submission_events';

    protected $fillable = [
        'submission_id', 'type', 'payload',
    ];
}
