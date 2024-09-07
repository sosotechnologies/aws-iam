module "acollins_iam_user" {
  source = "../../modules/iam-user"  
  name   = "afa.collins@gmail.com"
  pgp_key = file("gpgkeys/acollins-public.gpg")
}

module "asusan_iam_user" {
  source = "../../modules/iam-user"  
  name   = "afa.susan@gmail.com"
  pgp_key = file("gpgkeys/asusan-public.gpg")
}

module "aallen_iam_user" {
  source = "../../modules/iam-user"  
  name   = "afa.allen@gmail.com"
  pgp_key = file("gpgkeys/aallen-public.gpg")
}

module "amyra_iam_user" {
  source = "../../modules/iam-user"  
  name   = "afa.myra@gmail.com"
  pgp_key = file("gpgkeys/amyra-public.gpg")
}

module "acecil_iam_user" {
  source = "../../modules/iam-user"  
  name   = "afa.cecil@gmail.com"
  pgp_key = file("gpgkeys/acecil-public.gpg")
}

module "arose_iam_user" {
  source = "../../modules/iam-user"  
  name   = "afa.rose@gmail.com"
  pgp_key = file("gpgkeys/arose-public.gpg")
}
##----------------------------
