import socket

#Socket é ponto final que recebe dado. Para uma comunicação, existem dois pontos finais. Nesse modelo: O Client e o Server

#AF_INET = ipv4
#SOCK_STREAM = tcp
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
#Tupla do IP do servidor e a/o Porta/Port
s.bind((socket.gethostname(), 2300))
#Fila de 5 primeiras requisições quando overload
s.listen(5)

host_name = socket.gethostname()
host_adress = socket.gethostbyname(host_name)
print(host_adress)

while True:
	#Aceita todas as conexões
	clientsocket, address = s.accept()
	print(f"Conexão estabelecida de de {address}")
	clientsocket.send(bytes("Bem-vindo ao servidor!", "utf-8"))
	print(clientsocket.recv(1024))
