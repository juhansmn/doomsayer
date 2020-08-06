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
start_game_counter = 1
start_case_counter = 1

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(ADDR)
server_message = None

#lista de clientes ativos
clients = []

#lida com cada cliente individualmente e de forma simultânea
def handle_client(client):
	global counter
	global server_message

	connected = True

	send_playerConnection(client, True)
	send_playerID(client)

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

		print(f"[{client.address[0]}] {message_json['started_game']}")

		if message_json['started_game'] == True:
			global start_game_counter
			start_game_counter += 1

			if start_game_counter == 2:
				server_message["startGame"] = True
				for c in clients:
					c.connection.sendall(json.dumps(server_message).encode(FORMAT))

		if message_json['selected_case_id'] != null:
			server_message["selectedCase"] = message_json['selected_case_id']
			server_message["selectedCaseTitle"] = ""
			server_message["selectedCaseDescription"] = ""

			client.connection.send(json.dumps(server_message).encode(FORMAT))

		if message_json['started_case'] == True:
			global start_case_counter
			start_case_counter += 1

			if start_case_counter == 2:
				server_message["startCase"] = True
				for c in clients:
					c.connection.sendall(json.dumps(server_message).encode(FORMAT))

	disconnect_client(client)

#lida com servidor cheio (máximo de dois jogadores)
def handle_full_server(client):
	send_playerConnection(client, False)
	disconnect_client(client)

#disconecta o cliente do servidor
def disconnect_client(client):
		print(f"[DESCONECTOU] {client.address} desconectado.")
		client.connection.close()
		clients.remove(client)

def send_playerID(client):
	player_id = {"playerID": len(clients) - 1}
	client.connection.send(json.dumps(player_id).encode(FORMAT))

def send_playerConnection(client, connected):
	with open("connectionMessage.json", encoding='utf-8') as file:
		player_connection = json.loads(file.read())

		if connected:
			player_connection["isConnected"] = True
			player_connection["serverStatusMessage"] = "Você entrou no servidor"
			client.connection.send(json.dumps(player_connection).encode(FORMAT))
		else:
			player_connection["isConnected"] = False
			player_connection["serverStatusMessage"] = "Servidor cheio (máximo de 2 jogadores)"
			client.connection.send(json.dumps(player_connection).encode(FORMAT))

def loadJSONs():
	global server_message

	with open("serverMessage.json", encoding='utf-8') as file:
		server_message = json.loads(file.read())

#direciona cada cliente conectado
def start():
	print(f"[SERVER] {SERVER} iniciou!")
	loadJSONs()
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
