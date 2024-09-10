## Opentofu IAM Users with Policy statements

<!-- 
.
├── humans
│   └── iam
│       ├── README.md
│       ├── main.tf
│       ├── outputs.tf
│       ├── public.gpg
│       └── variables.tf
└── modules
    ├── iam-policy
    │   ├── main.tf
    │   ├── output.tf
    │   ├── variables.tf
    │   └── versions.tf
    └── iam-user
        ├── main.tf
        ├── outputs.tf
        ├── public.gpg
        ├── variables.tf
        └── versions.tf
-->

### using gpg password
[https://stackoverflow.com/questions/53534722/how-to-enable-the-console-login-for-iam-user-in-terraform](https://stackoverflow.com/questions/53534722/how-to-enable-the-console-login-for-iam-user-in-terraform)

PGP key with aws_iam_user_login_profile is a secure method to generate and encrypt the password for IAM users. 
This approach is preferred when you want to maintain high security, especially for sensitive credentials. 

***Set Up a PGP Key:***

- Create a gpg key for each user

<!-- 
afacollins1     afanwi.collins1@gmail.com
afacollins2     afanwi.collins2@gmail.com
afacollins3     afanwi.collins3@gmail.com
afacollins4     afanwi.collins4@gmail.com
afacollins5     afanwi.collins5@gmail.com
afacollins6     afanwi.collins6@gmail.com
-->

- Mk a diretory in the dirrectory humans/iam/
- execute the script to generate the tokens

### generate the tokens manually

```sh
gpg --generate-key
gpg --export | base64 > afacollins1-public.gpg

gpg --generate-key
gpg --export | base64 > afacollins2-public.gpg

gpg --generate-key
gpg --export | base64 > afacollins3-public.gpg

gpg --generate-key
gpg --export | base64 > afacollins4-public.gpg

gpg --generate-key
gpg --export | base64 > afacollins5-public.gpg

gpg --generate-key
gpg --export | base64 > afacollins6-public.gpg
```

### Apply the tofu code
```sh
tofu init
tofu plan
tofu validate
tofu apply --auto-approve
```

## after tofu has applied Decrypt and get password for users and use that to login to the console

```sh
gpg --list-secret-keys
echo $encrypted_password_afacollins1 | base64 -d | gpg -vv -d
echo $encrypted_password_afacollins2   | base64 -d | gpg -vv -d
echo $encrypted_password_afacollins3   | base64 -d | gpg -vv -d
echo $encrypted_password_afacollins4    | base64 -d | gpg -vv -d
echo $encrypted_password_afacollins5   | base64 -d | gpg -vv -d
echo $encrypted_password_afacollins6    | base64 -d | gpg -vv -d
```

***OR if thst method does not work, use the below***

```sh
tofu init -upgrade
echo $encrypted_password_afacollins1 | base64 -d > afacollins1_encrypted_password.bin
echo $encrypted_password_afacollins2   | base64 -d > afacollins2_encrypted_password.bin
echo $encrypted_password_afacollins3   | base64 -d > afacollins3_encrypted_password.bin
echo $encrypted_password_afacollins4    | base64 -d > afacollins4_encrypted_password.bin
echo $encrypted_password_afacollins5   | base64 -d > afacollins5_encrypted_password.bin
echo $encrypted_password_afacollins6    | base64 -d > afacollins6_encrypted_password.bin

gpg -d afacollins1_encrypted_password.bin
gpg -d afacollins2_encrypted_password.bin
gpg -d afacollins3_encrypted_password.bin
gpg -d afacollins4_encrypted_password.bin
gpg -d afacollins5_encrypted_password.bin
gpg -d afacollins6_encrypted_password.bin
```

## other debugging

### deleting the gpg keys
gpg --list-secret-keys
gpg --list-secret-keys --with-colons



8A09EA4FEB76064E
### optional - using scripts

```sh
mkdir ~/humans/iam/gpgkeys
cd ~/humans/iam/gpgkeys && touch generate_gpg_keys.sh
chmod +x generate_gpg_keys.sh
./generate_gpg_keys.sh
```