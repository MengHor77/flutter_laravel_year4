-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 11, 2026 at 10:23 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `flutter_book`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `name`, `email`, `password`, `created_at`, `updated_at`) VALUES
(1, 'admin', 'admin@gmail.com', '$2y$12$KkkyPAhXPa5z7qPwFV8qfeSs8OTS1FrxTCPbRzi2JWr.JJ93VGkaa', '2026-02-09 20:38:25', '2026-02-09 20:38:25');

-- --------------------------------------------------------

--
-- Table structure for table `best_selling_book`
--

CREATE TABLE `best_selling_book` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `book_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `best_selling_book`
--

INSERT INTO `best_selling_book` (`id`, `book_id`, `created_at`, `updated_at`) VALUES
(1, 3, '2026-02-10 12:49:33', '2026-02-10 12:49:33');

-- --------------------------------------------------------

--
-- Table structure for table `book`
--

CREATE TABLE `book` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `author` varchar(255) NOT NULL,
  `image` varchar(255) DEFAULT NULL,
  `price` decimal(8,2) NOT NULL DEFAULT 0.00,
  `category_id` bigint(20) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `book`
--

INSERT INTO `book` (`id`, `name`, `author`, `image`, `price`, `category_id`, `created_at`, `updated_at`) VALUES
(3, 'book3', 'au3', 'http://172.20.10.2:8000/uploads/books/1770727057_scaled_33.jpg', 3.00, 2, '2026-02-10 12:37:37', '2026-02-10 12:37:37'),
(4, 'book3', 'au3', 'http://172.20.10.2:8000/uploads/books/1770736172_scaled_33.jpg', 3.00, 2, '2026-02-10 15:09:32', '2026-02-10 15:09:32');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'cat1', 'ds1', '2026-02-09 20:39:15', '2026-02-09 20:39:15'),
(2, 'cat2', 'des2', '2026-02-10 12:29:45', '2026-02-10 12:29:45'),
(3, 'cat3', 'des3', '2026-02-10 12:31:17', '2026-02-10 12:31:36');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_02_05_105218_create_category_table', 1),
(5, '2026_02_05_105259_create_book_table', 1),
(6, '2026_02_05_105329_create_admin_table', 1),
(7, '2026_02_05_105417_create_order_list_table', 1),
(8, '2026_02_05_105606_create_special_offer_table', 1),
(9, '2026_02_05_134908_create_personal_access_tokens_table', 1),
(10, '2026_02_06_045730_create_best_selling_book_table', 1),
(11, '2026_02_08_150258_create_orders_table', 1),
(12, '2026_02_09_130419_create_sales_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `status` varchar(255) NOT NULL DEFAULT 'completed',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `total_amount`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 12.00, 'completed', '2026-02-09 20:40:35', '2026-02-09 20:40:35'),
(2, 1, 9.00, 'completed', '2026-02-10 01:03:54', '2026-02-10 01:03:54'),
(3, 1, 9.00, 'completed', '2026-02-10 01:06:14', '2026-02-10 01:06:14'),
(4, 1, 20.00, 'completed', '2026-02-10 02:25:54', '2026-02-10 02:25:54'),
(5, 1, 43.00, 'completed', '2026-02-10 02:37:13', '2026-02-10 02:37:13'),
(6, 1, 10.00, 'completed', '2026-02-10 02:40:07', '2026-02-10 02:40:07'),
(7, 1, 4.00, 'completed', '2026-02-10 09:54:58', '2026-02-10 09:54:58'),
(8, 1, 10.00, 'completed', '2026-02-10 09:59:46', '2026-02-10 09:59:46'),
(9, 1, 7.00, 'completed', '2026-02-10 12:54:02', '2026-02-10 12:54:02'),
(10, 1, 2.70, 'completed', '2026-02-10 12:56:35', '2026-02-10 12:56:35'),
(11, 1, 4.70, 'completed', '2026-02-10 14:41:08', '2026-02-10 14:41:08'),
(12, 1, 4.70, 'completed', '2026-02-10 15:10:44', '2026-02-10 15:10:44'),
(13, 1, 8.10, 'completed', '2026-02-11 02:29:41', '2026-02-11 02:29:41');

-- --------------------------------------------------------

--
-- Table structure for table `order_list`
--

CREATE TABLE `order_list` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `book_id` bigint(20) UNSIGNED NOT NULL,
  `price` decimal(8,2) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_list`
