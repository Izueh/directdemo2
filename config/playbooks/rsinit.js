rs.initiate(
  {
    _id: "conf",
    configsvr: true,
    members: [
      { _id : 0, host : "configsvr:27017" },
      { _id : 1, host : "configsvr:27018" },
      { _id : 2, host : "configsvr:27019" }
    ]
  }
)
