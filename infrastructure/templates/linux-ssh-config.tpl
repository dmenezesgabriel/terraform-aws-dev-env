cat << EOF >> ~/.ssh/config

Host ${hostname}
  Host ${hostname}
  User ${user}
  IdentityFile ${identityfile}
EOF