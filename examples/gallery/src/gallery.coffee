class Gallery extends WawJS.Brick
  
  # Builds the Gallery brick
  constructor: ->

    # This encapsulates the data model
    @model = new Model

    # Creates a see component
    @see = new See(@model)
  
    # This is the main page, as a View. It will be explicitely
    # refreshed at startup (see wInit)
    @main = new WawJS.View
      render: (v)=> 
        @see.render()

  # This function is called when the application is started.
  wInit: ->
    @main.refresh()
    @see.setMode('edit')

# When the document is ready, we build an app instance and start 
# running it
$(document).ready ->
  $.wApp.ready ->
    $.wRun(new Gallery)
