const express = require('express');
const http = require('http');
const { Server } = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = new Server(server);

app.use(express.static('client'));

io.on('connection', (socket) => {
    console.log('🟢 A player connected! ID:', socket.id);

    socket.on('disconnect', () => {
        console.log('🔴 A player disconnected. ID:', socket.id);
    });
});

const PORT = 3000;
server.listen(PORT, () => {
    console.log(`🚀 Server is running! Open http://localhost:${PORT} in your browser.`);
});