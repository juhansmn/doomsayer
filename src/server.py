import socket
import threading
import json
import sys
import select
import random

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
start_game_counter = 0
start_case_counter = 0
vote_counter = 0
voted_options = []

server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind(ADDR)
server_message = None
cases_json = None

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

		print(f"[{client.address[0]}] {message_json}")

		if message_json['started_game'] == True:
			global start_game_counter
			start_game_counter += 1

			if start_game_counter == 2:
				server_message["startGame"] = True

				server_message["players"][0]["portraitNumber"] = 1
				server_message["players"][1]["portraitNumber"] = 2

				for c in clients:
					c.connection.sendall(json.dumps(server_message).encode(FORMAT))

		if message_json['started_case'] == True:
			global start_case_counter
			start_case_counter += 1

			if start_case_counter == 2:
				server_message["startCase"] = True
				for c in clients:
					c.connection.sendall(json.dumps(server_message).encode(FORMAT))

				start_case_counter = 0

		if message_json['selected_case_id'] == 0 and message_json['started_case'] == False:
			server_message["players"][message_json['player_id']]["selectedCase"] = message_json['selected_case_id']
			server_message["players"][message_json['player_id']]["selectedCaseTitle"] = cases_json["case"][0]["caseTitle"]
			server_message["players"][message_json['player_id']]["selectedCaseDescription"] = str(cases_json["case"][0]["caseDescription"])

			for i in range(8):
				server_message["situationsDescription"].append(str(cases_json["case"][0]["situations"][i]["description"]))

			client.connection.send(json.dumps(server_message).encode(FORMAT))

		if message_json['selected_case_id'] == 0 and message_json['started_case'] == True and message_json['selected_option'] != 5:
			global vote_counter
			global voted_options

			vote_counter += 1
			voted_options.append(message_json['selected_option'])

			if vote_counter == 2:
				server_message["partnerConfirmed"] = True
				server_message["endCase"] = True

				if voted_options[0] == voted_options[1]:
					server_message["result"] = voted_options[0]
				else:
					server_message["result"] = voted_options[random.randint(0,1)]

				if server_message["result"] == 0:
					server_message["situationID"] = 2
					server_message["selectedCaseEndingID"] = 6

				if server_message["result"] == 1:
					server_message["situationID"] = 3
					server_message["selectedCaseEndingID"] = 6

				if server_message["result"] == 2:
					server_message["situationID"] = 4
					server_message["selectedCaseEndingID"] = 6

				if server_message["result"] == 3:
					server_message["situationID"] = 5
					server_message["selectedCaseEndingID"] = 7

				for c in clients:
					c.connection.sendall(json.dumps(server_message).encode(FORMAT))

				server_message["partnerConfirmed"] = False
				server_message["result"] = 5
				vote_counter = 1

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
	global cases_json

	with open("casesInfo.json", encoding='utf-8') as file:
		cases_json = json.loads(file.read())

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
