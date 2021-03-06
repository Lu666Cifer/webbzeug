(function() {
  var SaveAction, _base, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  if (window.Webbzeug == null) {
    window.Webbzeug = {};
  }

  if ((_base = window.Webbzeug).Actions == null) {
    _base.Actions = {};
  }

  window.Webbzeug.Actions.Save = SaveAction = (function(_super) {
    __extends(SaveAction, _super);

    function SaveAction() {
      _ref = SaveAction.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    SaveAction.prototype.type = 'save';

    SaveAction.prototype.name = 'Save';

    SaveAction.prototype.availableParameters = function() {
      return {
        id: {
          name: 'ID',
          type: 'integer',
          min: 0,
          max: 50,
          "default": 0,
          scrollPrecision: 1
        }
      };
    };

    SaveAction.prototype.render = function(contexts) {
      SaveAction.__super__.render.call(this);
      if (contexts.length === 0) {
        console.log("A save action needs one input");
        return false;
      }
      this.app.memory[this.getParameter('id')] = contexts[0];
      this.context = contexts[0];
      return this.context;
    };

    SaveAction.prototype.doRender = function(contexts) {
      var context;
      context = this.render(contexts);
      return context;
    };

    SaveAction.prototype.caption = function() {
      return 'Save (' + this.getParameter('id') + ')';
    };

    return SaveAction;

  })(Webbzeug.Action);

}).call(this);
