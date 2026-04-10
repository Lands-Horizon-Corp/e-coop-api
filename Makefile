# Variables
APP_NAME   = e-coop-api
ENCORE_GO  = $(HOME)/.encore/encore-go/bin
GO_VERSION = 1.26.1

.PHONY: run clean help

run:
	@echo "🚀 Aligning $(APP_NAME) with Encore Go toolchain ($(GO_VERSION))..."
	@# Updates go.mod to match the supported Encore Go version
	@sed -i 's/^go [0-9.]*/go $(GO_VERSION)/' go.mod
	-@pkill -9 encore 2>/dev/null || true
	@PATH="$(ENCORE_GO):$(PATH)" encore run
	
clean:
	@echo "🧹 Cleaning build cache..."
	@rm -rf ~/.cache/encore-build
	-@pkill -9 encore 2>/dev/null || true
	@echo "✅ Cleaned."


help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@sed -n 's/^##//p' Makefile | column -t -s ':' |  sed -e 's/^/ /'