# Домашнее задание к занятию 2 «Работа с Playbook»

## Подготовка к выполнению

1. * Необязательно. Изучите, что такое [ClickHouse](https://www.youtube.com/watch?v=fjTNS2zkeBs) и [Vector](https://www.youtube.com/watch?v=CgEhyffisLY).
2. Создайте свой публичный репозиторий на GitHub с произвольным именем или используйте старый.
3. Скачайте [Playbook](./playbook/) из репозитория с домашним заданием и перенесите его в свой репозиторий.
4. Подготовьте хосты в соответствии с группами из предподготовленного playbook.

##### Ответ:  

```bash
root@LE3:/home# docker run -itd --restart=always --name clickhouse-01 --network host bafa54e44377 sleep infinity
8c0c8793ab3f66628d6c38e4e3c4fd20c2ac725f6da7c5e57b032ee6f3563528
root@LE3:/home# docker run -itd --restart=always --name vector-01 --network host bafa54e44377 sleep infinity
f517706ce15dd9621512d4972c0cb6438593d6b12b88d9e601432ee23e54833c
root@LE3:/home# docker ps
CONTAINER ID   IMAGE          COMMAND            CREATED          STATUS          PORTS     NAMES
f517706ce15d   bafa54e44377   "sleep infinity"   14 seconds ago   Up 14 seconds             vector-01
8c0c8793ab3f   bafa54e44377   "sleep infinity"   25 seconds ago   Up 25 seconds             clickhouse-01
```

------

## Основная часть

1. Подготовьте свой inventory-файл `prod.yml`.

##### Ответ:

```yml
---
clickhouse:
  hosts:
    clickhouse-01:
        ansible_connection: docker
vector:
  hosts:
    vector-01:
      ansible_connection: docker
```

------

2. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает [vector](https://vector.dev). Конфигурация vector должна деплоиться через template файл jinja2. От вас не требуется использовать все возможности шаблонизатора, просто вставьте стандартный конфиг в template файл. Информация по шаблонам по [ссылке](https://www.dmosk.ru/instruktions.php?object=ansible-nginx-install). не забудьте сделать handler на перезапуск vector в случае изменения конфигурации!

##### Ответ:

```yml
---
- name: Install Clickhouse
  hosts: clickhouse
  handlers:
    - name: Start clickhouse service
      become: true
      ansible.builtin.service:
        name: clickhouse-server
        state: restarted
  tasks:
    - block:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: https://packages.clickhouse.com/rpm/stable/{{ item }}-{{ clickhouse_version }}.noarch.rpm
            dest: ./{{ item }}-{{ clickhouse_version }}.rpm
          with_items: "{{ clickhouse_packages }}"
      rescue:
        - name: Get clickhouse distrib
          ansible.builtin.get_url:
            url: https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-{{ clickhouse_version }}.x86_64.rpm
            dest: ./clickhouse-common-static-{{ clickhouse_version }}.rpm
    - name: Install clickhouse packages
      become: true
      ansible.builtin.yum:
        name:
          - clickhouse-common-static-{{ clickhouse_version }}.rpm
          - clickhouse-client-{{ clickhouse_version }}.rpm
          - clickhouse-server-{{ clickhouse_version }}.rpm
      notify: Start clickhouse service
    - name: Flush handlers
      ansible.builtin.meta: flush_handlers
    - name: Create database
      ansible.builtin.command: clickhouse-client -q 'create database logs;'
      register: create_db
      failed_when: create_db.rc != 0 and create_db.rc !=82
      changed_when: create_db.rc == 0
- name: Install and configure Vector
  hosts: vector
  become: true
  tasks:
    - name: Install Vector
      become: true
      ansible.builtin.yum:
        name: https://packages.timber.io/vector/{{ vector_ver }}/vector-1.x86_64.rpm
        state: present
    - name: Configure Vector
      ansible.builtin.template:
        src: vector_config.j2
        dest: /etc/vector/vector.toml
        owner: root
        group: root
        mode: "0644"
      notify: restart vector
  handlers:
    - name: Restart vector
      ansible.builtin.service:
        name: vector
        state: restarted

```

------

3. При создании tasks рекомендую использовать модули: `get_url`, `template`, `unarchive`, `file`.
4. Tasks должны: скачать дистрибутив нужной версии, выполнить распаковку в выбранную директорию, установить vector.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.

##### Ответ:

ansible-lint поругался про имена, пермишены и спэйсинг, но на работу плэйбука это сильно не повлияло

![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/7f513d8b-7e06-47ba-b0b6-4609eadc63b1)


------

6. Попробуйте запустить playbook на этом окружении с флагом `--check`.

##### Ответ:

```bash
root@LE3:/home/mnt_homeworks/ansible_hw/08-ansible-02-playbook/playbook# ansible-playbook -i ./inventory/prod.yml site.yml --check

PLAY [Install Clickhouse] *******************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] **********************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Flush handlers] ***********************************************************************************************************************************************************************************************************

TASK [Create database] **********************************************************************************************************************************************************************************************************
skipping: [clickhouse-01]

PLAY [Install and configure Vector] *********************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Install Vector] ***********************************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Configure Vector] *********************************************************************************************************************************************************************************************************
ok: [vector-01]

PLAY RECAP **********************************************************************************************************************************************************************************************************************
clickhouse-01              : ok=3    changed=0    unreachable=0    failed=0    skipped=1    rescued=1    ignored=0   
vector-01                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

------

7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.

##### Ответ:

```bash
root@LE3:/home/mnt_homeworks/ansible_hw/08-ansible-02-playbook/playbook# ansible-playbook -i ./inventory/prod.yml site.yml --diff

PLAY [Install Clickhouse] *******************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] **********************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Flush handlers] ***********************************************************************************************************************************************************************************************************

