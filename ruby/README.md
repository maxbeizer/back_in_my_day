# The Ruby version

## Creating instances
```
$ ruby create_instances.rb num_instances
```


## Checking on instances
```
$ ruby check_instances.rb
```


## Destroy all instances
```
$ ruby destroy_all_instances.rb
```


## Terminate instance by id
```
$ ruby terminate_instances_by_id.rb instance_id
```


## Update records set by IP
Add alias records to Route53 by IP or add for all running instances.
```
$ ruby record_set_modifier.rb ACTION {ips,all}
```
