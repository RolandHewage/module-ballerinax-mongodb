import ballerina/log;
import ballerinax/mongodb;

configurable string host = ?;
configurable int port = ?;
configurable string username = ?;
configurable string password = ?;
configurable string database = ?;
configurable string collection = ?;

type Index record {
    int v;
    json key;
    string name;
    string ns;
};
public function main() returns error? {
    
    mongodb:ConnectionConfig mongoConfig = {
        host: host,
        port: port,
        username: username,
        password: password,
        options: {sslEnabled: false, serverSelectionTimeout: 5000}
    };

    mongodb:Client mongoClient = check new (mongoConfig, database);

    log:printInfo("------------------ List Indicies -------------------");
    stream<Index, error?> indicies = check mongoClient->listIndices(collection);
    check indicies.forEach(function(Index index){
        log:printInfo(index.name);
    });
    
    mongoClient->close();
}
