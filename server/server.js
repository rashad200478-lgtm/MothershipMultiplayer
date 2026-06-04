const express = require('express');
const http = require('http');
const { Server } = require('socket.io');

// 1. Setup Express and the Server
const app = express();
const server = http.createServer(app);
const io = new Server(server);

// 2. Tell the server to host your Phaser game files
// This assumes your game is inside a folder named 'client'
app.use(express.static('../client'));
// 3. The Multiplayer "Ear"
// This listens for players opening the game in their browser
io.on('connection', (socket) => {
    console.log('🟢 A player connected! ID:', socket.id);

    // If they close the browser tab:
    socket.on('disconnect', () => {
        console.log('🔴 A player disconnected. ID:', socket.id);
    });
});

// 4. Turn the server on!
const PORT = 3000;
server.listen(PORT, () => {
    console.log(`🚀 Server is running! Open http://localhost:${PORT} in your browser.`);
});