# Домашнее задание к занятию «Helm»

### Цель задания

В тестовой среде Kubernetes необходимо установить и обновить приложения с помощью Helm.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение, например, MicroK8S.
2. Установленный локальный kubectl.
3. Установленный локальный Helm.
4. Редактор YAML-файлов с подключенным репозиторием GitHub.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://helm.sh/docs/intro/install/) по установке Helm. [Helm completion](https://helm.sh/docs/helm/helm_completion/).

------

### Задание 1. Подготовить Helm-чарт для приложения

1. Необходимо упаковать приложение в чарт для деплоя в разные окружения.   
```bash
user@test:~/2_5$ mkdir app-nginx
user@test:~/2_5$ cd app-nginx/
user@test:~/2_5/app-nginx$ cat Chart.yaml 
apiVersion: v2
name: nginx
description: A Helm chart for deploying Nginx
type: application
version: 1.0.0
appVersion: "1.16.1"
user@test:~/2_5/app-nginx$ cat values.yaml 
replicaCount: 1

image:
  repository: nginx
  tag: 1.16.1
  pullPolicy: IfNotPresent
user@test:~/2_5$ helm install app-nginx ./app-nginx
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /home/user/.kube/config
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /home/user/.kube/config
NAME: app-nginx
LAST DEPLOYED: Fri Aug  9 10:31:24 2024
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
user@test:~/2_5$ helm list --all
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /home/user/.kube/config
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /home/user/.kube/config
NAME     	NAMESPACE	REVISION	UPDATED                                	STATUS  CHART      	APP VERSION
app-nginx	default  	1       	2024-08-09 10:31:24.258621132 +0700 +07	deployednginx-1.0.0	1.16.1

#Меняем версию приложения в конфиг-файлах, обновляемся
user@test:~/2_5$ helm upgrade --install app-nginx ./app-nginx/
user@test:~/2_5$ helm list
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /home/user/.kube/config
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /home/user/.kube/config
NAME     	NAMESPACE	REVISION	UPDATED                                	STATUS  CHART      	APP VERSION
app-nginx	default  	3       	2024-08-09 10:44:02.600657591 +0700 +07	deployednginx-1.0.0	1.17.1

```
2. Каждый компонент приложения деплоится отдельным deployment’ом или statefulset’ом.
3. В переменных чарта измените образ приложения для изменения версии.

------
### Задание 2. Запустить две версии в разных неймспейсах

1. Подготовив чарт, необходимо его проверить. Запуститe несколько копий приложения.
2. Одну версию в namespace=app1, вторую версию в том же неймспейсе, третью версию в namespace=app2.
3. Продемонстрируйте результат.

### Правила приёма работы

1. Домашняя работа оформляется в своём Git репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, `helm`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

