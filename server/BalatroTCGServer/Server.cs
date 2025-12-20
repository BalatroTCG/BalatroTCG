using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Runtime.Remoting;
using System.Net.Sockets;
using System.Net;

namespace BalatroTCGServer {
	internal class Server {

		TcpListener serverClient;

		List<Client> connectedInstances;
		Dictionary<string, Lobby> lobbies;


		public void Start() {
			serverClient = new TcpListener(IPAddress.Any, 8788);

			serverClient.Start();
			serverClient.Server.NoDelay = true;

			connectedInstances = new List<Client>();
			lobbies = new Dictionary<string, Lobby>();

			new Thread(ReaderThread).Start();

			var t = new Timer(Loop!, null, 0, 2000);
		}

		void ReaderThread() {

			while (true) {
				if (serverClient.Pending()) {
					var newClient = new Client(this, serverClient.AcceptSocket());
					newClient.OnReceive += Socket_OnReceive;
					connectedInstances.Add(newClient);
				}
				else {
					for (int i = connectedInstances.Count - 1; i >= 0; i--) {
						if (!connectedInstances[i].Connected) {
							connectedInstances.RemoveAt(i);
						}
					}
					List<string> removeLobbies = new List<string>();
					foreach (var lobby in lobbies) {
						if (lobby.Value.PlayerCount <= 0) {
							lobby.Value.EmptyTime++;
							if (lobby.Value.EmptyTime > 2000) {
								removeLobbies.Add(lobby.Key);
							}
						}
					}
					foreach (var key in removeLobbies) {
						lobbies.Remove(key);
					}
					Thread.Sleep(10);
				}
			}
		}

		private void Socket_OnReceive(Client client, JObject data) {
			string action = (string)data["action"]!;

			switch (action) {
				case "createLobby": {
					Lobby lobby = new Lobby((string)data["gameMode"]);
					lobbies.Add(lobby.LobbyCode, lobby);
					lobby.AddClient(client);
					break;
				}
				case "joinLobby": {
					Lobby lobby;
					if (!lobbies.TryGetValue((string)data["code"], out lobby)) {
						client.Send(("action", "error"), ("message", "Lobby does not exist."));
					}
					else if (lobby.PlayerCount >= 2) {
						client.Send(("action", "error"), ("message", "Lobby is full."));
					}
					else {
						lobby.AddClient(client);
					}
					break;
				}
				default:
					break;
			}
		}

		void Loop(object obj) {

		}

	}
	class JsonSocket {
		Socket socket;
		
		byte[] receiveBuffer;

		int connectionTries, connectionDelay;

		object queueLock = new object();
		Queue<string> dataQueue;

		StringBuilder inputData = new StringBuilder();

		public event Action<JObject> OnReceive;

		Task taskRead, taskConnect, taskSend;

		public bool Connected { get; private set; }

		public JsonSocket(Socket socket) {
			this.socket = socket;
			receiveBuffer = new byte[4096];
			socket.SendBufferSize = receiveBuffer.Length;
			socket.ReceiveBufferSize = receiveBuffer.Length;

			Connected = true;

			dataQueue = new Queue<string>();

			taskRead = Task.Factory.StartNew(ReadTask);
			taskConnect = Task.Factory.StartNew(ConnectionTask);
			taskSend = Task.Factory.StartNew(SendTask);

			SendPacket(("action", "connected"));
			SendPacket(("action", "version"));
		}

		async Task ReadTask() {
			while (Connected) {
				await socket.ReceiveAsync(receiveBuffer);
				connectionDelay = 0;
				connectionTries = 0;

				try {

					for (int i = 0; i < receiveBuffer.Length; i++) {
						if (receiveBuffer[i] == 10) {

							if (inputData.ToString() == "ce_cache") {
								inputData.Clear();
								break;
							}

							JObject obj = JsonConvert.DeserializeObject<JObject>(inputData.ToString());

							if (obj["action"] != null) {
								string action = (string)obj["action"];

								switch (action) {
									default:
										OnReceive?.Invoke(obj);
										Console.WriteLine($"Recieved {obj["action"]!}");
										break;
									case "keepAlive":
										SendPacket(("action", "keepAliveAck"));
										break;
									case "keepAliveAck":
										break;
								}
							}

							inputData.Clear();
							break;
						}
						else {
							inputData.Append((char)receiveBuffer[i]);
						}
					}
				}
				catch (Exception e) {
					Console.WriteLine($"Error reading input {e}");
					Console.WriteLine($"{inputData}");
					inputData.Clear();
				}
			}
		}
		void ConnectionTask() {
			
			while (Connected) {
				connectionDelay++;
				if (connectionDelay >= 400) {
					connectionDelay = 0;
					if (connectionTries > 5) {
						Disconnect();
					}
					else {
						SendPacket(("action", "keepAlive"));
						connectionTries++;
					}

				}
				Thread.Sleep(10);
			}
		}
		void SendTask() {
			while (Connected) {
				string data = null!;
				lock (queueLock) {
					if (dataQueue.Count > 0) {
						data = dataQueue.Dequeue();
					}
				}
				if (data != null) {

					byte[] fullData = Encoding.UTF8.GetBytes(data + (char)10);

					JObject j = JsonConvert.DeserializeObject<JObject>(data);
					
					if (j["action"].ToString() != "keepAlive" && j["action"].ToString() != "keepAliveAck")
						Console.WriteLine($"Sending {data} at {fullData.Length + 1}");

					List<ArraySegment<byte>> segments = new List<ArraySegment<byte>>();

					segments.Add(new ArraySegment<byte>(fullData, 0, fullData.Length));
					socket.Send(segments);

				}
				Thread.Sleep(5);
			}

			socket.Disconnect(true);
		}

