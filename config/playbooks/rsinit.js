rs.initiate(
  {
    _id: "conf",
    configsvr: true,
    members: [
      { _id : 0, host : "appserver-1:27017" },
      { _id : 1, host : "appserver-2:27017" },
      { _id : 2, host : "appserver-3:27017" }
    ]
  }
)
