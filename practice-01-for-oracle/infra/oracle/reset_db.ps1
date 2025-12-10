# PowerShell版: Oracle DBリセットスクリプト
# 全テーブルtruncate & 初期データ再投入
param()

$container = "oracle-batch-practice-db"
$dbUser = "system"
$dbPass = "oracle"
$service = "ORCLCDB"

# テーブル名リスト
$tables = @("ORDER_DETAILS", "ORDERS", "DAILY_SALES_SUMMARY", "PRODUCTS")

# truncate all tables
foreach ($t in $tables) {
    $truncate = "TRUNCATE TABLE $t;"
    docker exec -i $container bash -c "echo \"$truncate\" | sqlplus -S $dbUser/$dbPass@$service"
}

# 初期データ再投入
Get-Content /docker-entrypoint-initdb.d/02_master_data.sql | docker exec -i $container bash -c "cat > /tmp/02_master_data.sql"
docker exec -i $container bash -c "echo exit | sqlplus $dbUser/$dbPass@$service @/tmp/02_master_data.sql"

Write-Host "DBリセット完了"
