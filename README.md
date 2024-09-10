aws-iam/
├── example/
│   └── main.tf
├── modules/
│   └── iam-user-profile/
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf

### Step 1: Generate GPG Keys for Each User
```sh
#### For Afa Collins:
gpg --full-generate-key
gpg --armor --export "Afa Collins" > afa_collins_public_key.asc

#### For Serge Mando:
gpg --full-generate-key
gpg --armor --export "Serge Mando" > serge_mando_public_key.asc

#### For Ttioe Resat:
gpg --full-generate-key
gpg --armor --export "Ttioe Resat" > ttioe_resat_public_key.asc
```


### Step 2: Use the GPG Keys in Terraform
```sh
tofu init
tofu plan
tofu apply
```

### Step 3: Decrypt Each User’s Password
```sh
echo "<afa_collins_encrypted_password>" > afa_collins_encrypted_password.txt
echo "<serge_mando_encrypted_password>" > serge_mando_encrypted_password.txt
echo "<ttioe_resat_encrypted_password>" > ttioe_resat_encrypted_password.txt

gpg --decrypt afa_collins_encrypted_password.txt
gpg --decrypt serge_mando_encrypted_password.txt
gpg --decrypt ttioe_resat_encrypted_password.txt
```