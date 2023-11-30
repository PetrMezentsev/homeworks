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

##### Ответ:

```bash
ansible-playbook site.yml -i inventory/prod.yml
```

![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/484402fa-59a8-4735-abc3-5543d7add79e)

------

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились значения: для `deb` — `deb default fact`, для `el` — `el default fact`.
6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

##### Ответ:

![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/fc44c7ed-845b-4a6a-af67-816e916ed17d)

------

7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

##### Ответ:

![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/459aa03f-7857-4e3e-afbb-56aded7eaaf1)

![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/d1f777ec-f77c-4e00-a2c6-29db48c50e3b)
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/96fcda1e-5597-44f7-ac72-608204eaad19)

------

8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

##### Ответ:
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/52d58a84-7b4c-454f-987b-cae91ac25957)

------

9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

##### Ответ:

Отображаем список плагинов для подключения, понимаем, что для работы на контроллере подходит плагин `ansible.builtin.local`

```bash
ansible-doc -t connection -l
ansible.builtin.local          execute on controller                                                                                              
ansible.builtin.paramiko_ssh   Run tasks via Python SSH (paramiko)                                                                                
ansible.builtin.psrp           Run tasks over Microsoft PowerShell Remoting Protocol                                                              
ansible.builtin.ssh            connect via SSH client binary                                                                                      
...
```

Можем ознакомиться с плагином более подробно

```bash
ansible-doc -t connection ansible.builtin.local
> ANSIBLE.BUILTIN.LOCAL    (/usr/local/lib/python3.10/dist-packages/ansible/plugins/connection/local.py)

        This connection plugin allows ansible to execute tasks on the Ansible 'controller' instead of on a remote host.

ADDED IN: historical

OPTIONS (= is mandatory):

- pipelining
        Pipelining reduces the number of connection operations required to execute a module on the remote server, by
        executing many Ansible modules without actual file transfers.
        This can result in a very significant performance improvement when enabled.
        However this can conflict with privilege escalation (become). For example, when using sudo operations you must
        first disable 'requiretty' in the sudoers file for the target hosts, which is why this feature is disabled by
        default.
        set_via:
          env:
          - name: ANSIBLE_PIPELINING
          ini:
          - key: pipelining
            section: defaults
          - key: pipelining
            section: connection
          vars:
          - name: ansible_pipelining
        default: false
        type: boolean


NOTES:
      * The remote user is ignored, the user with which the ansible CLI was executed is used instead.


AUTHOR: ansible (@core)

NAME: local
```

------

10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

##### Ответ:
------

11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь, что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

##### Ответ:
------

12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.
---
