# Gruntfile for HTML5 Webapps

Generalized Gruntfile for building static webapps.

#####Focus on:
* Framework & Precompiler agnosticism
* Maximum performance of compiled application
* Minimum latency in (change -> static analysis -> build -> view change) cycle

#####Influenced by:
* [Brunch](http://brunch.io/)
* [Yeoman Webapp Generator](https://github.com/yeoman/generator-webapp)

__Why not just use Yeoman's Generators?__

First, this Gruntfile can totally be used in Yeoman generators, but is sufficiently general for projects that decide not to use Yeoman.  To actually answer the question, I need a polyglot Gruntfile.

__Why not just use brunch?__

Brunch is really cool, but the biggest reason is probably [this](https://github.com/brunch/brunch/issues/401).  And generally I feel Grunt has a larger community (so more plugins) and more flexibility for unanticipated needs.
