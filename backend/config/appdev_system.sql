-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 02, 2024 at 02:19 PM
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
(67, 'MCC2022-0811', '2024-11-30', '08:00:00', '09:00:00', 'scheduled', '2024-11-30 23:19:05', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `empathy_challenges`
--

CREATE TABLE `empathy_challenges` (
  `id` int NOT NULL,
  `student_id` varchar(255) NOT NULL,
  `level` int DEFAULT '1',
  `comments_count` int DEFAULT '0',
  `start_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `end_date` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `empathy_challenges`
--

INSERT INTO `empathy_challenges` (`id`, `student_id`, `level`, `comments_count`, `start_date`, `end_date`) VALUES
(1, 'MCC2022-0811', 6, 22, '2024-12-02 21:04:25', NULL),
(2, 'MCC2022-0533', 1, 0, '2024-12-02 21:33:12', NULL);

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
(22, 'MCC2022-0811', 'suggestion', 'das', '2024-11-30 03:26:30', '2024-11-30 03:26:30');

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
(18, 'MCC2022-0811', 'Negative', 'Negative', '', '2024-12-02 01:49:19');

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
(46, 'MCC2022-6666', 'waduupp guys', 'Calm', 0, 0, '2024-11-25 05:03:25', '2024-11-25 05:03:25'),
(49, 'MCC2022-1212', 'dsa', 'Stressed', 0, 0, '2024-11-27 18:27:31', '2024-11-27 18:27:31'),
(51, 'MCC2022-0811', 'excellent', 'Stressed', 0, 0, '2024-11-28 00:49:01', '2024-11-30 06:52:27'),
(54, 'MCC2022-0811', 'so happy', 'Stressed', 0, 0, '2024-11-29 15:47:59', '2024-11-30 06:52:17'),
(55, 'MCC2022-0811', 'i win', 'Stressed', 0, 0, '2024-11-29 15:48:05', '2024-11-30 06:52:09'),
(56, 'MCC2022-0811', 'i want to kill', 'Sad', 0, 0, '2024-11-29 16:04:49', '2024-11-30 06:25:09'),
(57, 'MCC2022-0811', 'buhay nga naman', 'Stressed', 0, 0, '2024-11-30 06:54:03', '2024-11-30 06:54:03'),
(59, 'MCC2022-0811', 'gusto kong pumatay', 'Anxious', 0, 0, '2024-11-30 15:09:41', '2024-12-02 12:35:52'),
(60, 'MCC2022-0811', 'buhay ang may alam', 'Sad', 0, 0, '2024-12-01 10:57:36', '2024-12-01 10:58:03'),
(61, 'MCC2022-0811', 'dsa', 'Stressed', 0, 0, '2024-12-02 13:36:57', '2024-12-02 13:36:57'),
(62, 'MCC2022-0811', 'dasda', 'Sad', 0, 0, '2024-12-02 13:39:24', '2024-12-02 13:39:24'),
(63, 'MCC2022-0811', 'i want to stop the idea of jumping on the train\n', 'Happy', 0, 0, '2024-12-02 13:39:30', '2024-12-02 13:42:25');

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
(61, 49, 'MCC2022-0811', 'sarap', '2024-11-28 00:49:31'),
(106, 56, 'MCC2022-0811', 'das', '2024-11-29 16:05:53'),
(107, 59, 'MCC2022-0811', 'dasd', '2024-11-30 15:09:47'),
(108, 57, 'MCC2022-0811', 'dasads', '2024-11-30 15:18:55'),
(109, 60, 'MCC2022-0811', 'das', '2024-12-01 18:25:36'),
(110, 60, 'MCC2022-0811', 'dsada', '2024-12-02 13:04:29'),
(111, 60, 'MCC2022-0811', 'dasdas', '2024-12-02 13:07:59'),
(112, 60, 'MCC2022-0811', 'dsadsda', '2024-12-02 13:08:08'),
(113, 60, 'MCC2022-0811', 'dsadsda', '2024-12-02 13:08:08'),
(114, 60, 'MCC2022-0811', 'dsadsda', '2024-12-02 13:08:09'),
(115, 60, 'MCC2022-0811', 'dsadsda', '2024-12-02 13:08:09'),
(116, 60, 'MCC2022-0811', 'dsadsda', '2024-12-02 13:08:09'),
(117, 60, 'MCC2022-0811', 'dsadsda', '2024-12-02 13:08:09'),
(118, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:01'),
(119, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:01'),
(120, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:01'),
(121, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:01'),
(122, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:01'),
(123, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:01'),
(124, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:01'),
(125, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:02'),
(126, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:02'),
(127, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:02'),
(128, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:02'),
(129, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:02'),
(130, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:02'),
(131, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:03'),
(132, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:03'),
(133, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:03'),
(134, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:03'),
(135, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:03'),
(136, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:03'),
(137, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:03'),
(138, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:04'),
(139, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:04'),
(140, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:05'),
(141, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:05'),
(142, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:05'),
(143, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:05'),
(144, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:05'),
(145, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:05'),
(146, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:06'),
(147, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:06'),
(148, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:06'),
(149, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:06'),
(150, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:06'),
(151, 61, 'MCC2022-0811', 'dasdsadsdsa', '2024-12-02 13:37:06'),
(152, 61, 'MCC2022-0811', 'asa', '2024-12-02 13:38:06'),
(153, 61, 'MCC2022-0811', 'asa', '2024-12-02 13:38:06'),
(154, 61, 'MCC2022-0811', 'asa', '2024-12-02 13:38:06'),
(155, 61, 'MCC2022-0811', 'asa', '2024-12-02 13:38:06'),
(156, 61, 'MCC2022-0811', 'asa', '2024-12-02 13:38:06'),
(157, 61, 'MCC2022-0811', 'asa', '2024-12-02 13:38:06'),
(158, 61, 'MCC2022-0811', 'asa', '2024-12-02 13:38:06'),
(159, 61, 'MCC2022-0811', 'asa', '2024-12-02 13:38:07'),
(160, 61, 'MCC2022-0811', 'asa', '2024-12-02 13:38:07'),
(161, 61, 'MCC2022-0811', 'asa', '2024-12-02 13:38:08'),
(162, 61, 'MCC2022-0811', 'asa', '2024-12-02 13:38:08'),
(163, 61, 'MCC2022-0811', 'asa', '2024-12-02 13:38:08'),
(164, 61, 'MCC2022-0811', 'asa', '2024-12-02 13:38:08'),
(165, 61, 'MCC2022-0811', 'asa', '2024-12-02 13:38:09'),
(166, 61, 'MCC2022-0811', 'asa', '2024-12-02 13:38:09'),
(167, 61, 'MCC2022-0811', 'asa', '2024-12-02 13:38:09'),
(168, 61, 'MCC2022-0811', 'asa', '2024-12-02 13:38:09'),
(169, 61, 'MCC2022-0811', 'asa', '2024-12-02 13:38:09'),
(170, 61, 'MCC2022-0811', 'asa', '2024-12-02 13:38:09'),
(171, 61, 'MCC2022-0811', 'asa', '2024-12-02 13:38:10'),
(172, 61, 'MCC2022-0811', 'asa', '2024-12-02 13:38:10'),
(173, 61, 'MCC2022-0811', 'asa', '2024-12-02 13:38:10'),
(174, 59, 'MCC2022-0811', 'janss', '2024-12-02 13:38:17'),
(175, 59, 'MCC2022-0811', 'janss', '2024-12-02 13:38:18'),
(176, 59, 'MCC2022-0811', 'janss', '2024-12-02 13:38:18'),
(177, 59, 'MCC2022-0811', 'janss', '2024-12-02 13:38:18'),
(178, 59, 'MCC2022-0811', 'janss', '2024-12-02 13:38:18'),
(179, 59, 'MCC2022-0811', 'janss', '2024-12-02 13:38:18'),
(180, 59, 'MCC2022-0811', 'janss', '2024-12-02 13:38:18'),
(181, 59, 'MCC2022-0811', 'janss', '2024-12-02 13:38:18'),
(182, 59, 'MCC2022-0811', 'janss', '2024-12-02 13:38:18'),
(183, 59, 'MCC2022-0811', 'janss', '2024-12-02 13:38:19'),
(184, 59, 'MCC2022-0811', 'janss', '2024-12-02 13:38:19'),
(185, 59, 'MCC2022-0811', 'janss', '2024-12-02 13:38:19'),
(186, 59, 'MCC2022-0811', 'janss', '2024-12-02 13:38:19'),
(187, 59, 'MCC2022-0811', 'janss', '2024-12-02 13:38:19'),
(188, 59, 'MCC2022-0811', 'janss', '2024-12-02 13:38:19'),
(189, 59, 'MCC2022-0811', 'janss', '2024-12-02 13:38:19'),
(190, 63, 'MCC2022-0811', 'dsadas', '2024-12-02 13:39:40'),
(191, 63, 'MCC2022-0811', 'dsadas', '2024-12-02 13:39:40'),
(192, 63, 'MCC2022-0811', 'dsadas', '2024-12-02 13:39:41'),
(193, 63, 'MCC2022-0811', 'dsadas', '2024-12-02 13:39:41'),
(194, 63, 'MCC2022-0811', 'dsadas', '2024-12-02 13:39:41'),
(195, 63, 'MCC2022-0811', 'dsadas', '2024-12-02 13:39:41'),
(196, 63, 'MCC2022-0811', 'dsadas', '2024-12-02 13:39:41'),
(197, 63, 'MCC2022-0811', 'dsadas', '2024-12-02 13:39:41'),
(198, 63, 'MCC2022-0811', 'dsadas', '2024-12-02 13:39:42'),
(199, 63, 'MCC2022-0811', 'dsadas', '2024-12-02 13:39:42'),
(200, 63, 'MCC2022-0811', 'dsadas', '2024-12-02 13:39:42'),
(201, 63, 'MCC2022-0811', 'dsadas', '2024-12-02 13:39:42'),
(202, 63, 'MCC2022-0811', 'dsadas', '2024-12-02 13:39:42'),
(203, 63, 'MCC2022-0811', 'dsadas', '2024-12-02 13:39:42'),
(204, 63, 'MCC2022-0811', 'dsadas', '2024-12-02 13:39:43'),
(205, 63, 'MCC2022-0811', 'dsadas', '2024-12-02 13:39:43'),
(206, 63, 'MCC2022-0811', 'dsadas', '2024-12-02 13:39:43'),
(207, 63, 'MCC2022-0811', 'dsadas', '2024-12-02 13:39:43');

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

--
-- Dumping data for table `posts_reactions`
--

INSERT INTO `posts_reactions` (`id`, `post_id`, `student_id`, `reaction_type`, `created_at`) VALUES
(29, 46, 'MCC2022-6666', 'Care', '2024-11-25 05:04:07'),
(34, 49, 'MCC2022-1212', 'Heart', '2024-11-27 18:27:33'),
(35, 49, 'MCC2022-0811', 'Sad', '2024-11-27 18:37:21'),
(43, 56, 'MCC2022-0811', 'Angry', '2024-11-29 16:05:50'),
(44, 59, 'MCC2022-0811', 'Heart', '2024-11-30 15:09:50'),
(45, 60, 'MCC2022-0811', 'Like', '2024-12-01 10:57:37');

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
('MCC2022-0000', 'bossing malupiton', 'hernandezlanslorence@gmail.com', '$2a$10$DyxrT8cBD502NzB92iZC/.VkcAU1ID47fMTu8JQosL1PI7Yb2KsE2', 'ssa', 'sa', 'sa', 'Male', '2024-11-12', 'BSHM', NULL, NULL, 1, '2024-11-19 16:11:16', '2024-11-28 02:11:10', NULL, NULL, '/uploads/profilePicture-1732292217133-657932879.jpg', 'user'),
('MCC2022-0347', 'dan', 'danlloydclanor29@gmail.com', '$2a$10$rkoOzbeYD9IceCukb.z07u1GDwrVaRE7unddsmQEfFjVfzATtMGui', 'DAn', 'loyd', 'clanor', 'Male', '2024-11-18', 'BSIT', NULL, NULL, 1, '2024-11-18 10:01:49', '2024-11-18 10:02:20', NULL, NULL, NULL, 'user'),
('MCC2022-0359', 'Helios', 'abaskien@gmail.com', '$2a$10$SLDFVJiMB9lb97mZNuCageUuHmZqB2FVXHWzh74cae3XZIUZKqYde', 'Kien Eros', '', 'Abas', 'Male', '2004-03-18', 'BSIT', NULL, NULL, 1, '2024-11-27 13:14:02', '2024-11-27 13:14:38', NULL, NULL, NULL, 'user'),
('MCC2022-0533', 'jeromw', 'firedown1231@gmail.com', '$2a$10$Yl.3A/w0lX0Ng4K9XdxFau.vf.sFdPdHBzB3Re3.ePY3hLy3dTU.2', 'jer', 'gh', 'hg', 'Male', '2024-11-17', 'BSIT', NULL, NULL, 1, '2024-11-18 14:40:22', '2024-12-02 21:23:00', NULL, NULL, '/uploads/profilePicture-1733145779903-978398169.jpg', 'user'),
('MCC2022-0539', 'sachiii', 'leyesachi@gmail.com', '$2a$10$wGaBVx1KXSeYKSyHgjnTa.ImIy8het7kk2aX4n/vXSUft1XgDWe7a', 'Ma. Sachilette', 'Vibas', 'Leyesa', 'Female', '2004-02-25', 'BSIT', NULL, NULL, 1, '2024-11-12 23:56:01', '2024-11-13 00:34:14', NULL, NULL, NULL, 'user'),
('MCC2022-0811', 'L4nszxc_09', 'lanslorence@gmail.com', '$2a$10$oNCAwGqFKup/zkR04MjR/.CgM7v07mIKHKemRpNc6YPeJP7kSf4Zq', 'Lans Lorence', 'Navarro', 'Hernandez', 'Male', '2004-09-06', 'BTVTED', NULL, NULL, 1, '2024-11-28 02:23:03', '2024-11-28 20:54:35', '681962', '2024-11-28 20:59:35', '/uploads/profilePicture-1732731812260-193637340.jpg', 'user'),
('MCC2022-0850', 'Meanaldeamariejoygener', 'aldeamean13@gmail.com', '$2a$10$6DeJc3LxNicnIK44sMy1.OwT0mUeA44Gl5BHokzZX9b7MvXfZUgo6', 'Mean', '', 'Aldea', 'Female', '2003-11-06', 'BSIT', NULL, NULL, 1, '2024-11-28 09:02:52', '2024-11-28 09:06:07', NULL, NULL, NULL, 'user'),
('MCC2022-1122', 'l4nszxc', 'l4nsh3rn4nd3z@gmail.com', '$2a$10$L7h1Urz8uoc/7osMFlF9aecDclzYqRn2SA7BizUWpMymqKsX7sQLm', 'Lans Lorence', '', 'Navarro Hernandez', 'Female', '2332-03-31', 'BSTM', NULL, NULL, 1, '2024-11-28 09:18:36', '2024-11-28 09:18:49', NULL, NULL, NULL, 'user'),
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
(17, 'MCC2022-0811', '2024-12-02', 1, 'Guided Meditation', 'Loving-Kindness Meditation');

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
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=68;

--
-- AUTO_INCREMENT for table `empathy_challenges`
--
ALTER TABLE `empathy_challenges`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `feedback_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `help_articles`
--
ALTER TABLE `help_articles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `moods`
--
ALTER TABLE `moods`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT for table `posts_comments`
--
ALTER TABLE `posts_comments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=208;

--
-- AUTO_INCREMENT for table `posts_reactions`
--
ALTER TABLE `posts_reactions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `post_sentiments`
--
ALTER TABLE `post_sentiments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `user_exercises`
--
ALTER TABLE `user_exercises`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`student_id`);

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
