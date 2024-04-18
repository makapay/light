-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Апр 18 2024 г., 05:52
-- Версия сервера: 8.0.30
-- Версия PHP: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `light_meter_pav2`
--

DELIMITER $$
--
-- Процедуры
--
CREATE DEFINER=`root`@`%` PROCEDURE `xp1` (IN `reading_id` INT)   BEGIN
    DECLARE underage_count INT;
    DECLARE elder_count INT;
    DECLARE underage_privilege VARCHAR(255);
    DECLARE elder_privilege VARCHAR(255);

    -- Считаем количество лиц младше 18 лет
    SELECT COUNT(*) INTO underage_count
    FROM RegisteredIndividuals
    WHERE TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) < 18
    AND metering_device_id = (SELECT metering_device_id FROM MeterReadings WHERE id = reading_id);

    -- Считаем количество лиц старше 55 лет
    SELECT COUNT(*) INTO elder_count
    FROM RegisteredIndividuals
    WHERE TIMESTAMPDIFF(YEAR, date_of_birth, CURDATE()) > 55
    AND metering_device_id = (SELECT metering_device_id FROM MeterReadings WHERE id = reading_id);

    -- Определяем типы льгот
    IF underage_count >= 3 THEN
        SELECT name INTO underage_privilege
        FROM PrivilegeTypes
        WHERE id = 1; -- ID для типа льготы "Многодетная семья"
    END IF;

    IF elder_count > 0 THEN
        SELECT name INTO elder_privilege
        FROM PrivilegeTypes
        WHERE id = 2; -- ID для типа льготы "Пенсионер"
    END IF;

    -- Выводим результат
    SELECT underage_privilege AS underage_privilege_type, elder_privilege AS elder_privilege_type;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `xp2` (IN `device_id` INT)   BEGIN
    DECLARE last_reading_date DATETIME;
    DECLARE days_since_last_reading INT;
    
    -- Найдем последнюю дату показаний для данного прибора учета
    SELECT MAX(date_time) INTO last_reading_date
    FROM MeterReadings
    WHERE metering_device_id = device_id;
    
    -- Если есть показания, вычислим количество дней с последней даты показаний
    IF last_reading_date IS NOT NULL THEN
        SET days_since_last_reading = DATEDIFF(CURRENT_DATE(), last_reading_date);
        SELECT days_since_last_reading AS days_since_last_reading;
    ELSE
        SELECT 'No readings found for the device' AS message;
    END IF;
END$$

CREATE DEFINER=`root`@`%` PROCEDURE `xp3` (IN `device_id` INT, IN `current_reading` DECIMAL(10,2))   BEGIN
    DECLARE last_reading DECIMAL(10,2);
    DECLARE difference DECIMAL(10,2);
    
    -- Найдем последнее показание для данного прибора учета
    SELECT reading INTO last_reading
    FROM MeterReadings
    WHERE metering_device_id = device_id
    ORDER BY date_time DESC
    LIMIT 1;
    
    -- Если есть последнее показание, вычислим разницу
    IF last_reading IS NOT NULL THEN
        SET difference = current_reading - last_reading;
        SELECT difference AS meter_reading_difference;
    ELSE
        SELECT 'No previous reading found for the device' AS message;
    END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Структура таблицы `MeteringDevice`
--

