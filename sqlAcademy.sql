--https://sql-academy.org/ru/trainer/tasks/1
-- Вывести имена всех когда-либо обслуживаемых пассажиров авиакомпаний
SELECT name FROM Passenger

-- https://sql-academy.org/ru/trainer/tasks/3
-- Вывести все рейсы, совершенные из Москвы
SELECT * FROM Trip
WHERE town_from = 'Moscow'

-- https://sql-academy.org/ru/trainer/tasks/4
-- Вывести имена людей, которые заканчиваются на "man"
SELECT name FROM Passenger
WHERE name LIKE '%%man'

-- https://sql-academy.org/ru/trainer/tasks/5
-- Вывести количество рейсов, совершенных на TU-134
SELECT COUNT(plane) AS count FROM Trip
WHERE plane = "TU-134"

-- https://sql-academy.org/ru/trainer/tasks/6
-- Какие компании совершали перелеты на Boeing
SELECT name FROM Company
WHERE id IN (SELECT DISTINCT company FROM Trip WHERE plane = 'Boeing')

-- https://sql-academy.org/ru/trainer/tasks/7
-- Вывести все названия самолётов, на которых можно улететь в Москву (Moscow)
SELECT DISTINCT plane FROM Trip
WHERE town_to = 'Moscow'

-- https://sql-academy.org/ru/trainer/tasks/8
-- В какие города можно улететь из Парижа (Paris) и сколько времени это займёт?
SELECT town_to, TIMEDIFF(time_in, time_out) AS flight_time FROM Trip
WHERE town_from = 'Paris'

-- https://sql-academy.org/ru/trainer/tasks/10
-- Вывести вылеты, совершенные с 10 ч. по 14 ч. 1 января 1900 г.
SELECT * FROM Trip
WHERE time_out BETWEEN '1900-01-01 10:00:00' AND '1900-01-01 14:00:00'

-- https://sql-academy.org/ru/trainer/tasks/11
-- Вывести пассажиров с самым длинным именем
SELECT name FROM Passenger
WHERE LENGTH(name) = (SELECT MAX(LENGTH(name)) FROM Passenger)

-- https://sql-academy.org/ru/trainer/tasks/12
-- Вывести id и количество пассажиров для всех прошедших полётов
SELECT trip, COUNT(passenger) AS count FROM Pass_in_trip
GROUP BY trip

-- https://sql-academy.org/ru/trainer/tasks/13
-- Вывести имена людей, у которых есть полный тёзка среди пассажиров
SELECT name FROM Passenger
GROUP BY name
HAVING COUNT(*) > 1

-- https://sql-academy.org/ru/trainer/tasks/14
-- В какие города летал Bruce Willis
SELECT town_to FROM Trip
WHERE id IN (SELECT trip FROM Pass_in_trip WHERE passenger IN (
  SELECT id FROM Passenger WHERE name ='Bruce Willis'
  )
)

-- https://sql-academy.org/ru/trainer/tasks/15
-- Во сколько Стив Мартин (Steve Martin) прилетел в Лондон (London)
SELECT time_in FROM Trip
WHERE town_to = 'London' AND id IN (SELECT trip FROM Pass_in_trip WHERE passenger = (
  SELECT id FROM Passenger WHERE name ='Steve Martin'
  )
)

-- https://sql-academy.org/ru/trainer/tasks/16
-- Вывести отсортированный по количеству перелетов (по убыванию) и имени (по возрастанию) список пассажиров, совершивших хотя бы 1 полет.
SELECT name, COUNT(trip) AS count FROM Passenger
JOIN Pass_in_trip
ON Passenger.id = Pass_in_trip.passenger
GROUP BY name
HAVING count >= 1
ORDER BY count DESC, name ASC

