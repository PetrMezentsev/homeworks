## Задание 1

Есть скрипт:

```bash
a=1
b=2
c=a+b
d=$a+$b
e=$(($a+$b))
```

Какие значения переменным c, d, e будут присвоены? Почему?

| Переменная  | Значение | Обоснование |
| ------------- | ------------- | ------------- |
| `c`  | a+b  | `c` - переменная, которая содержит символьную запись `a+b` ![](images/1_1.PNG) |
| `d`  | 1+2  | `d` - переменная, содержащая значения переменных `a` и `b` и символ `+` между ними	![](images/1_2.PNG) |
| `e`  | 3  | `e` - содержит целочисленный результат операции сложения значений переменных `a` и `b`	![](images/1_3.PNG) |

----

## Задание 2

На нашем локальном сервере упал сервис, и мы написали скрипт, который постоянно проверяет его доступность, записывая дату проверок до тех пор, пока сервис не станет доступным. После чего скрипт должен завершиться. 

В скрипте допущена ошибка, из-за которой выполнение не может завершиться, при этом место на жёстком диске постоянно уменьшается. Что необходимо сделать, чтобы его исправить:

```bash
while ((1==1)
do
	curl https://localhost:4757
	if (($? != 0))
	then
		date >> curl.log
	fi
done
```

### Ваш скрипт:

```bash
#!/usr/bin/env bash
while ((1==1))
do
    curl https://localhost:4757
    if (($? != 0))
    then
        date >> curl.log
    else
        break
    fi
done
```

---

## Задание 3

Необходимо написать скрипт, который проверяет доступность трёх IP: `192.168.0.1`, `173.194.222.113`, `87.250.250.242` по `80` порту и записывает результат в файл `log`. Проверять доступность необходимо пять раз для каждого узла.

### Ваш скрипт:

```bash
#!/usr/bin/env bash
hosts_array=("192.168.0.1" "173.194.222.113" "87.250.250.242")
for i in {1..5}
do
  for host in ${hosts_array[@]}
  do
    nc -vzw3 $host 80 > /dev/null 2>&1
    if (($? == 0))
    then
      echo $(date) ' ' $host ' host is available' >> avail.log
    else
      echo $(date) ' ' $host ' host is unavailable' >> avail.log
    fi
  done
  echo -e >> avail.log
done
```

![](images/3.PNG)

---
## Задание 4

Необходимо дописать скрипт из предыдущего задания так, чтобы он выполнялся до тех пор, пока один из узлов не окажется недоступным. Если любой из узлов недоступен — IP этого узла пишется в файл error, скрипт прерывается.

### Ваш скрипт:

```bash
#!/usr/bin/env bash
hosts_array=("173.194.222.113" "87.250.250.242" "192.168.0.1")
while ((1 == 1))
do
  for host in ${hosts_array[@]}
  do
    nc -vzw3 $host 80 > /dev/null 2>&1
    if (($? == 0))
    then
      echo $(date) ' ' $host ' host is available' >> avail.log
    else
      echo $(date) ' ' $host ' host is unavailable' >> error.log
      exit
    fi
  done
  echo -e >> avail.log
done
```
![](images/4.PNG)

---
