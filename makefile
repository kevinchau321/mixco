#
#  File:       makefile
#  Author:     Juan Pedro Bolívar Puente <raskolnikov@es.gnu.org>
#  Date:       Mon May 20 15:27:56 2013
#
#  Generates proper Mixxx script configuration files from smart
#  smart CoffeeScript file.
#

NODE_BIN   = node_modules/.bin

NODEJS     = node
COFFEE     = $(NODE_BIN)/coffee
BROWSERIFY = $(NODE_BIN)/browserify
DOCCO      = $(NODE_BIN)/docco
MOCHA      = $(NODE_BIN)/_mocha
ISTANBUL   = $(NODE_BIN)/istanbul

SCRIPTS    = \
	out/korg_nanokontrol2.js out/korg_nanokontrol2.midi.xml \
	out/maudio_xponent.js    out/maudio_xponent.midi.xml \
	out/novation_twitch.js   out/novation_twitch.midi.xml

FRAMEWORK  = \
	lib/behaviour.js \
	lib/cli.js \
	lib/console.js \
	lib/control.js \
	lib/index.js \
	lib/script.js \
	lib/transform.js \
	lib/util.js \
	lib/value.js

DOCS       = \
	doc/index.html \
	doc/src/behaviour.html \
	doc/src/cli.html \
	doc/src/control.html \
	doc/src/console.html \
	doc/src/index.html \
	doc/src/script.html \
	doc/src/transform.html \
	doc/src/util.html \
	doc/src/value.html \
	doc/script/korg_nanokontrol2.html \
	doc/script/maudio_xponent.html \
	doc/script/novation_twitch.html \
	doc/spec/mixco/behaviour.spec.html \
	doc/spec/mixco/control.spec.html \
	doc/spec/mixco/script.spec.html \
	doc/spec/mixco/value.spec.html \
	doc/spec/mock.html \
	doc/spec/scripts.spec.html

framework: $(FRAMEWORK)

scripts: $(SCRIPTS)

doc: $(DOCS)
	cp -r ./pic ./doc/

.SECONDARY:
.PHONY: test

lib/%.js: src/%.litcoffee
	@mkdir -p $(@D)
	$(COFFEE) -c -p $< > $@
lib/%.js: src/%.coffee
	@mkdir -p $(@D)
	$(COFFEE) -c -p $< > $@
lib/%.js: src/%.js
	@mkdir -p $(@D)
	cp -f $< $@

tmp/%.js: script/%.litcoffee
	@mkdir -p $(@D)
	$(COFFEE) -c -p $< > $@
tmp/%.js: script/%.coffee
	@mkdir -p $(@D)
	$(COFFEE) -c -p $< > $@
tmp/%.js: script/%.js
	@mkdir -p $(@D)
	cp -f $< $@

out/%.js: tmp/%.js $(FRAMEWORK)
	@mkdir -p $(@D)
	$(BROWSERIFY) -r ./$< $< > $@
	echo ";$*=require('./$<').$*" >> $@

out/%.midi.xml: script/%.litcoffee $(FRAMEWORK)
	@mkdir -p $(@D)
	$(COFFEE) $< -g > $@
out/%.midi.xml: script/%.coffee $(FRAMEWORK)
	@mkdir -p $(@D)
	$(COFFEE) $< -g > $@
out/%.midi.xml: script/%.js $(FRAMEWORK)
	@mkdir -p $(@D)
	$(NODEJS) $< -g > $@

doc/index.html: README.md
	@mkdir -p $(@D)
	$(DOCCO) -t docco/docco.jst -c docco/docco.css  -o $(@D) $<
	mv $(@D)/README.html $@
	cp -rf docco/public $(@D)

doc/%.html: %.litcoffee
	@mkdir -p $(@D)
	$(DOCCO) -t docco/docco.jst -c docco/docco.css -o $(@D) $<
	cp -rf docco/public $(@D)
doc/%.html: %.coffee
	@mkdir -p $(@D)
	$(DOCCO) -t docco/docco.jst -c docco/docco.css -o $(@D) $<
	cp -rf docco/public $(@D)
doc/%.html: %.js
	@mkdir -p $(@D)
	$(DOCCO) -t docco/docco.jst -c docco/docco.css -o $(@D) $<
	cp -rf docco/public $(@D)

clean:
	rm -rf ./doc
	rm -rf ./out
	rm -rf ./tmp
	rm -rf ./lib
	find . -name "*~" -exec rm -f {} \;

test:
	$(MOCHA) \
		--recursive --compilers coffee:coffee-script/register

test-coverage:
	$(ISTANBUL) cover $(MOCHA) -- \
		--recursive --compilers coffee:coffee-script/register \
		--require coffee-coverage/register-istanbul
	$(ISTANBUL) report text lcov

upload-doc: doc
	ncftpput -R -m -u u48595320 sinusoid.es /mixco doc/*
