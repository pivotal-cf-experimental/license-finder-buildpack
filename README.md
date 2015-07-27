# NOT FOR PRODUCTION USE


# Building

```sh
rm -Rf vendor/cache vendor/bundle
bundle package --all

docker run -it -w `pwd`:/buildpack -w /buildpack cloudfoundry:cflinuxfs2 bash
export GEM_HOME=`ruby -e "require 'rbconfig';print \"vendor/bundle/#{RUBY_ENGINE}/#{RbConfig::CONFIG['ruby_version']}\""`
export GEM_PATH=`ruby -e "require 'rbconfig';print \"vendor/bundle/#{RUBY_ENGINE}/#{RbConfig::CONFIG['ruby_version']}\""`
gem install vendor/cache/*.gem --no-rdoc --no-ri
```

# Usage


