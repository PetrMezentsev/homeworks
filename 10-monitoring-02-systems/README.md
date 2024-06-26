# Домашнее задание к занятию "13.Системы мониторинга"

## Обязательные задания

1. Вас пригласили настроить мониторинг на проект. На онбординге вам рассказали, что проект представляет из себя 
платформу для вычислений с выдачей текстовых отчетов, которые сохраняются на диск. Взаимодействие с платформой 
осуществляется по протоколу http. Также вам отметили, что вычисления загружают ЦПУ. Какой минимальный набор метрик вы
выведите в мониторинг и почему?
- Коды состояния HTTP: отслеживание ответов сервера, чтобы обнаруживать ошибки, например, коды состояния 5хх;
- Скорость ответа HTTP: мониторинг времени ответа HTTP-запросов для оценки времени отклика платформы;
- Использование ЦПУ: мониторинг загрузки ЦПУ, мониторинг использования ядер и потоков для сбора информации о распределении нагрузки на ЦПУ, всё вместе это даёт информацию для планирования масштабирования системы в направлении ЦПУ;
- Использование ОЗУ: отслеживание использования ОЗУ для обнаружения неэффективного использования ресурсов;
- Использование дискового пространства: мониторинг заполненности дисков для обеспечения хранения данных, понимания необходимости масштабирования, мониторинг inodes;
- Скорость операций диска: отслеживание скорости операций ввода-вывода (I/O) для оптимизации производительности работы с данными на диске;
- Использование сетевого трафика: отслеживание объема и скорости переданных данных по сети для обнаружения узких мест и оптимизации сетевых соединений;
- Время выполнения вычислений: отслеживание времени выполнения ключевых операций вычислений для контроля производительности и своевременной выдачи отчетов.
#
2. Менеджер продукта посмотрев на ваши метрики сказал, что ему непонятно что такое RAM/inodes/CPUla. Также он сказал, 
что хочет понимать, насколько мы выполняем свои обязанности перед клиентами и какое качество обслуживания. Что вы 
можете ему предложить?
- Можно предложить ему метрики качества обслуживания, в которых будет полезно учесть:
  - Время отклика (Response Time) - среднее время реакции на запросы клиентов или на выполнение конкретных задач. Оценка скорости и эффективности работы системы;
  - Доступность (Availability) - процент времени, когда сервис доступен для клиентов. Отслеживание процента времени, когда сервис был недоступен или не отвечал на запросы;
  - Уровень обслуживания (Service Level Agreement - SLA) - сравнение метрик производительности и доступности с заданными целями и обязательствами по SLA
#
3. Вашей DevOps команде в этом году не выделили финансирование на построение системы сбора логов. Разработчики в свою 
очередь хотят видеть все ошибки, которые выдают их приложения. Какое решение вы можете предпринять в этой ситуации, 
чтобы разработчики получали ошибки приложения?
- Можно использовать несколько различных вариантов решения задачи:
  - Консольный вывод ошибок и проблем с сохранением в файлы и дальнейшей передачей разработчикам с использованием внутреннего инструментария GNU/Linux и применением самописных скриптов;
  - Использование разработчиками отладочных инструментов в средах разработки для идентификации и исправления проблем;
  - Централизованный сбор логов через бесплатные сервисы, например ELK Stack на облачных платформах, некоторые из них предоставляют бесплатные планы с ограничениями по объёму данных;
#
4. Вы, как опытный SRE, сделали мониторинг, куда вывели отображения выполнения SLA=99% по http кодам ответов. 
Вычисляете этот параметр по следующей формуле: summ_2xx_requests/summ_all_requests. Данный параметр не поднимается выше 
70%, но при этом в вашей системе нет кодов ответа 5xx и 4xx. Где у вас ошибка?
- Формула вычисления индекса скорее будет выглядеть следующим образом:
 
  *(summ_2xx_requests + summ_3xx_requests) / summ_all_requests*
#
5. Опишите основные плюсы и минусы pull и push систем мониторинга.

