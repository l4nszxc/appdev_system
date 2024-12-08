-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 08, 2024 at 09:52 AM
-- Server version: 8.0.30
-- PHP Version: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `appdev_system`
--

-- --------------------------------------------------------

--
-- Table structure for table `announcements`
--

CREATE TABLE `announcements` (
  `id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `appointments`
--

CREATE TABLE `appointments` (
  `id` int NOT NULL,
  `student_id` varchar(255) NOT NULL,
  `date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `status` varchar(20) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `meeting_link` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` (`id`, `student_id`, `date`, `start_time`, `end_time`, `status`, `created_at`, `updated_at`, `meeting_link`) VALUES
(65, 'MCC2022-0000', '2024-11-27', '08:00:00', '09:00:00', 'scheduled', '2024-11-26 06:41:18', NULL, NULL),
(66, 'MCC2022-1212', '2024-11-28', '14:00:00', '15:00:00', 'cancelled', '2024-11-28 02:27:44', '2024-11-28 02:30:35', 'https://meet.google.com/ajg-nupi-xvi'),
(67, 'MCC2022-0811', '2024-11-30', '08:00:00', '09:00:00', 'scheduled', '2024-11-30 23:19:05', NULL, NULL),
(68, 'MCC2022-0811', '2024-12-02', '10:00:00', '11:00:00', 'cancelled', '2024-12-02 23:36:29', '2024-12-02 23:45:53', 'https://meet.google.com/ybq-shgb-hee'),
(69, 'MCC2022-0811', '2024-12-04', '11:00:00', '12:00:00', 'scheduled', '2024-12-02 23:45:59', NULL, NULL),
(70, 'MCC2022-0811', '2024-12-05', '08:00:00', '09:00:00', 'scheduled', '2024-12-05 01:33:28', NULL, NULL),
(71, 'MCC2022-1212', '2024-12-05', '10:00:00', '11:00:00', 'scheduled', '2024-12-05 01:37:05', NULL, NULL),
(72, 'MCC2022-0811', '2024-12-08', '10:00:00', '11:00:00', 'cancelled', '2024-12-08 12:43:36', '2024-12-08 13:12:40', NULL),
(73, 'MCC2022-0811', '2024-12-08', '09:00:00', '10:00:00', 'cancelled', '2024-12-08 13:12:43', '2024-12-08 13:12:44', NULL),
(77, 'MCC2022-0811', '2024-12-08', '08:00:00', '09:00:00', 'cancelled', '2024-12-08 13:12:48', '2024-12-08 13:12:49', NULL),
(89, 'MCC2022-0811', '2024-12-08', '13:00:00', '14:00:00', 'scheduled', '2024-12-08 13:13:01', NULL, NULL),
(90, 'MCC2022-1209', '2024-12-08', '16:00:00', '17:00:00', 'scheduled', '2024-12-08 15:59:31', '2024-12-08 16:00:05', 'https://meet.google.com/hqj-bgew-gzn?ijlm=1733644800358&hs=187&adhoc=1');

-- --------------------------------------------------------

--
-- Table structure for table `conversations`
--

CREATE TABLE `conversations` (
  `id` int NOT NULL,
  `student_id` varchar(255) NOT NULL,
  `participant_id` varchar(255) NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `conversations`
--

INSERT INTO `conversations` (`id`, `student_id`, `participant_id`, `created_at`, `updated_at`) VALUES
(100, 'MCC2022-1209', 'MCC2022-0000', '2024-12-08 16:32:45', '2024-12-08 16:32:45'),
(101, 'MCC2022-0811', 'MCC2022-0000', '2024-12-08 16:34:47', '2024-12-08 16:34:47'),
(102, 'MCC2022-0000', 'MCC2022-0347', '2024-12-08 16:35:21', '2024-12-08 16:35:21'),
(103, 'MCC2022-0000', 'MCC2022-0359', '2024-12-08 16:46:14', '2024-12-08 16:46:14'),
(104, 'MCC2022-0000', 'MCC2022-0850', '2024-12-08 16:46:15', '2024-12-08 16:46:15'),
(105, 'MCC2022-0000', 'MCC2022-0347', '2024-12-08 16:47:08', '2024-12-08 16:47:08'),
(106, 'MCC2022-0000', 'MCC2022-0347', '2024-12-08 16:47:09', '2024-12-08 16:47:09'),
(107, 'MCC2022-0000', 'MCC2022-0359', '2024-12-08 16:47:10', '2024-12-08 16:47:10'),
(108, 'MCC2022-0000', 'MCC2022-0539', '2024-12-08 16:47:10', '2024-12-08 16:47:10'),
(109, 'MCC2022-0000', 'MCC2022-1122', '2024-12-08 17:01:04', '2024-12-08 17:01:04'),
(110, 'MCC2022-0000', 'MCC2022-6666', '2024-12-08 17:01:08', '2024-12-08 17:01:08'),
(111, 'MCC2022-0000', 'MCC2022-1302', '2024-12-08 17:01:10', '2024-12-08 17:01:10'),
(112, 'MCC2022-0000', 'MCC2022-0533', '2024-12-08 17:01:12', '2024-12-08 17:01:12'),
(113, 'MCC2022-0811', 'MCC2022-0347', '2024-12-08 17:27:57', '2024-12-08 17:27:57'),
(114, 'MCC2022-0811', 'MCC2022-0359', '2024-12-08 17:46:38', '2024-12-08 17:46:38'),
(115, 'MCC2022-0811', 'MCC2022-0850', '2024-12-08 17:48:05', '2024-12-08 17:48:05'),
(116, 'MCC2022-0811', 'MCC2022-0539', '2024-12-08 17:48:09', '2024-12-08 17:48:09'),
(117, 'MCC2022-0811', 'MCC2022-0533', '2024-12-08 17:48:10', '2024-12-08 17:48:10');

-- --------------------------------------------------------

--
-- Table structure for table `empathy_challenges`
--

CREATE TABLE `empathy_challenges` (
  `id` int NOT NULL,
  `student_id` varchar(255) NOT NULL,
  `comment_level` int DEFAULT '1',
  `comments_count` int DEFAULT '0',
  `reaction_level` int DEFAULT '1',
  `reactions_count` int DEFAULT '0',
  `start_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `end_date` datetime DEFAULT NULL,
  `last_reset_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `empathy_challenges`
--

INSERT INTO `empathy_challenges` (`id`, `student_id`, `comment_level`, `comments_count`, `reaction_level`, `reactions_count`, `start_date`, `end_date`, `last_reset_date`) VALUES
(6, 'MCC2022-0811', 1, 1, 1, 0, '2024-12-03 10:36:14', NULL, '2024-12-08 04:33:20'),
(7, 'MCC2022-0533', 1, 0, 1, 0, '2024-12-05 01:33:43', NULL, '2024-12-04 17:33:43'),
(8, 'MCC2022-1212', 1, 0, 1, 0, '2024-12-05 01:34:59', NULL, '2024-12-04 17:34:59'),
(9, 'MCC2022-1209', 1, 0, 1, 0, '2024-12-08 15:59:18', NULL, '2024-12-08 07:59:18');

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `feedback_id` int NOT NULL,
  `student_id` varchar(255) NOT NULL,
  `feedback_type` varchar(20) NOT NULL,
  `feedback_content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`feedback_id`, `student_id`, `feedback_type`, `feedback_content`, `created_at`, `updated_at`) VALUES