		public void SendPacket(params (string, object)[] data) {

			StringBuilder builder = new StringBuilder();


			foreach (var item in data) {
				if (builder.Length > 0)
					builder.Append(',');
				else
					builder.Append('{');
				string value = item.Item2.ToString();
				if (item.Item2 is bool) {
					value = value.ToLower();
				}
				builder.Append($"\"{item.Item1}\":\"{value}\"");
			}

			builder.Append('}');

			lock (queueLock) {
				dataQueue.Enqueue(builder.ToString());
			}
		}
		public void SendPacket(JObject data) {

			StringBuilder builder = new StringBuilder();

			foreach (var item in data) {
				if (builder.Length > 0)
					builder.Append(',');
				else
					builder.Append('{');
				string value = item.Value.ToString();
				builder.Append($"\"{item.Key}\":\"{value}\"");
			}
			builder.Append('}');

			lock (queueLock) {
				dataQueue.Enqueue(builder.ToString());
			}
		}

		public void Disconnect() {
			Connected = false;
		}
	}
	internal class Client {

		public string UserName { get; private set; }
		public string[] Mods { get; private set; }
		public string ModHash { get; private set; }
		public string Version { get; private set; }

		public bool Cached { get; private set; }

		public bool Ready { get; set; }

		public bool Connected => Socket.Connected;

		public JsonSocket Socket { get; private set; }

		public Lobby Lobby;

		public Client(Server parent, Socket socket) {
			Socket = new JsonSocket(socket);
			Socket.OnReceive += Receieve;
			Cached = true;
		}


		public event Action<Client, JObject> OnReceive;

		private void Receieve(JObject data) {

			string action = (string)data["action"]!;

			switch (action) {
				case "username":
					UserName = (string)data["username"];
					SetMods((string)data["modHash"]);
					break;
				case "version":
					Version = (string)data["version"];
					break;
				case "readyLobby":
					Ready = true;
					Lobby?.BroadcastInfo();
					break;
				case "unreadyLobby":
					Ready = false;
					Lobby?.BroadcastInfo();
					break;
				case "syncClient":
					Cached = bool.Parse((string)data["isCached"]);
					break;
				default:
					OnReceive?.Invoke(this, data);
					break;
			}
		}

		void SetMods(string hash) {
			ModHash = hash;
			Mods = hash.Split(';');
		}

		public void Send(params (string, object)[] data) {
			Socket.SendPacket(data);
		}
		public void Send(JObject data) {
			Socket.SendPacket(data);
		}
	}
	internal class Lobby {

		public int EmptyTime;

		bool InGame;

		List<Client> ConnectedPlayers;
		public int PlayerCount => ConnectedPlayers.Count;
		public string GameMode { get; private set; }

		public Client Host { get; private set; }

		public string LobbyCode { get; private set; }

		static char[] ValidCodeChars = new char[]{
			'A',
			'B',
			'C',
			'D',
			'E',
			'F',
			'G',
			'H',
			'I',
			'J',
			'K',
			'L',
			'M',
			'N',
			'O',
			'P',
			'Q',
			'R',
			'S',
			'T',
			'U',
			'V',
			'W',
			'X',
			'Y',
			'Z',
		};

		static char[] ValidSeedChars = new char[]{
			'A',
			'B',
			'C',
			'D',
			'E',
			'F',
			'G',
			'H',
			'I',
			'J',
			'K',
			'L',
			'M',
			'N',
			'O',
			'P',
			'Q',
			'R',
			'S',
			'T',
			'U',
			'V',
			'W',
			'X',
			'Y',
			'Z',

			'a',
			'b',
			'c',
			'd',
			'e',
			'f',
			'g',
			'h',
			'i',
			'j',
			'k',
			'l',
			'm',
			'n',
			'o',
			'p',
			'q',
			'r',
			's',
			't',
			'u',
			'v',
			'w',
			'x',
			'y',
			'z',

			'0',
			'1',
			'2',
			'3',
			'4',
			'5',
			'6',
			'7',
			'8',
			'9',
		};

		Dictionary<string, string> Options;
		Dictionary<Client, int> Bets;