TASK [Create database] **********************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install and configure Vector] *********************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Install Vector] ***********************************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Configure Vector] *********************************************************************************************************************************************************************************************************
ok: [vector-01]

PLAY RECAP **********************************************************************************************************************************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
vector-01                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

------

8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.

##### Ответ:

```bash
root@LE3:/home/mnt_homeworks/ansible_hw/08-ansible-02-playbook/playbook# ansible-playbook -i ./inventory/prod.yml site.yml --diff

PLAY [Install Clickhouse] *******************************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************************************************
ok: [clickhouse-01] => (item=clickhouse-client)
ok: [clickhouse-01] => (item=clickhouse-server)
failed: [clickhouse-01] (item=clickhouse-common-static) => {"ansible_loop_var": "item", "changed": false, "dest": "./clickhouse-common-static-22.3.3.44.rpm", "elapsed": 0, "gid": 0, "group": "root", "item": "clickhouse-common-static", "mode": "0644", "msg": "Request failed", "owner": "root", "response": "HTTP Error 404: Not Found", "size": 246310036, "state": "file", "status_code": 404, "uid": 0, "url": "https://packages.clickhouse.com/rpm/stable/clickhouse-common-static-22.3.3.44.noarch.rpm"}

TASK [Get clickhouse distrib] ***************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Install clickhouse packages] **********************************************************************************************************************************************************************************************
ok: [clickhouse-01]

TASK [Flush handlers] ***********************************************************************************************************************************************************************************************************

TASK [Create database] **********************************************************************************************************************************************************************************************************
ok: [clickhouse-01]

PLAY [Install and configure Vector] *********************************************************************************************************************************************************************************************

TASK [Gathering Facts] **********************************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Install Vector] ***********************************************************************************************************************************************************************************************************
ok: [vector-01]

TASK [Configure Vector] *********************************************************************************************************************************************************************************************************
ok: [vector-01]

PLAY RECAP **********************************************************************************************************************************************************************************************************************
clickhouse-01              : ok=4    changed=0    unreachable=0    failed=0    skipped=0    rescued=1    ignored=0   
vector-01                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

------

9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги. Пример качественной документации ansible playbook по [ссылке](https://github.com/opensearch-project/ansible-playbook). Так же приложите скриншоты выполнения заданий №5-8

##### Ответ:

https://github.com/PetrMezentsev/homeworks/blob/main/08-ansible-02-playbook/playbook.md

------

10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-02-playbook` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---
