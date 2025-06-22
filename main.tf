# Proveedor para la cuenta de seguridad
provider "aws" {
  alias  = "security_account"
  region = "us-east-1"
  profile = "security-account-profile"  # Usa un perfil de AWS CLI para esta cuenta
}

# Proveedor para la cuenta de gestión de usuarios
provider "aws" {
  alias  = "user_account"
  region = "us-west-2"
  profile = "user-account-profile"  # Perfil de AWS CLI para esta cuenta
}

# Proveedor para la cuenta de procesamiento de pagos
provider "aws" {
  alias  = "payment_account"
  region = "eu-central-1"
  profile = "payment-account-profile"
}

# Otros proveedores para otras cuentas de microservicios, por ejemplo
provider "aws" {
  alias  = "flight_account"
  region = "us-west-1"
  profile = "flight-account-profile"
}
