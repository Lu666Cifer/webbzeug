window.Webbzeug ?= {}
window.Webbzeug.App = class App
  gridHeight: 27
  gridWidth:  112 / 3
  classMap: 
    rectangle: Webbzeug.Actions.Rectangle
  constructor: (@canvas) ->
    @context = @canvas.getContext 'experimental-webgl'

    @incrementalIndex = 0
    @actions = []

    @width = @context.canvas.width
    @height = @context.canvas.height

    @handleNavigation()
    @handleWorkspaceKeyboard()

    @watchedActionIndex  = null
    @selectedActionIndex = null

    # every 1000 / 60, =>
    #   @render()

  handleNavigation: ->
    self = this
    $('.navigation li').click (e) ->
      e.preventDefault()

      self.handleWorkspaceClick()

      $(this).parent().find('li').removeClass('active')
      $(this).addClass('active')

      self.selectedActionId = $(this).attr('data-id')
      self.selectedActionName = $(this).text()
      self.selectedActionType = $(this).attr('data-type')

  # When workspace is clicked, create new element
  handleWorkspaceClick: ->
    $('.workspace').mouseenter (e) =>
      if not @selectedElement and @selectedActionId
        el = $('<div>').addClass('action')

        x = e.pageX
        y = e.pageY

        el.text(@selectedActionName).addClass(@selectedActionType).css
          left: x
          top: y

        $('.workspace').append el

        @selectedElement = el

    $('.workspace').mousemove (e) =>
      if @selectedElement
        offsetX = $('.workspace').offset().left
        offsetY = $('.workspace').offset().top

        @selectedElement.css
          left: Math.floor((e.pageX - offsetX) / @gridWidth) * @gridWidth
          top:  Math.floor((e.pageY - offsetY) / @gridHeight) * @gridHeight

    $('.workspace').mousedown (e) =>
      $('.workspace').off('mouseenter mousemove mousedown')
      if @selectedElement
        x = Math.round(@selectedElement.position().left / @gridWidth)
        y = Math.round(@selectedElement.position().top  / @gridHeight)

        if @selectedActionId
          action = new @classMap[@selectedActionId] x, y, @incrementalIndex

          @selectedElement.attr 'data-index': @incrementalIndex
          @incrementalIndex++

          @actions.push action

          element = @selectedElement
          @handleElementClick element
          @selectedElement.click =>
            @handleElementClick element

          @handleElementDrag element

        @selectedElement = null
        @selectedActionId = @selectedActionType = @selectedActionName = null

  handleElementDrag: (element) ->
    $(element).mousedown (e) =>
      editingElement = element

      $('.workspace').mousemove (e) =>
        offsetX = $('.workspace').offset().left
        offsetY = $('.workspace').offset().top

        editingElement.css
          left: Math.floor((e.pageX - offsetX) / @gridWidth) * @gridWidth
          top:  Math.floor((e.pageY - offsetY) / @gridHeight) * @gridHeight

      $(document).mouseup (e) =>
        $('.workspace').off('mousemove')

        action = @actions[editingElement.attr('data-index')]
        action.x = Math.round(editingElement.position().left / @gridWidth)
        action.y = Math.round(editingElement.position().top  / @gridHeight)

  handleWorkspaceKeyboard: ->
    $(document).keydown (e) =>
      if e.keyCode is 32
        e.preventDefault()
        if @selectedActionIndex
          $('.workspace .action').removeClass('watched')
          $('.workspace .action[data-index=' + @selectedActionIndex + ']').addClass('watched')

          @watchedActionIndex = @selectedActionIndex


  handleElementClick: (element) ->
    @selectedActionIndex = element.attr('data-index')

    $('.workspace .action').removeClass('selected')
    $(element).addClass('selected')



  render: ->
    console.log "Existing actions:"
    for action in @actions
      action.render()