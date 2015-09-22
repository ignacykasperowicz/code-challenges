var helpers = new function() {
  this.showPublicMesage = function(data) {
    $('#messages').append($('<li>').text(data.name + ': ' + data.msg));
  };

  this.showPrivateMessage = function(data) {
    $('#messages').append($('<li class="private">').text(data.name + ': ' + data.msg));
  }

  this.showBotMessage = function(data) {
    $('#messages').append($('<li class="bot">').text(data.name + ': ' + data.msg));
  };

  this.showErrorMessage = function(msg) {
    $('#messages').append($('<li class="error">').text(msg));
  };

  this.isBotMessage = function(msg) {
    return msg.indexOf("bot") == 0
  };

  this.isPrivateMessage = function(msg) {
    return msg.indexOf("user") == 0
  };

  this.isPublicMessage = function(msg) {
    return !this.isPrivateMessage(msg) && !this.isBotMessage(msg);
  };

  this.toUserName = function(msg) {
    return _.first(msg.split(' '));
  };

  this.findUserBySocketId = function(socket) {
    return _.find(allUsers, function(user) {
      return user.socket == socket;
    });
  };

  this.findUserByUserName = function(name) {
    return _.find(allUsers, function(user) {
      return user.name == name;
    });
  };

  this.currentUserSocketId = function() {
    return socket.io.engine.id;
  };

  this.trimBotMessage = function(msg) {
    return _.trimLeft(msg.replace('bot', ''));
  };

  this.trimPrivateMessage = function(msg) {
    return _.trimLeft(msg.replace(/user\d{4}/, ''));
  };

  this.refreshUsersList = function(users) {
    $('#users').text('');
    _.each(users, function(user) {
      var activeClass = '';
      if(user.name == helpers.findUserBySocketId(helpers.currentUserSocketId()).name) {
        activeClass = 'active'
      }
      $('#users').append($('<li class="username ' + activeClass + '">').text(user.name));
    });
  };
}

