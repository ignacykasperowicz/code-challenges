var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var _ = require('lodash');
var users = [];

app.get('/', function(req, res){
  res.sendFile(__dirname + '/index.html');
});

var userName = function() {
  return 'user' + Math.floor(1000 + Math.random() * 9000);
};

var findUserBySocketId = function(socket) {
  return _.find(users, function(user) {
    return user.socket == socket;
  });
};

io.on('connection', function(socket){
  users.push({
    name: userName(),
    socket: socket.id
  });

  io.emit('connected',
    {
      users: users,
      user: socket.id
    }
  );

  socket.on('disconnect', function() {
    _.remove(users, {
      socket: socket.id
    });

    io.emit('disconnected',
      {
        users: users
      }
    );
  });

  socket.on('send-private-message', function(data) {
    var user = findUserBySocketId(data.from)
    data['name'] = user.name;
    io.to(data.to).emit('receive-private-message', data);
  });

  socket.on('send-public-message', function(data){
    var user = findUserBySocketId(data.from)
    data['name'] = user.name;
    io.emit('receive-public-message', data);
  });
});

http.listen(3000, function(){
  console.log('listening on *:3000');
});