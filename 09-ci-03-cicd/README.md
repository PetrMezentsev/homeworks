# Домашнее задание к занятию 9 «Процессы CI/CD»

## Подготовка к выполнению

1. Создайте два VM в Yandex Cloud с параметрами: 2CPU 4RAM Centos7 (остальное по минимальным требованиям).  
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
7.  Проверьте готовность Nexus через [бразуер](http://localhost:8081).  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/e22c8fe3-f5c8-4b83-b410-2c02153fccb9)

8. Подключитесь под admin\admin123, поменяйте пароль, сохраните анонимный доступ.

## Знакомоство с SonarQube

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
4. В ответе пришлите файл `maven-metadata.xml` для этого артефекта.

### Знакомство с Maven

### Подготовка к выполнению

1. Скачайте дистрибутив с [maven](https://maven.apache.org/download.cgi).
2. Разархивируйте, сделайте так, чтобы binary был доступен через вызов в shell (или поменяйте переменную PATH, или любой другой, удобный вам способ).
3. Удалите из `apache-maven-<version>/conf/settings.xml` упоминание о правиле, отвергающем HTTP- соединение — раздел mirrors —> id: my-repository-http-unblocker.
4. Проверьте `mvn --version`.
5. Заберите директорию [mvn](./mvn) с pom.

### Основная часть

1. Поменяйте в `pom.xml` блок с зависимостями под ваш артефакт из первого пункта задания для Nexus (java с версией 8_282).
2. Запустите команду `mvn package` в директории с `pom.xml`, ожидайте успешного окончания.
3. Проверьте директорию `~/.m2/repository/`, найдите ваш артефакт.
4. В ответе пришлите исправленный файл `pom.xml`.

---

### Как оформить решение задания

Выполненное домашнее задание пришлите в виде ссылки на .md-файл в вашем репозитории.

---

