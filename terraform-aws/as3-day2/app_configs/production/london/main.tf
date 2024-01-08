data "terraform_remote_state" "aws_demo" {
  backend = "local"

  config = {
    path = "${path.module}/../../../../terraform.tfstate"
  }
}

provider "bigip" {
  address  = data.terraform_remote_state.aws_demo.outputs.f5_ui
  username = data.terraform_remote_state.aws_demo.outputs.f5_username
  password = data.terraform_remote_state.aws_demo.outputs.f5_password
}

resource "bigip_as3" "nginx" {
  as3_json     = templatefile("./as3_vs2.tpl", {
    vs2_ip     = jsonencode([data.terraform_remote_state.aws_demo.outputs.f5_vs2[0]])
    cert       = var.cert
    key        = var.key
    ciphertext = base64encode(var.ciphertext)
    protected  = base64encode(var.protected)
  })
}

resource "local_file" "nginx" {
  content       = templatefile("./as3_vs2.tpl", {
    vs2_ip     = jsonencode([data.terraform_remote_state.aws_demo.outputs.f5_vs2[0]])
    cert       = var.cert
    key        = var.key
    ciphertext = base64encode(var.ciphertext)
    protected  = base64encode(var.protected)

  })
  filename = "./rendered-as3.json"
}