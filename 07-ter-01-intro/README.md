# Домашнее задание к занятию «Введение в Terraform»

### Чеклист готовности к домашнему заданию

1. Скачайте и установите актуальную версию **terraform** >=1.4.X . Приложите скриншот вывода команды ```terraform --version```.

![](images/0.1.PNG)

2. Скачайте на свой ПК данный git репозиторий. Исходный код для выполнения задания расположен в директории **01/src**.
3. Убедитесь, что в вашей ОС установлен docker.

```powershell
PS D:\> docker --version
Docker version 24.0.2, build cb74dfc
```
 
4. Зарегистрируйте аккаунт на сайте https://hub.docker.com/, выполните команду docker login и введите логин/пароль.

```powershell
PS D:\> docker login
Authenticating with existing credentials...
Login Succeeded

Logging in with your password grants your terminal complete access to your account.
For better security, log in with a limited-privilege personal access token. Learn more at https://docs.docker.com/go/access-tokens/
```

------

### Задание 1

1. Перейдите в каталог [**src**](https://github.com/netology-code/ter-homeworks/tree/main/01/src). Скачайте все необходимые зависимости, использованные в проекте.

##### Ответ:
![](images/1.1.PNG)   


2. Изучите файл **.gitignore**. В каком terraform файле согласно этому .gitignore допустимо сохранить личную, секретную информацию?

##### Ответ:
Файл `personal.auto.tfvars` может быть использован для хранения переменных, содержащих конфиденциальные данные, такие как пароли, ключи API или другую информацию, которой вы не хотите делиться или сохранять в репозитории Git. Кроме того в файлах `.tfstate` по умолчанию хранится секретная информация, не предназначенная для широкого круга лиц.

3. Выполните код проекта. Найдите  в State-файле секретное содержимое созданного ресурса **random_password**, пришлите в качестве ответа конкретный ключ и его значение.

##### Ответ:
```terraform
"result": "sCwL9g2NSMvpAu7r"
```

4. Раскомментируйте блок кода, примерно расположенный на строчках 29-42 файла **main.tf**. Выполните команду ```terraform validate```. Объясните в чем заключаются намеренно допущенные ошибки? Исправьте их.

##### Ответ:
`Invalid resource name` - Наименование должно начинаться с буквы или нижнего подчёркивания и может содержать буквы, цифры и нижние подчёркивания. Для исправления ошибки удаляем `1` из значения `1nginx`;  
`Reference to undeclared resource` - Ссылка на необъявленный ресурс. Ресурс `"docker_image" "nginx"` не был объявлен в нашем модуле. Для исправления ошибки раскомментируем многострочный комментарий примерно со строк 23-28;  
`Missing name for resource` - Отсутствует имя для ресурса `"docker_image"`. Приводим строку к виду `resource "docker_image" "nginx"{`;  
`Reference to undeclared resource` - Ссылка на необъявленный ресурс. Удаляем случайно попавшие символы `_FAKE` и приводим строку к виду `name  = "example_${random_password.random_string.resulT}"`;  
`Unsupported attribute` - Неподдерживаемый атрибут. Terraform не нашёл аргументов или атрибутов с именем `"resulT"`. Система подозревает, что допущена опечатка и предлагает нам вариант `"result"`.

5. Выполните код. В качестве ответа приложите вывод команды ```docker ps```

```powershell
PS D:\ter\01\src> docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                  NAMES
abf96c1883cd   021283c8eb95   "/docker-entrypoint.…"   3 minutes ago   Up 3 minutes   0.0.0.0:8000->80/tcp   example_sCwL9g2NSMvpAu7r
```

6. Замените имя docker-контейнера в блоке кода на ```hello_world```, выполните команду ```terraform apply -auto-approve```. Объясните своими словами, в чем может быть опасность применения ключа  ```-auto-approve``` ? В качестве ответа дополнительно приложите вывод команды ```docker ps```

##### Ответ:  
Ключ `-auto-approve` применяет все изменения без ожидания подтверждения от пользователя в виде `yes`. Мы получаем применение потенциально некорректного плана без возможности его изучения и внесения корректировок. Так как все могут ошибаться, то произойдёт как минимум потеря времени на возвращение инфраструктуры к нужному виду.

```powershell
PS D:\ter\01\src> docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED              STATUS              PORTS                  NAMES
90c4414fc2ce   021283c8eb95   "/docker-entrypoint.…"   About a minute ago   Up About a minute   0.0.0.0:8000->80/tcp   hello_world
```

7. Уничтожьте созданные ресурсы с помощью **terraform**. Убедитесь, что все ресурсы удалены. Приложите содержимое файла **terraform.tfstate**.

```terraform
{
  "version": 4,
  "terraform_version": "1.5.3",
  "serial": 12,
  "lineage": "fec9224d-734e-2993-3604-b811fd1b5962",
  "outputs": {},
  "resources": [],
  "check_results": null
}
```

8. Объясните, почему при этом не был удален docker образ **nginx:latest** ? Ответ подкрепите выдержкой из документации провайдера.

##### Ответ: 
В файле `main.tf` мы использовали аргумент `keep_locally = true` в ресурсе `"docker_image" "nginx"`. Это логическое значение определяет, оставлять ли локально скачанные образы при разрушении инфраструктуры.

```txt
keep_locally - (Optional, boolean) If true, then the Docker image won't be deleted on destroy operation. If this is false, it will delete the image from the docker local storage on destroy operation.
```
------
