# e-coop-api

Minimal Encore.go API starter.

## Run locally

```bash
encore run
```

## API

```bash
curl -X POST http://localhost:4000/tasks \
	-H "Content-Type: application/json" \
	-d '{"title":"First task","description":"from README"}'

curl http://localhost:4000/tasks
```

## Test

```bash
encore test ./...
```