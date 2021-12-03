-- DB schema (https://sql-ex.ru/help/select13.php#db_1)

--Short database description "Computer firm":
-- The database scheme consists of four tables:
-- Product(maker, model, type)
-- PC(code, model, speed, ram, hd, cd, price)
-- Laptop(code, model, speed, ram, hd, screen, price)
-- Printer(code, model, color, type, price)

-- The Product table contains data on the maker, model number, and type of product ('PC', 'Laptop', or 'Printer').
-- It is assumed that model numbers in the Product table are unique for all makers and product types.

-- Each personal computer in the PC table is unambiguously identified by a unique code,
-- and is additionally characterized by its model (foreign key referring to the Product table),
-- processor speed (in MHz) – speed field, RAM capacity (in Mb) - ram, hard disk drive capacity (in Gb) – hd,
-- CD-ROM speed (e.g, '4x') - cd, and its price.

-- The Laptop table is similar to the PC table, except that instead of the CD-ROM speed,
-- it contains the screen size (in inches) – screen.

-- For each printer model in the Printer table, its output type (‘y’ for color and ‘n’ for monochrome) –
-- color field, printing technology ('Laser', 'Jet', or 'Matrix') – type, and price are specified.



-- 1. Find the model number, speed and hard drive capacity for all the PCs with prices below $500.
-- Result set: model, speed, hd.
SELECT model, speed, hd FROM PC
WHERE price < 500

-- 2. List all printer makers. Result set: maker.
SELECT DISTINCT maker FROM Product
WHERE type = 'Printer'

-- 3. Find the model number, RAM and screen size of the laptops with prices over $1000.
SELECT model, ram, screen FROM Laptop
WHERE price > 1000

-- 4. Find all records from the Printer table containing data about color printers.
SELECT * FROM Printer
WHERE color = 'y'

-- 5. Find the model number, speed and hard drive capacity of PCs cheaper than $600 having a 12x or a 24x CD drive.
SELECT model, speed, hd FROM PC
WHERE price < 600 AND (cd = '12x' OR cd = '24x')

-- 6. For each maker producing laptops with a hard drive capacity of 10 Gb or higher, find the speed of such laptops.
-- Result set: maker, speed.
SELECT DISTINCT maker, speed
FROM Product, Laptop
WHERE Product.model = Laptop.model AND hd >= 10

-- 7.Get the models and prices for all commercially available products (of any type) produced by maker B.
SELECT model, price FROM PC
WHERE model IN (SELECT model FROM Product
WHERE maker = 'B')
UNION
SELECT model, price FROM Laptop
WHERE model IN (SELECT model FROM Product
WHERE maker = 'B')
UNION
SELECT model, price FROM Printer
WHERE model IN (SELECT model FROM Product
WHERE maker = 'B')

-- 8. Find the makers producing PCs but not laptops.
SELECT maker FROM Product
WHERE type = 'PC'
EXCEPT
SELECT maker FROM Product
WHERE type = 'Laptop'

-- 9. Find the makers of PCs with a processor speed of 450 MHz or more. Result set: maker.
SELECT DISTINCT maker FROM Product
WHERE model IN (SELECT model FROM PC WHERE speed >= 450)

-- 10. Find the printer models having the highest price. Result set: model, price.
SELECT model, price FROM Printer
WHERE price IN (SELECT MAX(price) FROM Printer)

-- 11. Find out the average speed of PCs.
SELECT AVG(speed) avg_speed FROM PC

-- 12. Find out the average speed of the laptops priced over $1000.
SELECT AVG(speed) avg_speed FROM Laptop
WHERE price > 1000

-- 13. Find out the average speed of the PCs produced by maker A.
SELECT AVG(speed) avg_speed FROM PC
WHERE model IN(SELECT model FROM Product
WHERE maker = 'A')

-- 14. For the ships in the Ships table that have at least 10 guns, get the class, name, and country.
SELECT Ships.class, name, country
FROM Ships, Classes
WHERE Ships.class = Classes.class AND
numGuns >= 10

-- 15. Get hard drive capacities that are identical for two or more PCs. Result set: hd.
SELECT hd FROM PC
GROUP BY hd
HAVING COUNT(hd) > 1

-- 16. Get pairs of PC models with identical speeds and the same RAM capacity.
-- Each resulting pair should be displayed only once, i.e. (i, j) but not (j, i).
-- Result set: model with the bigger number, model with the smaller number, speed, and RAM.
SELECT DISTINCT A.model model, B.model model, A.speed, B.ram
FROM PC AS A, PC AS B
WHERE A.speed = B.speed
AND A.ram = B.ram
AND A.model > B.model

-- 17. Get the laptop models that have a speed smaller than the speed of any PC.
-- Result set: type, model, speed.
SELECT DISTINCT type, Laptop.model, speed
FROM Product, Laptop
WHERE type = 'Laptop'
AND speed < ALL (SELECT speed FROM PC)

-- 18. Find the makers of the cheapest color printers. Result set: maker, price.
SELECT DISTINCT maker, price
FROM Product JOIN Printer
ON Printer.model = Product.model
WHERE price = (SELECT MIN(price) FROM Printer
WHERE color = 'y') AND color = 'y'
