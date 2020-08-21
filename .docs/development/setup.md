# Local development environment setup
In order to work, Mooncake relies on a complex system composed of different parts. For this reason, setting up the local environment on top of which to test the application properly is not simple. However, we tried to create the easiest-to-use system possible.  

## Requirements
The following requirements should be met in order to properly setup a local development environment for Mooncake.

- Having [Docker compose](https://docs.docker.com/compose/) installed. If you don't have it, you can read how to get it [here](https://docs.docker.com/compose/install/).

## Setup
### Getting the required configuration data
The first thing we need to do is to get the proper data that we need in order to set up everything.

Before doing anything, you need to go inside the proper folder. To do this, from the root folder of the Mooncake project run:

```
cd development
```  

#### Downloading the PostgreSQL and Hasura metadata 
The first things to get are: 

- the PostgreSQL tables schema that will be used to create our database
- the Hasura metadata that will be used to setup the GraphQL server
 
To get them, simply run the following commands: 

```
wget https://github.com/desmos-labs/djuno/archive/version/v0.10.0.zip
unzip v0.10.0.zip
rm v0.10.0.zip
mv djuno-version-v0.10.0/schema .
rm -r djuno-version-v0.10.0
```

After running those commands, you should end up with a folder structure like the following: 

```
development
    |- schema
    |    |- hasura
    |    |    |- <A bunch of .graphql, .yml and .json files>
    |    |
    |    |- <A bunch of .sql files>
    | 
    |- docker-compose.yml
```

#### Creating the DJuno configuration file
The second step to take is to create the proper configuration files for DJuno. This deamon will run on the background, parsing all the Desmos data and putting it into the PostgreSQL database so that it can be properly read by Hasura. 

DJuno will take two different configuration files: 

- a `config.toml` containing the details of how to connect to the Desmos REST APIs and to the PostgreSQL databae
- a `firebase-config.json` file containing the private keys that will be used to send notifications to the clients trough the [Firebase Cloud Messaging](https://firebase.google.com/products/cloud-messaging) platform

##### The config.toml
In order to create the proper `config.toml` configuration, first create the `config` folder inside which the files will be placed: 

```shell
mkdir config
```

Then create the `config.toml` file with the correct contents:

```shell
tee config/config.toml > /dev/null <<EOF  
rpc_node = "http://desmosd:26657"
client_node = "http://desmoscli:1317"

[database]
type = "postgresql"

[database.config]
host = "postgres"
port = 5432
user = "user"
password = "password"
name = "djuno"
EOF
```

##### The firebase-config.json file 
The second file needed is the one that contains the data to properly use the Firebase Cloud Messaging system. This needs to be a JSON file containing a FCM service account. You can read more about this inside the [official FCM documentation page](https://firebase.google.com/docs/cloud-messaging/auth-server#provide-credentials-manually).

:::warning Be aware of the file name and location  
In order for everything to work properly, make sure the service account file is named `firebase-config.json` and placed inside the `config` folder under the `development` one. Failing to have such configuration will result in the system not working properly.  
:::

## Starting the services 
Once you have followed the setup entirely, you should end up with the following folder structure: 

```shell
development
    |- schema
    |    |- hasura
    |    |    |- <A bunch of .graphql, .yml and .json files>
    |    |
    |    |- <A bunch of .sql files>
    | 
    |- config
    |    |- config.toml
    |    |- firebase-config.json
    | 
    |- docker-compose.yml
```

In order to start all the services, you now need to run the following command: 

```shell
docker-compose up
```

This will start multiple Docker containers as described inside the `docker-compose.yml` file. 

## Setting up the application
Finally, if everything is running properly, you need to edit the Mooncake configuration in order to make so that it communicates with the local chain instead of the public one. 

To do, just open the `lib/sources/dependency_injection.dart` file and change the `_useLocalEndpoints` variable to `true. 

:::warning Remember to change it back  
Before pushing any commit to the repository, remember to change this value back to `true`.  
:::
