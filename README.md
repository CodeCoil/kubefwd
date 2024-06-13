# IMPORTANT NOTICE

This is a fork of the original repo that provided a patched version of the binaries that fix 
an issue (mostly on windows) where forwarding fails if any mapping for a pod/service has
more than 10 hostname aliases (because windows only support a maximum of 10 aliases per line).

Note that there aren't any changes to the actual code here, the fix is actually in the 
module [github.com/txn2/txeh](https://github.com/txn2) and this fork has been simply updated to 
reference the module from the forked repo that contains the fix ([github.com/CodeCoil/txeh](github.com/CodeCoil/txeh)).

This repo serve only as a mean to get binaries with the fix.

By default the limit is set to 10 on windows and none for other OSes.

But, although the issue only inpact windows, since this also include a mean to change the number of 
hostnames that `kubefwd` is allowed to add for a single line in the hosts file, the CI in this repos 
still also produce binaries for some (no *homebrew*, sorry) non windows platforms.

You can change the limit using the `KUBEFWD_MAX_HOSTNAMES_PER_LINE` environment variable.
E.g.:

Bash

```bash
export KUBEFWD_MAX_HOSTNAMES_PER_LINE=1
```

Windows:

```powershell
$env:KUBEFWD_MAX_HOSTNAMES_PER_LINE="1"
```

This will limit the maximum number of hosts for each line to `1`.

> I personally find much easier to deal with multiple entries for the same address, instead of
> something that *grow horizontally*, so i set the default to 1 on the env of my user.

Apart from the change described above, the rest should work exactly as the original.

> I will try to open an issue/PR on the [upstream repo](github.com/txn2/txeh) as soon as i have more time.

---

[English](https://github.com/txn2/kubefwd/blob/master/README.md)|[中文](https://github.com/txn2/kubefwd/blob/master/README_CN.md)

Kubernetes port forwarding for local development.

**NOTE:** Accepting pull requests for bug fixes, tests, and documentation only. 

![kubefwd - kubernetes bulk port forwarding](https://raw.githubusercontent.com/txn2/kubefwd/master/kubefwd-mast2.jpg)


[![Build Status](https://github.com/CodeCoil/kubefwd/actions/workflows/goreleaser.yaml/badge.svg?event=push)](https://github.com/CodeCoil/kubefwd/actions/workflows/goreleaser.yaml)
[![GitHub license](https://img.shields.io/github/license/txn2/kubefwd.svg)](https://github.com/CodeCoil/kubefwd/blob/master/LICENSE)
[![Go Report Card](https://goreportcard.com/badge/github.com/CodeCoil/kubefwd)](https://goreportcard.com/report/github.com/CodeCoil/kubefwd)
[![GitHub release](https://img.shields.io/github/release/CodeCoil/kubefwd.svg)](https://github.com/CodeCoil/kubefwd/releases)


# kubefwd (Kube Forward)

Read [Kubernetes Port Forwarding for Local Development](https://mk.imti.co/kubernetes-port-forwarding/) for background and a detailed guide to **kubefwd**. Follow [Craig Johnston](https://twitter.com/cjimti) on Twitter for project updates.

**kubefwd** is a command line utility built to port forward multiple [services] within one or more [namespaces] on one or more Kubernetes clusters. **kubefwd** uses the same port exposed by the service and forwards it from a loopback IP address on your local workstation. **kubefwd** temporally adds domain entries to your `/etc/hosts` file with the service names it forwards.

When working on our local workstation, my team and I often build applications that access services through their service names and ports within a [Kubernetes] namespace. **kubefwd** allows us to develop locally with services available as they would be in the cluster.

![kubefwd - Kubernetes port forward](kubefwd_ani.gif)

<p align="center">
  <img width="654" height="684" src="https://mk.imti.co/images/content/kubefwd-net.png" alt="kubefwd - Kubernetes Port Forward Diagram">
</p>

## OS

Tested directly on **macOS** and **Linux** based docker containers.

## MacOs Install / Update

**kubefwd** assumes you have **kubectl** installed and configured with access to a Kubernetes cluster. **kubefwd** uses the **kubectl** current context. The **kubectl** configuration is not used. However, its configuration is needed to access a Kubernetes cluster.

Ensure you have a context by running:
```bash
kubectl config current-context
```

~~If you are running MacOS and use [homebrew] you can install **kubefwd** directly from the [txn2] tap:~~

> Not supported for this fork.

## Windows Install / Update

> Download binaries from the latest github release. See [Alternative Installs]

## Docker

> Not supported for this fork.


## Alternative Installs (tar.gz, RPM, deb)
Check out the [releases](https://github.com/txn2/kubefwd/releases) section on Github for alternative binaries.

## Contribute
[Fork kubefwd](https://github.com/txn2/kubefwd) and build a custom version.
Accepting pull requests for bug fixes, tests, stability and compatibility
enhancements, and documentation only.

## Usage

Forward all services for the namespace `the-project`. Kubefwd finds the first Pod associated with each Kubernetes service found in the Namespace and port forwards it based on the Service spec to a local IP  address and port. A domain name is added to your /etc/hosts file pointing to the local IP.

### Update
Forwarding of headlesss Service is currently supported, Kubefwd forward all Pods for headless service; At the same time, the namespace-level service monitoring is supported. When a new service is created or the old service is deleted under the namespace, kubefwd can automatically start/end forwarding; Supports Pod-level forwarding monitoring. When the forwarded Pod is deleted (such as updating the deployment, etc.), the forwarding of the service to which the pod belongs is automatically restarted;

```bash
sudo kubefwd svc -n the-project
```

Forward all svc for the namespace `the-project` where labeled `system: wx`:

```bash
sudo kubefwd svc -l system=wx -n the-project
```

Forward a single service named `my-service` in the namespace `the-project`:

```
sudo kubefwd svc -n the-project -f metadata.name=my-service
```

Forward more than one service using the `in` clause:
```bash
sudo kubefwd svc -l "app in (app1, app2)"
```

## Help

```bash
$ kubefwd svc --help

INFO[00:00:48]  _          _           __             _     
INFO[00:00:48] | | ___   _| |__   ___ / _|_      ____| |    
INFO[00:00:48] | |/ / | | | '_ \ / _ \ |_\ \ /\ / / _  |    
INFO[00:00:48] |   <| |_| | |_) |  __/  _|\ V  V / (_| |    
INFO[00:00:48] |_|\_\\__,_|_.__/ \___|_|   \_/\_/ \__,_|    
INFO[00:00:48]                                              
INFO[00:00:48] Version 0.0.0                                
INFO[00:00:48] https://github.com/txn2/kubefwd              
INFO[00:00:48]                                              
Forward multiple Kubernetes services from one or more namespaces. Filter services with selector.

Usage:
  kubefwd services [flags]

Aliases:
  services, svcs, svc

Examples:
  kubefwd svc -n the-project
  kubefwd svc -n the-project -l app=wx,component=api
  kubefwd svc -n default -l "app in (ws, api)"
  kubefwd svc -n default -n the-project
  kubefwd svc -n default -d internal.example.com
  kubefwd svc -n the-project -x prod-cluster
  kubefwd svc -n the-project -m 80:8080 -m 443:1443
  kubefwd svc -n the-project -z path/to/conf.yml
  kubefwd svc -n the-project -r svc.ns:127.3.3.1
  kubefwd svc --all-namespaces

Flags:
  -A, --all-namespaces          Enable --all-namespaces option like kubectl.
  -x, --context strings         specify a context to override the current context
  -d, --domain string           Append a pseudo domain name to generated host names.
  -f, --field-selector string   Field selector to filter on; supports '=', '==', and '!=' (e.g. -f metadata.name=service-name).
  -z, --fwd-conf string         Define an IP reservation configuration
  -h, --help                    help for services
  -c, --kubeconfig string       absolute path to a kubectl config file
  -m, --mapping strings         Specify a port mapping. Specify multiple mapping by duplicating this argument.
  -n, --namespace strings       Specify a namespace. Specify multiple namespaces by duplicating this argument.
  -r, --reserve strings         Specify an IP reservation. Specify multiple reservations by duplicating this argument.
  -l, --selector string         Selector (label query) to filter on; supports '=', '==', and '!=' (e.g. -l key1=value1,key2=value2).
  -v, --verbose                 Verbose output.
```

### License

Apache License 2.0

# Sponsor

Open source utility by [Craig Johnston](https://twitter.com/cjimti), [imti blog](http://imti.co/) and sponsored by [Deasil Works, Inc.]

Please check out my book [Advanced Platform Development with Kubernetes](https://imti.co/kubernetes-platform-book/):
Enabling Data Management, the Internet of Things, Blockchain, and Machine Learning.

[![Book Cover - Advanced Platform Development with Kubernetes: Enabling Data Management, the Internet of Things, Blockchain, and Machine Learning](https://raw.githubusercontent.com/apk8s/book-source/master/img/apk8s-banner-w.jpg)](https://amzn.to/3g3ihZ3)

Source code from the book [Advanced Platform Development with Kubernetes: Enabling Data Management, the Internet of Things, Blockchain, and Machine Learning](https://amzn.to/3g3ihZ3) by [Craig Johnston](https://imti.co) ([@cjimti](https://twitter.com/cjimti)) ISBN 978-1-4842-5610-7 [Apress; 1st ed. edition (September, 2020)](https://www.apress.com/us/book/9781484256107)

Read my blog post [Advanced Platform Development with Kubernetes](https://imti.co/kubernetes-platform-book/) for more info and background on the book.

Follow me on Twitter: [@cjimti](https://twitter.com/cjimti) ([Craig Johnston](https://twitter.com/cjimti))


## Please Help the Children of Ukraine

UNICEF is on the ground helping Ukraine's children, please donate to https://www.unicefusa.org/ <- "like" this project by donating.


[Kubernetes]:https://kubernetes.io/
[namespaces]:https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
[services]:https://kubernetes.io/docs/concepts/services-networking/service/
[homebrew]:https://brew.sh/
[txn2]:https://txn2.com/
[Deasil Works, Inc.]:https://deasil.works/