(20, 'MCC2022-0000', 'issue', 'hirap', '2024-11-25 22:42:46', '2024-11-25 22:42:46'),
(21, 'MCC2022-0000', 'issue', 'haybu', '2024-11-27 17:00:47', '2024-11-27 17:00:47'),
(22, 'MCC2022-0811', 'suggestion', 'das', '2024-11-30 03:26:30', '2024-11-30 03:26:30'),
(23, 'MCC2022-0811', 'suggestion', 'dsa', '2024-12-02 15:45:10', '2024-12-02 15:45:10'),
(24, 'MCC2022-0811', 'issue', 'dsa', '2024-12-02 18:36:09', '2024-12-02 18:36:09');

-- --------------------------------------------------------

--
-- Table structure for table `help_articles`
--

CREATE TABLE `help_articles` (
  `id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `category` varchar(100) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` int NOT NULL,
  `conversation_id` int NOT NULL,
  `sender_id` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `is_seen` tinyint(1) DEFAULT '0',
  `seen_at` datetime DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`id`, `conversation_id`, `sender_id`, `message`, `created_at`, `is_seen`, `seen_at`, `is_read`) VALUES
(19, 100, 'MCC2022-1209', 'boss', '2024-12-08 16:32:47', 0, NULL, 0),
(20, 101, 'MCC2022-0811', 'boss? bossing ko boss', '2024-12-08 16:34:55', 1, '2024-12-08 17:25:35', 0),
(21, 101, 'MCC2022-0000', 'hi l4ns', '2024-12-08 16:35:16', 1, '2024-12-08 17:25:54', 0),
(22, 101, 'MCC2022-0811', 'dsadsa', '2024-12-08 17:00:22', 1, '2024-12-08 17:25:35', 0),
(23, 101, 'MCC2022-0811', 'dsa', '2024-12-08 17:00:22', 1, '2024-12-08 17:25:35', 0),
(24, 101, 'MCC2022-0811', 'dsa', '2024-12-08 17:00:24', 1, '2024-12-08 17:25:35', 0),
(25, 101, 'MCC2022-0811', 'dsa', '2024-12-08 17:00:24', 1, '2024-12-08 17:25:35', 0),
(26, 101, 'MCC2022-0811', 'das', '2024-12-08 17:00:24', 1, '2024-12-08 17:25:35', 0),
(27, 101, 'MCC2022-0811', 'd', '2024-12-08 17:00:24', 1, '2024-12-08 17:25:35', 0),
(28, 101, 'MCC2022-0811', 'as', '2024-12-08 17:00:24', 1, '2024-12-08 17:25:35', 0),
(29, 101, 'MCC2022-0811', 'dsa', '2024-12-08 17:00:24', 1, '2024-12-08 17:25:35', 0),
(30, 101, 'MCC2022-0811', 'd', '2024-12-08 17:00:25', 1, '2024-12-08 17:25:35', 0),
(31, 101, 'MCC2022-0811', 'as', '2024-12-08 17:00:25', 1, '2024-12-08 17:25:35', 0),
(32, 101, 'MCC2022-0811', 'd', '2024-12-08 17:00:25', 1, '2024-12-08 17:25:35', 0),
(33, 101, 'MCC2022-0811', 'd', '2024-12-08 17:00:26', 1, '2024-12-08 17:25:35', 0),
(34, 101, 'MCC2022-0811', 'sda', '2024-12-08 17:00:26', 1, '2024-12-08 17:25:35', 0),
(35, 101, 'MCC2022-0811', 'das', '2024-12-08 17:00:26', 1, '2024-12-08 17:25:35', 0),
(36, 101, 'MCC2022-0811', 'd', '2024-12-08 17:00:26', 1, '2024-12-08 17:25:35', 0),
(37, 101, 'MCC2022-0811', 'asd', '2024-12-08 17:00:27', 1, '2024-12-08 17:25:35', 0),
(38, 101, 'MCC2022-0811', 'as', '2024-12-08 17:00:27', 1, '2024-12-08 17:25:35', 0),
(39, 101, 'MCC2022-0811', 'das', '2024-12-08 17:00:27', 1, '2024-12-08 17:25:35', 0),
(40, 101, 'MCC2022-0811', 'dsa', '2024-12-08 17:00:27', 1, '2024-12-08 17:25:35', 0),
(41, 101, 'MCC2022-0811', 'd', '2024-12-08 17:00:27', 1, '2024-12-08 17:25:35', 0),
(42, 101, 'MCC2022-0811', 'asd', '2024-12-08 17:00:28', 1, '2024-12-08 17:25:35', 0),
(43, 101, 'MCC2022-0811', 'as', '2024-12-08 17:00:28', 1, '2024-12-08 17:25:35', 0),
(44, 101, 'MCC2022-0811', 'das', '2024-12-08 17:00:28', 1, '2024-12-08 17:25:35', 0),
(45, 101, 'MCC2022-0811', 'das', '2024-12-08 17:00:28', 1, '2024-12-08 17:25:35', 0),
(46, 101, 'MCC2022-0811', 'das', '2024-12-08 17:00:28', 1, '2024-12-08 17:25:35', 0),
(47, 101, 'MCC2022-0811', 'das', '2024-12-08 17:00:29', 1, '2024-12-08 17:25:35', 0),
(48, 101, 'MCC2022-0811', 'das', '2024-12-08 17:00:29', 1, '2024-12-08 17:25:35', 0),
(49, 101, 'MCC2022-0811', 'd', '2024-12-08 17:00:29', 1, '2024-12-08 17:25:35', 0),
(50, 101, 'MCC2022-0811', 'asd', '2024-12-08 17:00:29', 1, '2024-12-08 17:25:35', 0),
(51, 101, 'MCC2022-0811', 'ad', '2024-12-08 17:00:29', 1, '2024-12-08 17:25:35', 0),
(52, 101, 'MCC2022-0811', 'sa', '2024-12-08 17:00:30', 1, '2024-12-08 17:25:35', 0),
(53, 101, 'MCC2022-0811', 'das', '2024-12-08 17:00:30', 1, '2024-12-08 17:25:35', 0),
(54, 101, 'MCC2022-0811', 'das', '2024-12-08 17:00:30', 1, '2024-12-08 17:25:35', 0),
(55, 101, 'MCC2022-0811', 'das', '2024-12-08 17:00:30', 1, '2024-12-08 17:25:35', 0),
(56, 101, 'MCC2022-0811', 'd', '2024-12-08 17:00:30', 1, '2024-12-08 17:25:35', 0),
(57, 101, 'MCC2022-0811', 'sad', '2024-12-08 17:00:31', 1, '2024-12-08 17:25:35', 0),
(58, 101, 'MCC2022-0811', 'asd', '2024-12-08 17:00:31', 1, '2024-12-08 17:25:35', 0),
(59, 101, 'MCC2022-0811', 'as', '2024-12-08 17:00:31', 1, '2024-12-08 17:25:35', 0),
(60, 101, 'MCC2022-0811', 'das', '2024-12-08 17:00:31', 1, '2024-12-08 17:25:35', 0),
(61, 101, 'MCC2022-0811', 'das', '2024-12-08 17:00:31', 1, '2024-12-08 17:25:35', 0),
(62, 101, 'MCC2022-0811', 'd', '2024-12-08 17:00:32', 1, '2024-12-08 17:25:35', 0),
(63, 101, 'MCC2022-0811', 'asd', '2024-12-08 17:00:32', 1, '2024-12-08 17:25:35', 0),
(64, 101, 'MCC2022-0811', 'as', '2024-12-08 17:00:32', 1, '2024-12-08 17:25:35', 0),
(65, 101, 'MCC2022-0811', 'dsa', '2024-12-08 17:00:32', 1, '2024-12-08 17:25:35', 0),
(66, 101, 'MCC2022-0811', 'das', '2024-12-08 17:00:32', 1, '2024-12-08 17:25:35', 0),
(67, 101, 'MCC2022-0811', 'das', '2024-12-08 17:00:33', 1, '2024-12-08 17:25:35', 0),
(68, 101, 'MCC2022-0811', 'd', '2024-12-08 17:00:33', 1, '2024-12-08 17:25:35', 0),
(69, 101, 'MCC2022-0811', 'asd', '2024-12-08 17:00:33', 1, '2024-12-08 17:25:35', 0),
(70, 101, 'MCC2022-0811', 'as', '2024-12-08 17:00:33', 1, '2024-12-08 17:25:35', 0),
(71, 101, 'MCC2022-0811', 'das', '2024-12-08 17:00:34', 1, '2024-12-08 17:25:35', 0),
(72, 101, 'MCC2022-0811', 'das', '2024-12-08 17:00:34', 1, '2024-12-08 17:25:35', 0),
(73, 101, 'MCC2022-0811', 'dasd', '2024-12-08 17:00:34', 1, '2024-12-08 17:25:35', 0),
(74, 101, 'MCC2022-0811', 'asf', '2024-12-08 17:00:34', 1, '2024-12-08 17:25:35', 0),
(75, 101, 'MCC2022-0811', 'fsa', '2024-12-08 17:00:35', 1, '2024-12-08 17:25:35', 0),
(76, 101, 'MCC2022-0811', 'fsa', '2024-12-08 17:00:36', 1, '2024-12-08 17:25:35', 0),
(77, 101, 'MCC2022-0811', 'fssa', '2024-12-08 17:00:36', 1, '2024-12-08 17:25:35', 0),
(78, 101, 'MCC2022-0811', 'fas', '2024-12-08 17:00:36', 1, '2024-12-08 17:25:35', 0),
(79, 101, 'MCC2022-0811', 's', '2024-12-08 17:00:37', 1, '2024-12-08 17:25:35', 0),
(80, 101, 'MCC2022-0811', 'as', '2024-12-08 17:00:37', 1, '2024-12-08 17:25:35', 0),
(81, 101, 'MCC2022-0811', 'fsa\'f', '2024-12-08 17:00:37', 1, '2024-12-08 17:25:35', 0),
(82, 101, 'MCC2022-0000', 'heyyyy', '2024-12-08 17:25:38', 1, '2024-12-08 17:25:54', 0),
(83, 101, 'MCC2022-0000', 'hey', '2024-12-08 17:25:44', 1, '2024-12-08 17:25:54', 0),
(84, 101, 'MCC2022-0811', 'boss', '2024-12-08 17:27:53', 1, '2024-12-08 17:28:22', 0),
(85, 101, 'MCC2022-0811', 'dasdas', '2024-12-08 17:45:33', 1, '2024-12-08 17:47:00', 0),
(86, 113, 'MCC2022-0811', 'yoo', '2024-12-08 17:47:45', 0, NULL, 0),
(87, 114, 'MCC2022-0811', 'hello', '2024-12-08 17:47:51', 0, NULL, 0),
(88, 115, 'MCC2022-0811', 'dasda', '2024-12-08 17:48:07', 0, NULL, 0);

