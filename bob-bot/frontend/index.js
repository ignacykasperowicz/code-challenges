var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var _ = require('lodash');
var users = [];

app.get('/', function(req, res){
  res.sendFile(__dirname + '/index.html');
});

var userName = function() {
  return 'user' + Math.floor(Math.random()*9000);
};

io.on('connection', function(socket){
  users.push({name: userName(), socket: socket.id});

  io.emit('connected',
    { users: users, user: socket.id }
  );

  socket.on('disconnect', function() {
    _.remove(users, {
      socket: socket.id
    });

    io.emit('disconnected',
      { users: users }
    );
  });

  socket.on('chat message', function(data){
    var user = _.find(users, function(user) {
      return user.socket == data.socket;
    });
    data['name'] = user.name;
    io.emit('chat message', data);
  });
});

http.listen(3000, function(){
  console.log('listening on *:3000');
});