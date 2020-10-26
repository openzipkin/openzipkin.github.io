source 'https://rubygems.org'

# Use the version of github-pages used by the actual GitHub Pages
# As suggested in http://jekyllrb.com/docs/github-pages/#deploying-jekyll-to-github-pages
require 'json'
require 'open-uri'
versions = JSON.parse(open('https://pages.github.com/versions.json').read)
gem 'github-pages', versions['github-pages']
gem "yaml-lint", "~> 0.0.10"
gem "terminal-table", "~> 1.8"
