CREATE DATABASE rugby_stats;
Query OK, 1 row affected (0,01 sec)

SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| EJ                 |
| crm_inmobiliario   |
| ejemploclaves      |
| empresadam         |
| information_schema |
| mysql              |
| performance_schema |
| rugby_stats        |
| sys                |
+--------------------+

USE rugby_stats;
Database changed

CREATE TABLE partidos(
	id_partido VARCHAR(15),
	equipo_local VARCHAR(50),
	equipo_visitante VARCHAR (50),
	resultado VARCHAR (15),
	fecha VARCHAR (10)
);
Query OK, 0 rows affected (0,04 sec)

INSERT INTO partidos VALUES(
	"001",
	"Centro",
	"Provincia",
	"10 a 20",
	"19/10"
);
	
INSERT INTO partidos VALUES(
	"002",
	"Cau",
	"Geba",
	"0 a 45",
	"19/10"
);

INSERT INTO partidos VALUES(
	"003",
	"Alumni",
	"SIC",
	"30 a 30",
	"19/10"
);

INSERT INTO partidos VALUES(
	"004",
	"Ciudad",
	"Centro naval",
	"12 a 15",
	"19/10"
);

INSERT INTO partidos VALUES(
	"005",
	"Geba",
	"SITAS",
	"70 a 30",
	"19/10"
);
Query OK, 1 row affected (0,01 sec)

SELECT * FROM partidos;
+------------+--------------+------------------+-----------+-------+
| id_partido | equipo_local | equipo_visitante | resultado | fecha |
+------------+--------------+------------------+-----------+-------+
| 001        | Centro       | Provincia        | 10 a 20   | 19/10 |
| 002        | Cau          | Geba             | 0 a 45    | 19/10 |
| 003        | Alumni       | SIC              | 30 a 30   | 19/10 |
| 004        | Ciudad       | Centro naval     | 12 a 15   | 19/10 |
| 005        | Geba         | SITAS            | 70 a 30   | 19/10 |
+------------+--------------+------------------+-----------+-------+