-- https://sql-academy.org/ru/trainer/tasks/17
-- Определить, сколько потратил в 2005 году каждый из членов семьи
SELECT member_name, status, SUM(amount*unit_price) AS costs
FROM FamilyMembers JOIN Payments
ON FamilyMembers.member_id = Payments.family_member
WHERE date BETWEEN '2005-01-01' AND '2005-12-31'
GROUP BY member_name, status

-- https://sql-academy.org/ru/trainer/tasks/18
-- Узнать, кто старше всех в семьe
SELECT member_name FROM FamilyMembers
WHERE birthday = (SELECT MIN(birthday) FROM FamilyMembers)

-- https://sql-academy.org/ru/trainer/tasks/19
-- Определить, кто из членов семьи покупал картошку (potato)
SELECT status FROM FamilyMembers
WHERE member_id IN (SELECT family_member FROM Payments WHERE good = (
  SELECT good_id FROM Goods WHERE good_name = 'potato'
  )
)

-- https://sql-academy.org/ru/trainer/tasks/20
-- Сколько и кто из семьи потратил на развлечения (entertainment). Вывести статус в семье, имя, сумму
SELECT status, member_name, SUM(amount*unit_price) AS costs
FROM FamilyMembers JOIN Payments
ON FamilyMembers.member_id = Payments.family_member
WHERE good = (SELECT good_id FROM Goods WHERE type = (
  SELECT good_type_id FROM GoodTypes WHERE good_type_name = 'entertainment'
  )
)
GROUP BY status, member_name

-- https://sql-academy.org/ru/trainer/tasks/21
-- Определить товары, которые покупали более 1 раза
SELECT good_name FROM Goods
WHERE good_id IN (SELECT good FROM Payments GROUP BY good HAVING COUNT(*) > 1)

-- https://sql-academy.org/ru/trainer/tasks/22
-- Найти имена всех матерей (mother)
SELECT member_name FROM FamilyMembers
WHERE status = 'mother'

-- https://sql-academy.org/ru/trainer/tasks/23
-- Найдите самый дорогой деликатес (delicacies) и выведите его стоимость
SELECT good_name, unit_price
FROM Goods JOIN Payments
ON Goods.good_id = Payments.good
WHERE unit_price = (
    SELECT MAX(unit_price) FROM Payments WHERE good IN (
        SELECT good_id FROM Goods WHERE type = (
            SELECT good_type_id FROM GoodTypes WHERE good_type_name = 'delicacies'
        )
    )
)

-- https://sql-academy.org/ru/trainer/tasks/24
-- Определить кто и сколько потратил в июне 2005
SELECT member_name, unit_price*amount AS costs
FROM FamilyMembers JOIN Payments
ON FamilyMembers.member_id = Payments.family_member
WHERE date BETWEEN '2005-06-01' AND '2005-06-30'

-- https://sql-academy.org/ru/trainer/tasks/25
-- Определить, какие товары имеются в таблице Goods, но не покупались в течение 2005 года
SELECT good_name FROM Goods
WHERE good_id NOT IN (SELECT good FROM Payments WHERE date BETWEEN '2005-01-01' AND '2005-12-31')

-- https://sql-academy.org/ru/trainer/tasks/26
-- Определить группы товаров, которые не приобретались в 2005 году (но покупались когда-либо)
SELECT good_type_name FROM GoodTypes
WHERE good_type_id NOT IN (SELECT type FROM Goods WHERE good_id IN (
  SELECT good FROM Payments WHERE date BETWEEN '2005-01-01' AND '2005-12-31'
  )
)

-- https://sql-academy.org/ru/trainer/tasks/27
-- Узнать, сколько потрачено на каждую из групп товаров в 2005 году. Вывести название группы и сумму
SELECT good_type_name, SUM(amount*unit_price) AS costs
FROM GoodTypes JOIN Goods
ON GoodTypes.good_type_id = Goods.type
JOIN Payments
ON Goods.good_id = Payments.good
WHERE date BETWEEN '2005-01-01' AND '2005-12-31'
GROUP BY good_type_name
