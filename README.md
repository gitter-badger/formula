# Using Macros and States

[![Join the chat at https://gitter.im/everysquare/formula](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/everysquare/formula?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

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

