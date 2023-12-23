# Домашнее задание к занятию 4 «Работа с roles»

## Основная часть

Ваша цель — разбить ваш playbook на отдельные roles. 

Задача — сделать roles для ClickHouse, Vector и LightHouse и написать playbook для использования этих ролей. 

Ожидаемый результат — существуют три ваших репозитория: два с roles и один с playbook.

**Что нужно сделать**

1. Создайте в старой версии playbook файл `requirements.yml` и заполните его содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.13"
       name: clickhouse 
   ```

2. При помощи `ansible-galaxy` скачайте себе эту роль.
3. Создайте новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
5. Перенести нужные шаблоны конфигов в `templates`.
6. Опишите в `README.md` обе роли и их параметры. Пример качественной документации ansible role [по ссылке](https://github.com/cloudalchemy/ansible-prometheus).
7. Повторите шаги 3–6 для LightHouse. Помните, что одна роль должна настраивать один продукт.
8. Выложите все roles в репозитории. Проставьте теги, используя семантическую нумерацию. Добавьте roles в `requirements.yml` в playbook.
9. Переработайте playbook на использование roles. Не забудьте про зависимости LightHouse и возможности совмещения `roles` с `tasks`.

##### Ответ:

Переработанный playbook  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/8c5cf1ac-c9c4-4cb2-adc6-4b2582fd0f1b)

Результат работы playbook
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/e1bf68a2-4097-4c70-94bd-927a873c0e83)

Страница с Lighthouse
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/96182130-a08c-4a9c-9f8f-3427b500970a)

------

10. Выложите playbook в репозиторий.
11. В ответе дайте ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

##### Ответ:

[Vector](https://github.com/PetrMezentsev/vector-role)  
[Lighthouse](https://github.com/PetrMezentsev/lighthouse-role)  
[Playbook](https://github.com/PetrMezentsev/homeworks/tree/main/08-ansible-04-role/playbook)  

---
