# postgresql-patroni
PostgreSQL High Availability with patroni/spilo for Docker Swarm

## Getting Started

You need to have a Docker Swarm cluster up and running and etcd cluster running.

> See https://github.com/YouMightNotNeedKubernetes/etcd for instructions on how to setup an etcd cluster.

## How it works

There are many ways to run high availability with PostgreSQL; for a list, see the [PostgreSQL Documentation](https://wiki.postgresql.org/wiki/Replication,_Clustering,_and_Connection_Pooling).

Patroni is a template for high availability (HA) PostgreSQL solutions using Python. For maximum accessibility, Patroni supports a variety of distributed configuration stores like **ZooKeeper**, **etcd**, **Consul** or **Kubernetes**. Database engineers, DBAs, DevOps engineers, and SREs who are looking to quickly deploy HA PostgreSQL in datacenters - or anywhere else - will hopefully find it useful.

![Patroni Architecture](https://github.com/YouMightNotNeedKubernetes/resources/assets/4363857/c663d7a5-c92e-48d5-8de4-88338879c212)

Before you can deploy PostgreSQL, you need to carefully plan your deployment.
- Consider how many PostgreSQL instances you want to deploy.
- Node placement for each PostgreSQL instance.
- Storage driver for the volumes.
- How much storage you want to allocate to each instance.
- etc...

Here are some useful tips to help you plan your deployment.

### Server placement

A `node.labels.postgres.${namespace}` label is used to determine which nodes the PostgreSQL server can be deployed on.

> [!IMPORTANT]
> The `${namespace}` can be anything you want, but it must be the same for all nodes.
> Please DO NOT mix namespaces from different PostgreSQL clusters.

The deployment uses both placement **constraints** & **preferences** to ensure that the servers are spread evenly across the Docker Swarm manager nodes and only **ALLOW** one replica per node.

![placement_prefs](https://docs.docker.com/engine/swarm/images/placement_prefs.png)

> See https://docs.docker.com/engine/swarm/services/#control-service-placement for more information.

#### List the nodes
On the manager node, run the following command to list the nodes in the cluster.

```sh
docker node ls
```

#### Add the label to the node
On the manager node, run the following command to add the label to the node.

Repeat this step for each node you want to deploy PostgreSQL server to. Make sure that the number of node updated matches the number of replicas you want to deploy.

**Example PostgreSQL with 3 replicas**:
```sh
# The namespace can be anything you want, but it must be the same for all nodes.
# Please DO NOT mix namespaces from different PostgreSQL clusters.
namespace=pgsql

docker node update --label-add postgres.${namespace}=true <node-1>
docker node update --label-add postgres.${namespace}=true <node-2>
docker node update --label-add postgres.${namespace}=true <node-3>
```

## FAQs

### Official Spilo deployment

Its creators are working on a Postgres operator that would make it simpler to deploy scalable Postgres clusters in a Kubernetes environment.

The documents now moving toward using Kubernetes, but the Spilo project is still a good reference for how to deploy Postgres in a Docker Swarm environment.

Hence the reason why this project exists. To keep the tradition going.
