module "msk" {
  source = "./modules/msk"
}

module "ec2" {
  source = "./modules/ec2"
}

module "ec2-front" {
  source = "modules/ec2-reactjs"
}

module "alb" {
  source = "modules/alb"
}

module "mysql" {
  source = "modules/mysql"
}
