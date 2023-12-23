Ansible Role: Vector
=========

Роль устанавливает Vector на системы EL

Role Variables
--------------
Переменные могут быть переопределены в файле `defaults/main.yml`
| Переменная | Значение по умолчанию| Описание | 
|------------|----------------------|----------|
|`vector_ver`| 0.30.0 | Версия пакета |

Support platforms:
----------------

| Name | Version |
| :----: | :-----:|
| Centos| 7,8|
| Rhel | 7,8 |


Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:
```yaml
    - hosts: servers
      roles:
         - role: vector-role 
```
License
-------

MIT

Author Information
------------------

Petr Mezentsev