-- --------------------------------------------------------

--
-- Table structure for table `moods`
--

CREATE TABLE `moods` (
  `id` int NOT NULL,
  `student_id` varchar(255) NOT NULL,
  `mood` text NOT NULL,
  `sentiment` enum('Positive','Neutral','Negative') NOT NULL,
  `comment` text,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `moods`
--

INSERT INTO `moods` (`id`, `student_id`, `mood`, `sentiment`, `comment`, `created_at`) VALUES
(11, 'MCC2022-6666', 'Neutral', 'Neutral', 'xcadvsx', '2024-11-25 13:26:35'),
(13, 'MCC2022-0000', 'Negative', 'Negative', 'hays', '2024-11-28 01:00:51'),
(14, 'MCC2022-0811', 'Negative', 'Negative', '', '2024-11-28 02:50:34'),
(15, 'MCC2022-0811', 'Positive', 'Positive', '', '2024-11-28 08:37:00'),
(16, 'MCC2022-0811', 'Negative', 'Negative', '', '2024-11-30 01:35:15'),
(17, 'MCC2022-0811', 'Neutral', 'Neutral', '', '2024-11-30 11:26:36'),
(18, 'MCC2022-0811', 'Negative', 'Negative', '', '2024-12-02 01:49:19'),
(19, 'MCC2022-0811', 'Neutral', 'Neutral', '', '2024-12-02 23:38:01'),
(20, 'MCC2022-0811', 'Negative', 'Negative', '', '2024-12-05 01:15:37'),
(21, 'MCC2022-0533', 'Fear', 'Negative', '', '2024-12-05 01:34:09'),
(22, 'MCC2022-0811', 'Sadness', 'Neutral', '', '2024-12-08 12:43:04'),
(23, 'MCC2022-0000', 'Fear', 'Negative', '', '2024-12-08 12:47:52'),
(24, 'MCC2022-1209', 'Anger', 'Negative', '', '2024-12-08 15:54:28');

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `id` int NOT NULL,
  `student_id` varchar(255) DEFAULT NULL,
  `content` text NOT NULL,
  `emotion` varchar(50) DEFAULT NULL,
  `reactions` int DEFAULT '0',
  `comments_count` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`id`, `student_id`, `content`, `emotion`, `reactions`, `comments_count`, `created_at`, `updated_at`) VALUES
