# 📡 Megafon SQL Database Project

Этот проект моделирует работу базы данных мобильного оператора «Мегафон». В базе реализованы пользователи, сотрудники, тарифные планы, паспортные данные, логика валидации, связи между таблицами и функции для управления данными.

## 📦 Содержимое

- `megafon_project.sql` — дамп базы данных PostgreSQL
- `README.md` — описание проекта

## 🧱 Структура базы данных

База данных состоит из 4 основных таблиц:

### 🧍‍♂️ users

- `id` — первичный ключ
- `first_name`, `last_name`, `middle_name` — ФИО (ограничение: только буквы)
- `phone_number` — уникальный номер (только 9 цифр)
- `balance` — текущий баланс
- `tarif_id` — связь с тарифом
- `passport_id` — связь с таблицей паспортов

### 📃 passports

- `id` — первичный ключ
- `first_name`, `last_name`, `middle_name` — имена (только буквы)
- `gender` — только `male` или `female`
- `birth_date` — дата рождения
- `country` — страна

### 💼 employees

- `id` — первичный ключ
- `f_name`, `l_name`, `m_name` — имена (только буквы)
- `permission_level` — уровень доступа
- `passport_id` — связь с паспортными данными

### 📱 tarifs

- `id` — первичный ключ
- `megabytes` — объём интернета
- `minutes` — минуты
- `night_bezlimit` — безлимит ночью
- `price` — цена тарифа

## 🔐 Валидации и ограничения

- Имена: только буквы (проверяются через `CHECK`)
- `phone_number`: только 9 цифр, `UNIQUE`
- `gender`: только `'male'` или `'female'`
- `middle_name`: допускается `NULL` или буквы
- `passport_id`: `FOREIGN KEY` из `users` и `employees`

## 🛠 Реализованные функции

```sql
-- Добавление пользователя
SELECT add_user('Ivan', 'Ivanov', '123456789', 500, 1, 1);

-- Смена тарифа
SELECT change_tarif(3, 2);  -- сменить тариф у user с id=3 на тариф с id=2
```

## 📊 Примеры SQL-запросов

```sql
-- Найти всех пользователей с балансом выше 100
SELECT * FROM users WHERE balance > 100;

-- Показать всех пользователей с их тарифами
SELECT u.first_name, t.megabytes, t.minutes
FROM users u
JOIN tarifs t ON u.tarif_id = t.id;

-- Показать сотрудников с уровнем доступа > 5
SELECT * FROM employees WHERE permission_level > 5;
```

## ⚙️ Установка

```bash
psql -U postgres -d megafon_db < megafon_project.sql
```

## 🧠 Навыки, продемонстрированные в проекте

- Проектирование базы данных с нуля
- Ограничения, связи и нормализация
- SQL-функции, CHECK, UNIQUE, FOREIGN KEY
- Практика INSERT, UPDATE, SELECT, JOIN
- Работа с PostgreSQL как в продакшене

## 📍 Зачем этот проект

Проект показывает реальное понимание:
- архитектуры БД,
- написания SQL-запросов,
- построения удобной и масштабируемой структуры.

## 👤 Автор

Unkind — начинающий разработчик с уверенным владением SQL и PostgreSQL.
GitHub: [Unkind](https://github.com/Unkind)
