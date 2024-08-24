resource "yandex_iam_service_account" "sa" {
  folder_id = var.folder_id
  name      = "bucket-sa"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id  = var.folder_id
  role       = "storage.editor"
  member     = "serviceAccount:${yandex_iam_service_account.sa.id}"
  depends_on = [yandex_iam_service_account.sa]
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "static access key for object storage"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-kms" {
  folder_id = var.folder_id
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_kms_symmetric_key" "my-key" {
  name              = "my-kms-key"
  description       = "For my bucket encryption"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
}

resource "yandex_storage_bucket" "my-bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "mezentsev-bucket"
  acl        = "public-read"
  max_size   = 314572800
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.my-key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

resource "yandex_storage_object" "my-picture" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  bucket     = "mezentsev-bucket"
  key        = "mypicture.jpg"
  source     = "./pic.jpg"
  depends_on = [yandex_storage_bucket.my-bucket]
  acl        = "public-read"
}