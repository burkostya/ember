version = `grep -o 'version.*' ../component.json | awk '{split($$0,a,"\""); print a[3];}'`

component:
	@rm -rf ember.js
	@git clone https://github.com/emberjs/ember.js.git
	@cd ember.js && git checkout v$(version)
	@cd ember.js && bundle install && bundle exec rake
	@cp ember.js/dist/ember.js ./index.js
	@rm -rf ember.js
	@sed -i -r '/var imports = Ember\.imports = Ember\.imports \|\| this;/ i \
		Ember.imports = {};\
		Ember.imports.jQuery = require\("jquery"\);\
		Ember.imports.Handlebars = require\("handlebars"\);' index.js
	@sed -i -r 's/exports\.Em = exports\.Ember (= Em = Ember)/\
		module\.exports \1/g' index.js

build: components index.js
	@component build --dev

components: component.json
	@component install --dev

clean:
	rm -fr build components template.js

.PHONY: clean
