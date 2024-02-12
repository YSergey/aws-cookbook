

module "DB" {
  source = "./modules/DB"
  sysname = local.db.sysname
  table_name = local.db.table_name
}

