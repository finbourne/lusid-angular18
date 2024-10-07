# How to generate clients

## LUSID clients

In the `lusid` folder there is a script, `generate-lusid-client.sh` that will use the `openapi-generator-cli` to generate code from LUSID swagger files.

You should create a folder for each LUSID "client" that is needed. In each folder you should

- create a `generate-client.sh` file that calls `lusid/generate-lusid-client.sh`, passing the associated service name, to generate code.
- add any service specific code/scripts - DO NOT PUT THIS IN THE `generated` folder
- create a `index.ts` file to export the required classes / types

### Example

There is a helper script, `create-client.sh` in the `lusid` folder, that can be used to create the required folders / files by supplying the service name.

To create the folders / files need to generate a **Configuration** client

```bash
./create-client.sh configuration
```

- This only needs to be done once as it doesn't actually generate a client, it only creates the structure required to generate a client
- To actually generate a client

```bash
cd configuration
./generate-client.sh
```

- This should be run each time the LUSID service changes!

- don't forget to replace BASE_PATH with corresponding url (example: { provide: WORKFLOW_BASE_PATH, useValue: config.workflowUrl })

## Other Clients

There are several ways to install and use the `openapi-generator-cli`, see https://openapi-generator.tech/docs/installation/

The `lusid/generate-lusid-client.sh` allows the use of 2 ways, using **docker** or using the **openapi-generator-cli** npm package

- the **openapi-generator-cli** npm package required JAVA on the host machine to generate clients
- the docker container has JAVA on it
