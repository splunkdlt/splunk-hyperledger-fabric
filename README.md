# Splunk App for Hyperledger Fabric

The Splunk App for Hyperledger Fabric contains a set of dashboards and analytics to give you full visibility into the system metrics, application data and ledger so that you can maintain security, stability and performance for your Hyperledger Fabric deployment.  

These dashboards are meant to be a starting point for building analytics around your environment whether your infrastructure is virtual or physical, on-premise or in the cloud.

In order to take full advantage of the dashboards provided there are 4 types of data sources that should be configured.

  1. **Hyperledger Fabric Distributed Ledger** - These logs contain transaction information from the ledger itself and provide insight into operations and actions on-chain. We’ve open sourced our [Splunk Connect for Hyperledger Fabric](https://github.com/splunk/fabric-logger) to help you easily ingest Hyperledger Fabric ledgers in Splunk.
  2. **Hyperledger Fabric Application Logs** - Application logs provide information about specific Hyperledger components such as the Orderers, Peer Nodes and other services (CouchDB and Kafka) useful for troubleshooting, debugging and monitoring application performance.
  3. **Hyperledger Fabric Metrics** - These are metrics specific to Hyperledger Fabric components and performance. You can find a reference on these metrics [here](https://hyperledger-fabric.readthedocs.io/en/release-2.2/metrics_reference.html).
  4. **Infrastructure/System Level Metrics and Logs** - System metrics such as CPU,MEM,DISK and NETWORK activity provide insight into the underlying infrastructure Hyperledger Fabric nodes are running on.  These metrics/logs could come from physical machines, Docker, Kubernetes, IBM IKS, Microsoft Azure, Google’s GCP and AWS Cloudwatch to name a few.  Splunk has different Add-ons and connectors for each.  

## App Features

### Dashboards
There are a few dashboards provided to get you started with analyzing your Hyperledger Fabric deployment. These include:
  * **Data Setup** - A dashboard to ensure that your Splunk environment is receiving all the data the application requires.
  * **Network Architecture and Channels** - See at a glance the number of orderers, peers, and channels in your Hyperledger Fabric network.
  * **Infrastructure Health and Monitoring** - An overview of system health from system metrics like CPU, uptime status as well as transaction latency. You can see in real time when transactions are starting to back up or a peer is falling behind on blocks.
  * **Transaction Analytics** - Real time visibility into the transactions being written on each ledger. In this dashboard, we’re blending ledger data sent from the peers with logs and metrics to give a holistic view of the network’s health.
  * **Security Monitoring** - High level visibility into key threat indicators to facilitate detection of attacks on the network. This dashboard is informed by ledger, log and metric data.
<div style="display: inline-block;">
<img src="/splunk-hyperledger-fabric/appserver/static/architecture.png?raw=true" alt="Network Architecture and Channels" width="33%"/>
<img src="/splunk-hyperledger-fabric/appserver/static/monitoring.png?raw=true" alt="Infrastructure Health and Monitoring" width="33%"/>
</div>
<div style="display: inline-block;">
<img src="/splunk-hyperledger-fabric/appserver/static/transaction_analytics.png?raw=true" alt="Transaction Analytics" width="33%"/>
<img src="/splunk-hyperledger-fabric/appserver/static/security.png?raw=true" alt="Security Monitoring" width="33%"/>
</div>

### Field Extractions and Aliases
The app provides a number of field extractions and aliases that will make searching and investigating Hyperledger Fabric data easier. These include parsing couchdb logs for actions (GET, PUT, POST, etc) and documents, chaincode logs for channel and latency metadata, and field aliases for accessing various parts of ledger transactions. To see the full list you can look at the [props.conf](https://github.com/splunkdlt/splunk-hyperledger-fabric/blob/main/default/props.conf) file or go to Settings > Fields in Splunk.

# Getting Started

1. Install the App on a Splunk Enterprise Search Head that will have access to the data.  
2. Open the App and navigate to the “Data Setup” dashboard from the Introduction Page.
3. Follow the instructions for each of the 4 data sources on the “Data Setup” page in order to populate the graphs and validate data is coming in correctly. 
    * **Hyperledger Fabric Ledger Logs** - The [Splunk Connect for Hyperledger Fabric](https://github.com/splunk/fabric-logger) is an open source agent that connects to a peer on the Hyperledger Fabric network. See the README on Github here for deployment instructions. Docker, Kubernetes, and native deployments are all options.
    * **Hyperledger Fabric Application Logs** - There are several options to get data in from you Hyperledger Fabric environment depending on where and how the nodes are hosted.  You will need to [create an index](https://docs.splunk.com/Documentation/Splunk/latest/Indexer/Setupmultipleindexes) in Splunk as well as an input mechanism to receive the data.  We usually like to create an index called “*hyperledger_logs*” and “*hyperledger_metrics*” and enable the Splunk HEC to receive data.  You can use the example “indexes.conf.example” provided in the app.  Simply rename the file from “indexes.conf.example” to “indexes.conf” to enable the indexes, and rename “inputs.conf.example” to “inputs.conf” to enable the HEC endpoints. You will also need to [enable the HTTP Event Collector (HEC)](https://docs.splunk.com/Documentation/Splunk/7.3.0/Data/UsetheHTTPEventCollector#Configure_HTTP_Event_Collector_on_Splunk_Enterprise) to receive data if it has not been "enabled" already.  
    ```
    $ cd $SPLUNK_HOME/etc/apps/splunk-hyperledger-fabric/default
    $ sudo mv inputs.conf.example inputs.conf
    $ sudo mv indexes.conf.example indexes.conf
    $ cd /opt/splunk/bin
    $ sudo ./splunk restart
    ```
      Now you will need to configure logging from your Hyperledger Fabric nodes depending on the environments below:
      - Docker: [Splunk Docker Logging Driver](https://docs.docker.com/config/containers/logging/splunk/)
      - Kubernetes: [Splunk Connect for Kubernetes](https://github.com/splunk/splunk-connect-for-kubernetes)
      - Syslog: [Monitoring Network Ports in Splunk](https://docs.splunk.com/Documentation/Splunk/latest/Data/Monitornetworkports)
      - Log File: [Monitoring Files and Directories with Splunk]( https://docs.splunk.com/Documentation/Splunk/latest/Data/MonitorfilesanddirectorieswithSplunkWeb)
      - IBM Cloud Platform: [IBM Cloud Platform](https://www.ibm.com/blogs/bluemix/2019/02/solving-business-problems-with-splunk-on-ibm-cloud-kubernetes-service/)
      - Microsoft Azure: [Splunk Add-on for Microsoft Cloud Services](https://splunkbase.splunk.com/app/3110/)
      - AWS Cloudwatch: [Splunk App for AWS](https://splunkbase.splunk.com/app/1274/)
      - GCP Stackdriver: [Splunk Add-on for Google Cloud](https://splunkbase.splunk.com/app/3088/)
     
    Also make sure to set the following environment variable in your Hyperledger Fabric environments:
    ```
    FABRIC_LOGGING_FORMAT=json
    ``` 
    * **Hyperledger Fabric Metrics (Prometheus)** - Hyperledger Fabric 2.2 exposes metrics for ingestion using Prometheus, which can be scraped by Splunk Connect for Hyperledger Fabric.
      - First set the following environment variables in your Hyperledger Fabric environment.
      ```
      CORE_METRICS_PROVIDER: prometheus
      CORE_OPERATIONS_LISTENADDRESS: [EXTERNAL-IP]:[PORT]
      ORDERER_METRICS_PROVIDER: prometheus
      ORDERER_OPERATIONS_LISTENADDRESS: [EXTERNAL-IP]:[PORT]
      ```
      - Then configure [Splunk Connect for Hyperledger Fabric](https://github.com/splunk/fabric-logger) or the [Splunk Opentelemetry Connector](https://github.com/signalfx/splunk-otel-collector) to scrape these metrics.
      - Open the [Metrics Workspace](https://docs.splunk.com/Documentation/SMW/latest/Use/Launch) to explore and analyze your metrics.
  
   * **System Logs/Metrics** - Depending on how you’ve deployed your Hyperledger Fabric network, there is probably a great option to get your System Logs and Metrics for end-to-end visibility. On the data setup dashboard, we’ve provided a list of common options that you can use to get your data into Splunk. 
   
*You are now ready to use the Splunk App for Hyperledger Fabric!*
