resource "aws_lightsail_container_service" "nginx_service" {
  name            = "nginx-container-service"
  power           = "nano"   # Adjust based on required resources
  scale           = 1        # Number of instances
  is_disabled     = false
}
