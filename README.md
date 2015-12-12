# Standard minion config

```
file_client: local

fileserver_backend:
  - git
  - roots

gitfs_remotes:
  - https://github.com/everysquare/formula.git

file_roots:
  base:
    - /vagrant/salt/root
```

### Using Macros and States

#### Include the state

```
include:
  - formula.nginx
```

#### Import the macro

```
{% from "formula/nginx/macros.sls" import nginxsite %}
```

#### Use the macro

```
{{ nginxsite("user", "group",
             template="salt://formula/nginx/files/proxy-upstream.conf",
             cors="*",
             server_name="_",
             static="/vagrant/static"
             defaults={
              'port': '5000'
             })
}}
```

