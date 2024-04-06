# Домашнее задание к занятию 11 «Teamcity»

## Подготовка к выполнению

1. В Yandex Cloud создайте новый инстанс (4CPU4RAM) на основе образа `jetbrains/teamcity-server`.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/bf4e8192-c89e-4234-becf-4e129d0a2f4b)




2. Дождитесь запуска teamcity, выполните первоначальную настройку.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/749ed2f7-a4c1-47c1-9f28-79f18b8c5953)


3. Создайте ещё один инстанс (2CPU4RAM) на основе образа `jetbrains/teamcity-agent`. Пропишите к нему переменную окружения `SERVER_URL: "http://<teamcity_url>:8111"`.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/a09b341f-00b8-4849-a2e8-59fb373b519c)

4. Авторизуйте агент.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/4e85a6f6-93ac-4b27-8d20-ec2ecfa697f6)

5. Сделайте fork [репозитория](https://github.com/aragastmatb/example-teamcity).
6. Создайте VM (2CPU4RAM) и запустите [playbook](./infrastructure).  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/8a0cb071-e057-4a5e-ba3d-c61c6db3dc77)


## Основная часть

1. Создайте новый проект в teamcity на основе fork.
2. Сделайте autodetect конфигурации.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/bca62312-a3e0-48d9-9074-87e291d772e8)

3. Сохраните необходимые шаги, запустите первую сборку master.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/a3c61290-414e-475d-831f-4dede7b37c39)
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/d1012c3b-16c5-478d-b04a-5dbbdce7f880)

4. Поменяйте условия сборки: если сборка по ветке `master`, то должен происходит `mvn clean deploy`, иначе `mvn clean test`.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/bbc523c3-3518-42d6-976b-0ba09a1df07c)



5. Для deploy будет необходимо загрузить [settings.xml](./teamcity/settings.xml) в набор конфигураций maven у teamcity, предварительно записав туда креды для подключения к nexus.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/9b3715d5-0852-4a7a-ad03-d6038124e269)
  
6. В pom.xml необходимо поменять ссылки на репозиторий и nexus.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/7ee5fc53-3104-422d-9f47-aa1759b88cd7)

7. Запустите сборку по master, убедитесь, что всё прошло успешно и артефакт появился в nexus.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/78cdb1e5-a3d1-4f91-9de7-a91c6a64b0d6)

8. Мигрируйте `build configuration` в репозиторий.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/3ab32c20-574e-4d74-8f99-ce064ff9b00a)

9. Создайте отдельную ветку `feature/add_reply` в репозитории.
10. Напишите новый метод для класса Welcomer: метод должен возвращать произвольную реплику, содержащую слово `hunter`.
11. Дополните тест для нового метода на поиск слова `hunter` в новой реплике.
12. Сделайте push всех изменений в новую ветку репозитория.
13. Убедитесь, что сборка самостоятельно запустилась, тесты прошли успешно.
14. Внесите изменения из произвольной ветки `feature/add_reply` в `master` через `Merge`.
15. Убедитесь, что нет собранного артефакта в сборке по ветке `master`.
16. Настройте конфигурацию так, чтобы она собирала `.jar` в артефакты сборки.
17. Проведите повторную сборку мастера, убедитесь, что сбора прошла успешно и артефакты собраны.
18. Проверьте, что конфигурация в репозитории содержит все настройки конфигурации из teamcity.
19. В ответе пришлите ссылку на репозиторий.

---
