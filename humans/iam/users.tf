module "afacollins1_iam_user" {
  source = "../../modules/iam-user"  
  name   = "afanwi.collins1@gmail.com"
  pgp_key = file("gpgkeys/afacollins1-public.gpg")
}

module "afacollins2_iam_user" {
  source = "../../modules/iam-user"  
  name   = "afanwi.collins2@gmail.com"
  pgp_key = file("gpgkeys/afacollins2-public.gpg")
}

module "afacollins3_iam_user" {
  source = "../../modules/iam-user"  
  name   = "afanwi.collins3@gmail.com"
  pgp_key = file("gpgkeys/afacollins3-public.gpg")
}

module "afacollins4_iam_user" {
  source = "../../modules/iam-user"  
  name   = "afanwi.collins4@gmail.com"
  pgp_key = file("gpgkeys/afacollins4-public.gpg")
}

module "afacollins5_iam_user" {
  source = "../../modules/iam-user"  
  name   = "afanwi.collins5@gmail.com"
  pgp_key = file("gpgkeys/afacollins5-public.gpg")
}

module "afacollins6_iam_user" {
  source = "../../modules/iam-user"  
  name   = "afa.rose@gmail.com"
  pgp_key = file("gpgkeys/afacollins6-public.gpg")
}
##----------------------------
