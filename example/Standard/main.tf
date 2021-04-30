module "python_lambda" {
  source = "../../"
  lambda_handler = "hello_world.print_hello"
}