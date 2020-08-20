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

