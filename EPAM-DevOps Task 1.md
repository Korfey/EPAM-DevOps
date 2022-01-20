# EPAM-DevOps Task 1
## Задание
>Создать скрипт, который при помощи команд `grep`/`awk`/`ip a`/`ip ro` будет отображать вывод формата
`interfaceName:IPaddress default`
## Код
```bash
#!/bin/bash
for item in `ip a | awk -F " " '/UP/||/inet / {print $2}'`
do
    if [[ $item == *"/"* ]]
    then
        echo $item | awk -F "/" '{ORS=""} {print "\t" "\033[33m" $1}'
        if [[ *"$previous"* == *"`ip ro | grep default | awk '{print $5}'`"* ]]
        then    
            echo "default " | awk '{print "\t" "\033[34m" $0}'
        fi
        echo
        continue
    fi
    echo "$item" | awk '{ORS=""} {print "\033[32m" $0}'
    previous=$item
done
```  
## Разбор кода
Фрагмент кода   
``ip a | awk -F " " '/UP/||/inet / {print $2}'`` передает в цикл 2 наименования интерфейса и 2 ip-адреса, обрабатывая строки, содержащие "*UP*" или "*inet* "  
  
`if [[ $item == *"/"* ]]` проверяет является ли элемент ip-адресом. Если нет, то элемент выводится с помощью `echo "$item" | awk '{ORS=""} {print "\033[32m" $0}'`, где   
- `\033[32m` меняет цвет вывода;   
- `ORS=""` отменяет перевод на новую строку.      

В случе если элемент все-таки ip-адрес, то он выводится через `echo $item | awk -F "/" '{ORS=""} {print "\t" "\033[33m" $1}'`, где   
 `-F "/"` и `$1` позволяют избавиться от маски.    

Если условие   
```if [[ *"$previous"* == *"`ip ro | grep default | awk '{print $5}'`"* ]]```   
возвращает истину, *что происходит если интерфейс, к которому относится этот адрес, есть в списке интерфейсов по-умолчанию*, то справа к полученной строке приписывается **`default`**   
**`echo "default " | awk '{print "\t" "\033[34m" $0}'`.
## Результат  
**<span style="color:green">lo: &emsp;&emsp;&emsp; </span>**
<span style="color:darkorange">127.0.0.1 &emsp; </span>
</br>
**<span style="color:green">enp0s3: &nbsp;&nbsp; </span>**
<span style="color:darkorange">10.0.2.15 &emsp; </span>
**<span style="color:blue">default &emsp; </span>**
