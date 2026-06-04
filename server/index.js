const express = require('express');
const http = require('http');
const path = require('path');
const { Server } = require('socket.io');

const app = express();
const server = http.createServer(app);
const io = new Server(server, { cors: { origin: '*' } });

const PORT = process.env.PORT || 3000;
const CLIENT_DIR = path.resolve(__dirname, '..', 'client');

app.use(express.static(CLIENT_DIR));
app.get('*', (req, res) => {
    res.sendFile(path.join(CLIENT_DIR, 'index.html'));
});

let gameRooms = {};

io.on('connection', (socket) => {
    console.log(`Player connected: ${socket.id}`);

    socket.on('joinGame', (data) => {
        let roomId = typeof data === 'string' ? data : data.roomId;
        let preferredSide = data.side || 'blue';
        if (!gameRooms[roomId]) {
            gameRooms[roomId] = { players: [] };
        }
        let room = gameRooms[roomId];
        if (room.players.length >= 2) {
            socket.emit('error', 'Room full');
            return;
        }
        // Respect preferred side if available, otherwise take the other
        let side = preferredSide;
        if (room.players.find(p => p.side === side)) {
            side = side === 'blue' ? 'red' : 'blue';
        }
        room.players.push({ id: socket.id, side });
        socket.join(roomId);
        socket.emit('assignedSide', side);
        socket.to(roomId).emit('opponentJoined', side);
        console.log(`${socket.id} joined room ${roomId} as ${side}`);
    });

    socket.on('gameState', (data) => {
        socket.to(data.roomId).emit('remoteState', data.state);
    });

    socket.on('gameEvent', (data) => {
        socket.to(data.roomId).emit('gameEvent', { eventName: data.eventName, payload: data.payload });
    });

    socket.on('disconnect', () => {
        for (let roomId in gameRooms) {
            let room = gameRooms[roomId];
            let idx = room.players.findIndex(p => p.id === socket.id);
            if (idx >= 0) {
                room.players.splice(idx, 1);
                socket.to(roomId).emit('opponentDisconnected');
                if (room.players.length === 0) delete gameRooms[roomId];
                break;
            }
        }
        console.log(`Player disconnected: ${socket.id}`);
    });
});

server.listen(PORT, () => {
    console.log(`Mothership server running on port ${PORT}`);
});