***PULL***
- Плюсы:
  - Pull-системы обычно проще настраивать, так как агент мониторинга на стороне системы мониторинга инициирует запросы к таргетам для получения данных;
  - Меньшая нагрузка на таргеты, так как запросы на данные инициируются системой мониторинга, что позволяет избежать постоянной передачи метрик с таргетов;
- Минусы:
  - Возможна задержка в получении новых данных, так как запросы инициируются системой мониторинга, это может быть особенно критично для быстро меняющихся метрик;
  - Возможные проблемы в сети может вызвать задержки или потерю данных.

***PUSH***
- Плюсы:
  - Точность данных и актуальность - данные постоянно отправляются с таргетов по мере их появления, что позволяет получать актуальную информацию с минимальными задержками;
  - Отказоустойчивость - в случае недоступности системы мониторинга, таргеты могут сохранять метрики у себя в кэше и отправить их позже;
- Минусы:
  - Дополнительная нагрузка на таргеты - агенты, собирающие метрики на таргета, могу отъёдать часть ресурсов системы;
  - Требуется настройка агентов на таргетах;
#
6. Какие из ниже перечисленных систем относятся к push модели, а какие к pull? А может есть гибридные?

    - Prometheus - Pull
    - TICK - Push
    - Zabbix - Push/Pull
    - VictoriaMetrics - Push/Pull
    - Nagios - Pull
#
7. Склонируйте себе [репозиторий](https://github.com/influxdata/sandbox/tree/master) и запустите TICK-стэк, 
используя технологии docker и docker-compose.

В виде решения на это упражнение приведите скриншот веб-интерфейса ПО chronograf (`http://localhost:8888`).   
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/b479f857-e180-4cb6-98b3-dc8d486f10ce)


P.S.: если при запуске некоторые контейнеры будут падать с ошибкой - проставьте им режим `Z`, например
`./data:/var/lib:Z`
#
8. Перейдите в веб-интерфейс Chronograf (http://localhost:8888) и откройте вкладку Data explorer.
        
    - Нажмите на кнопку Add a query
    - Изучите вывод интерфейса и выберите БД telegraf.autogen
    - В `measurments` выберите cpu->host->telegraf-getting-started, а в `fields` выберите usage_system. Внизу появится график утилизации cpu.
    - Вверху вы можете увидеть запрос, аналогичный SQL-синтаксису. Поэкспериментируйте с запросом, попробуйте изменить группировку и интервал наблюдений.

Для выполнения задания приведите скриншот с отображением метрик утилизации cpu из веб-интерфейса.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/7478c81f-d4a7-4aed-8d75-f12e114734d3)  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/a42e2567-b372-495e-ab87-8937a29ade3b)

#
9. Изучите список [telegraf inputs](https://github.com/influxdata/telegraf/tree/master/plugins/inputs). 
Добавьте в конфигурацию telegraf следующий плагин - [docker](https://github.com/influxdata/telegraf/tree/master/plugins/inputs/docker):
```
[[inputs.docker]]
  endpoint = "unix:///var/run/docker.sock"
```

Дополнительно вам может потребоваться донастройка контейнера telegraf в `docker-compose.yml` дополнительного volume и 
режима privileged:
```
  telegraf:
    image: telegraf:1.4.0
    privileged: true
    volumes:
      - ./etc/telegraf.conf:/etc/telegraf/telegraf.conf:Z
      - /var/run/docker.sock:/var/run/docker.sock:Z
    links:
      - influxdb
    ports:
      - "8092:8092/udp"
      - "8094:8094"
      - "8125:8125/udp"
```

После настройке перезапустите telegraf, обновите веб интерфейс и приведите скриншотом список `measurments` в 
веб-интерфейсе базы telegraf.autogen . Там должны появиться метрики, связанные с docker.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/1aa6a731-d5d7-40c9-b073-bb286900ba53)  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/1d55b194-7d40-4080-a531-2c47cb0622a0)




