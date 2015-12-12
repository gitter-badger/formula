vagrant:
  user.present:
    - fullname: Vagrant User
    - shell: /bin/bash
    - home: /home/vagrant
    - uid: 1001
    - gid: 1001
    - groups:
      - vagrant
      - sudo
