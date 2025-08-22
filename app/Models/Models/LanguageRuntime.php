<?php

namespace App\Models\Models;

use Illuminate\Database\Eloquent\Model;

class LanguageRuntime extends Model
{
    protected $table = 'language_runtimes';

    protected $fillable = [
        'name', 'version', 'image_ref', 'compile_cmd', 'run_cmd',
    ];
}
