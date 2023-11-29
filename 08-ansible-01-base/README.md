# Домашнее задание к занятию 1 «Введение в Ansible»

## Основная часть

1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте значение, которое имеет факт `some_fact` для указанного хоста при выполнении playbook.
##### Ответ:  

Значение = 12

![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/2eb411be-c2dc-4fc6-bc6b-2763671eeb52)
------  

2. Найдите файл с переменными (group_vars), в котором задаётся найденное в первом пункте значение, и поменяйте его на `all default fact`.

##### Ответ:    

![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/756d13ce-92c2-4310-8115-40a976edba52)


![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/e3aab423-d471-46bb-be97-62b64e0a0554)

------

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

##### Ответ: 
Поискал на Docker Hub пару подхдящих под условия образов, запустил контейнеры командами:
```bash
docker run -itd --restart=always --name ubuntu --network host caacd5b6b541
docker run -itd --restart=always --name centos7 --network host 39c0e5cecbeb

docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS                                                  NAMES
edef8c84cb20   caacd5b6b541   "python3"                3 minutes ago    Up 3 minutes                                                           ubuntu
3ec13fe4dd74   39c0e5cecbeb   "/bin/bash /opt/spac…"   36 minutes ago   Up 16 minutes                                                          centos7
```
------

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.
5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились значения: для `deb` — `deb default fact`, для `el` — `el default fact`.
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.
7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.
8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.
9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.
10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.
11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь, что факты `some_fact` для каждого из хостов определены из верных `group_vars`.
12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.
---
