### A Wintersmith tag plugin based on the built-in paginator plugin ###

_ = require "underscore"

module.exports = (env, callback) ->
  ### Tag plugin. Defaults can be overridden in config.json
      e.g. "tag": {"perPage": 10} ###

  paginatorDefaults =
    template: 'index.jade' # template that renders pages
    articles: 'articles' # directory containing contents to paginate
    first: 'index.html' # filename/url for first page
    filename: 'page/%d/index.html' # filename for rest of pages
    perPage: 2 # number of articles per page

  tagDefaults = 
    filename: 'tag/%s/%d/index.html' # => tag/:tagName/:pageNum/index.html


  # assign defaults any option not set in the config file
  options = _.extend {}, paginatorDefaults, env.config.paginator, tagDefaults, env.config.tag

  # a map from a tag to its home page
  tagHomePages = {}

  # all tags in the system
  allTags = []

  # return the home page of a tag
  getTagHome = (tag) -> tagHomePages[tag]

  # return all tags
  getAllTags = () -> allTags

  # return an array of tags in an article 
  getTagsFromArticle = (article) -> 
    if article.metadata.tags then article.metadata.tags.split(/,\s*/) else []

  getArticlesArray = (contents) ->
    articles = []
    for key, value of contents[options.articles]
      articles.push value if value instanceof env.plugins.Page
    return articles

  # parse and store the global set of tags in alltags
  processTags = (contents) ->
    tags = {}
    getArticlesArray(contents).forEach (article) ->
      getTagsFromArticle(article).forEach (tag) ->
        tags[tag] = tag
    allTags = Object.keys(tags)

  # return a list of articles that have tag tagName
  getArticlesByTag = (contents, tagName) ->
    articles = getArticlesArray(contents).sort (a, b) -> b.date - a.date
    return articles.filter (a) -> a.metadata.tags and a.metadata.tags.split(/,\s*/).indexOf(tagName) > -1

  class TagPaginatorPage extends env.plugins.Page
    ### Based on the PaginatorPage class ###

    constructor: (@tagName, @pageNum, @articles) ->

    getFilename: ->
      options.filename.replace('%d', @pageNum)
        .replace '%s', @tagName

    getView: -> (env, locals, contents, templates, callback) ->
      # simple view to pass articles and pagenum to the paginator template
      # note that this function returns a funciton

      # get the pagination template
      template = templates[options.template]
      if not template?
        return callback new Error "unknown paginator template '#{ options.template }'"

      # setup the template context
      ctx = {@articles, @prevPage, @nextPage, @tagName}

      # extend the template context with the enviroment locals
      env.utils.extend ctx, locals

      # finally render the template
      template.render ctx, callback

  # register a generator, 'paginator' here is the content group generated content will belong to
  # i.e. contents._.paginator
  env.registerGenerator 'tagPaginator', (contents, callback) ->

    # find all tags
    tags = processTags contents

    rv = {pages:{}}
    
    # populate pages
    tags.forEach (tag) ->
      articles = getArticlesByTag contents, tag
      numPages = Math.ceil articles.length / options.perPage
      pages = []
      for i in [0...numPages]
        pageArticles = articles.slice i * options.perPage, (i + 1) * options.perPage
        pages.push new TagPaginatorPage tag, i + 1, pageArticles

      # add references to prev/next to each page
      for page, i in pages
        page.prevPage = pages[i - 1]
        page.nextPage = pages[i + 1]

      # create the object that will be merged with the content tree (contents)
      # do _not_ modify the tree directly inside a generator, consider it read-only
      for page in pages
        rv.pages["#{ tag + '-' + page.pageNum }.page"] = page # file extension is arbitrary

      # save url for each tag
      tagHomePages[tag] = pages[0]

    # callback with the generated contents
    callback null, rv

  # add helpers to the environment so we can use it later
  env.helpers.getArticlesByTag = getArticlesByTag
  env.helpers.getAllTags = getAllTags
  env.helpers.getTagHome = getTagHome
  env.helpers.getTagsFromArticle = getTagsFromArticle

  # tell the plugin manager we are done
  callback()
