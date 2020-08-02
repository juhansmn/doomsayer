import socketio

#cria um servidor Socket.IO
server_io = socketio.AsyncServer(async_mode='aiohttp')

#interface ASGI para servidores assíncronos
app = web.Application()

#sid = socket id associado ao cliente
#envrion = dicionário que contém a informação requisitada

@server_io.event
def connect(sid, environ):
	print('Connect', sid)

@server_io.event
def disconnect(sid):
	print('Disconnect', sid)

@server_io.on('message')
def print_message(sid, message):
	print("Socket ID:", sid)
	print(message)

if __name__ == '__main__':
    socketio.run(app)
