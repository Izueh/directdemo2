rs.initiate(
  {
    _id: "directdemocracy",
    configsvr: true,
    members: [
      { _id : 0, host : "192.168.1.27:27017" },
      { _id : 1, host : "192.168.1.28:27017" },
      { _id : 2, host : "192.168.1.29:27017" }
    ]
  }
)
