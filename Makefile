##################################################
# project config

resources= \
	   drawables.xml \
	   images/launcher-icon.png \
	   layouts.xml \
	   strings.xml
sources= \
	 Widget.mc DataField.mc
# the first output is the one used by $(make test)
output_names=datafield widget

outputs=$(output_names:%=bin/%.prg)
manifests=$(output_names:%=%.xml)
prerequisites=$(manifests) $(resources:%=resources/%) $(sources:%=source/%)

##################################################
# project config

##################################################
# system-wide config

bin=$(CONNECTIQ_SDK_HOME)/current/bin
developer_key=$(CONNECTIQ_SDK_HOME)/developer_key.der
udev_id=usb-Garmin_FR935_Flash-0:0
device_id=fr935

##################################################
# targets

build: $(outputs)

bin/%.prg: %.jungle $(prerequisites)
	@$(bin)/monkeyc --device $(device_id) --jungles $< --output $@ --private-key $(developer_key)

# TODO test all of them, not only the first one
run: $(outputs)
	@pgrep -x connectiq || $(bin)/connectiq &
	@$(bin)/monkeydo $< $(device_id)

mount:
	@pmount /dev/disk/by-id/$(udev_id)
	@cp -vf /media/disk_by-id_$(udev_id)/GARMIN/APPS/LOGS/CIQ_LOG.YML .

logs:
	@less +%100 CIQ_LOG.YML

deploy: $(outputs)
	@cp -vf $^ /media/disk_by-id_$(udev_id)/GARMIN/APPS/

umount:
	@pumount /dev/disk/by-id/$(udev_id)
