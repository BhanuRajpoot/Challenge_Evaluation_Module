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
        Schema::create('test_cases', function (Blueprint $table) {
            $table->id();
            $table->foreignId('problem_id')->constrained('problems')->cascadeOnDelete();
            $table->enum('visibility', ['public', 'hidden'])->default('public');
            $table->unsignedInteger('weight')->default(1);
            $table->string('input_ref');
            $table->string('expected_output_ref');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('test_cases');
    }
};
