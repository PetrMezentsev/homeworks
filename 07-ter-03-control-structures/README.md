# Домашнее задание к занятию «Управляющие конструкции в коде Terraform»

### Задание 1

1. Изучите проект.
2. Заполните файл personal.auto.tfvars.
3. Инициализируйте проект, выполните код. Он выполнится, даже если доступа к preview нет.

Примечание. Если у вас не активирован preview-доступ к функционалу «Группы безопасности» в Yandex Cloud, запросите доступ у поддержки облачного провайдера. Обычно его выдают в течение 24-х часов.

Приложите скриншот входящих правил «Группы безопасности» в ЛК Yandex Cloud или скриншот отказа в предоставлении доступа к preview-версии.

##### Ответ:
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/71aa0a77-a0ea-4230-ae5b-182f93d318a8)

------

### Задание 2

1. Создайте файл count-vm.tf. Опишите в нём создание двух **одинаковых** ВМ  web-1 и web-2 (не web-0 и web-1) с минимальными параметрами, используя мета-аргумент **count loop**. Назначьте ВМ созданную в первом задании группу безопасности.(как это сделать узнайте в документации провайдера yandex/compute_instance )  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/5ee22e11-fbb6-4bd5-989f-a23367129732)

2. Создайте файл for_each-vm.tf. Опишите в нём создание двух ВМ с именами "main" и "replica" **разных** по cpu/ram/disk , используя мета-аргумент **for_each loop**. Используйте для обеих ВМ одну общую переменную типа list(object({ vm_name=string, cpu=number, ram=number, disk=number  })). При желании внесите в переменную все возможные параметры.
3. ВМ из пункта 2.2 должны создаваться после создания ВМ из пункта 2.1.
4. Используйте функцию file в local-переменной для считывания ключа ~/.ssh/id_rsa.pub и его последующего использования в блоке metadata, взятому из ДЗ 2.
5. Инициализируйте проект, выполните код.  

##### Ответ:  
```bash
yandex_compute_instance.web[1]: Creation complete after 48s [id=fhmo8njso68mqs8eiq59]
yandex_compute_instance.web[0]: Still creating... [50s elapsed]
yandex_compute_instance.web[0]: Still creating... [1m0s elapsed]
yandex_compute_instance.web[0]: Still creating... [1m10s elapsed]
yandex_compute_instance.web[0]: Creation complete after 1m17s [id=fhm8cs6h7v0v4oa4qbeb]
yandex_compute_instance.dz_2_2["replica"]: Creating...
yandex_compute_instance.dz_2_2["main"]: Creating...
yandex_compute_instance.dz_2_2["main"]: Still creating... [10s elapsed]
yandex_compute_instance.dz_2_2["replica"]: Still creating... [10s elapsed]
yandex_compute_instance.dz_2_2["replica"]: Still creating... [20s elapsed]
yandex_compute_instance.dz_2_2["main"]: Still creating... [20s elapsed]
yandex_compute_instance.dz_2_2["main"]: Still creating... [30s elapsed]
yandex_compute_instance.dz_2_2["replica"]: Still creating... [30s elapsed]
yandex_compute_instance.dz_2_2["main"]: Creation complete after 35s [id=fhmpr9elhn05vncv0qfh]
yandex_compute_instance.dz_2_2["replica"]: Still creating... [40s elapsed]
yandex_compute_instance.dz_2_2["replica"]: Still creating... [50s elapsed]
yandex_compute_instance.dz_2_2["replica"]: Still creating... [1m0s elapsed]
yandex_compute_instance.dz_2_2["replica"]: Creation complete after 1m1s [id=fhmut0dvr5eruqtj589g]

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.
```
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/83e50a65-5025-4f93-a087-d49b438ac1ba)


------

### Задание 3

1. Создайте 3 одинаковых виртуальных диска размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count в файле **disk_vm.tf** .
2. Создайте в том же файле **одиночную**(использовать count или for_each запрещено из-за задания №4) ВМ c именем "storage"  . Используйте блок **dynamic secondary_disk{..}** и мета-аргумент for_each для подключения созданных вами дополнительных дисков.

------

### Задание 4

1. В файле ansible.tf создайте inventory-файл для ansible.
Используйте функцию tepmplatefile и файл-шаблон для создания ansible inventory-файла из лекции.
Готовый код возьмите из демонстрации к лекции [**demonstration2**](https://github.com/netology-code/ter-homeworks/tree/main/03/demonstration2).
Передайте в него в качестве переменных группы виртуальных машин из задания 2.1, 2.2 и 3.2, т. е. 5 ВМ.
2. Инвентарь должен содержать 3 группы [webservers], [databases], [storage] и быть динамическим, т. е. обработать как группу из 2-х ВМ, так и 999 ВМ.
4. Выполните код. Приложите скриншот получившегося файла. 

------




