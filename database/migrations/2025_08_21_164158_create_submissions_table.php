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
        Schema::create('submissions', function (Blueprint $table) {
            $table->uuid('id')->primary();
            $table->foreignId('user_id')->nullable()->constrained('users')->nullOnDelete();
            $table->foreignId('problem_id')->constrained('problems')->cascadeOnDelete();
            $table->foreignId('language_runtime_id')->constrained('language_runtimes');
            $table->longText('source_code');
            $table->enum('status', ['queued','running','completed','failed'])->default('queued');
            $table->unsignedInteger('total_tests')->default(0);
            $table->unsignedInteger('passed_tests')->default(0);
            $table->decimal('weighted_score',5,2)->default(0);
            $table->string('idempotency_key')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('submissions');
    }
};
