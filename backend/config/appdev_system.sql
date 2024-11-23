-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 23, 2024 at 06:26 AM
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
(54, 'MCC2022-0811', '2024-11-22', '08:00:00', '09:00:00', 'scheduled', '2024-11-22 12:53:03', '2024-11-22 12:54:48', 'https://meet.google.com/landing'),
(56, 'MCC2022-0000', '2024-11-23', '08:00:00', '09:00:00', 'scheduled', '2024-11-22 12:53:49', '2024-11-23 04:01:03', 'dsadas'),
(57, 'MCC2022-0811', '2024-11-23', '09:00:00', '10:00:00', 'scheduled', '2024-11-23 04:02:30', '2024-11-23 04:02:42', 'ddasdas');

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
(11, 'MCC2022-6666', 'issue', 'dsa', '2024-11-20 18:37:58', '2024-11-20 18:37:58'),
(12, 'MCC2022-0811', 'issue', 'dsadsa', '2024-11-22 18:50:14', '2024-11-22 18:50:14'),
(13, 'MCC2022-0811', 'suggestion', 'dsadas', '2024-11-22 18:50:16', '2024-11-22 18:50:16'),
(14, 'MCC2022-0811', 'issue', 'dsasdaaaaaaaaaaaaaaaaaaaaaaaaaaaaaadsadsaD  afa fgsd gsdgfd gstre gsgfa', '2024-11-22 18:51:57', '2024-11-22 18:51:57');

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
(4, 'MCC2022-0811', 'Positive', 'Positive', 'so glad i have u', '2024-11-23 03:49:39'),
(5, 'MCC2022-0811', 'Neutral', 'Neutral', 'lans', '2024-11-23 11:18:21');

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
(19, 'MCC2022-0811', 'l4ns', 'Anxious', 0, 0, '2024-11-20 16:52:09', '2024-11-20 16:52:09'),
(20, 'MCC2022-0000', 'super lala boss\n', 'Stressed', 0, 0, '2024-11-20 21:13:23', '2024-11-20 21:13:23'),
(21, 'MCC2022-0811', 'dsa', 'Stressed', 0, 0, '2024-11-22 04:56:53', '2024-11-22 04:56:53'),
(22, 'MCC2022-0000', 'mahal ang gamot', 'Stressed', 0, 0, '2024-11-22 04:57:21', '2024-11-22 04:57:21'),
(23, 'MCC2022-0811', 'redas', 'Sad', 0, 0, '2024-11-22 15:21:52', '2024-11-22 15:21:52'),
(24, 'MCC2022-0811', 'dsa', 'Calm', 0, 0, '2024-11-22 15:28:07', '2024-11-22 15:28:07'),
(25, 'MCC2022-0811', 'dasdsa', 'Stressed', 0, 0, '2024-11-22 15:32:08', '2024-11-22 15:32:08'),
(33, 'MCC2022-0811', 'dasdas', 'Stressed', 0, 0, '2024-11-23 03:19:24', '2024-11-23 03:19:24');

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
(7, 22, 'MCC2022-0811', 'dasdas', '2024-11-22 16:16:42'),
(13, 22, 'MCC2022-0811', 'bossing', '2024-11-22 17:02:20'),
(14, 22, 'MCC2022-0811', 'bossing', '2024-11-22 17:02:22'),
(15, 22, 'MCC2022-0811', 'bossing', '2024-11-22 17:02:24'),
(16, 22, 'MCC2022-0811', 'bossing', '2024-11-22 17:02:24'),
(17, 22, 'MCC2022-0811', 'bossing', '2024-11-22 17:02:24'),
(18, 33, 'MCC2022-0811', 'fdffdsfsd', '2024-11-23 03:19:31');

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
(10, 22, 'MCC2022-0811', 'Heart', '2024-11-22 16:52:36'),
(15, 25, 'MCC2022-0811', 'Heart', '2024-11-22 19:00:41'),
(16, 24, 'MCC2022-0811', 'Haha', '2024-11-22 19:00:42'),
(21, 33, 'MCC2022-0811', 'Heart', '2024-11-23 03:19:26');

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
('MCC2022-0000', 'bossing malupiton', 'hernandezlanslorence@gmail.com', '$2a$10$DyxrT8cBD502NzB92iZC/.VkcAU1ID47fMTu8JQosL1PI7Yb2KsE2', 'ssa', 'sa', 'sa', 'Male', '2024-11-14', 'BSIT', NULL, NULL, 1, '2024-11-19 16:11:16', '2024-11-23 00:16:57', NULL, NULL, '/uploads/profilePicture-1732292217133-657932879.jpg', 'user'),
('MCC2022-0347', 'dan', 'danlloydclanor29@gmail.com', '$2a$10$rkoOzbeYD9IceCukb.z07u1GDwrVaRE7unddsmQEfFjVfzATtMGui', 'DAn', 'loyd', 'clanor', 'Male', '2024-11-18', 'BSIT', NULL, NULL, 1, '2024-11-18 10:01:49', '2024-11-18 10:02:20', NULL, NULL, NULL, 'user'),
('MCC2022-0359', 'cjbading', 'abaskien@gmail.com', '$2a$10$xa945/aR9vGfEXjyuFRvhuaPLDhYBFXif65IAIRro4F30PzJQXl0O', 'Kien Eros', 'Morales', 'Abas', 'Male', '2004-03-18', 'BSIT', NULL, NULL, 1, '2024-11-13 12:10:57', '2024-11-13 12:12:54', NULL, NULL, NULL, 'user'),
('MCC2022-0533', 'jeromw', 'firedown1231@gmail.com', '$2a$10$/Re7rPZ.Ez0H20Tnw8kpcu9xyxyDv3IyZmwo.5NcPhPWwEsVhMS42', 'jer', 'gh', 'hg', 'Male', '2024-11-18', 'BSIT', NULL, NULL, 1, '2024-11-18 14:40:22', '2024-11-18 14:41:23', NULL, NULL, NULL, 'user'),
('MCC2022-0539', 'sachiii', 'leyesachi@gmail.com', '$2a$10$wGaBVx1KXSeYKSyHgjnTa.ImIy8het7kk2aX4n/vXSUft1XgDWe7a', 'Ma. Sachilette', 'Vibas', 'Leyesa', 'Female', '2004-02-25', 'BSIT', NULL, NULL, 1, '2024-11-12 23:56:01', '2024-11-13 00:34:14', NULL, NULL, NULL, 'user'),
('MCC2022-0811', 'l4nszxc_09', 'lanslorence@gmail.com', '$2a$10$/E225oQhvULfkFNAJkX6/.Ykc/vzqxbqz2WHt7KCKVqi07lKIb8U2', 'Lans Lorence', 'Navarro', 'Hernandez', 'Male', '2004-09-05', 'BSIT', NULL, NULL, 1, '2024-11-21 00:51:36', '2024-11-23 01:04:44', NULL, NULL, '/uploads/profilePicture-1732121552544-605728348.jpg', 'user'),
('MCC2022-1302', 'ansel', 'kusakalaniosa28@gmail.com', '$2a$10$DyeGtuqcknW3dLH8CGnt1.j4lVuISjmV./PJRFoHe44URJc8aPtXK', 'Ansel Philip', 'C.', 'Laniosa', 'Male', '2003-05-28', 'BSIT', NULL, NULL, 1, '2024-11-18 13:38:20', '2024-11-18 14:10:59', NULL, NULL, NULL, 'user'),
('MCC2022-6666', 'sachi', 'saaach25@gmail.com', '$2a$10$0ZCuJNk.phHegDZ0AlBoUeeroCBysU1Hh7NVmCpFIZ3Rlz12yayDS', 'dasd', 'das', 'dsa', 'Female', '2024-11-21', 'BSIT', NULL, NULL, 1, '2024-11-21 02:37:14', '2024-11-21 02:37:29', NULL, NULL, NULL, 'user'),
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
(7, 'MCC2022-0811', '2024-11-21', 1, 'Breathing Technique', 'Box Breathing'),
(8, 'MCC2022-6666', '2024-11-21', 1, 'Breathing Technique', 'Box Breathing'),
(9, 'MCC2022-0000', '2024-11-23', 1, 'Guided Meditation', 'Loving-Kindness Meditation'),
(10, 'MCC2022-0811', '2024-11-23', 1, 'Guided Meditation', 'Loving-Kindness Meditation');

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
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `feedback_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `help_articles`
--
ALTER TABLE `help_articles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `moods`
--
ALTER TABLE `moods`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `posts_comments`
--
ALTER TABLE `posts_comments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `posts_reactions`
--
ALTER TABLE `posts_reactions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `user_exercises`
--
ALTER TABLE `user_exercises`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`student_id`);

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
-- Constraints for table `user_exercises`
--
ALTER TABLE `user_exercises`
  ADD CONSTRAINT `user_exercises_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`student_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
