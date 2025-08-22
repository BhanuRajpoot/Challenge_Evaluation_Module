<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('execution_results', function (Blueprint $table) {
            $table->id();
            $table->uuid('submission_id');
            $table->foreign('submission_id')->references('id')->on('submissions')->cascadeOnDelete();
            $table->foreignId('test_case_id')->constrained('test_cases')->cascadeOnDelete();
            $table->enum('status', ['AC','WA','TLE','MLE','RE','CE']);
            $table->unsignedInteger('exec_time_ms')->nullable();
            $table->unsignedInteger('memory_kb')->nullable();
            $table->string('stderr_ref')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('execution_results');
    }
};
