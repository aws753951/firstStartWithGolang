postgres:
	docker run --name postgres12 -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres12 dropdb simple_bank

// up的內容寫在 xxx.up.sql內
migrateup:
	migrate -path db -database "postgresql://root:secret@172.30.104.242:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db -database "postgresql://root:secret@172.30.104.242:5432/simple_bank?sslmode=disable" -verbose down

# 這些目標都會在執行時執行指定的操作
.PHONY: postgres createdb dropdb migrateup migratedown