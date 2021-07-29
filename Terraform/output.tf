resource "local_file" "AnsibleInventory" {
 content    = templatefile("inventory.tmpl",
 {
 stage-ip   = aws_instance.stage.*.public_ip
 prod-ip    = aws_instance.prod.*.public_ip
 }
 )
 filename   = "inventory"
}
