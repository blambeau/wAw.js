exports.Waw = {
	
  run: (app) ->
    @app = app
    app._init()

  fetch: (selector) ->
    cur = @app
    for x in selector.split('/')
      cur = cur.fetch(x)
    cur

  get: (selector) ->
    this.fetch(selector).get();

  set: (selector, value) ->
	  this.fetch(selector).set(value);

}