(74, 'MCC2022-0811', 'hey', NULL, 0, 0, '2024-12-08 06:19:39', '2024-12-08 06:19:39'),
(75, 'MCC2022-0811', 'i want to make friends\n', NULL, 0, 0, '2024-12-08 06:19:48', '2024-12-08 06:19:48');

-- --------------------------------------------------------

--
-- Table structure for table `posts_comments`
--

CREATE TABLE `posts_comments` (
  `id` int NOT NULL,
  `post_id` int DEFAULT NULL,
  `student_id` varchar(255) DEFAULT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `posts_comments`
--

INSERT INTO `posts_comments` (`id`, `post_id`, `student_id`, `content`, `created_at`) VALUES
(308, 75, 'MCC2022-0811', 'hey', '2024-12-08 06:20:30');

-- --------------------------------------------------------

--
-- Table structure for table `posts_reactions`
--

CREATE TABLE `posts_reactions` (
  `id` int NOT NULL,
  `post_id` int DEFAULT NULL,
  `student_id` varchar(255) DEFAULT NULL,
  `reaction_type` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `post_sentiments`
--

CREATE TABLE `post_sentiments` (
  `id` int NOT NULL,
  `post_id` int NOT NULL,
  `sentiment` enum('positive','neutral','negative') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `student_id` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `firstname` varchar(255) NOT NULL,
  `middlename` varchar(255) DEFAULT NULL,
  `lastname` varchar(255) NOT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `program` varchar(255) DEFAULT NULL,
  `otp` varchar(6) DEFAULT NULL,
  `otpExpires` datetime DEFAULT NULL,
  `isVerified` tinyint(1) DEFAULT '0',
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `reset_password_token` varchar(255) DEFAULT NULL,
  `reset_password_expires` datetime DEFAULT NULL,
  `profile_picture` varchar(255) DEFAULT NULL,
  `role` enum('user','admin') DEFAULT 'user'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`student_id`, `username`, `email`, `password`, `firstname`, `middlename`, `lastname`, `gender`, `birthdate`, `program`, `otp`, `otpExpires`, `isVerified`, `created_at`, `updated_at`, `reset_password_token`, `reset_password_expires`, `profile_picture`, `role`) VALUES
('MCC2022-0000', 'bossing malupiton', 'hernandezlanslorence@gmail.com', '$2a$10$DyxrT8cBD502NzB92iZC/.VkcAU1ID47fMTu8JQosL1PI7Yb2KsE2', 'BOSS MALUPITON', '', 'HAHAHAHA', 'Male', '2024-11-11', 'BSHM', NULL, NULL, 1, '2024-11-19 16:11:16', '2024-12-08 15:08:25', NULL, NULL, '/uploads/profilePicture-1732292217133-657932879.jpg', 'user'),
('MCC2022-0347', 'dan', 'danlloydclanor29@gmail.com', '$2a$10$rkoOzbeYD9IceCukb.z07u1GDwrVaRE7unddsmQEfFjVfzATtMGui', 'DAn', 'loyd', 'clanor', 'Male', '2024-11-18', 'BSIT', NULL, NULL, 1, '2024-11-18 10:01:49', '2024-11-18 10:02:20', NULL, NULL, NULL, 'user'),
('MCC2022-0359', 'Helios', 'abaskien@gmail.com', '$2a$10$SLDFVJiMB9lb97mZNuCageUuHmZqB2FVXHWzh74cae3XZIUZKqYde', 'Kien Eros', '', 'Abas', 'Male', '2004-03-18', 'BSIT', NULL, NULL, 1, '2024-11-27 13:14:02', '2024-11-27 13:14:38', NULL, NULL, NULL, 'user'),
('MCC2022-0533', 'jeromw', 'firedown1231@gmail.com', '$2a$10$Yl.3A/w0lX0Ng4K9XdxFau.vf.sFdPdHBzB3Re3.ePY3hLy3dTU.2', 'jer', 'gh', 'hg', 'Male', '2024-11-17', 'BSIT', NULL, NULL, 1, '2024-11-18 14:40:22', '2024-12-02 21:23:00', NULL, NULL, '/uploads/profilePicture-1733145779903-978398169.jpg', 'user'),
('MCC2022-0539', 'sachiii', 'leyesachi@gmail.com', '$2a$10$wGaBVx1KXSeYKSyHgjnTa.ImIy8het7kk2aX4n/vXSUft1XgDWe7a', 'Ma. Sachilette', 'Vibas', 'Leyesa', 'Female', '2004-02-25', 'BSIT', NULL, NULL, 1, '2024-11-12 23:56:01', '2024-11-13 00:34:14', NULL, NULL, NULL, 'user'),
('MCC2022-0811', 'L4nszxc_09', 'lanslorence@gmail.com', '$2a$10$RyxTCEYQVxdHJGgaIJT8Ru7FrRBOmsthAb8SBKOGQ2YQsry0xxzIy', 'Lans Lorence', 'Navarro', 'Hernandez', 'Male', '2004-09-03', 'BTVTED', NULL, NULL, 1, '2024-11-28 02:23:03', '2024-12-08 13:20:41', NULL, NULL, '/uploads/profilePicture-1733158007099-318897815.jpg', 'user'),
('MCC2022-0850', 'Meanaldeamariejoygener', 'aldeamean13@gmail.com', '$2a$10$6DeJc3LxNicnIK44sMy1.OwT0mUeA44Gl5BHokzZX9b7MvXfZUgo6', 'Mean', '', 'Aldea', 'Female', '2003-11-06', 'BSIT', NULL, NULL, 1, '2024-11-28 09:02:52', '2024-11-28 09:06:07', NULL, NULL, NULL, 'user'),
('MCC2022-1122', 'l4nszxc', 'l4nsh3rn4nd3z@gmail.com', '$2a$10$L7h1Urz8uoc/7osMFlF9aecDclzYqRn2SA7BizUWpMymqKsX7sQLm', 'Lans Lorence', '', 'Navarro Hernandez', 'Female', '2332-03-31', 'BSTM', NULL, NULL, 1, '2024-11-28 09:18:36', '2024-11-28 09:18:49', NULL, NULL, NULL, 'user'),
('MCC2022-1209', 'vangeeee', 'evangelcapiofajardo.18@gmail.com', '$2a$10$eSvyyaKE4WIHamanb6orIeta7.6HeKnM4mHMEczAxN1fftGnzjWKW', 'Evangel', '', 'Fajardo', 'Female', '2004-02-17', 'BSIT', NULL, NULL, 1, '2024-12-08 15:53:25', '2024-12-08 15:54:20', NULL, NULL, '/uploads/profilePicture-1733644459371-338923845.png', 'user'),
('MCC2022-1212', 'ikaw bahala kana', 'rjaybalinton833@gmail.com', '$2a$10$cDFoPmD5/tzsNwiTW3NBpOd3jwA95GATWump6kbvetv2EgBLrBrKO', 'R-jay ', 'L.', 'Balinton', 'Male', '2001-02-05', 'BSIT', NULL, NULL, 1, '2024-11-28 02:26:16', '2024-11-28 02:27:16', NULL, NULL, '/uploads/profilePicture-1732732033991-556689265.png', 'user'),
('MCC2022-1302', 'ansel', 'kusakalaniosa28@gmail.com', '$2a$10$DyeGtuqcknW3dLH8CGnt1.j4lVuISjmV./PJRFoHe44URJc8aPtXK', 'Ansel Philip', 'C.', 'Laniosa', 'Male', '2003-05-28', 'BSIT', NULL, NULL, 1, '2024-11-18 13:38:20', '2024-11-18 14:10:59', NULL, NULL, NULL, 'user'),
('MCC2022-6666', 'sachi', 'saaach25@gmail.com', '$2a$10$0ZCuJNk.phHegDZ0AlBoUeeroCBysU1Hh7NVmCpFIZ3Rlz12yayDS', 'Ma. Sachilette', 'Vibas', 'Leyesa', 'Female', '2024-11-19', 'BSIT', NULL, NULL, 1, '2024-11-21 02:37:14', '2024-11-25 13:09:07', NULL, NULL, '/uploads/profilePicture-1732511069639-456354837.jpg', 'user'),
('MCC2024-0000', 'admin', 'mindconnect@gmail.com', '$2a$10$WMB3WirdHPGwsWDhNu8k1eSqWudvlhriLoyIEDbqFjesdBvNa.sDG', 'Admin', NULL, 'Lastname', NULL, NULL, NULL, NULL, NULL, 1, '2024-11-21 00:48:40', NULL, NULL, NULL, NULL, 'admin');

-- --------------------------------------------------------

--
-- Table structure for table `user_exercises`
--

CREATE TABLE `user_exercises` (
  `id` int NOT NULL,
  `student_id` varchar(255) NOT NULL,
  `exercise_date` date NOT NULL,
  `exercise_completed` tinyint(1) DEFAULT '0',
  `exercise_type` varchar(255) NOT NULL,
  `exercise_title` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user_exercises`
--

INSERT INTO `user_exercises` (`id`, `student_id`, `exercise_date`, `exercise_completed`, `exercise_type`, `exercise_title`) VALUES
(13, 'MCC2022-6666', '2024-11-25', 1, 'Breathing Technique', '4-7-8 Breathing'),
(15, 'MCC2022-0000', '2024-11-28', 1, 'Guided Meditation', 'Body Scan Meditation'),
(16, 'MCC2022-0811', '2024-11-30', 1, 'Breathing Technique', 'Box Breathing'),
(17, 'MCC2022-0811', '2024-12-02', 1, 'Guided Meditation', 'Loving-Kindness Meditation'),
(18, 'MCC2022-0811', '2024-12-03', 1, 'Guided Meditation', 'Body Scan Meditation'),
(19, 'MCC2022-0533', '2024-12-03', 1, 'Guided Meditation', 'Loving-Kindness Meditation'),
(20, 'MCC2022-0811', '2024-12-05', 1, 'Guided Meditation', 'Body Scan Meditation'),
(21, 'MCC2022-0811', '2024-12-08', 1, 'Breathing Technique', 'Box Breathing'),
(22, 'MCC2022-1209', '2024-12-08', 1, 'Guided Meditation', 'Body Scan Meditation');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `announcements`
--
ALTER TABLE `announcements`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_date_time` (`date`,`start_time`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `conversations`
--
ALTER TABLE `conversations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `participant_id` (`participant_id`);

--
-- Indexes for table `empathy_challenges`
--
ALTER TABLE `empathy_challenges`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`feedback_id`),
  ADD KEY `idx_feedback_student_id` (`student_id`);

--
-- Indexes for table `help_articles`
--
ALTER TABLE `help_articles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `conversation_id` (`conversation_id`),
  ADD KEY `sender_id` (`sender_id`);

--
-- Indexes for table `moods`
--
ALTER TABLE `moods`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `posts_comments`
--
ALTER TABLE `posts_comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_id` (`post_id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `posts_reactions`
--
ALTER TABLE `posts_reactions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_reaction` (`post_id`,`student_id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `post_sentiments`
--
ALTER TABLE `post_sentiments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_id` (`post_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`student_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_exercises`
--
ALTER TABLE `user_exercises`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `announcements`
--
ALTER TABLE `announcements`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=91;

--
-- AUTO_INCREMENT for table `conversations`
--
ALTER TABLE `conversations`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=118;

--
-- AUTO_INCREMENT for table `empathy_challenges`
--
ALTER TABLE `empathy_challenges`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `feedback_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `help_articles`
--
ALTER TABLE `help_articles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=89;

--
-- AUTO_INCREMENT for table `moods`
--
ALTER TABLE `moods`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=76;

--
-- AUTO_INCREMENT for table `posts_comments`
--
ALTER TABLE `posts_comments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=309;

--
-- AUTO_INCREMENT for table `posts_reactions`
--
ALTER TABLE `posts_reactions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

--
-- AUTO_INCREMENT for table `post_sentiments`
--
ALTER TABLE `post_sentiments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `user_exercises`
--
ALTER TABLE `user_exercises`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`student_id`);

--
-- Constraints for table `conversations`
--
ALTER TABLE `conversations`
  ADD CONSTRAINT `conversations_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`student_id`),
  ADD CONSTRAINT `conversations_ibfk_2` FOREIGN KEY (`participant_id`) REFERENCES `users` (`student_id`);

--
-- Constraints for table `empathy_challenges`
--
ALTER TABLE `empathy_challenges`
  ADD CONSTRAINT `empathy_challenges_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`student_id`);

--
-- Constraints for table `feedback`
--
ALTER TABLE `feedback`
  ADD CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`student_id`) ON DELETE CASCADE;

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`conversation_id`) REFERENCES `conversations` (`id`),
  ADD CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`sender_id`) REFERENCES `users` (`student_id`);

--
-- Constraints for table `moods`
--
ALTER TABLE `moods`
  ADD CONSTRAINT `moods_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`student_id`);

--
-- Constraints for table `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`student_id`);

--
-- Constraints for table `posts_comments`
--
ALTER TABLE `posts_comments`
  ADD CONSTRAINT `posts_comments_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  ADD CONSTRAINT `posts_comments_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `users` (`student_id`);

--
-- Constraints for table `posts_reactions`
--
ALTER TABLE `posts_reactions`
  ADD CONSTRAINT `posts_reactions_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  ADD CONSTRAINT `posts_reactions_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `users` (`student_id`);

--
-- Constraints for table `post_sentiments`
--
ALTER TABLE `post_sentiments`
  ADD CONSTRAINT `post_sentiments_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`);

--
-- Constraints for table `user_exercises`
--
ALTER TABLE `user_exercises`
  ADD CONSTRAINT `user_exercises_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`student_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