CREATE TABLE `MeteringDevice` (
  `id` int NOT NULL,
  `number` varchar(20) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `MeteringDevice`
--

INSERT INTO `MeteringDevice` (`id`, `number`, `address`) VALUES
(1, '38vu46', 'ул. Красный казанец, д. 17. кв. 3'),
(2, 'uf9834', 'ул. Кутузовская, д. 34, кв. 54'),
(3, 'r57y6', 'ул. Волковская, д. 12, кв. 13');

-- --------------------------------------------------------

--
-- Структура таблицы `MeterReadings`
--

CREATE TABLE `MeterReadings` (
  `id` int NOT NULL,
  `date_time` date DEFAULT NULL,
  `reading` decimal(10,2) DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `tariff_id` int DEFAULT NULL,
  `metering_device_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `MeterReadings`
--

INSERT INTO `MeterReadings` (`id`, `date_time`, `reading`, `amount`, `tariff_id`, `metering_device_id`) VALUES
(1, '2024-04-03', '123.00', '5000.00', 2, 1),
(2, '2024-04-04', '111.00', '5500.00', 1, 2),
(3, '2024-04-03', '120.00', '6000.00', 2, 2),
(4, '2024-04-06', '200.00', '5000.00', 1, 1);

-- --------------------------------------------------------

--
-- Структура таблицы `PrivilegeTypes`
--

CREATE TABLE `PrivilegeTypes` (
  `id` int NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `rate` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `PrivilegeTypes`
--

INSERT INTO `PrivilegeTypes` (`id`, `name`, `rate`) VALUES
(1, 'многодетные', '0.70'),
(2, 'пенсионер', '0.60');

-- --------------------------------------------------------

--
-- Структура таблицы `RecordedPrivileges`
--

CREATE TABLE `RecordedPrivileges` (
  `id` int NOT NULL,
  `privilege_type_id` int DEFAULT NULL,
  `reading_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `RecordedPrivileges`
--

INSERT INTO `RecordedPrivileges` (`id`, `privilege_type_id`, `reading_id`) VALUES
(1, 1, 1),
(2, 2, 2);

-- --------------------------------------------------------

--
-- Структура таблицы `RegisteredIndividuals`
--

CREATE TABLE `RegisteredIndividuals` (
  `id` int NOT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `metering_device_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `RegisteredIndividuals`
--

INSERT INTO `RegisteredIndividuals` (`id`, `full_name`, `date_of_birth`, `metering_device_id`) VALUES
(1, 'Иванов Федор Михайлович', '1966-11-21', 1),
(2, 'Иванова Вероника Степанона', '1968-10-23', 1),
(3, 'Иванова Анна Федоровна', '2014-06-10', 1),
(4, 'Иванов Сергей Федорович', '2022-12-11', 1),
(5, 'Иванова Ксения Федоровна', '2018-04-19', 1),
(6, 'Житенев Николай Дмитриевич', '1947-02-15', 2);

-- --------------------------------------------------------

--
-- Структура таблицы `Tariffs`
--

CREATE TABLE `Tariffs` (
  `id` int NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `rate` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `Tariffs`
--

INSERT INTO `Tariffs` (`id`, `name`, `rate`) VALUES
(1, 'ночной', '4.31'),
(2, 'дневной', '6.72');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `MeteringDevice`
--
ALTER TABLE `MeteringDevice`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `MeterReadings`
--
ALTER TABLE `MeterReadings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tariff_id` (`tariff_id`),
  ADD KEY `metering_device_id` (`metering_device_id`);

--
-- Индексы таблицы `PrivilegeTypes`
--
ALTER TABLE `PrivilegeTypes`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `RecordedPrivileges`
--
ALTER TABLE `RecordedPrivileges`
  ADD PRIMARY KEY (`id`),
  ADD KEY `privilege_type_id` (`privilege_type_id`),
  ADD KEY `reading_id` (`reading_id`);

--
-- Индексы таблицы `RegisteredIndividuals`
--
ALTER TABLE `RegisteredIndividuals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `metering_device_id` (`metering_device_id`);

--
-- Индексы таблицы `Tariffs`
--
ALTER TABLE `Tariffs`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `MeteringDevice`
--
ALTER TABLE `MeteringDevice`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `MeterReadings`
--
ALTER TABLE `MeterReadings`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `PrivilegeTypes`
--
ALTER TABLE `PrivilegeTypes`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `RecordedPrivileges`
--
ALTER TABLE `RecordedPrivileges`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `RegisteredIndividuals`
--
ALTER TABLE `RegisteredIndividuals`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT для таблицы `Tariffs`
--
ALTER TABLE `Tariffs`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `MeterReadings`
--
ALTER TABLE `MeterReadings`
  ADD CONSTRAINT `meterreadings_ibfk_1` FOREIGN KEY (`tariff_id`) REFERENCES `Tariffs` (`id`),
  ADD CONSTRAINT `meterreadings_ibfk_2` FOREIGN KEY (`metering_device_id`) REFERENCES `MeteringDevice` (`id`);

--
-- Ограничения внешнего ключа таблицы `RecordedPrivileges`
--
ALTER TABLE `RecordedPrivileges`
  ADD CONSTRAINT `recordedprivileges_ibfk_1` FOREIGN KEY (`privilege_type_id`) REFERENCES `PrivilegeTypes` (`id`),
  ADD CONSTRAINT `recordedprivileges_ibfk_2` FOREIGN KEY (`reading_id`) REFERENCES `MeterReadings` (`id`);

--
-- Ограничения внешнего ключа таблицы `RegisteredIndividuals`
--
ALTER TABLE `RegisteredIndividuals`
  ADD CONSTRAINT `registeredindividuals_ibfk_1` FOREIGN KEY (`metering_device_id`) REFERENCES `MeteringDevice` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
