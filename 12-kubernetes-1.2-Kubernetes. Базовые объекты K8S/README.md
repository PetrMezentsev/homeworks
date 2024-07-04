# Домашнее задание к занятию «Базовые объекты K8S»

### Цель задания

В тестовой среде для работы с Kubernetes, установленной в предыдущем ДЗ, необходимо развернуть Pod с приложением и подключиться к нему со своего локального компьютера. 

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным Git-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. Описание [Pod](https://kubernetes.io/docs/concepts/workloads/pods/) и примеры манифестов.
2. Описание [Service](https://kubernetes.io/docs/concepts/services-networking/service/).

------

### Задание 1. Создать Pod с именем hello-world

1. Создать манифест (yaml-конфигурацию) Pod.  

[Манифест](https://github.com/PetrMezentsev/homeworks/blob/main/12-kubernetes-1.2-Kubernetes.%20%D0%91%D0%B0%D0%B7%D0%BE%D0%B2%D1%8B%D0%B5%20%D0%BE%D0%B1%D1%8A%D0%B5%D0%BA%D1%82%D1%8B%20K8S/manifest/pod.yaml)
```bash
user@test:~$ cat pod.yaml 
apiVersion: v1
kind: Pod
metadata:
  name: hello-world
spec:
  containers:
  - name: hello-world
    image: gcr.io/kubernetes-e2e-test-images/echoserver:2.2
    ports:
    - containerPort: 8080
```
2. Использовать image - gcr.io/kubernetes-e2e-test-images/echoserver:2.2.  

![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/709602d8-47d1-41bb-9c2e-00a548916f58)

3. Подключиться локально к Pod с помощью `kubectl port-forward` и вывести значение (curl или в браузере).
```bash
user@test:~$ kubectl port-forward pod/hello-world 8080:8080
Forwarding from 127.0.0.1:8080 -> 8080
Forwarding from [::1]:8080 -> 8080
```

```bash
user@test:~$ curl localhost:8080


Hostname: hello-world

Pod Information:
	-no pod information available-

Server values:
	server_version=nginx: 1.12.2 - lua: 10010

Request Information:
	client_address=127.0.0.1
	method=GET
	real path=/
	query=
	request_version=1.1
	request_scheme=http
	request_uri=http://localhost:8080/

Request Headers:
	accept=*/*  
	host=localhost:8080  
	user-agent=curl/7.81.0  

Request Body:
	-no body in request-
```

![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/e63ae4c2-3bd0-43ca-aa54-45dde2dd9bb9)


------

### Задание 2. Создать Service и подключить его к Pod

1. Создать Pod с именем netology-web.  

[Манифест](https://github.com/PetrMezentsev/homeworks/blob/main/12-kubernetes-1.2-Kubernetes.%20%D0%91%D0%B0%D0%B7%D0%BE%D0%B2%D1%8B%D0%B5%20%D0%BE%D0%B1%D1%8A%D0%B5%D0%BA%D1%82%D1%8B%20K8S/manifest/netology-web.yaml)

```bash
user@test:~$ cat netology-web.yaml 
---
apiVersion: v1
kind: Pod
metadata:
  name: netology-web
  labels:
    app: netology-web
spec:
  containers:
  - name: netology-web
    image: gcr.io/kubernetes-e2e-test-images/echoserver:2.2
```
```bash
user@test:~$ kubectl apply -f netology-web.yaml
pod/netology-web created
```
2. Использовать image — gcr.io/kubernetes-e2e-test-images/echoserver:2.2.  
![изображение](https://github.com/PetrMezentsev/homeworks/assets/124135353/e47d30bc-19bc-4310-90d2-73f3774c9cfb)

3. Создать Service с именем netology-svc и подключить к netology-web.  
```bash
user@test:~$ cat netology-svc.yaml 
apiVersion: v1
kind: Service
metadata:
  name: netology-svc
spec:
  selector:
    app: netology-web
  ports:
  - port: 80
    targetPort: 8083
user@test:~$ kubectl apply -f netology-svc.yaml
service/netology-svc created
user@test:~$ kubectl get svc
NAME           TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
kubernetes     ClusterIP   10.152.183.1     <none>        443/TCP   7d1h
netology-svc   ClusterIP   10.152.183.235   <none>        80/TCP    2m49s
```

4. Подключиться локально к Service с помощью `kubectl port-forward` и вывести значение (curl или в браузере).

------

### Правила приёма работы

1. Домашняя работа оформляется в своем Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода команд `kubectl get pods`, а также скриншот результата подключения.
3. Репозиторий должен содержать файлы манифестов и ссылки на них в файле README.md.

------
