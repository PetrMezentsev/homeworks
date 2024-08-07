# Домашнее задание к занятию «Управление доступом»

### Цель задания

В тестовой среде Kubernetes нужно предоставить ограниченный доступ пользователю.

------

### Чеклист готовности к домашнему заданию

1. Установлено k8s-решение, например MicroK8S.
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым github-репозиторием.

------

### Инструменты / дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/reference/access-authn-authz/rbac/) RBAC.
2. [Пользователи и авторизация RBAC в Kubernetes](https://habr.com/ru/company/flant/blog/470503/).
3. [RBAC with Kubernetes in Minikube](https://medium.com/@HoussemDellai/rbac-with-kubernetes-in-minikube-4deed658ea7b).

------

### Задание 1. Создайте конфигурацию для подключения пользователя

1. Создайте и подпишите SSL-сертификат для подключения к кластеру.  
```bash
#Создание закрытого ключа
user@test:~/2_4$ openssl genrsa -out user.key 2048
#Создание запроса на подпись сертификата
user@test:~/2_4$ openssl req -new -key user.key  -out user.csr  -subj "/CN=user/O=group"
#Подпись сертификата
user@test:~/2_4$ openssl x509 -req -in user.csr \
-CA /var/snap/microk8s/7018/certs/ca.crt \
-CAkey /var/snap/microk8s/7018/certs/ca.key \
-CAcreateserial \
-out user.crt -days 365
Certificate request self-signature ok
subject=CN = user, O = group
#Кладём файлы сертификата и ключа в созданную вручную директорию
user@test:~$ ls .certs/
user.crt  user.key
#Устанавливаем креды для нашего пользователя user
user@test:~$ kubectl config set-credentials user \
--client-certificate=/home/user/.certs/user.crt \
--client-key=/home/user/.certs/user.key
User "user" set.
#Создаём контекст для нашего пользователя user
user@test:~$ kubectl config set-context user-context \
--cluster=microk8s-cluster --user=user
Context "user-context" created.
#Просмотр файла кофигурации kubectl
user@test:~$ kubectl config view
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: DATA+OMITTED
    server: https://192.168.75.128:16443
  name: microk8s-cluster
contexts:
- context:
    cluster: microk8s-cluster
    user: admin
  name: microk8s
- context:
    cluster: microk8s-cluster
    user: user
  name: user-context
current-context: microk8s
kind: Config
preferences: {}
users:
- name: admin
  user:
    client-certificate-data: DATA+OMITTED
    client-key-data: DATA+OMITTED
- name: user
  user:
    client-certificate: /home/user/.certs/user.crt
    client-key: /home/user/.certs/user.key
#Применяем роль для пользователя user
user@test:~/2_4$ kubectl apply -f role-for-user.yaml 
role.rbac.authorization.k8s.io/for-user-pod-describe-and-logs created
user@test:~/2_4$ kubectl get roles.rbac.authorization.k8s.io 
NAME                             CREATED AT
for-user-pod-describe-and-logs   2024-08-07T10:39:51Z
#Применяем RoleBinding
user@test:~/2_4$ kubectl apply -f role-binding-for-user.yaml 
rolebinding.rbac.authorization.k8s.io/user-rolebinding created
user@test:~/2_4$ kubectl get rolebindings.rbac.authorization.k8s.io 
NAME               ROLE                                  AGE
user-rolebinding   Role/for-user-pod-describe-and-logs   17s
#Переключаемся на контекст пользователя user
user@test:~/2_4$ kubectl config get-contexts 
CURRENT   NAME           CLUSTER            AUTHINFO   NAMESPACE
*         microk8s       microk8s-cluster   admin      
          user-context   microk8s-cluster   user       
user@test:~/2_4$ kubectl config use-context user-context 
Switched to context "user-context".
user@test:~/2_4$ kubectl config get-contexts 
CURRENT   NAME           CLUSTER            AUTHINFO   NAMESPACE
          microk8s       microk8s-cluster   admin      
*         user-context   microk8s-cluster   user
```


#Проверяем работу describe

![изображение](https://github.com/user-attachments/assets/812d5a2f-f28e-4d42-97e8-ce345e3787df)


#Проверяем работу logs

![изображение](https://github.com/user-attachments/assets/a84231b0-d827-4c73-b743-aebc64f92e75)



2. Настройте конфигурационный файл kubectl для подключения.
3. Создайте роли и все необходимые настройки для пользователя.
4. Предусмотрите права пользователя. Пользователь может просматривать логи подов и их конфигурацию (`kubectl logs pod <pod_id>`, `kubectl describe pod <pod_id>`).
5. Предоставьте манифесты и скриншоты и/или вывод необходимых команд.

------

### Правила приёма работы

1. Домашняя работа оформляется в своём Git-репозитории в файле README.md. Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.
2. Файл README.md должен содержать скриншоты вывода необходимых команд `kubectl`, скриншоты результатов.
3. Репозиторий должен содержать тексты манифестов или ссылки на них в файле README.md.

------

