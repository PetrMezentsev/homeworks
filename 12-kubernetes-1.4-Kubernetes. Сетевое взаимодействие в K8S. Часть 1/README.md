# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 1»

### Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к приложению, установленному в предыдущем ДЗ и состоящему из двух контейнеров, по разным портам в разные контейнеры как внутри кластера, так и снаружи.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/) Deployment и примеры манифестов.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Описание Service.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment и обеспечить доступ к контейнерам приложения по разным портам из другого Pod внутри кластера

1. Создать Deployment приложения, состоящего из двух контейнеров (nginx и multitool), с количеством реплик 3 шт.  
[Deployment](https://github.com/PetrMezentsev/homeworks/blob/main/12-kubernetes-1.4-Kubernetes.%20%D0%A1%D0%B5%D1%82%D0%B5%D0%B2%D0%BE%D0%B5%20%D0%B2%D0%B7%D0%B0%D0%B8%D0%BC%D0%BE%D0%B4%D0%B5%D0%B9%D1%81%D1%82%D0%B2%D0%B8%D0%B5%20%D0%B2%20K8S.%20%D0%A7%D0%B0%D1%81%D1%82%D1%8C%201/manifest/Deployment_1.yaml)  
```bash
user@test:~/1_4$ kubectl get po -o wide 
NAME                   READY   STATUS    RESTARTS   AGE     IP            NODE   NOMINATED NODE   READINESS GATES
app-6f776fc8d8-8cqqx   2/2     Running   0          20m     10.1.27.198   test   <none>           <none>
app-6f776fc8d8-jqkbr   2/2     Running   0          20m     10.1.27.206   test   <none>           <none>
app-6f776fc8d8-jr2f9   2/2     Running   0          20m     10.1.27.202   test   <none>           <none>
```
2. Создать Service, который обеспечит доступ внутри кластера до контейнеров приложения из п.1 по порту 9001 — nginx 80, по 9002 — multitool 8080.  
[Service](https://github.com/PetrMezentsev/homeworks/blob/main/12-kubernetes-1.4-Kubernetes.%20%D0%A1%D0%B5%D1%82%D0%B5%D0%B2%D0%BE%D0%B5%20%D0%B2%D0%B7%D0%B0%D0%B8%D0%BC%D0%BE%D0%B4%D0%B5%D0%B9%D1%81%D1%82%D0%B2%D0%B8%D0%B5%20%D0%B2%20K8S.%20%D0%A7%D0%B0%D1%81%D1%82%D1%8C%201/manifest/Service_1.yaml)  
```bash
user@test:~/1_4$ kubectl get svc -o wide 
NAME          TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)             AGE   SELECTOR
app-service   ClusterIP   10.152.183.50   <none>        9001/TCP,9002/TCP   13m   app=app
```
3. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложения из п.1 по разным портам в разные контейнеры.  
[Pod](https://github.com/PetrMezentsev/homeworks/blob/main/12-kubernetes-1.4-Kubernetes.%20%D0%A1%D0%B5%D1%82%D0%B5%D0%B2%D0%BE%D0%B5%20%D0%B2%D0%B7%D0%B0%D0%B8%D0%BC%D0%BE%D0%B4%D0%B5%D0%B9%D1%81%D1%82%D0%B2%D0%B8%D0%B5%20%D0%B2%20K8S.%20%D0%A7%D0%B0%D1%81%D1%82%D1%8C%201/manifest/Pod_1.yaml)

![изображение](https://github.com/user-attachments/assets/d4471e87-20e1-49eb-86e3-79acadb56def)

5. Продемонстрировать доступ с помощью `curl` по доменному имени сервиса.  
![изображение](https://github.com/user-attachments/assets/af3a1ac9-c5b5-4e95-9cec-1376e1c6974a)


6. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

------

### Задание 2. Создать Service и обеспечить доступ к приложениям снаружи кластера

1. Создать отдельный Service приложения из Задания 1 с возможностью доступа снаружи кластера к nginx, используя тип NodePort.
2. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.
3. Предоставить манифест и Service в решении, а также скриншоты или вывод команды п.2.

------

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
