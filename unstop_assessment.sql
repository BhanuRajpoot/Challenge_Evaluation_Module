-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Aug 22, 2025 at 04:10 PM
-- Server version: 8.3.0
-- PHP Version: 8.3.6

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `unstop_assessment`
--

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

DROP TABLE IF EXISTS `cache`;
CREATE TABLE IF NOT EXISTS `cache` (
  `key` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `value` mediumtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

DROP TABLE IF EXISTS `cache_locks`;
CREATE TABLE IF NOT EXISTS `cache_locks` (
  `key` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `owner` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expiration` int NOT NULL,
  PRIMARY KEY (`key`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `execution_results`
--

DROP TABLE IF EXISTS `execution_results`;
CREATE TABLE IF NOT EXISTS `execution_results` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `submission_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `test_case_id` bigint UNSIGNED NOT NULL,
  `status` enum('AC','WA','TLE','MLE','RE','CE') COLLATE utf8mb4_unicode_ci NOT NULL,
  `exec_time_ms` int UNSIGNED DEFAULT NULL,
  `memory_kb` int UNSIGNED DEFAULT NULL,
  `stderr_ref` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `execution_results_submission_id_foreign` (`submission_id`),
  KEY `execution_results_test_case_id_foreign` (`test_case_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

DROP TABLE IF EXISTS `failed_jobs`;
CREATE TABLE IF NOT EXISTS `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `uuid` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

DROP TABLE IF EXISTS `jobs`;
CREATE TABLE IF NOT EXISTS `jobs` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `queue` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `attempts` tinyint UNSIGNED NOT NULL,
  `reserved_at` int UNSIGNED DEFAULT NULL,
  `available_at` int UNSIGNED NOT NULL,
  `created_at` int UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

DROP TABLE IF EXISTS `job_batches`;
CREATE TABLE IF NOT EXISTS `job_batches` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `total_jobs` int NOT NULL,
  `pending_jobs` int NOT NULL,
  `failed_jobs` int NOT NULL,
  `failed_job_ids` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `options` mediumtext COLLATE utf8mb4_unicode_ci,
  `cancelled_at` int DEFAULT NULL,
  `created_at` int NOT NULL,
  `finished_at` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `language_runtimes`
--

DROP TABLE IF EXISTS `language_runtimes`;
CREATE TABLE IF NOT EXISTS `language_runtimes` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `version` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_ref` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `compile_cmd` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `run_cmd` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `language_runtimes`
--

INSERT INTO `language_runtimes` (`id`, `name`, `version`, `image_ref`, `compile_cmd`, `run_cmd`, `created_at`, `updated_at`) VALUES
(1, 'python', '3.11', NULL, NULL, 'python main.py', '2025-08-22 02:35:27', '2025-08-22 02:35:27');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
CREATE TABLE IF NOT EXISTS `migrations` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `migration` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2025_08_21_164155_create_problems_table', 2),
(5, '2025_08_21_164156_create_test_cases_table', 2),
(6, '2025_08_21_164157_create_language_runtimes_table', 2),
(7, '2025_08_21_164158_create_submissions_table', 2),
(8, '2025_08_21_164159_create_execution_results_table', 2),
(9, '2025_08_21_164159_create_submission_events_table', 2);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
CREATE TABLE IF NOT EXISTS `password_reset_tokens` (
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `problems`
--

DROP TABLE IF EXISTS `problems`;
CREATE TABLE IF NOT EXISTS `problems` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `slug` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `time_limit_ms` int UNSIGNED NOT NULL DEFAULT '2000',
  `memory_limit_mb` int UNSIGNED NOT NULL DEFAULT '256',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `problems_slug_unique` (`slug`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `problems`
--

INSERT INTO `problems` (`id`, `slug`, `title`, `description`, `time_limit_ms`, `memory_limit_mb`, `created_at`, `updated_at`) VALUES
(1, 'two-sum', 'Two Sum', 'Find indices', 2000, 256, '2025-08-22 02:35:27', '2025-08-22 02:35:27');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

DROP TABLE IF EXISTS `sessions`;
CREATE TABLE IF NOT EXISTS `sessions` (
  `id` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8mb4_unicode_ci,
  `payload` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_activity` int NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('d0WxKzNw6CBGfoPuQ6Fxplccps2npj23NgXmDfiN', NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiRXhBTGRaMVRjVk1FNTJnd3M3cWNpOGpyV1Y3bjdIYnk4eDZ5MjFBMCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDE6Imh0dHA6Ly9sb2NhbGhvc3QvdW5zdG9wX2Fzc2Vzc21lbnQvcHVibGljIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1755794335),
('NXReEVFzwXZrqEjAE5HB7gRos8BJx4joGeUtXsxd', NULL, '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiQ1ExU0RuaHpsc1NWTU5sR2tPNHRaMDBEMjF6V2dLOHllWmhqM2xjVCI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6NDE6Imh0dHA6Ly9sb2NhbGhvc3QvdW5zdG9wX2Fzc2Vzc21lbnQvcHVibGljIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1755853762),
('ZrKGtRT7u7urLItgk66bF8NQgCLxJRSaOQFzUgpO', NULL, '127.0.0.1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiN3hMdjBUdXRZMVRvM2RwMTN5OE5qaVlTQ2Z1OExDM2prYXZweG96bSI7czo5OiJfcHJldmlvdXMiO2E6MTp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7fXM6NjoiX2ZsYXNoIjthOjI6e3M6Mzoib2xkIjthOjA6e31zOjM6Im5ldyI7YTowOnt9fX0=', 1755850599);

-- --------------------------------------------------------

--
-- Table structure for table `submissions`
--

DROP TABLE IF EXISTS `submissions`;
CREATE TABLE IF NOT EXISTS `submissions` (
  `id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `problem_id` bigint UNSIGNED NOT NULL,
  `language_runtime_id` bigint UNSIGNED NOT NULL,
  `source_code` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('queued','running','completed','failed') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'queued',
  `total_tests` int UNSIGNED NOT NULL DEFAULT '0',
  `passed_tests` int UNSIGNED NOT NULL DEFAULT '0',
  `weighted_score` decimal(5,2) NOT NULL DEFAULT '0.00',
  `idempotency_key` varchar(191) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `submissions_user_id_foreign` (`user_id`),
  KEY `submissions_problem_id_foreign` (`problem_id`),
  KEY `submissions_language_runtime_id_foreign` (`language_runtime_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `submissions`
--

INSERT INTO `submissions` (`id`, `user_id`, `problem_id`, `language_runtime_id`, `source_code`, `status`, `total_tests`, `passed_tests`, `weighted_score`, `idempotency_key`, `created_at`, `updated_at`) VALUES
('1398c7fc-7b82-445f-8dcd-c0f4a30ec540', NULL, 1, 1, 'print(2+2)', 'completed', 5, 2, 40.00, NULL, '2025-08-22 03:01:17', '2025-08-22 03:01:18'),
('5f64cff4-3531-4e02-a66f-7fa673beb0b1', NULL, 1, 1, 'print(\'hello\')', 'completed', 5, 2, 40.00, NULL, '2025-08-22 04:53:42', '2025-08-22 04:53:44'),
('41dbee6d-24d1-41c5-b1d9-e5944a3584d6', NULL, 1, 1, 'print(1+2)', 'completed', 5, 2, 40.00, NULL, '2025-08-22 09:29:27', '2025-08-22 09:29:28'),
('ad62f975-ae6a-4911-866c-b63e5b0cab42', NULL, 1, 1, 'print(5+1)', 'completed', 5, 2, 40.00, NULL, '2025-08-22 10:03:53', '2025-08-22 10:03:54');

-- --------------------------------------------------------

--
-- Table structure for table `submission_events`
--

DROP TABLE IF EXISTS `submission_events`;
CREATE TABLE IF NOT EXISTS `submission_events` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `submission_id` char(36) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `submission_events_submission_id_foreign` (`submission_id`)
) ENGINE=MyISAM AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `submission_events`
--

INSERT INTO `submission_events` (`id`, `submission_id`, `type`, `payload`, `created_at`, `updated_at`) VALUES
(1, '1398c7fc-7b82-445f-8dcd-c0f4a30ec540', 'compile_start', NULL, '2025-08-22 03:01:17', '2025-08-22 03:01:17'),
(2, '1398c7fc-7b82-445f-8dcd-c0f4a30ec540', 'compile_end', '{\"ok\": true}', '2025-08-22 03:01:17', '2025-08-22 03:01:17'),
(3, '1398c7fc-7b82-445f-8dcd-c0f4a30ec540', 'testcase_start', '{\"index\": 1}', '2025-08-22 03:01:17', '2025-08-22 03:01:17'),
(4, '1398c7fc-7b82-445f-8dcd-c0f4a30ec540', 'testcase_end', '{\"index\": 1, \"status\": \"AC\"}', '2025-08-22 03:01:17', '2025-08-22 03:01:17'),
(5, '1398c7fc-7b82-445f-8dcd-c0f4a30ec540', 'testcase_start', '{\"index\": 2}', '2025-08-22 03:01:17', '2025-08-22 03:01:17'),
(6, '1398c7fc-7b82-445f-8dcd-c0f4a30ec540', 'testcase_end', '{\"index\": 2, \"status\": \"WA\"}', '2025-08-22 03:01:17', '2025-08-22 03:01:17'),
(7, '1398c7fc-7b82-445f-8dcd-c0f4a30ec540', 'testcase_start', '{\"index\": 3}', '2025-08-22 03:01:18', '2025-08-22 03:01:18'),
(8, '1398c7fc-7b82-445f-8dcd-c0f4a30ec540', 'testcase_end', '{\"index\": 3, \"status\": \"WA\"}', '2025-08-22 03:01:18', '2025-08-22 03:01:18'),
(9, '1398c7fc-7b82-445f-8dcd-c0f4a30ec540', 'testcase_start', '{\"index\": 4}', '2025-08-22 03:01:18', '2025-08-22 03:01:18'),
(10, '1398c7fc-7b82-445f-8dcd-c0f4a30ec540', 'testcase_end', '{\"index\": 4, \"status\": \"AC\"}', '2025-08-22 03:01:18', '2025-08-22 03:01:18'),
(11, '1398c7fc-7b82-445f-8dcd-c0f4a30ec540', 'testcase_start', '{\"index\": 5}', '2025-08-22 03:01:18', '2025-08-22 03:01:18'),
(12, '1398c7fc-7b82-445f-8dcd-c0f4a30ec540', 'testcase_end', '{\"index\": 5, \"status\": \"WA\"}', '2025-08-22 03:01:18', '2025-08-22 03:01:18'),
(13, '1398c7fc-7b82-445f-8dcd-c0f4a30ec540', 'final', '{\"score\": 40, \"total\": 5, \"passed\": 2}', '2025-08-22 03:01:18', '2025-08-22 03:01:18'),
(14, '5f64cff4-3531-4e02-a66f-7fa673beb0b1', 'compile_start', NULL, '2025-08-22 04:53:43', '2025-08-22 04:53:43'),
(15, '5f64cff4-3531-4e02-a66f-7fa673beb0b1', 'compile_end', '{\"ok\": true}', '2025-08-22 04:53:43', '2025-08-22 04:53:43'),
(16, '5f64cff4-3531-4e02-a66f-7fa673beb0b1', 'testcase_start', '{\"index\": 1}', '2025-08-22 04:53:43', '2025-08-22 04:53:43'),
(17, '5f64cff4-3531-4e02-a66f-7fa673beb0b1', 'testcase_end', '{\"index\": 1, \"status\": \"AC\"}', '2025-08-22 04:53:43', '2025-08-22 04:53:43'),
(18, '5f64cff4-3531-4e02-a66f-7fa673beb0b1', 'testcase_start', '{\"index\": 2}', '2025-08-22 04:53:43', '2025-08-22 04:53:43'),
(19, '5f64cff4-3531-4e02-a66f-7fa673beb0b1', 'testcase_end', '{\"index\": 2, \"status\": \"AC\"}', '2025-08-22 04:53:43', '2025-08-22 04:53:43'),
(20, '5f64cff4-3531-4e02-a66f-7fa673beb0b1', 'testcase_start', '{\"index\": 3}', '2025-08-22 04:53:43', '2025-08-22 04:53:43'),
(21, '5f64cff4-3531-4e02-a66f-7fa673beb0b1', 'testcase_end', '{\"index\": 3, \"status\": \"WA\"}', '2025-08-22 04:53:43', '2025-08-22 04:53:43'),
(22, '5f64cff4-3531-4e02-a66f-7fa673beb0b1', 'testcase_start', '{\"index\": 4}', '2025-08-22 04:53:43', '2025-08-22 04:53:43'),
(23, '5f64cff4-3531-4e02-a66f-7fa673beb0b1', 'testcase_end', '{\"index\": 4, \"status\": \"WA\"}', '2025-08-22 04:53:43', '2025-08-22 04:53:43'),
(24, '5f64cff4-3531-4e02-a66f-7fa673beb0b1', 'testcase_start', '{\"index\": 5}', '2025-08-22 04:53:43', '2025-08-22 04:53:43'),
(25, '5f64cff4-3531-4e02-a66f-7fa673beb0b1', 'testcase_end', '{\"index\": 5, \"status\": \"WA\"}', '2025-08-22 04:53:44', '2025-08-22 04:53:44'),
(26, '5f64cff4-3531-4e02-a66f-7fa673beb0b1', 'final', '{\"score\": 40, \"total\": 5, \"passed\": 2}', '2025-08-22 04:53:44', '2025-08-22 04:53:44'),
(27, '41dbee6d-24d1-41c5-b1d9-e5944a3584d6', 'compile_start', NULL, '2025-08-22 09:29:27', '2025-08-22 09:29:27'),
(28, '41dbee6d-24d1-41c5-b1d9-e5944a3584d6', 'compile_end', '{\"ok\": true}', '2025-08-22 09:29:27', '2025-08-22 09:29:27'),
(29, '41dbee6d-24d1-41c5-b1d9-e5944a3584d6', 'testcase_start', '{\"index\": 1}', '2025-08-22 09:29:27', '2025-08-22 09:29:27'),
(30, '41dbee6d-24d1-41c5-b1d9-e5944a3584d6', 'testcase_end', '{\"index\": 1, \"status\": \"AC\"}', '2025-08-22 09:29:27', '2025-08-22 09:29:27'),
(31, '41dbee6d-24d1-41c5-b1d9-e5944a3584d6', 'testcase_start', '{\"index\": 2}', '2025-08-22 09:29:27', '2025-08-22 09:29:27'),
(32, '41dbee6d-24d1-41c5-b1d9-e5944a3584d6', 'testcase_end', '{\"index\": 2, \"status\": \"AC\"}', '2025-08-22 09:29:27', '2025-08-22 09:29:27'),
(33, '41dbee6d-24d1-41c5-b1d9-e5944a3584d6', 'testcase_start', '{\"index\": 3}', '2025-08-22 09:29:27', '2025-08-22 09:29:27'),
(34, '41dbee6d-24d1-41c5-b1d9-e5944a3584d6', 'testcase_end', '{\"index\": 3, \"status\": \"WA\"}', '2025-08-22 09:29:27', '2025-08-22 09:29:27'),
(35, '41dbee6d-24d1-41c5-b1d9-e5944a3584d6', 'testcase_start', '{\"index\": 4}', '2025-08-22 09:29:27', '2025-08-22 09:29:27'),
(36, '41dbee6d-24d1-41c5-b1d9-e5944a3584d6', 'testcase_end', '{\"index\": 4, \"status\": \"WA\"}', '2025-08-22 09:29:28', '2025-08-22 09:29:28'),
(37, '41dbee6d-24d1-41c5-b1d9-e5944a3584d6', 'testcase_start', '{\"index\": 5}', '2025-08-22 09:29:28', '2025-08-22 09:29:28'),
(38, '41dbee6d-24d1-41c5-b1d9-e5944a3584d6', 'testcase_end', '{\"index\": 5, \"status\": \"WA\"}', '2025-08-22 09:29:28', '2025-08-22 09:29:28'),
(39, '41dbee6d-24d1-41c5-b1d9-e5944a3584d6', 'final', '{\"score\": 40, \"total\": 5, \"passed\": 2}', '2025-08-22 09:29:28', '2025-08-22 09:29:28'),
(40, 'ad62f975-ae6a-4911-866c-b63e5b0cab42', 'compile_start', NULL, '2025-08-22 10:03:53', '2025-08-22 10:03:53'),
(41, 'ad62f975-ae6a-4911-866c-b63e5b0cab42', 'compile_end', '{\"ok\": true}', '2025-08-22 10:03:53', '2025-08-22 10:03:53'),
(42, 'ad62f975-ae6a-4911-866c-b63e5b0cab42', 'testcase_start', '{\"index\": 1}', '2025-08-22 10:03:53', '2025-08-22 10:03:53'),
(43, 'ad62f975-ae6a-4911-866c-b63e5b0cab42', 'testcase_end', '{\"index\": 1, \"status\": \"AC\"}', '2025-08-22 10:03:53', '2025-08-22 10:03:53'),
(44, 'ad62f975-ae6a-4911-866c-b63e5b0cab42', 'testcase_start', '{\"index\": 2}', '2025-08-22 10:03:53', '2025-08-22 10:03:53'),
(45, 'ad62f975-ae6a-4911-866c-b63e5b0cab42', 'testcase_end', '{\"index\": 2, \"status\": \"WA\"}', '2025-08-22 10:03:53', '2025-08-22 10:03:53'),
(46, 'ad62f975-ae6a-4911-866c-b63e5b0cab42', 'testcase_start', '{\"index\": 3}', '2025-08-22 10:03:53', '2025-08-22 10:03:53'),
(47, 'ad62f975-ae6a-4911-866c-b63e5b0cab42', 'testcase_end', '{\"index\": 3, \"status\": \"WA\"}', '2025-08-22 10:03:54', '2025-08-22 10:03:54'),
(48, 'ad62f975-ae6a-4911-866c-b63e5b0cab42', 'testcase_start', '{\"index\": 4}', '2025-08-22 10:03:54', '2025-08-22 10:03:54'),
(49, 'ad62f975-ae6a-4911-866c-b63e5b0cab42', 'testcase_end', '{\"index\": 4, \"status\": \"AC\"}', '2025-08-22 10:03:54', '2025-08-22 10:03:54'),
(50, 'ad62f975-ae6a-4911-866c-b63e5b0cab42', 'testcase_start', '{\"index\": 5}', '2025-08-22 10:03:54', '2025-08-22 10:03:54'),
(51, 'ad62f975-ae6a-4911-866c-b63e5b0cab42', 'testcase_end', '{\"index\": 5, \"status\": \"WA\"}', '2025-08-22 10:03:54', '2025-08-22 10:03:54'),
(52, 'ad62f975-ae6a-4911-866c-b63e5b0cab42', 'final', '{\"score\": 40, \"total\": 5, \"passed\": 2}', '2025-08-22 10:03:54', '2025-08-22 10:03:54');

-- --------------------------------------------------------

--
-- Table structure for table `test_cases`
--

DROP TABLE IF EXISTS `test_cases`;
CREATE TABLE IF NOT EXISTS `test_cases` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `problem_id` bigint UNSIGNED NOT NULL,
  `visibility` enum('public','hidden') COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'public',
  `weight` int UNSIGNED NOT NULL DEFAULT '1',
  `input_ref` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expected_output_ref` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `test_cases_problem_id_foreign` (`problem_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(191) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_email_unique` (`email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
