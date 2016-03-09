# openzipkin.github.io

This repository contains the source code for the Zipkin documentation site
http://zipkin.io. It's the
[organization page](https://help.github.com/articles/user-organization-and-project-pages/)
for [`openzipkin`](https://github.com/openzipkin/), hosted using
[GitHub pages and Jekyll](https://help.github.com/articles/using-jekyll-as-a-static-site-generator-with-github-pages/).
This means that everything on the `master` branch is immediately and
automatically published.

It uses the static site generator [Jekyll](http://jekyllrb.com/). Jekyll is
implemented in [Ruby](https://www.ruby-lang.org/en/).

## Contributing

Improvements to the documentation are more than welcome. This section tries to
get you up to speed on how to run the site locally and make changes. Just like
the documentation, this meta-documentation also welcomes all improvements. If
you can, you should use OSX or Linux; Jekyll is not very well supported on
Windows.

### If you've done this kind of thing before

1. Fork, branch, clone
2. `bundle`
3. `jekyll serve`
4. Make changes, commit, push
5. Open a pull-request

### Preparing your environment

1. **Install Ruby**

   The official documentation at
   https://www.ruby-lang.org/en/documentation/installation/ describes the
   procedure for all major operating systems.
   
1. **System-level dependencies**

   [Nokogiri](http://www.nokogiri.org/), one of the components used by Jekyll,
   requires some system-level libraries to be in place before installation of
   Jekyll can begin. Things should generally work out of the box, but keep in
   mind that if Jekyll installation fails referencing Nokogiri, then the
   [Installing Nokogiri](http://www.nokogiri.org/tutorials/installing_nokogiri.html)
   document most likely has what you need.
   
1. **Clone the repository**

        git clone https://github.com/openzipkin/openzipkin.github.io.git
        
1. **Install Jekyll and friends**

   GitHub quite considerately provides the exact list of packages that are used
   to generate the site on GitHub Pages, which means we can use the exact same
   packages when running the site locally. This minimizes differences between
   what you see locally, and what you'll see in production. [`Gemfile`](Gemfile)
   defines the packages to be installed using the list provided by GitHub (and
   [`Gemfile.lock`](Gemfile.lock) makes sure we all have the same versions
   locally). To install these packages:
   
        cd openzipkin.github.io
        bundle
        
1. **Run the site**

   You're now all set! The following command starts Jekyll, and makes the site
   available at [http://localhost:4000](http://localhost:4000). It'll also pick
   up any changes you make locally, and regenerate the site, so you can review
   your changes live without having to restart Jekyll.
   
        jekyll serve


### Finding your way around the repository

Next up is making some changes to the site. To do that, you'll need to have a
basic understanding of how the repository is structured.

Content for all the pages lives in the [`pages`](pages) directory. This makes it
very clear where you need to look when making changes to the website text; it's
clearly separated from all the scaffolding around the actual content. The only
exception is the home page, [`index.md`](index.md). It's in the root of the
repository for purely technical reasons (GitHub Pages can only serve the root
document from the root of the repository, and doesn't allow running any Jekyll
plugins).

The rest of the repository contains scaffolding; here's a list to give you a
basic idea of what's what:

 * [`_data`](_data) contains lists of things that are rendered into various
   parts of the page. For instance the list of existing tracers is defined here
   in a structured way.
 * [`_includes`](_includes) contains HTML snippets that are shared by some or
   all pages.
 * [`_layouts`](_layouts) contains the basic HTML shared by all pages - and
   references snippets in `_includes`. At the time of writing, all pages use the
   `page` layout, and I don't foresee new layouts becoming actively used.
 * [`_sass`](_sass) contains style-sheets implemented in [`Sass`](http://sass-lang.com/).
 * [`public`](public) contains static content that's directly served to browsers as-is.
 * [`.editorconfig`](.editorconfig) contains
   [EditorConfig](http://editorconfig.org/) configuration that makes sure
   editors supporting EditorConfig format files in this repository in the same
   way (think spaces vs tabs)
 * [`CNAME`](CNAME) tells GitHub pages that this site should be served at
   [http://zipkin.io](http://zipkin.io) instead of
   [http://openzipkin.zipkin.io](http://openzipkin.zipkin.io). For details on
   how, see
   [https://help.github.com/articles/using-a-custom-domain-with-github-pages/](Using
   a custom domain with GitHub Pages)
 * [`Gemfile`](Gemfile) and [`Gemfile.lock`](Gemfile.lock) describe the Ruby
   packages used for building and serving this site; see the documentation of
   [Bundler](http://bundler.io/) for more details.
 * [`_config.yml`](_config.yml) contains configuration options used by Jekyll
   when generating the site.

### Some finer points

There are a few things to keep an eye out for while making changes to the site.

 * For links to work correctly both locally, on forks, and in production, we
   need to include `{{ site.github.url }}` at the beginning of URLs. For
   example, a link to the Quickstart guide looks like this: `{{ site.github.url
   }}/pages/quickstart`. This is expanded by Jekyll to the correct value based
   on where it's running. More documentation is available
   [here](https://jekyllrb.com/docs/github-pages/)
 * A link to each page appears in the side-bar. The links are ordered based on a
   custom value `weight` assigned to each page. By default each page has a
   weight of 100 - the default is defined in `_config.yml`. This can be
   overridden in each page, see [`index.md`](index.md) for an example. Pages
   with lower weight come first in the list. Pages with the same weight are
   sorted however Jekyll sees fit - probably alphabetically.
       * This is implemented by custom logic for in
         [`_includes/sidebar.html`](_includes/sidebar.html). As we add more
         content, we may want to add more structure to the side-bar, and we may
         need to re-think this approach. Worst case, we can manage the side-bar
         contents manually.

### Creating a pull-request

Once you've made your changes, you'll want to create a pull-request, so that the
changes can be merged into the `master` branch of
`openzipkin/openzipkin.github.io`, and so published for the betterment of all.
This section describes the steps for getting there, assuming you've followed the
instructions so far.

1. **Fork this repository**

    Go to
    [openzipkin/openzipkin.github.io](https://github.com/openzipkin/openzipkin.github.io),
    and click the "Fork" button. Or just
    [click here](https://github.com/openzipkin/openzipkin.github.io/fork).
    
1. **Tell git about your fork**

   We're going to call your fork `origin`, and the original `openzipkin`
   repository `upstream`. The following commands tell `git` to make the
   appropriate changes:
   
        git remote rename origin upstream
        git remote add origin git@github.com:$USER/openzipkin.github.io
        git fetch upstream
        
1. **Create a branch, commit and push your changes**

        git checkout -b my-awesome-changes
        git commit -m 'Short, useful description of my changes'
        git push
        
1. **Open a pull-request**

   Open https://github.com/openzipkin/openzipkin.github.io. You should see a bar
   above the list of files that says you've recently pushed to your branch, with
   a green button on the right to open a pull request. Click it; add text to
   text fields and click buttons as appropriate. See
   [https://help.github.com/articles/using-pull-requests/](https://help.github.com/articles/using-pull-requests/)
   for detailed instructions.
   
### Pulling changes
   
When you come back to the project later, you'll want to make sure you have all
the recent changes downloaded before making any further changes. **Note**: the
following commands throw away any and all changes you have locally. If that's
not desired, refer to the documentation of your git client.

```
git checkout master
git fetch upstream
git reset --hard upstream/master
git push
```

You'll also want to make sure you have all the required Ruby packages, at
exactly the required versions:

```
bundle
```

You are now ready to start a new branch and add more awesome to the
documentation.
