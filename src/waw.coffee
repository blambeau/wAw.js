exports.Waw = {
	
  run: (app) ->
    @app = app
    @app.winit(this, this, '/')

  fetch: (selector) ->
	  if selector[0] == '/'
      @app.wFetch(selector.substring(1).split('/'), 0)
    else
      @app.wFetch(selector.split('/'), 0)

  get: (selector) ->
    this.fetch(selector).get();

  set: (selector, value) ->
	  this.fetch(selector).set(value);
	
	wid: ->
		''
	
}