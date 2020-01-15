-- Практическое задание по теме “Операторы, фильтрация, сортировка и ограничение”

-- Задание 1.	Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

-- создадим таблицу с данными
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME,
  updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-15'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');
 
-- Обновить поля текущей датой временем можно следующим образом:
UPDATE users SET created_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP;
-- если необходимо обновить только те строки где и created_at и updated_at пустые, то таким образом:
 UPDATE users SET created_at = CURRENT_TIMESTAMP, updated_at = CURRENT_TIMESTAMP where created_at is NULL and updated_at is null;

-- Задание 2.	Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения.

-- создадим таблицу с данными  где created_at и updated_at текстовые данные
 
DROP TABLE IF EXISTS users_text; 
CREATE TABLE users_text (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = 'Покупатели';

INSERT INTO users_text (name,birthday_at,created_at,updated_at) VALUES 
('Геннадий','1990-10-05','15.01.2020 21:33','15.01.2020 22:06')
,('Наталья','1984-11-12','15.01.2020 21:33','15.01.2020 22:06')
,('Александр','1985-05-20','15.01.2020 21:33','15.01.2020 22:06')
,('Сергей','1988-02-15','15.01.2020 21:33','15.01.2020 22:06')
,('Иван','1998-01-12','15.01.2020 21:33','15.01.2020 22:06')
,('Мария','1992-08-29','15.01.2020 21:33','15.01.2020 22:06')
;

-- теперь создадим таблицу где created_at и updated_at объявлены как DATETIME
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME,
  updated_at DATETIME ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

Select str_to_date (created_at, '%d.%m.%Y %H:%i') as datetime from users_text;

-- перенесем в эту таблицу данные с учетом конвертации текстовых данных в DATETIME
insert into users (`name`, birthday_at, created_at, updated_at)
 select `name`, 
 birthday_at, 
 str_to_date (created_at, '%d.%m.%Y %H:%i'), 
 str_to_date (updated_at, '%d.%m.%Y %H:%i')
 from users_text;
 
 -- Задание 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.
 
 -- создадим таблицу с данными 
 DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  `value` INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';
INSERT INTO storehouses_products (storehouse_id,product_id,`value`,created_at,updated_at) VALUES 
(1,1,576,'2020-01-15 22:54:09','2020-01-15 22:56:49')
,(1,2,1196,'2020-01-15 22:54:09','2020-01-15 22:56:49')
,(1,3,1752,'2020-01-15 22:54:09','2020-01-15 22:56:49')
,(1,4,0,'2020-01-15 22:54:09','2020-01-15 22:57:50')
,(1,5,604,'2020-01-15 22:54:09','2020-01-15 22:56:49')
,(1,6,0,'2020-01-15 22:54:09','2020-01-15 22:57:50')
,(1,7,719,'2020-01-15 22:54:09','2020-01-15 22:56:49')
;
-- сортировка по возрастанию остатков при этом  нулевые остатки в конце:
Select * from storehouses_products sp order BY if (`value` = 0, 99999999999999,`value`);

-- Задание 4* Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august')
-- таблицу users возьмем из заданий выше
-- тогда выбрать родившихся в месяцах представленном в списке можно следующим образом:
select * from users where DATE_FORMAT(birthday_at, '%M') IN ('may', 'august');

-- Задание 5*. Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN

 -- создадим таблицу с данными 
 DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Название раздела',
  UNIQUE unique_name(name(10))
) COMMENT = 'Разделы интернет-магазина';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');
 -- решение задания:
 SELECT * FROM catalogs WHERE id IN (5, 1, 2) order by FIELD (id, 5, 1, 2); 
 
 
 
 -- Практическое задание теме “Агрегация данных”
 
 -- Задание 1. Подсчитайте средний возраст пользователей в таблице users
 -- таблицу users возьмем из заданий выше
 -- решение:
 SELECT AVG (TIMESTAMPDIFF(YEAR,birthday_at,CURRENT_TIMESTAMP)) from users;
 
-- Задание 2.	Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. Следует учесть, что необходимы дни недели текущего года, а не года рождения.
 -- таблицу users возьмем из заданий выше
 -- решение:
select 
	DATE_FORMAT ((str_to_date (DATE_FORMAT (birthday_at, '%d.%m.2020'), '%d.%m.%Y') ), '%w') as day_week,
	COUNT(*)
from users 
GROUP by day_week;

-- Задание 3*.	(по желанию) Подсчитайте произведение чисел в столбце таблицы (1,2,3,4,5)
-- возьмем таблицу catalogs (из примера выше) и посчитаем произведение колонки ID:
Select EXP(Sum(LN(id))) from catalogs;

