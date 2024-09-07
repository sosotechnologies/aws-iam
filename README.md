## Opentofu IAM Users with Policy statements

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


### using gpg password
[https://stackoverflow.com/questions/53534722/how-to-enable-the-console-login-for-iam-user-in-terraform](https://stackoverflow.com/questions/53534722/how-to-enable-the-console-login-for-iam-user-in-terraform)

PGP key with aws_iam_user_login_profile is a secure method to generate and encrypt the password for IAM users. 
This approach is preferred when you want to maintain high security, especially for sensitive credentials. 

***Set Up a PGP Key:***

- Create a gpg key for each user

acollins   afa.collins@gmail.com
asusan     afa.susan@gmail.com
aallen     afa.allen@gmail.com
amyra      afa.myra@gmail.com
acecil     afa.cecil@gmail.com
arose      afa.rose@gmail.com

- Mk a diretory in the dirrectory humans/iam/
- execute the script to generate the tokens

```sh
mkdir ~/humans/iam/gpgkeys
cd ~/humans/iam/gpgkeys && touch generate_gpg_keys.sh
chmod +x generate_gpg_keys.sh
./generate_gpg_keys.sh
```

### Apply the tofu code
```sh
tofu init
tofu plan
tofu validate
tofu apply --auto-approve
```

## Decrypt and get password for users and use that to login to the console
```sh
terraform init -upgrade
echo $encrypted_password_acollins | base64 -d > acollins_encrypted_password.bin
echo $encrypted_password_asusan   | base64 -d > asusan_encrypted_password.bin
echo $encrypted_password_mallen   | base64 -d > mallen_encrypted_password.bin
echo $encrypted_password_amyra    | base64 -d > amyra_encrypted_password.bin
echo $encrypted_password_acecil   | base64 -d > acecil_encrypted_password.bin
echo $encrypted_password_arose    | base64 -d > arose_encrypted_password.bin

gpg -d encrypted_password.bin
```

## other debugging
gpg --list-secret-keys
echo $encrypted_password_asusan | base64 -d | gpg -vv -d


## other commands... generating the tokens manually
```sh
gpg --generate-key
gpg --export | base64 > acollins-public.gpg

gpg --generate-key
gpg --export | base64 > asusan-public.gpg

gpg --generate-key
gpg --export | base64 > aallen-public.gpg

gpg --generate-key
gpg --export | base64 > amyra-public.gpg

gpg --generate-key
gpg --export | base64 > acecil-public.gpg

gpg --generate-key
gpg --export | base64 > arose-public.gpg

acollins   afa.collins@gmail.com
asusan     afa.susan@gmail.com
aallen     afa.allen@gmail.com
amyra      afa.myra@gmail.com
acecil     afa.cecil@gmail.com
arose      afa.rose@gmail.com
```