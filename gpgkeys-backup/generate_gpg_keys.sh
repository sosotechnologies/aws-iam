#!/bin/bash

# Declare an associative array of users and emails
declare -A users_emails=(
  ["afacollins1"]="afanwi.collins1@gmail.com"
  ["afacollins2"]="afanwi.collins2@gmail.com"
  ["afacollins3"]="afanwi.collins3@gmail.com"
  ["afacollins4"]="afanwi.collins4@gmail.com"
  ["afacollins5"]="afanwi.collins5@gmail.com"
  ["afacollins6"]="afa.rose@gmail.com"
)

# Loop through each user and email
for user in "${!users_emails[@]}"; do
  email=${users_emails[$user]}

  # Check if the GPG key for the user already exists
  if gpg --list-keys $email > /dev/null 2>&1; then
    echo "GPG key for $user ($email) already exists. Skipping key generation."
    continue
  fi

  echo "Generating GPG key for $user <$email>..."

  # Generate GPG key using batch mode to avoid interactive prompts
  gpg --batch --gen-key <<EOF
    Key-Type: RSA
    Key-Length: 4096
    Name-Real: $user
    Name-Email: $email
    Expire-Date: 0
    %no-protection
EOF

  # Export the public key and convert to base64, then save to a file
  gpg --armor --export $email | base64 > "${user}-public.gpg"
  
  echo "GPG key for $user generated and public key saved to ${user}-public.gpg"
done

echo "All new GPG keys have been generated and exported."
