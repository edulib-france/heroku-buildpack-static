S3_BUCKET ?= scalingo-buildpack-static

.PHONY: build build-scalingo-16 build-scalingo-18 build-scalingo-20 sync

build: build-scalingo-16 build-scalingo-18 build-scalingo-20

build-scalingo-16:
	@docker pull scalingo/scalingo:16-build
	@docker run -v "$(shell pwd)":/buildpack --rm -it -e "STACK=scalingo-16" scalingo/scalingo:16-build /buildpack/scripts/build_ngx_mruby.sh

build-scalingo-18:
	@docker pull scalingo/scalingo:18-build
	@docker run -v "$(shell pwd)":/buildpack --rm -it -e "STACK=scalingo-18" scalingo/scalingo:18-build /buildpack/scripts/build_ngx_mruby.sh

build-scalingo-20:
	@docker pull scalingo/scalingo:20-build
	@docker run -v "$(shell pwd)":/buildpack --rm -it -e "STACK=scalingo-20" scalingo/scalingo:20-build /buildpack/scripts/build_ngx_mruby.sh

sync:
	@echo "Performing dry run of sync to $(S3_BUCKET)..."
	@echo
	@aws s3 sync archives/ s3://$(S3_BUCKET) --dryrun
	@echo
	@read -p "Continue with sync? [y/N]? " answer && [ "$$answer" = "y" ]
	@echo
	@aws s3 sync archives/ s3://$(S3_BUCKET)
