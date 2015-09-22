var socket = io();
var allUsers;
var ws;

var setupEvents = function() {
  $('#users').on('click', 'li.username', function() {
    $('#m').val($(this).text() + ' ');
    $('#m').focus();
  });
}

var setupBot = function() {
  ws = new WebSocket("ws://localhost:8080");
  ws.onmessage = function(message) {
    helpers.showBotMessage({
      name: 'bob-bot',
      msg: message.data
    });
  };
}

var setupSockets = function() {
  socket.on('receive-private-message', function(data) {
    helpers.showPrivateMessage(data);
  });

  socket.on('receive-public-message', function(data) {
    helpers.showPublicMesage(data);
  });

  socket.on('connected', function(users) {
    allUsers = users.users;
    helpers.refreshUsersList(users.users);
  });

  socket.on('disconnected', function(users) {
    helpers.refreshUsersList(users.users);
  });
}

setupEvents();
setupBot();
setupSockets();

$('form').submit(function() {
  var msg = $('#m').val();

  if( helpers.isBotMessage(msg) ) {
    ws.send( helpers.trimBotMessage(msg) );
  }

  if( helpers.isPrivateMessage(msg) ) {
    var toUser = helpers.findUserByUserName( helpers.toUserName( msg ) );
    if( toUser ) {
      if( toUser.socket != helpers.currentUserSocketId() ) {
        socket.emit('send-private-message', {
          from: helpers.currentUserSocketId(),
          to: toUser.socket,
          msg: helpers.trimPrivateMessage(msg)
        });
      } else {
        helpers.showErrorMessage('You cannot send private message to yourself.');
      }
    } else {
      helpers.showErrorMessage('User ' + helpers.toUserName(msg) + ' does not exists.');
    }
  }

  if( helpers.isPublicMessage(msg) ) {
    socket.emit('send-public-message', {
      from: helpers.currentUserSocketId(),
      msg: msg
    });
  }

  $('#m').val('');

  return false;
});