		public Lobby(string gamemode) {
			ConnectedPlayers = new List<Client>();
			Options = new Dictionary<string, string>();
			Bets = new Dictionary<Client, int>();
			GameMode = gamemode;
			Random rng = new Random();
			LobbyCode = "";
			for (int i = 0; i < 5; i++) {
				LobbyCode += ValidCodeChars[rng.Next(ValidCodeChars.Length)];
			}
		}

		public void AddClient(Client client) {
			if (!ConnectedPlayers.Contains(client)) {
				if (ConnectedPlayers.Count == 0 || Host == null) {
					Host = client;
				}
				client.Lobby = this;
				ConnectedPlayers.Add(client);
				client.OnReceive += Recieve;
				client.Send(("action", "joinedLobby"), ("type", GameMode), ("code", LobbyCode));
				BroadcastOptions();
				BroadcastInfo();
			}
		}
		public void RemoveClient(Client client) {
			if (ConnectedPlayers.Contains(client)) {
				client.Lobby = null;
				client.Ready = false;
				ConnectedPlayers.Remove(client);
				client.OnReceive -= Recieve;
			}
		}

		void SendOptions(Client client) {
			List<(string, object)> tosend = new List<(string, object)>(){
				("action", "lobbyOptions"),
				("gamemode", GameMode),
			};
			foreach (var kv in Options) {
				tosend.Add((kv.Key, kv.Value));
			}
			client.Send(tosend.ToArray());
		}
		void BroadcastOptions() {
			foreach (var player in ConnectedPlayers) {
				SendOptions(player);
			}
		}
		void SendInfo(Client client) {
			List<(string, object)> tosend = new List<(string, object)>(){
				("action", "lobbyInfo"),
				("host", Host.UserName),
				("hostHash", Host.ModHash),
				("isHost", Host == client),
				("hostCached", Host.Cached)
			};

			if (ConnectedPlayers.Count >= 2) {
				var guest = ConnectedPlayers[1];

				tosend.Add(("guest", guest.UserName));
				tosend.Add(("guestHash", guest.ModHash));
				tosend.Add(("guestCached", guest.Cached));
				tosend.Add(("guestReady", guest.Ready));
			}
			
			foreach (var kv in Options) {
				tosend.Add((kv.Key, kv.Value));
			}
			client.Send(tosend.ToArray());
		}
		public void BroadcastInfo() {
			foreach (var player in ConnectedPlayers) {
				SendInfo(player);
			}
		}

		static string GenerateSeed() {

			Random rng = new Random();
			string seed = "";
			for (int i = 0; i < 8; i++) {
				seed += ValidSeedChars[rng.Next(ValidSeedChars.Length)];
			}
			return seed;
		}

		void StopGame() {
			for (int i = 0; i < ConnectedPlayers.Count; i++) {
				ConnectedPlayers[i].Send(("action", "stopGame"));
				ConnectedPlayers[i].Ready = false;
			}
		}

		private void Recieve(Client client, JObject data) {
			string action = (string)data["action"]!;

			switch (action) {
				case "leaveLobby":
					RemoveClient(client);
					if (InGame) {
						StopGame();
					}
					break;
				case "lobbyOptions":
					Options.Clear();
					foreach (var kv in data) {
						if (kv.Key != "action") {
							Options[kv.Key] = kv.Value!.ToString();
						}
					}
					BroadcastOptions();
					break;
				case "lobbyInfo":
					SendInfo(client);
					break;
				case "tcgBet":
					Bets[client] = int.Parse(data["amount"].ToString());
					if (Bets.Count == PlayerCount) {
						List<Client> best = new List<Client>();
						int bestBet = -1;
						foreach (var kv in Bets) {
							if (bestBet == kv.Value) {
								bestBet = kv.Value;
								best.Add(kv.Key);
							}
							else if (bestBet < kv.Value) {
								bestBet = kv.Value;
								best.Clear();
								best.Add(kv.Key);
							}
						}

						var first = best[Random.Shared.Next(0, best.Count)];

						for (int i = 0; i < ConnectedPlayers.Count; i++) {
							ConnectedPlayers[i].Send(("action", "tcgPlayerStatus"), ("type", "ready"), ("damage", (first == ConnectedPlayers[i] ? bestBet : 0)), ("starting", first == ConnectedPlayers[i]));
						}
					}
					break;
				case "tcgPlayerStatus":

					for (int i = 0; i < ConnectedPlayers.Count; i++) {
						if (client == ConnectedPlayers[i])
							continue;
						ConnectedPlayers[i].Send(data);
					}
					break;
				case "startGame":
					string seed = GenerateSeed();
					for (int i = 0; i < ConnectedPlayers.Count; i++) {
						ConnectedPlayers[i].Send(("action", "startGame"), ("seed", seed), ("starting", false));
					}
					break;
				case "startPlaying":
					break;
				case "tcgEndTurn":
					for (int i = 0; i < ConnectedPlayers.Count; i++) {
						if (ConnectedPlayers[i] != client)
							ConnectedPlayers[i].Send(("action", "tcgStartTurn"));
					}
					break;
				case "stopGame":
					StopGame();
					Bets.Clear();
					break;
				default:
					break;
			}
		}

	}
}
