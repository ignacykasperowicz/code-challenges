var app = require('express')();
var http = require('http').Server(app);
var io = require('socket.io')(http);
var users = [];

app.get('/', function(req, res){
  res.sendFile(__dirname + '/index.html');
});

io.on('connection', function(socket){
  users.push(socket.id);

  io.emit('connected',
    { users: users }
  );

  socket.on('disconnect', function() {
    users.splice(users.indexOf(socket.id), 1);
    io.emit('disconnected',
      { users: users }
    );
  });

  socket.on('chat message', function(msg){
    io.emit('chat message', msg);
    console.log(users);
  });
});

http.listen(3000, function(){
  console.log('listening on *:3000');
});