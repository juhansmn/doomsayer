import socket
import threading
import json
import sys
import select

class Client:
	connection = None
	address =  None
	username = None
	player_id = None

	def __init__(self, connection, address):
		self.connection = connection
		self.address = address

PORT = 2350
SERVER = socket.gethostbyname(socket.gethostname())
ADDR = (SERVER, PORT)
HEADER = 64
FORMAT = 'utf-8'
DISCONNECTION_MESSAGE = "!EXIT"
MAX_PLAYERS = 2
counter = 2

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(ADDR)

#lista de clientes ativos
clients = []

#lida com cada cliente individualmente e de forma simultânea
def handle_client(client):
	global counter
	connected = True

	while connected:
		#recebe primeiro o tamanho da mensagem em bytes
		message_header = client.connection.recv(HEADER)

		#se a mensagem for a vazia é porque o cliente se desconectou abruptamente
		if not len(message_header):
			connected = False
			break

		#se o cliente estiver conectado, terá uma mensagem
		message_length = int(message_header.decode(FORMAT))
		message = client.connection.recv(message_length)
		message_json = json.loads(message)

		print(message_length)

		print(f"[{client.address[0]}] {message_json['selected_option']}")
		client.connection.send(json.dumps(message_json).encode(FORMAT))

		#if message_json['selected_option'] == 2:
			#envia JSON para o cliente

		if 	message == DISCONNECTION_MESSAGE:
			connected = False
			break

		elif message == "count":
			counter += 1
			print(counter)

		elif message == "confirm" and counter == 2:
			for c in clients:
				c.connection.sendall("Confirmado.".encode(FORMAT))

	disconnect_client(client)

#lida com servidor cheio (máximo de dois jogadores)
def handle_full_server(client):
	print("[SERVIDOR CHEIO. QUANTIDADE MÁXIMA DE JOGADORES ATINGIDA]")

	client.connection.send("[SERVIDOR CHEIO. QUANTIDADE MÁXIMA DE JOGADORES ATINGIDA]".encode(FORMAT))
	disconnect_client(client)

#disconecta o cliente do servidor
def disconnect_client(client):
		print(f"[DESCONECTOU] {client.address} desconectado.")
		client.connection.close()
		clients.remove(client)

#direciona cada cliente conectado
def start():
	print(f"[SERVER] {SERVER} iniciou!")
	#possibilita conexões
	server.listen()

	while True:
		#cliente se conecta no servidor
		conn, addr = server.accept()
		client = Client(conn, addr)
		clients.append(client)

		print(f"[NOVA CONEXÃO] {client.address} conectado.")

		#se o servidor estiver cheio
		if len(clients) > MAX_PLAYERS:
			thread = threading.Thread(target=handle_full_server, args=(client,))
			thread.start()

		else:
			thread = threading.Thread(target=handle_client, args=(client,))
			thread.start()
			print(f"[CONEXÕES ATIVAS] {threading.activeCount() - 1}")

if __name__ == '__main__':
	start()
