#### dbdiagram: 做出schema的好工具

#### Postgresql: docker

```
docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine
# 取得console，並使用root身分
docker exec -it postgres12 psql -U root (可輸入資料庫名稱若有創建的話)
```

> 進入console並不會要求密碼，是因為本地端設置了信任身分驗證

```
select now();     
\q                // 離開
```



#### 使用TablePlus: 連結DB

> DB名稱沒顯示設置，則為USERNAME

```
ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'
```

> 可找到wsl的IP位置

```
ctrl + r 可於吃進設定後重整畫面
ctrl + s 可於刪除table後確認 (需使用cascade刪除所有外來鍵)
```



#### 使用golang-migrate來做資料庫的遷移 (資料庫的結構變更)

```
CLI: https://github.com/golang-migrate/migrate/tree/master/cmd/migrate

migrate create -ext sql -dir db -seq init_schema
```

> -ext 文件的擴展名為.sql
>
> -dir 在哪個資料夾做
>
> -seq 生成連續版本號
>
> 最後則為遷徙的名稱

```
up : 向後更改 down : 往回更改
```



```
migrate -help   // 查詢資料庫driver的名稱

migrate -path db -database "postgresql://root:secret@172.30.104.242:5432/simple_bank?sslmode=disable" -verbose up
```

> sslmode=disable : 預設ssl是不允許的
>
> -verbose : 顯示logging
>
> up : up migrate



#### 進入postgres容器內生成資料庫

```
docker exec -it postgres12 sh

createdb --username=root --owner=root simple_bank   // 創建DB
psql simple_bank  // 進入指定的DB

dropdb simple_bank  // 刪除指定DB

exit 
```



#### 使用Makefile紀錄執行的指令

```
postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

# 這些目標都會在執行時執行指定的操作
.PHONY: postgres createdb dropdb 
```

> make postgres => 可直接執行指令