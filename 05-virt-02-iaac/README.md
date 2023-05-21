# Домашнее задание к занятию 2. «Применение принципов IaaC в работе с виртуальными машинами»

---

## Задача 1

- Опишите основные преимущества применения на практике IaaC-паттернов.  
  - Ускорение производства и вывода продукта на рынок  
  - Стабильность среды, устранение дрейфа конфигураций  
  - Более быстрая и эффективная разработка  

Эти преимущества в конечном итоге улучшают показатель time-to-market, что повышает конкурентоспособность бизнеса.

- Какой из принципов IaaC является основополагающим?

Принцип идемпотентности, когда при последующем выполнении одних и тех же операций мы получаем каждый раз тот же самый результат, что и при первом выполнении.

---

## Задача 2

- Чем Ansible выгодно отличается от других систем управление конфигурациями?
  - Скорость (быстрый старт на текущей SSH-инфраструктуре)
  - Относительная простота освоения (более низкий порог входа в сравнении с аналогами, не требует установки агентов на конфигурируемые хосты, что упрощает настройку и управление)
  - Масштабируемость (Ansible можно использовать для управления конфигурацией отдельных узлов, а также для управления сотнями и тысячами узлов. Он также поддерживает множество платформ, включая Linux, Unix, Windows и другие)
  - Расширяемость (лёгкое подключение кастомных ролей и модулей)
  - Безопасность (обеспечивает безопасность данных и конфигураций, так как используется шифрование и аутентификация для защиты данных и управляемых узлов)
  - Сообщество (большое и активное сообщество пользователей и разработчиков, постоянно расширяющее возможности Ansible)

- Какой, на ваш взгляд, метод работы систем конфигурации более надёжный — push или pull?
  - В целом, метод "pull" считается более надежным, так как он дает больше контроля над изменениями и узлы могут проверять совместимость изменений с их конфигурацией. Однако, метод "push" может быть более подходящим в случаях, когда изменения необходимо быстро внедрить на узлы. Стоит отметить, что выбор между этими методами зависит от конкретных потребностей и условий, и оптимальным решением может быть комбинация обоих методов в зависимости от ситуации.


---

## Задача 3

Установите на личный компьютер:
*Приложите вывод команд установленных версий каждой из программ, оформленный в Markdown.*

- [VirtualBox](https://www.virtualbox.org/),

```bash
user@LE3:~$ vboxmanage --version
6.1.38_Ubuntur153438
```

- [Vagrant](https://github.com/netology-code/devops-materials),

```bash
user@LE3:~$ vagrant -v
Vagrant 2.2.19
```

- [Terraform](https://github.com/netology-code/devops-materials/blob/master/README.md),

```bash
user@LE3:~$ terraform -v
Terraform v1.4.6
on linux_amd64
```

- Ansible.

```bash
user@LE3:~$ ansible --version
ansible 2.10.8
  config file = None
  configured module search path = ['/home/user/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.10.6 (main, Mar 10 2023, 10:55:28) [GCC 11.3.0]
```

---

## Задача 4 

Воспроизведите практическую часть лекции самостоятельно.

- Создайте виртуальную машину.
- Зайдите внутрь ВМ, убедитесь, что Docker установлен с помощью команды
```
docker ps,
```
Vagrantfile из лекции и код ansible находятся в [папке](https://github.com/netology-code/virt-homeworks/tree/virt-11/05-virt-02-iaac/src).

Примечание. Если Vagrant выдаёт ошибку:
```
URL: ["https://vagrantcloud.com/bento/ubuntu-20.04"]     
Error: The requested URL returned error: 404:
```

выполните следующие действия:

1. Скачайте с [сайта](https://app.vagrantup.com/bento/boxes/ubuntu-20.04) файл-образ "bento/ubuntu-20.04".
2. Добавьте его в список образов Vagrant: "vagrant box add bento/ubuntu-20.04 <путь к файлу>".

##### Ответ:

```bash
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND   CREATED   STATUS    PORTS     NAMES
vagrant@server1:~$ docker version
Client: Docker Engine - Community
 Version:           24.0.1
 API version:       1.43
 Go version:        go1.20.4
 Git commit:        6802122
 Built:             Fri May 19 18:06:24 2023
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          24.0.1
  API version:      1.43 (minimum version 1.12)
  Go version:       go1.20.4
  Git commit:       463850e
  Built:            Fri May 19 18:06:24 2023
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.6.21
  GitCommit:        3dce8eb055cbb6872793272b4f20ed16117344f8
 runc:
  Version:          1.1.7
  GitCommit:        v1.1.7-0-g860f061
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
```

---
