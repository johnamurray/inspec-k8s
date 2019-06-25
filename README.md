# InSpec Kubernetes Resource Pack

This InSpec resource pack provides InSpec helpers to validate the spec of any object/resource inside Kubernetes.

## Usage

At this point, the following Inspec base resources are implemented:

- k8sobjects
- k8sobject

This allows for listing/filtering objects:

```ruby
describe k8sobjects(api: 'v1', type: 'pods', namespace: 'default', labelSelector: 'run=nginx') do
  it { should exist }
  ...
end
```

```ruby
describe k8sobjects(api: 'v1', type: 'namespaces', labelSelector: 'myns=prod') do
  it { should exist }
  ...
end
```

And then for assessing the spec of a specific object:

```ruby
describe k8sobject(api: 'v1', type: 'pod', namespace: 'default', name: 'my-pod') do
  it { should exist }
  its('name') { should eq 'my-pod' }
  ...
end
```

## Preconditions

- Inspec 3+
- InSpec K8s train/backend plugin [train-kubernetes](https://github.com/bgeesaman/train-kubernetes)

## Train plugin installation

To install the plugin `train-kubernetes`:

```
$ inspec plugin install train-kubernetes
```

Verify the plugin is installed:

```
$ inspec detect -t k8s://

== Platform Details

Name:      k8s
Families:  cloud, api
Release:   0.1.0
```

Run inspec against a profile called `path-to-profile` with an attributes file: 
```
inspec exec path-to-profile -t k8s:// --attrs attributes.yml
```

## Troubleshooting

If you run into issues installing via `inspec plugin install train-kubernetes`, try:

* Ensure you can cleanly install the `k8s-client` gem version `0.10.0` or greater.  e.g. `gem install k8s-client -v 0.10.0`
* Ensure that only one version of the `excon` gem is installed.  e.g. `gem list | grep excon`.  If you see two versions, `gem uninstall -v 0.62.0` and remove the older version.
