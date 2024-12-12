-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Dec 12, 2024 at 01:01 PM
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
(145, 'MCC2022-0811', '2024-12-09', '08:00:00', '09:00:00', 'on going', '2024-12-09 23:59:04', '2024-12-09 23:59:16', 'hey'),
(146, 'MCC2022-0811', '2024-12-12', '08:00:00', '09:00:00', 'on going', '2024-12-12 20:54:04', '2024-12-12 20:54:16', 'dasdas');

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
(125, 'MCC2022-0811', 'MCC2022-0000', '2024-12-10 00:00:57', '2024-12-10 00:00:57'),
(126, 'MCC2022-0811', 'MCC2022-0347', '2024-12-10 00:01:01', '2024-12-10 00:01:01'),
(127, 'MCC2022-0811', 'MCC2022-0359', '2024-12-10 00:01:01', '2024-12-10 00:01:01'),
(128, 'MCC2022-0811', 'MCC2022-0539', '2024-12-10 00:01:02', '2024-12-10 00:01:02'),
(129, 'MCC2022-0811', 'MCC2022-1122', '2024-12-10 00:01:02', '2024-12-10 00:01:02'),
(130, 'MCC2022-0811', 'MCC2022-1209', '2024-12-10 00:01:03', '2024-12-10 00:01:03'),
(131, 'MCC2022-0811', 'MCC2022-1212', '2024-12-10 00:01:04', '2024-12-10 00:01:04'),
(132, 'MCC2022-0811', 'MCC2022-6666', '2024-12-10 00:01:04', '2024-12-10 00:01:04');

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
(11, 'MCC2022-0811', 1, 5, 1, 5, '2024-12-10 00:01:21', NULL, '2024-12-12 12:48:38');

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
(27, 'MCC2022-0811', 'issue', 'dsadas', '2024-12-12 12:58:50', '2024-12-12 12:58:50');

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
  `seen_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`id`, `conversation_id`, `sender_id`, `message`, `created_at`, `is_seen`, `seen_at`) VALUES
(307, 125, 'MCC2022-0811', 'hello', '2024-12-10 00:01:09', 0, NULL),
(308, 125, 'MCC2022-0811', 'bossing', '2024-12-12 20:58:41', 0, NULL);

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
(28, 'MCC2022-0811', 'Fear', 'Negative', '', '2024-12-12 20:48:41');

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
(84, 'MCC2022-0811', 'hello sach, good evedas', NULL, 0, 0, '2024-12-08 17:36:05', '2024-12-08 19:07:47'),
(87, 'MCC2022-0533', 'dasdasdasdsa', NULL, 0, 0, '2024-12-08 17:49:28', '2024-12-08 18:21:27'),
(88, 'MCC2022-0811', 'dsadas', NULL, 0, 0, '2024-12-08 20:26:27', '2024-12-08 20:26:27'),
(89, 'MCC2022-0811', 'si jose ay mataba pero siya ay ulaga at mabait na bata at laging tatanga tanga', NULL, 0, 0, '2024-12-08 20:30:06', '2024-12-09 06:22:29'),
(90, 'MCC2022-0811', 'gusto ko pumatay\n', NULL, 0, 0, '2024-12-09 06:10:05', '2024-12-09 06:21:56');

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
(328, 90, 'MCC2022-0811', 'hello', '2024-12-12 12:52:25'),
(329, 90, 'MCC2022-0811', 'hiii hello', '2024-12-12 12:52:31'),
(330, 90, 'MCC2022-0811', 'i love u ', '2024-12-12 12:52:43'),
(331, 90, 'MCC2022-0811', 'dasdsa', '2024-12-12 12:52:58'),
(332, 90, 'MCC2022-0811', 'dasdsa', '2024-12-12 12:52:58'),
(333, 90, 'MCC2022-0811', 'dasdsa', '2024-12-12 12:52:58'),
(334, 90, 'MCC2022-0811', 'dasdsa', '2024-12-12 12:52:58'),
(335, 90, 'MCC2022-0811', 'dasdsa', '2024-12-12 12:52:59'),
(336, 90, 'MCC2022-0811', 'dasdsa', '2024-12-12 12:52:59');

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
(98, 90, 'MCC2022-0811', 'Heart', '2024-12-09 16:01:27');

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
  `exercise_title` varchar(255) NOT NULL,
  `exercise_rating` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `user_exercises`
--

INSERT INTO `user_exercises` (`id`, `student_id`, `exercise_date`, `exercise_completed`, `exercise_type`, `exercise_title`, `exercise_rating`) VALUES
(44, 'MCC2022-0811', '2024-12-10', 1, 'Breathing Technique', 'Box Breathing', NULL),
(45, 'MCC2022-0811', '2024-12-12', 1, 'Guided Meditation', 'Body Scan Meditation', NULL);

--
-- Indexes for dumped tables
--

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
-- AUTO_INCREMENT for table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=147;

--
-- AUTO_INCREMENT for table `conversations`
--
ALTER TABLE `conversations`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=133;

--
-- AUTO_INCREMENT for table `empathy_challenges`
--
ALTER TABLE `empathy_challenges`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `feedback_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=309;

--
-- AUTO_INCREMENT for table `moods`
--
ALTER TABLE `moods`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=91;

--
-- AUTO_INCREMENT for table `posts_comments`
--
ALTER TABLE `posts_comments`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=337;

--
-- AUTO_INCREMENT for table `posts_reactions`
--
ALTER TABLE `posts_reactions`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=109;

--
-- AUTO_INCREMENT for table `user_exercises`
--
ALTER TABLE `user_exercises`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

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
-- Constraints for table `user_exercises`
--
ALTER TABLE `user_exercises`
  ADD CONSTRAINT `user_exercises_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`student_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
