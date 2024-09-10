provider "aws" {
  region = "us-east-1"
}

# Call the module for Afa Collins
module "afa_collins" {
  source   = "../modules/iam-user-profile"
  user_name = "afa.collins"
  pgp_key   = file("../keys/afa_collins_public_key.asc")  # Path to Afa Collins' public key
}

# Call the module for Serge Mando
module "serge_mando" {
  source   = "../modules/iam-user-profile"
  user_name = "serge.mando"
  pgp_key   = file("../keys/serge_mando_public_key.asc")  # Path to Serge Mando's public key
}

# Call the module for Ttioe Resat
module "ttioe_resat" {
  source   = "../modules/iam-user-profile"
  user_name = "ttioe.resat"
  pgp_key   = file("../keys/ttioe_resat_public_key.asc")  # Path to Ttioe Resat's public key
}

output "user_profiles" {
  value = {
    afa_collins = module.afa_collins.encrypted_password
    serge_mando = module.serge_mando.encrypted_password
    ttioe_resat = module.ttioe_resat.encrypted_password
  }
}
