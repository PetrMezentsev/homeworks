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
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/d272e75d-d57e-416e-80b6-a3de378a5ba4)


8. Мигрируйте `build configuration` в репозиторий.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/3ab32c20-574e-4d74-8f99-ce064ff9b00a)

9. Создайте отдельную ветку `feature/add_reply` в репозитории.  

10. Напишите новый метод для класса Welcomer: метод должен возвращать произвольную реплику, содержащую слово `hunter`.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/80e4c5e7-75d5-4a9d-9698-21e5e2dcee56)

11. Дополните тест для нового метода на поиск слова `hunter` в новой реплике.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/c46c6f9e-6e26-4022-9cd7-de6f233189cb)

12. Сделайте push всех изменений в новую ветку репозитория.
```bash
git push -f git@github.com:PetrMezentsev/example-teamcity.git
Перечисление объектов: 13, готово.
Подсчет объектов: 100% (13/13), готово.
При сжатии изменений используется до 4 потоков
Сжатие объектов: 100% (4/4), готово.
Запись объектов: 100% (7/7), 521 байт | 521.00 КиБ/с, готово.
Всего 7 (изменений 2), повторно использовано 0 (изменений 0), повторно использовано пакетов 0
remote: Resolving deltas: 100% (2/2), completed with 2 local objects.
To github.com:PetrMezentsev/example-teamcity.git
   ec09af8..e479286  feature/add_reply -> feature/add_reply
```
13. Убедитесь, что сборка самостоятельно запустилась, тесты прошли успешно.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/c927e152-fefa-4ad3-95c8-3023a54ff957)

14. Внесите изменения из произвольной ветки `feature/add_reply` в `master` через `Merge`.  
```bash
git merge feature/add_reply 
Обновление 17a35c7..e479286
Fast-forward
 src/main/java/plaindoll/Welcomer.java     | 3 +++
 src/test/java/plaindoll/WelcomerTest.java | 6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)
```
```bash
git push -f git@github.com:PetrMezentsev/example-teamcity.git
Всего 0 (изменений 0), повторно использовано 0 (изменений 0), повторно использовано пакетов 0
To github.com:PetrMezentsev/example-teamcity.git
 + 92ad55e...e479286 master -> master (forced update)
```
15. Убедитесь, что нет собранного артефакта в сборке по ветке `master`.
16. Настройте конфигурацию так, чтобы она собирала `.jar` в артефакты сборки.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/855cf7ee-3e82-4379-9c15-399514b991e5)

17. Проведите повторную сборку мастера, убедитесь, что сборка прошла успешно и артефакты собраны.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/70d0fdbf-0872-476e-95b0-ba26f389a8c2)
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/edcfdbd5-68b6-4eec-b172-32cfb6a976fd)


18. Проверьте, что конфигурация в репозитории содержит все настройки конфигурации из teamcity.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/5adaa230-f83b-4c2a-999d-ca178a4f83ea)


19. В ответе пришлите ссылку на репозиторий.

![Ссылка на репозиторий](https://github.com/PetrMezentsev/example-teamcity)

---
