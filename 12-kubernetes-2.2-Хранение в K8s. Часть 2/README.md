# Домашнее задание к занятию «Хранение в K8s. Часть 2»

### Цель задания

В тестовой среде Kubernetes нужно создать PV и продемострировать запись и хранение файлов.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8S).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключенным GitHub-репозиторием.

------

### Дополнительные материалы для выполнения задания

1. [Инструкция по установке NFS в MicroK8S](https://microk8s.io/docs/nfs). 
2. [Описание Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/). 
3. [Описание динамического провижининга](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/). 
4. [Описание Multitool](https://github.com/wbitt/Network-MultiTool).

------

### Задание 1

**Что нужно сделать**

Создать Deployment приложения, использующего локальный PV, созданный вручную.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Создать PV и PVC для подключения папки на локальной ноде, которая будет использована в поде.
3. Продемонстрировать, что multitool может читать файл, в который busybox пишет каждые пять секунд в общей директории.   
```bash
user@test:~/2_2$ kubectl apply -f data-pv.yaml 
persistentvolume/data-pv created
user@test:~/2_2$ kubectl apply -f data-pvc.yaml 
persistentvolumeclaim/data-pvc created
user@test:~/2_2$ kubectl apply -f local_pv_deployment.yaml 
deployment.apps/local-pv-deployment created
user@test:~/2_2$ kubectl get po
NAME                                   READY   STATUS    RESTARTS   AGE
local-pv-deployment-6868554956-66nvd   2/2     Running   0          24s
local-pv-deployment-6868554956-nnvg2   2/2     Running   0          24s
user@test:~/2_2$ kubectl exec -it local-pv-deployment-6868554956-nnvg2 -c multitool -- bash
local-pv-deployment-6868554956-nnvg2:/# while true; do tail -f /data/test.txt; sleep 3; done
Fri Aug 2 03:48:16 UTC 2024
Fri Aug 2 03:48:16 UTC 2024
Fri Aug 2 03:48:21 UTC 2024
Fri Aug 2 03:48:21 UTC 2024
Fri Aug 2 03:48:26 UTC 2024
Fri Aug 2 03:48:26 UTC 2024
Fri Aug 2 03:48:31 UTC 2024
Fri Aug 2 03:48:31 UTC 2024
Fri Aug 2 03:48:36 UTC 2024
Fri Aug 2 03:48:36 UTC 2024
Fri Aug 2 03:48:41 UTC 2024
Fri Aug 2 03:48:41 UTC 2024
Fri Aug 2 03:48:46 UTC 2024
Fri Aug 2 03:48:46 UTC 2024
Fri Aug 2 03:48:51 UTC 2024
Fri Aug 2 03:48:51 UTC 2024
```
4. Удалить Deployment и PVC. Продемонстрировать, что после этого произошло с PV. Пояснить, почему.  
```bash
user@test:~/2_2$ kubectl delete deployments.apps local-pv-deployment 
deployment.apps "local-pv-deployment" deleted
user@test:~/2_2$ kubectl delete pvc data-pvc 
persistentvolumeclaim "data-pvc" deleted
user@test:~/2_2$ kubectl get deployments.apps 
No resources found in default namespace.
user@test:~/2_2$ kubectl get pvc
No resources found in default namespace.

#Видим, что PV, созданный нами вручную, продолжил существовать в качестве объекта, но у него появился статус Released, так как связь (bound) между PV и PVC (который мы удалили) отсутствует.
user@test:~/2_2$ kubectl get pv
NAME      CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM              STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
data-pv   10Mi       RWO            Retain           Released   default/data-pvc                  <unset>                          13m
```
5. Продемонстрировать, что файл сохранился на локальном диске ноды. Удалить PV.  Продемонстрировать что произошло с файлом после удаления PV. Пояснить, почему.  
```bash
user@test:~/2_2$ ls /mnt/data/test.txt 
/mnt/data/test.txt
user@test:~/2_2$ tail -n 15 /mnt/data/test.txt 
Fri Aug 2 03:55:32 UTC 2024
Fri Aug 2 03:55:37 UTC 2024
Fri Aug 2 03:55:37 UTC 2024
Fri Aug 2 03:55:42 UTC 2024
Fri Aug 2 03:55:42 UTC 2024
Fri Aug 2 03:55:47 UTC 2024
Fri Aug 2 03:55:47 UTC 2024
Fri Aug 2 03:55:52 UTC 2024
Fri Aug 2 03:55:52 UTC 2024
Fri Aug 2 03:55:57 UTC 2024
Fri Aug 2 03:55:57 UTC 2024
Fri Aug 2 03:56:02 UTC 2024
Fri Aug 2 03:56:02 UTC 2024
Fri Aug 2 03:56:07 UTC 2024
Fri Aug 2 03:56:07 UTC 2024

#Видим, что после удаления PV файл остался на файловой системе ноды, потому что по логике работы объекта k8s PersistentVolume  
#в поле persistentVolumeReclaimPolicy установлено значение Retain, указывающее, что нужно сохранять файлы в volume при удалении PV.
user@test:~/2_2$ kubectl delete pv data-pv 
persistentvolume "data-pv" deleted
user@test:~/2_2$ ls /mnt/data/test.txt 
/mnt/data/test.txt
user@test:~/2_2$ tail -n 5 /mnt/data/test.txt 
Fri Aug 2 03:55:57 UTC 2024
Fri Aug 2 03:56:02 UTC 2024
Fri Aug 2 03:56:02 UTC 2024
Fri Aug 2 03:56:07 UTC 2024
Fri Aug 2 03:56:07 UTC 2024
```
6. Предоставить манифесты, а также скриншоты или вывод необходимых команд.
(Manifest)[https://github.com/PetrMezentsev/homeworks/blob/main/12-kubernetes-2.2-%D0%A5%D1%80%D0%B0%D0%BD%D0%B5%D0%BD%D0%B8%D0%B5%20%D0%B2%20K8s.%20%D0%A7%D0%B0%D1%81%D1%82%D1%8C%202/task1.yaml]
------

### Задание 2

**Что нужно сделать**

Создать Deployment приложения, которое может хранить файлы на NFS с динамическим созданием PV.

1. Включить и настроить NFS-сервер на MicroK8S.
2. Создать Deployment приложения состоящего из multitool, и подключить к нему PV, созданный автоматически на сервере NFS.
3. Продемонстрировать возможность чтения и записи файла изнутри пода. 
4. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, а также скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.
