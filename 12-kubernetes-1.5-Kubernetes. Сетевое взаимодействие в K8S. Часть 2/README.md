# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 2»

### Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к двум приложениям снаружи кластера по разным путям.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://microk8s.io/docs/getting-started) по установке MicroK8S.
2. [Описание](https://kubernetes.io/docs/concepts/services-networking/service/) Service.
3. [Описание](https://kubernetes.io/docs/concepts/services-networking/ingress/) Ingress.
4. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment приложений backend и frontend

1. Создать Deployment приложения _frontend_ из образа nginx с количеством реплик 3 шт.
2. Создать Deployment приложения _backend_ из образа multitool.   
```bash
user@test:~/1_5$ kubectl get po
NAME                        READY   STATUS    RESTARTS      AGE
backend-79fd848bb8-fdwvg    1/1     Running   0             7m7s
frontend-69b666bd75-5x5mw   1/1     Running   1 (13m ago)   15m
frontend-69b666bd75-8bbdz   1/1     Running   1 (13m ago)   15m
frontend-69b666bd75-wtzdg   1/1     Running   1 (13m ago)   15m
```
3. Добавить Service, которые обеспечат доступ к обоим приложениям внутри кластера.   
```bash
user@test:~/1_5$ kubectl get svc
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
backend      ClusterIP   10.152.183.152   <none>        8080/TCP   15m
frontend     ClusterIP   10.152.183.184   <none>        80/TCP     16m
```
4. Продемонстрировать, что приложения видят друг друга с помощью Service.  
```bash
user@test:~/1_5$ kubectl exec frontend-69b666bd75-5x5mw -- curl backend:8080
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   140  100   140    0     0   136k      0 --:--:-- --:--:-- --:--:--  136k
WBITT Network MultiTool (with NGINX) - backend-79fd848bb8-fdwvg - 10.1.27.239 - HTTP: 80 , HTTPS: 443 . (Formerly praqma/network-multitool)
```
```bash
user@test:~/1_5$ kubectl exec backend-79fd848bb8-fdwvg -- curl frontend
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   612  100   612    0     0   384k   <!DOCTYPE html>-:--:-- --:--:--     0
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
   0 --:--:-- --:--:-- --:--:--  597k
```
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.  
[Манифесты](https://github.com/PetrMezentsev/homeworks/blob/main/12-kubernetes-1.5-Kubernetes.%20%D0%A1%D0%B5%D1%82%D0%B5%D0%B2%D0%BE%D0%B5%20%D0%B2%D0%B7%D0%B0%D0%B8%D0%BC%D0%BE%D0%B4%D0%B5%D0%B9%D1%81%D1%82%D0%B2%D0%B8%D0%B5%20%D0%B2%20K8S.%20%D0%A7%D0%B0%D1%81%D1%82%D1%8C%202/manifest/task1.yaml)
------

### Задание 2. Создать Ingress и обеспечить доступ к приложениям снаружи кластера

1. Включить Ingress-controller в MicroK8S.  
![изображение](https://github.com/user-attachments/assets/d423f6fe-db72-457e-8cee-200103851a35)

2. Создать Ingress, обеспечивающий доступ снаружи по IP-адресу кластера MicroK8S так, чтобы при запросе только по адресу открывался _frontend_ а при добавлении /api - _backend_.  
3. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.  
![изображение](https://github.com/user-attachments/assets/0b2b9cf4-d4bb-4664-b4b0-06651f1e37ba)  


![изображение](https://github.com/user-attachments/assets/7d7704de-b117-492d-ad12-31f00386ba7b)


4. Предоставить манифесты и скриншоты или вывод команды п.2.
[Манифест](https://github.com/PetrMezentsev/homeworks/blob/main/12-kubernetes-1.5-Kubernetes.%20%D0%A1%D0%B5%D1%82%D0%B5%D0%B2%D0%BE%D0%B5%20%D0%B2%D0%B7%D0%B0%D0%B8%D0%BC%D0%BE%D0%B4%D0%B5%D0%B9%D1%81%D1%82%D0%B2%D0%B8%D0%B5%20%D0%B2%20K8S.%20%D0%A7%D0%B0%D1%81%D1%82%D1%8C%202/manifest/task2.yaml)
------

### Правила приема работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl` и скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------