--

INSERT INTO `order_list` (`id`, `user_id`, `book_id`, `price`, `quantity`, `created_at`, `updated_at`) VALUES
(22, 1, 3, 2.70, 1, '2026-02-11 02:31:23', '2026-02-11 02:35:16'),
(23, 1, 4, 3.00, 1, '2026-02-11 02:35:20', '2026-02-11 02:35:20');

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(1, 'App\\Models\\Admin', 1, 'mobile_app', '2c1d4c31974e20829f4ed9811f81e301e4fb45bc202cbea6c900e4055ad79e86', '[\"*\"]', '2026-02-09 20:39:03', NULL, '2026-02-09 20:39:02', '2026-02-09 20:39:03'),
(2, 'App\\Models\\User', 1, 'mobile_app', '47cd091fd42a79ab2f6ff9288466ea4d93a822865d68a59a7377e7d11fe29161', '[\"*\"]', '2026-02-09 20:40:35', NULL, '2026-02-09 20:40:22', '2026-02-09 20:40:35'),
(3, 'App\\Models\\Admin', 1, 'mobile_app', '6a4a2a17cb61de6624f1cb127f0f18a9a3d677195408c18a384e26f5b073782b', '[\"*\"]', '2026-02-10 01:02:19', NULL, '2026-02-10 01:02:15', '2026-02-10 01:02:19'),
(4, 'App\\Models\\User', 1, 'mobile_app', 'dc104b7204ad7c8a8bd43515fa6c14b0842ef339e1448645f0e68e7be5ccecc6', '[\"*\"]', '2026-02-10 01:03:54', NULL, '2026-02-10 01:03:17', '2026-02-10 01:03:54'),
(5, 'App\\Models\\Admin', 1, 'mobile_app', 'a5648a21eb3eb06cdca84d2865e860d10cc88680c8505bec5625de84df32a4c9', '[\"*\"]', '2026-02-10 01:04:48', NULL, '2026-02-10 01:04:37', '2026-02-10 01:04:48'),
(6, 'App\\Models\\User', 1, 'mobile_app', '1e50f61e926339709be10fa45940404a32f9581063ef8a52869786f4cf3f27be', '[\"*\"]', '2026-02-10 01:06:14', NULL, '2026-02-10 01:05:48', '2026-02-10 01:06:14'),
(7, 'App\\Models\\Admin', 1, 'mobile_app', '5b0c3f670d6bc4b6451c6bc8604cdebd903e055ad87a3cf5d3fd38049c90a52a', '[\"*\"]', '2026-02-10 02:24:15', NULL, '2026-02-10 01:06:43', '2026-02-10 02:24:15'),
(8, 'App\\Models\\User', 1, 'mobile_app', '701d90dacf36cffafe6daf09a9969af4df6b15fc1ceaea205647d4c52d50afb0', '[\"*\"]', '2026-02-10 02:25:54', NULL, '2026-02-10 02:25:05', '2026-02-10 02:25:54'),
(9, 'App\\Models\\Admin', 1, 'mobile_app', '3a780e5d26c11e0d3810f03e173fafe48f3b3b39423e11fcde4bf358f0840a3f', '[\"*\"]', '2026-02-10 02:28:45', NULL, '2026-02-10 02:26:21', '2026-02-10 02:28:45'),
(10, 'App\\Models\\User', 1, 'mobile_app', '8834aaaeb86f33e5d83b126f9b70d21e61967066e252da5297248360e76fa898', '[\"*\"]', '2026-02-10 02:40:07', NULL, '2026-02-10 02:29:55', '2026-02-10 02:40:07'),
(11, 'App\\Models\\Admin', 1, 'mobile_app', '21f587547169aa7f4183c2b35b3dfbfd363459c24cd4da31524c37e23e6eb599', '[\"*\"]', '2026-02-10 09:52:13', NULL, '2026-02-10 02:40:42', '2026-02-10 09:52:13'),
(12, 'App\\Models\\User', 1, 'mobile_app', '0a628cccd1b96104d6f25d022bfada6a51468ac83eef416dc0ae2b69f99654fb', '[\"*\"]', '2026-02-10 09:54:58', NULL, '2026-02-10 09:54:32', '2026-02-10 09:54:58'),
(13, 'App\\Models\\Admin', 1, 'mobile_app', 'bea2f009f8bbeb2eb4c3d804c1ded6794d2d260477abd6a884548e3bc70853f5', '[\"*\"]', '2026-02-10 09:58:59', NULL, '2026-02-10 09:55:27', '2026-02-10 09:58:59'),
(14, 'App\\Models\\User', 1, 'mobile_app', 'ecf595f5ae9f8e66b48e4c8b4e031605606e99cb768a30abc37fefd9e9f0ee32', '[\"*\"]', '2026-02-10 09:59:46', NULL, '2026-02-10 09:59:30', '2026-02-10 09:59:46'),
(15, 'App\\Models\\Admin', 1, 'mobile_app', '140874e76406f12fc95dd7ab9a253538e534c504061ee8d4863b4ed3d4a9c8b3', '[\"*\"]', '2026-02-10 10:03:46', NULL, '2026-02-10 10:00:16', '2026-02-10 10:03:46'),
(16, 'App\\Models\\Admin', 1, 'mobile_app', '4e03e034d7335e59a326f5c240084df0eef96c5699917acf8127ce71de5e6a26', '[\"*\"]', '2026-02-10 12:52:46', NULL, '2026-02-10 11:39:28', '2026-02-10 12:52:46'),
(17, 'App\\Models\\User', 1, 'mobile_app', '2043f61c810d3a0ecb5647a79c052d1d9950304069ea659435ee3f1828429074', '[\"*\"]', '2026-02-10 12:54:02', NULL, '2026-02-10 12:53:34', '2026-02-10 12:54:02'),
(18, 'App\\Models\\Admin', 1, 'mobile_app', '4c46a9719af34d2b87dcaf2b4bd8af98f78c5735861af4011a60115cc0dd93a6', '[\"*\"]', '2026-02-10 12:54:48', NULL, '2026-02-10 12:54:47', '2026-02-10 12:54:48'),
(19, 'App\\Models\\User', 1, 'mobile_app', '652dc0c149816889719a3204121bc1df37613014235ef923293eb688b89255ab', '[\"*\"]', '2026-02-10 14:41:06', NULL, '2026-02-10 12:55:47', '2026-02-10 14:41:06'),
(20, 'App\\Models\\Admin', 1, 'mobile_app', 'a99efed6806a91949b0704d3215617cf956b2d8ba08c53f9e952f2e6e32e5385', '[\"*\"]', '2026-02-10 14:53:15', NULL, '2026-02-10 14:42:52', '2026-02-10 14:53:15'),
(21, 'App\\Models\\User', 1, 'mobile_app', '523fd8f0f17ab99d2636012a270dad7185a3cd91805478c6882d2262b294914f', '[\"*\"]', '2026-02-10 15:10:44', NULL, '2026-02-10 15:10:16', '2026-02-10 15:10:44'),
(22, 'App\\Models\\Admin', 1, 'mobile_app', '859a0ae6d416b79a523ab0cf9a3e6294f5278e34c28c9252576a40e1fc5b787d', '[\"*\"]', '2026-02-10 15:46:12', NULL, '2026-02-10 15:11:15', '2026-02-10 15:46:12'),
(23, 'App\\Models\\Admin', 1, 'mobile_app', 'c3deb49533a6af0f9fce58d345ff543f29167ab24ecc8bdd6901aefbced9746d', '[\"*\"]', '2026-02-11 01:24:48', NULL, '2026-02-11 01:24:15', '2026-02-11 01:24:48'),
(24, 'App\\Models\\User', 1, 'mobile_app', '9c7bdb95d54ddca120d1e27ced2ea97c049cd9d733d8b3b968169690020c9ec5', '[\"*\"]', '2026-02-11 01:41:54', NULL, '2026-02-11 01:27:11', '2026-02-11 01:41:54'),
(25, 'App\\Models\\User', 1, 'mobile_app', '2a40ba97d4810bd3613338b87e49e678c427e20cd57d987086215b509b3e5ee1', '[\"*\"]', '2026-02-11 02:00:55', NULL, '2026-02-11 02:00:55', '2026-02-11 02:00:55'),
(26, 'App\\Models\\User', 1, 'mobile_app', 'b8a40632e6c45bed8ad7a12f7d445e71350c09de0f8ba0c3216d9152793b66e2', '[\"*\"]', '2026-02-11 02:14:28', NULL, '2026-02-11 02:14:27', '2026-02-11 02:14:28'),
(27, 'App\\Models\\User', 1, 'mobile_app', '549bb8aac34f10750dcdba6ee0f42ef22dcdea01baf97f10a7519784a4e4e024', '[\"*\"]', '2026-02-11 02:29:41', NULL, '2026-02-11 02:26:02', '2026-02-11 02:29:41'),
(28, 'App\\Models\\Admin', 1, 'mobile_app', '36659cb43e1f8df833392da280e0be0573c3f144cb35ec7922604f1a932b33b2', '[\"*\"]', '2026-02-11 02:30:28', NULL, '2026-02-11 02:30:27', '2026-02-11 02:30:28'),
(29, 'App\\Models\\User', 1, 'mobile_app', '3ef876e647788d23e485d43a5fb844b7fd33f6c35fdd1b06996f22886c7b88a1', '[\"*\"]', '2026-02-11 02:31:23', NULL, '2026-02-11 02:31:19', '2026-02-11 02:31:23'),
(30, 'App\\Models\\Admin', 1, 'mobile_app', '2eff777bb777091ddb29bd54d69ade85ff103c51a38fb5b31c84d3167600ec76', '[\"*\"]', '2026-02-11 02:32:47', NULL, '2026-02-11 02:31:53', '2026-02-11 02:32:47'),
(31, 'App\\Models\\Admin', 1, 'mobile_app', 'eb5251b3813a665fbe00056195bce606ca697a83899ffd9adb2aa7936e471d43', '[\"*\"]', '2026-02-11 02:34:07', NULL, '2026-02-11 02:33:38', '2026-02-11 02:34:07'),
(32, 'App\\Models\\User', 1, 'mobile_app', '207d8895d480db4b2fbe688f980db7330544aa57247578b108e328cde967e230', '[\"*\"]', '2026-02-11 02:35:20', NULL, '2026-02-11 02:34:53', '2026-02-11 02:35:20'),
(33, 'App\\Models\\Admin', 1, 'mobile_app', 'c246679a4bd761ad1a6826d10b6a1be2f50b2263c8a0307d86d805e551c75d75', '[\"*\"]', '2026-02-11 02:35:45', NULL, '2026-02-11 02:35:43', '2026-02-11 02:35:45'),
(34, 'App\\Models\\User', 1, 'mobile_app', '1eb2f63768b5d038c492aa9194209c97d96970b4af3aa883d9456237ae9d6dd6', '[\"*\"]', '2026-02-11 02:37:28', NULL, '2026-02-11 02:37:27', '2026-02-11 02:37:28');

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

