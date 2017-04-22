rs.initiate(
  {
    _id: "directdemocracy",
    shardsrv: true,
    members: [
      { _id : 0, host : "192.168.1.23:27017" },
      { _id : 1, host : "192.168.1.24:27017" },
      { _id : 2, host : "192.168.1.30:27017" }
    ]
  }
)
