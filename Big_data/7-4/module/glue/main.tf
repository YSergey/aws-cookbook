# 4. Glueデータベースの作成
resource "aws_glue_catalog_database" "database" {
  name = "awscookbook704db1"
}

# 5. Glueテーブルの作成
resource "aws_glue_catalog_table" "table" {
  name          = "awscookbook704table"
  database_name = aws_glue_catalog_database.database.name
  table_type    = "EXTERNAL_TABLE"

  storage_descriptor {
    columns {
      name = "title"
      type = "string"
    }
    columns {
      name = "other titles"
      type = "string"
    }
    columns {
      name = "bl record id"
      type = "bigint"
    }
    columns {
      name = "type of resource"
      type = "string"
    }
    columns {
      name = "content type"
      type = "string"
    }
    columns {
      name = "material type"
      type = "string"
    }
    columns {
      name = "bnb number"
      type = "string"
    }
    columns {
      name = "isbn"
      type = "string"
    }
    columns {
      name = "name"
      type = "string"
    }
    columns {
      name = "dates associated with name"
      type = "string"
    }
    columns {
      name = "type of name"
      type = "string"
    }
    columns {
      name = "role"
      type = "string"
    }
    columns {
      name = "all names"
      type = "string"
    }
    columns {
      name = "series title"
      type = "string"
    }
    columns {
      name = "number within series"
      type = "string"
    }
    columns {
      name = "country of publication"
      type = "string"
    }
    columns {
      name = "place of publication"
      type = "string"
    }
    columns {
      name = "publisher"
      type = "string"
    }
    columns {
      name = "date of publication"
      type = "string"
    }
    columns {
      name = "edition"
      type = "string"
    }
    columns {
      name = "physical description"
      type = "string"
    }
    columns {
      name = "dewey classification"
      type = "string"
    }
    columns {
      name = "bl shelfmark"
      type = "string"
    }
    columns {
      name = "topics"
      type = "string"
    }
    columns {
      name = "genre"
      type = "string"
    }
    columns {
      name = "languages"
      type = "string"
    }
    columns {
      name = "notes"
      type = "string"
    }
    location      = "s3://${var.bucket_id}/data"
    input_format  = "org.apache.hadoop.mapred.TextInputFormat"
    output_format = "org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat"
    
    ser_de_info  {
      name = "org.apache.hive.serde2.lazy.LazySimpleSerDe"
      parameters = {
        "serialization.format" = ","
        "field.delim"          = ","
      }
    }
  }

  parameters = {
    "has_encrypted_data" = "false"
  }
}