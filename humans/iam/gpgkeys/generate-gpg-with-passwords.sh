#!/bin/bash

# Admin password for securing the keys
admin_password="Secret2024$"

# Declare an associative array of users and emails
declare -A users=(
    ["afacollins1"]="afanwi.collins1@gmail.com"
    ["afacollins2"]="afanwi.collins2@gmail.com"
    ["afacollins3"]="afanwi.collins3@gmail.com"
    ["afacollins4"]="afanwi.collins4@gmail.com"
    ["afacollins5"]="afanwi.collins5@gmail.com"
    ["afacollins6"]="afanwi.collins6@gmail.com"
)

# Loop through each user and email
for user in "${!users[@]}"; do
  email=${users[$user]}

  # Check if the GPG key for the user already exists
  if gpg --list-keys $email > /dev/null 2>&1; then
    echo "GPG key for $user ($email) already exists. Skipping key generation."
    continue
  fi

  echo "Generating GPG key for $user <$email>..."

  # Generate GPG key using batch mode to avoid interactive prompts
  gpg --batch --passphrase "$admin_password" --gen-key <<EOF
    %echo Generating GPG Key for $user <$email>
    Key-Type: RSA
    Key-Length: 4096
    Name-Real: $user
    Name-Email: $email
    Expire-Date: 0
    Passphrase: $admin_password
    %commit
    %echo Key Generation Complete
EOF

  # Export the public key and convert to base64, then save to a file with the user's name
  gpg --export $email | base64 > "${user}-public.gpg"

  # Decode and decrypt the password (assuming the passwords are stored in base64 format)
  encrypted_password="U2VjcmV0MjAk"  # Example encoded password (replace with real one)
  decoded_password=$(echo "$encrypted_password" | base64 -d)

  echo "Decoded password for $user: $decoded_password"
done

echo "All new GPG keys have been generated, protected, and exported."
