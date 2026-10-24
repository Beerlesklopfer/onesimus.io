# Onesimus Website - Build & Deploy
# Hugo static site -> onesimus.io (own server via rsync)
# Adopted from the Makefile of forgeiec-website; credentials are not in this file.
# Copy deploy.env.example to deploy.env (ignored by git) and fill in the values.
# Any variable can also be set on the command line: make deploy DEPLOY_USER=...

-include deploy.env

HUGO        ?= hugo
DEPLOY_HOST ?= onesimus.io
DEPLOY_USER ?=
DEPLOY_PATH ?=
DEPLOY_KEY  ?=
DEPLOY_PORT ?= 22
DEPLOY_IPV4 ?=
DEPLOY_SSH  := $(DEPLOY_USER)@$(DEPLOY_HOST)

SSH_OPTS    := $(if $(DEPLOY_IPV4),-4) -p $(DEPLOY_PORT) -o BatchMode=yes -o IdentitiesOnly=yes $(if $(DEPLOY_KEY),-i $(DEPLOY_KEY))
RSYNC       := rsync -avz --delete -e "ssh $(SSH_OPTS)"

.DEFAULT_GOAL := help
.PHONY: help build serve check deploy-dry deploy clean _need-config

help:
	@echo "Onesimus Website (Hugo) - targets:"
	@echo ""
	@echo "  make help        this help (default)"
	@echo "  make build       build the static site into public/ (minified)"
	@echo "  make serve       local dev server with live reload (127.0.0.1:1313, drafts included)"
	@echo "  make check       build to a temp dir; must print nothing"
	@echo "  make deploy-dry  build + rsync --dry-run: shows what would change, writes nothing"
	@echo "  make deploy      build + rsync to the server"
	@echo "  make clean       remove public/ and resources/_gen/"
	@echo ""
	@echo "Config: deploy.env (see deploy.env.example)"
	@echo "  DEPLOY_HOST  $(DEPLOY_HOST)"
	@echo "  DEPLOY_USER  $(if $(DEPLOY_USER),$(DEPLOY_USER),<not set>)"
	@echo "  DEPLOY_PATH  $(if $(DEPLOY_PATH),$(DEPLOY_PATH),<not set>)"
	@echo "  DEPLOY_KEY   $(if $(DEPLOY_KEY),$(DEPLOY_KEY),<default keys>)"
	@echo "  DEPLOY_PORT  $(DEPLOY_PORT)"
	@echo "  DEPLOY_IPV4  $(if $(DEPLOY_IPV4),yes (ssh -4),no)"

build:
	HUGO_ENV=production $(HUGO) --minify

serve:
	$(HUGO) server -D --bind 127.0.0.1

check:
	$(HUGO) --quiet --minify --destination "$${TMPDIR:-/tmp}/onesimus-website-check"

_need-config:
	@test -n "$(DEPLOY_USER)" -a -n "$(DEPLOY_PATH)" || { echo "set DEPLOY_USER and DEPLOY_PATH in deploy.env (see deploy.env.example)"; exit 1; }
	@case "$(DEPLOY_PATH)" in /*/*) ;; *) echo "DEPLOY_PATH '$(DEPLOY_PATH)' looks unsafe for rsync --delete"; exit 1;; esac

deploy-dry: build _need-config
	$(RSYNC) --dry-run public/ $(DEPLOY_SSH):$(DEPLOY_PATH)

deploy: build _need-config
	@echo "Deploying to $(DEPLOY_SSH):$(DEPLOY_PATH) ..."
	$(RSYNC) public/ $(DEPLOY_SSH):$(DEPLOY_PATH)
	@echo "Deployed to https://$(DEPLOY_HOST)/"

clean:
	rm -rf public/ resources/_gen/
