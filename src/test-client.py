import socket
import threading

HEADER = 64
PORT = 2350
SERVER = "192.168.0.15"
ADDR = (SERVER, PORT)
FORMAT = 'utf-8'
DISCONNECT_MESSAGE = "!EXIT"

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect(ADDR)

def main():
	thread = threading.Thread(target=read_server, args=())
	thread.start()

	while True:
		message = input("Digite uma mensagem para o servidor: ")
		send(message)

def read_server():
	while True:
		print(f"\n{client.recv(2048).decode(FORMAT)}")

def send(msg):
	message = msg.encode(FORMAT)
	msg_length = len(message)
	send_length = str(msg_length).encode(FORMAT)
	send_length += b' '  * (HEADER - len(send_length))
	client.send(send_length)
	client.send(message)

if __name__ == '__main__':
	main()