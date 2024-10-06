# Лабораторная работа №2. Взаимодействие с источниками данных
## Цель работы
Получить навыки выгрузки исходных данных и отправки результатов модели с использованием различных источников данных согласно варианту задания.
## Ход работы
Для реализации источника данных была выбрана база данных PostgreSQL, так как согласно варианту не получилось развернуть Greenplum на ОС Windows 10 (была попытка развёртки в коренной ОС и в Docker контейнере, однако, безуспешно).

Код реализации базы приведён ниже:
```
import psycopg2


class PostgresDB:
    def __init__(self, dbname, user, password, host='localhost', port=5432):
        self.conn = psycopg2.connect(
            dbname=dbname,
            user=user,
            password=password,
            host=host,
            port=port
        )
        self.cursor = self.conn.cursor()

    def create_table(self):
        self.cursor.execute('''
            CREATE TABLE IF NOT EXISTS results (
                id SERIAL PRIMARY KEY,
                Round VARCHAR(10000),
                air_date_group VARCHAR(10000),
                Question VARCHAR(10000),
                Value INT
            );
        ''')
        self.conn.commit()

    def insert_data(self, round, air_date_group, question, value):
        self.cursor.execute('''
            INSERT INTO results (Round, air_date_group, Question, Value) VALUES (%s, %s, %s, %s);
        ''', (round, air_date_group, question, value))
        self.conn.commit()

    def drop_table(self):
        self.cursor.execute('DROP TABLE IF EXISTS results;')
        self.conn.commit()

    def close(self):
        self.cursor.close()
        self.conn.close()
```

В файл кода predict.py был добавлен код для взаимодействия с БД.
```
self.dbname = self.config["DATABASE"]["dbname"]
self.user = self.config["DATABASE"]["user"]
self.password = self.config["DATABASE"]["password"]
self.db = PostgresDB(self.dbname, self.user, self.password)
self.db.create_table()
```

```
round = str(data["X"][0]["Round"])
air_date_group = str(data["X"][0]["air_date_group"])
question = str(data["X"][0]["Question"])
prediction = classifier.predict(X)
self.db.insert_data(round, air_date_group, question, int(prediction))
```