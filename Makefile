UNAME_S := $(shell uname -a)
ifeq ($(findstring Microsoft,$(UNAME_S)),)
ifeq ($(findstring WSL,$(UNAME_S)),)
    OS_STRING := ubuntu
    EXECUTABLE := ""
else
    OS_STRING := windows
    EXECUTABLE := ".exe"
endif
else
    OS_STRING := windows
    EXECUTABLE := ".exe"
endif

SITE_URL := "https://www.platinumgames.co.jp/dev-bayonetta3/article/311"

.PHONY: all backup

all: Bayonetta3_blogwallpaper_PC.png

backup:
	@$(eval DEST_DIR=$(shell date --iso-8601=ns --utc | sed 's/:/_/g;'))
	mkdir -p "$(DEST_DIR)"
	cd "$(DEST_DIR)" && wget --mirror \
		--convert-links \
		--execute robots=off \
		--level=1 \
		--wait=1 \
		--random-wait \
		"$(SITE_URL)"
	@echo "Create a new backup: $(DEST_DIR)"

Bayonetta3_blogwallpaper_PC.jpg:
	@$(eval DEST_FILE=$(shell find . -name 'Bayonetta3_blogwallpaper_PC.jpg' -exec ls -lt {} + | head -n 1 | awk '{print $$9}'))
	cp "$(DEST_FILE)" "$@"

realesrgan-ncnn-vulkan$(EXECUTABLE):
	wget "https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.5.0/realesrgan-ncnn-vulkan-20220424-$(OS_STRING).zip"
	unzip -o "realesrgan-ncnn-vulkan-20220424-$(OS_STRING).zip"

Bayonetta3_blogwallpaper_PC.png: Bayonetta3_blogwallpaper_PC.jpg realesrgan-ncnn-vulkan$(EXECUTABLE)
	./realesrgan-ncnn-vulkan$(EXECUTABLE) -i "$<" \
		-o "$@" \
		-n realesrgan-x4plus \
		-s 4 \
		-t 0 \
		-x

