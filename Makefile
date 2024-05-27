postgres:
	sudo docker run --name postgres12 --network banknet -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:12-alpine

createdb:
	sudo docker exec -it postgres12 createdb --username=root --owner=root simple_bank

dropdb:
	sudo docker exec -it postgres12 dropdb --username=root --owner=root simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up

migrateup1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose up 1

migratedown:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down

migratedown1:
	migrate -path db/migration -database "postgresql://root:secret@localhost:5432/simple_bank?sslmode=disable" -verbose down 1

sqlc:
	sqlc generate

test:
	go test -v -cover ./...

server:
	go run main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go simplebank/db/sqlc Store

proto:
	rm -f pb/*.go
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
  --go-grpc_out=pb --go-grpc_opt=paths=source_relative \
  proto/*.proto

evans:
	evans --host localhost --port 7070 -r repl

.PHONY: postgres createdb dropdb migratedown migrateup migratedown1 migrateup1 sqlc test server mock proto