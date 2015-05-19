# Standard minion config

```
file_client: local

fileserver_backend:
  - git
  - roots

gitfs_remotes:
  - https://github.com/stackstrap/formula.git

file_roots:
  base:
    - /vagrant/salt/root
```

### Using Macros and States

#### Include the state

```
include:
  - stackstrap.nginx
```

#### Import the macro

```
{% from "stackstrap/nginx/macros.sls" import nginxsite %}
```

#### Use the macro

```
{{ nginxsite("user", "group",
             template="salt://stackstrap/nginx/files/proxy-upstream.conf",
             cors="*",
             server_name="_",
             static="/vagrant/static"
             defaults={
              'port': '5000'
             })
}}
```

### More examples

To see a comprehensive collection of usage examples you can checkout the [kitchen sink](https://github.com/stackstrap/kitchen-sink).
