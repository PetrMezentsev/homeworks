# Домашнее задание к занятию 9 «Процессы CI/CD»

## Подготовка к выполнению

1. Создайте две VM в Yandex Cloud с параметрами: 2CPU 4RAM Centos7 (остальное по минимальным требованиям).  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/f9804780-2b69-4a48-b615-2ef60c8ad38e)


2. Пропишите в [inventory](./infrastructure/inventory/cicd/hosts.yml) [playbook](./infrastructure/site.yml) созданные хосты.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/7d2361f7-a7cc-44fa-bfb2-1493c35213ca)


3. Добавьте в [files](./infrastructure/files/) файл со своим публичным ключом (id_rsa.pub). Если ключ называется иначе — найдите таску в плейбуке, которая использует id_rsa.pub имя, и исправьте на своё.
4. Запустите playbook, ожидайте успешного завершения.  
* Примечание: 11 версия Postgresql не устанавливалась по ссылкам на репозиторий, описанный в подготовленном плэйбуке, поменял в тасках плэйбука версию на 12
```bash
...09-ci-03-cicd/infrastructure$ ansible-playbook -i ./inventory/cicd/hosts.yml site.yml
```

![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/bdde83ed-1658-44c0-961e-03cc3d34b383)


5. Проверьте готовность SonarQube через [браузер](http://localhost:9000).  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/bf0ebd8c-3230-47fd-a6ef-e1a18f1540dd)

6. Зайдите под admin\admin, поменяйте пароль на свой.
7.  Проверьте готовность Nexus через [браузер](http://localhost:8081).  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/e22c8fe3-f5c8-4b83-b410-2c02153fccb9)

8. Подключитесь под admin\admin123, поменяйте пароль, сохраните анонимный доступ.

## Знакомство с SonarQube

### Основная часть

1. Создайте новый проект, название произвольное.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/0746f9d7-9544-4e89-aced-876473528e90)

2. Скачайте пакет sonar-scanner, который вам предлагает скачать SonarQube.  
3. Сделайте так, чтобы binary был доступен через вызов в shell (или поменяйте переменную PATH, или любой другой, удобный вам способ).
4. Проверьте `sonar-scanner --version`.  
```bash
root@LE3:/home/sonar_scanner/sonar-scanner-5.0.1.3006-linux/bin# sonar-scanner --version
INFO: Scanner configuration file: /home/sonar_scanner/sonar-scanner-5.0.1.3006-linux/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: SonarScanner 5.0.1.3006
INFO: Java 17.0.7 Eclipse Adoptium (64-bit)
INFO: Linux 6.5.0-21-generic amd64
```
5. Запустите анализатор против кода из директории [example](./example) с дополнительным ключом `-Dsonar.coverage.exclusions=fail.py`.  
```bash
...09-ci-03-cicd/example# sonar-scanner -Dsonar.projectKey=test_project -Dsonar.sources=. -Dsonar.host.url=http://158.160.50.192:9000 -Dsonar.login=1745ace05a5b0905394fd1cc28db2c6842300acb -Dsonar.coverage.exclusions=fail.py
INFO: Scanner configuration file: /home/sonar_scanner/sonar-scanner-5.0.1.3006-linux/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: SonarScanner 5.0.1.3006
INFO: Java 17.0.7 Eclipse Adoptium (64-bit)
INFO: Linux 6.5.0-21-generic amd64
INFO: User cache: /root/.sonar/cache
INFO: Analyzing on SonarQube server 9.1.0
INFO: Default locale: "ru_RU", source code encoding: "UTF-8" (analysis is platform dependent)
INFO: Load global settings
INFO: Load global settings (done) | time=237ms
...
INFO: Analysis total time: 9.468 s
INFO: ------------------------------------------------------------------------
INFO: EXECUTION SUCCESS
INFO: ------------------------------------------------------------------------
INFO: Total time: 31.364s
INFO: Final Memory: 8M/34M
INFO: ------------------------------------------------------------------------
```
6. Посмотрите результат в интерфейсе.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/924e9d4d-8a63-4012-8721-91b09cbe4435)