CREATE TABLE `sales` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `order_id` bigint(20) UNSIGNED NOT NULL,
  `book_id` bigint(20) UNSIGNED NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `quantity` int(11) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sales`
--

INSERT INTO `sales` (`id`, `user_id`, `order_id`, `book_id`, `price`, `quantity`, `total_amount`, `created_at`, `updated_at`) VALUES
(14, 1, 9, 3, 3.00, 1, 3.00, '2026-02-10 12:54:02', '2026-02-10 12:54:02'),
(15, 1, 10, 3, 2.70, 1, 2.70, '2026-02-10 12:56:35', '2026-02-10 12:56:35'),
(17, 1, 11, 3, 2.70, 1, 2.70, '2026-02-10 14:41:08', '2026-02-10 14:41:08'),
(18, 1, 12, 3, 2.70, 1, 2.70, '2026-02-10 15:10:44', '2026-02-10 15:10:44'),
(20, 1, 13, 3, 2.70, 3, 8.10, '2026-02-11 02:29:41', '2026-02-11 02:29:41');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `special_offer`
--

CREATE TABLE `special_offer` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `book_id` bigint(20) UNSIGNED NOT NULL,
  `title` varchar(255) NOT NULL,
  `discount_percentage` decimal(5,2) NOT NULL,
  `offer_price` decimal(8,2) NOT NULL,
  `start_date` datetime DEFAULT NULL,
  `end_date` datetime DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `special_offer`
--

INSERT INTO `special_offer` (`id`, `book_id`, `title`, `discount_percentage`, `offer_price`, `start_date`, `end_date`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 3, 'chines new year', 10.00, 2.70, NULL, NULL, 1, '2026-02-10 12:55:12', '2026-02-10 12:55:12');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `email_verified_at`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'hor', 'hor@gmail.com', NULL, '$2y$12$fuaie0q7b8vkfwaXfvKIDOr0ZXUbWUt9YdCm1SMrFOrYrEraaSOEa', NULL, '2026-02-09 20:40:02', '2026-02-09 20:40:02');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `admin_email_unique` (`email`);

--
-- Indexes for table `best_selling_book`
--
ALTER TABLE `best_selling_book`
  ADD PRIMARY KEY (`id`),
  ADD KEY `best_selling_book_book_id_foreign` (`book_id`);

--
-- Indexes for table `book`
--
ALTER TABLE `book`
  ADD PRIMARY KEY (`id`),
  ADD KEY `book_category_id_foreign` (`category_id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `category_name_unique` (`name`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orders_user_id_foreign` (`user_id`);

--
-- Indexes for table `order_list`
--
ALTER TABLE `order_list`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_list_user_id_foreign` (`user_id`),
  ADD KEY `order_list_book_id_foreign` (`book_id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indexes for table `sales`
--
ALTER TABLE `sales`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sales_user_id_foreign` (`user_id`),
  ADD KEY `sales_order_id_foreign` (`order_id`),
  ADD KEY `sales_book_id_foreign` (`book_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `special_offer`
--
ALTER TABLE `special_offer`
  ADD PRIMARY KEY (`id`),
  ADD KEY `special_offer_book_id_foreign` (`book_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `best_selling_book`
--
ALTER TABLE `best_selling_book`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `book`
--
ALTER TABLE `book`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `order_list`
--
ALTER TABLE `order_list`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=35;

--
-- AUTO_INCREMENT for table `sales`
--
ALTER TABLE `sales`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `special_offer`
--
ALTER TABLE `special_offer`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `best_selling_book`
--
ALTER TABLE `best_selling_book`
  ADD CONSTRAINT `best_selling_book_book_id_foreign` FOREIGN KEY (`book_id`) REFERENCES `book` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `book`
--
ALTER TABLE `book`
  ADD CONSTRAINT `book_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `order_list`
--
ALTER TABLE `order_list`
  ADD CONSTRAINT `order_list_book_id_foreign` FOREIGN KEY (`book_id`) REFERENCES `book` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `order_list_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sales`
--
ALTER TABLE `sales`
  ADD CONSTRAINT `sales_book_id_foreign` FOREIGN KEY (`book_id`) REFERENCES `book` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `sales_order_id_foreign` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `sales_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `special_offer`
--
ALTER TABLE `special_offer`
  ADD CONSTRAINT `special_offer_book_id_foreign` FOREIGN KEY (`book_id`) REFERENCES `book` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
