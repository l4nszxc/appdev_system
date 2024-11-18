-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Nov 18, 2024 at 01:47 PM
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
(1, 'MCC2022-0811', 'suggestion', 'ssasa', '2024-11-18 02:20:06', '2024-11-18 02:20:06'),
(2, 'MCC2022-0811', 'issue', 'mesyadong maganda\n', '2024-11-18 02:24:57', '2024-11-18 02:24:57'),
(3, 'MCC2022-0811', 'issue', 'sa', '2024-11-18 05:16:39', '2024-11-18 05:16:39'),
(4, 'MCC2022-0811', 'issue', 'lans', '2024-11-18 05:25:44', '2024-11-18 05:25:44'),
(5, 'MCC2022-0811', 'issue', 'pogi ko', '2024-11-18 05:35:10', '2024-11-18 05:35:10'),
(6, 'MCC2022-0533', 'issue', 'qwertt', '2024-11-18 06:46:15', '2024-11-18 06:46:15');

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
  `profile_picture` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`student_id`, `username`, `email`, `password`, `firstname`, `middlename`, `lastname`, `gender`, `birthdate`, `program`, `otp`, `otpExpires`, `isVerified`, `created_at`, `updated_at`, `reset_password_token`, `reset_password_expires`, `profile_picture`) VALUES
('MCC2022-0347', 'dan', 'danlloydclanor29@gmail.com', '$2a$10$rkoOzbeYD9IceCukb.z07u1GDwrVaRE7unddsmQEfFjVfzATtMGui', 'DAn', 'loyd', 'clanor', 'Male', '2024-11-18', 'BSIT', NULL, NULL, 1, '2024-11-18 10:01:49', '2024-11-18 10:02:20', NULL, NULL, NULL),
('MCC2022-0358', 'gelo', 'saaach25@gmail.com', '$2a$10$ZcXgFFL4J9FZfA0NLhZPO.zaMQFDv4zBqhYKBU5VlFIPJstGtqoEa', 'Angelo', 'coco', 'Barbacena', 'Male', '2014-02-06', 'BSIT', NULL, NULL, 1, '2024-11-17 12:29:10', '2024-11-18 19:38:01', NULL, NULL, '/uploads/profilePicture-1731929879009-585614423.jpg'),
('MCC2022-0359', 'cjbading', 'abaskien@gmail.com', '$2a$10$xa945/aR9vGfEXjyuFRvhuaPLDhYBFXif65IAIRro4F30PzJQXl0O', 'Kien Eros', 'Morales', 'Abas', 'Male', '2004-03-18', 'BSIT', NULL, NULL, 1, '2024-11-13 12:10:57', '2024-11-13 12:12:54', NULL, NULL, NULL),
('MCC2022-0533', 'jeromw', 'firedown1231@gmail.com', '$2a$10$/Re7rPZ.Ez0H20Tnw8kpcu9xyxyDv3IyZmwo.5NcPhPWwEsVhMS42', 'jer', 'gh', 'hg', 'Male', '2024-11-18', 'BSIT', NULL, NULL, 1, '2024-11-18 14:40:22', '2024-11-18 14:41:23', NULL, NULL, NULL),
('MCC2022-0539', 'sachiii', 'leyesachi@gmail.com', '$2a$10$wGaBVx1KXSeYKSyHgjnTa.ImIy8het7kk2aX4n/vXSUft1XgDWe7a', 'Ma. Sachilette', 'Vibas', 'Leyesa', 'Female', '2004-02-25', 'BSIT', NULL, NULL, 1, '2024-11-12 23:56:01', '2024-11-13 00:34:14', NULL, NULL, NULL),
('MCC2022-0811', 'l4nszxc_', 'lanslorence@gmail.com', '$2a$10$7FyFsMcMMKa9bofsOVRwXOzxC.iPQJ4Zj0uw6soAeFXtGgfCHtIy.', 'Lans Lorence', 'Navarro', 'Hernandez', 'Male', '2004-07-09', 'BSIT', NULL, NULL, 1, '2024-11-16 14:13:10', '2024-11-18 21:19:02', NULL, NULL, '/uploads/profilePicture-1731925378002-188856268.jpg'),
('MCC2022-1302', 'ansel', 'kusakalaniosa28@gmail.com', '$2a$10$DyeGtuqcknW3dLH8CGnt1.j4lVuISjmV./PJRFoHe44URJc8aPtXK', 'Ansel Philip', 'C.', 'Laniosa', 'Male', '2003-05-28', 'BSIT', NULL, NULL, 1, '2024-11-18 13:38:20', '2024-11-18 14:10:59', NULL, NULL, NULL),
('MCC2024-0911', 'l4nszxc', 'hernandezlanslorence@gmail.com', '$2a$10$Z692Aa6PHgsgWcbjwY5sjeKj3OGP9flSqAm15LxVHdeSQUDAl6k36', 'rhyan', 'adeva', 'Hernandez', 'Female', '2024-11-16', 'BSIT', NULL, NULL, 1, '2024-11-16 14:07:18', '2024-11-16 14:08:49', NULL, NULL, NULL);

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
(1, 'MCC2022-0811', '2024-11-18', 1, 'Breathing Technique', 'Box Breathing'),
(2, 'MCC2022-0358', '2024-11-18', 1, 'Breathing Technique', '4-7-8 Breathing'),
(3, 'MCC2022-0533', '2024-11-18', 1, 'Breathing Technique', '4-7-8 Breathing');

--
-- Indexes for dumped tables
--

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
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `feedback_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `help_articles`
--
ALTER TABLE `help_articles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `user_exercises`
--
ALTER TABLE `user_exercises`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `feedback`
--
ALTER TABLE `feedback`
  ADD CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`student_id`) ON DELETE CASCADE;

--
-- Constraints for table `user_exercises`
--
ALTER TABLE `user_exercises`
  ADD CONSTRAINT `user_exercises_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`student_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