7. Исправьте ошибки, которые он выявил, включая warnings.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/de63627e-84f5-4dc1-93d3-7cf71cb8ce0e)
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/b1bbdd22-ea7a-44e4-acf8-27ccaea5309c)  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/2d0494c6-d924-4fa7-9603-919ae872aa27)

8. Запустите анализатор повторно — проверьте, что QG пройдены успешно.  

9. Сделайте скриншот успешного прохождения анализа, приложите к решению ДЗ.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/0fa70cf3-4ad9-4e5a-a31e-c721178a9100)


## Знакомство с Nexus

### Основная часть

1. В репозиторий `maven-public` загрузите артефакт с GAV-параметрами:

 *    groupId: netology;
 *    artifactId: java;
 *    version: 8_282;
 *    classifier: distrib;
 *    type: tar.gz.
   
2. В него же загрузите такой же артефакт, но с version: 8_102.
3. Проверьте, что все файлы загрузились успешно.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/9b946ebb-0a75-45d7-92a1-4d2488d5fac0)

4. В ответе пришлите файл `maven-metadata.xml` для этого артефакта.  
[maven-metadata.xml](https://github.com/PetrMezentsev/homeworks/blob/main/09-ci-03-cicd/nexus/maven-metadata.xml)

### Знакомство с Maven

### Подготовка к выполнению

1. Скачайте дистрибутив с [maven](https://maven.apache.org/download.cgi).
2. Разархивируйте, сделайте так, чтобы binary был доступен через вызов в shell (или поменяйте переменную PATH, или любой другой, удобный вам способ).
3. Удалите из `apache-maven-<version>/conf/settings.xml` упоминание о правиле, отвергающем HTTP- соединение — раздел mirrors —> id: my-repository-http-unblocker.  
После удаления раздела участок файла с настройками будет выглядеть примерно так:
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/478cebd9-1e1a-4e21-ae0e-a37b3a41269b)

5. Проверьте `mvn --version`.  
```bash
user@LE3:~$ mvn --version
Apache Maven 3.9.6 (bc0240f3c744dd6b6ec2920b3cd08dcc295161ae)
Maven home: /home/maven/apache-maven-3.9.6
Java version: 11.0.22, vendor: Ubuntu, runtime: /usr/lib/jvm/java-11-openjdk-amd64
Default locale: ru_RU, platform encoding: UTF-8
OS name: "linux", version: "6.5.0-21-generic", arch: "amd64", family: "unix"
```
5. Заберите директорию [mvn](./mvn) с pom.

### Основная часть

1. Поменяйте в `pom.xml` блок с зависимостями под ваш артефакт из первого пункта задания для Nexus (java с версией 8_282).  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/ad3b21e0-7f55-4efe-9dae-ae633433bea0)

2. Запустите команду `mvn package` в директории с `pom.xml`, ожидайте успешного окончания.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/907889da-d87b-44c4-b232-c971fbb724b4)

3. Проверьте директорию `~/.m2/repository/`, найдите ваш артефакт.  
```bash
ls -lh ~/.m2/repository/netology/java/8_282/
итого 12K
-rw-r--r-- 1 root root   0 апр  2 17:18 java-8_282-distrib.tar.gz
-rw-r--r-- 1 root root  40 апр  2 17:18 java-8_282-distrib.tar.gz.sha1
-rw-r--r-- 1 root root 393 апр  2 17:18 java-8_282.pom.lastUpdated
-rw-r--r-- 1 root root 176 апр  2 17:18 _remote.repositories
```
4. В ответе пришлите исправленный файл `pom.xml`.  
[pom.xml](https://github.com/PetrMezentsev/homeworks/blob/main/09-ci-03-cicd/mvn/pom.xml)

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---

