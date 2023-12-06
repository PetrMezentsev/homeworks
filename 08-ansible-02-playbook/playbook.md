# Ansible Playbook: Установка ClickHouse и Vector

Данный Ansible playbook предназначен для установки ClickHouse и Vector на целевые хосты.

## Что делает playbook

1. Установка ClickHouse:
   - Получает дистрибутив ClickHouse (rpm-пакеты) в зависимости от версии и заданных параметров.
   - Устанавливает пакеты ClickHouse.
   - Создает базу данных "logs".

2. Установка и настройка Vector:
   - Устанавливает пакет Vector.
   - Применяет конфигурацию Vector из файла шаблона.

## Параметры

### ClickHouse
- clickhouse_version: версия ClickHouse для установки.
- clickhouse_packages: пакеты ClickHouse для загрузки.
- hosts: clickhouse: группа хостов для установки ClickHouse.

### Vector
- vector_ver: версия Vector для установки.
- hosts: vector: группа хостов для установки Vector.

## Теги

- start_clickhouse_service: тег для перезапуска ClickHouse сервиса.
- restart_vector: тег для перезапуска сервиса Vector.

## Пример использования тегов

1. Выполнение только установки ClickHouse:
   ```bash
   ansible-playbook playbook.yml --tags "clickhouse_install"
   ```

2. Выполнение только установки Vector:
   ```bash
   ansible-playbook playbook.yml --tags "vector_install"
   ```

3. Перезапуск сервиса ClickHouse:
   ```bash
   ansible-playbook playbook.yml --tags "start_clickhouse_service"
   ```

4. Перезапуск сервиса Vector:
   ```bash
   ansible-playbook playbook.yml --tags "restart_vector"
   ```

---
