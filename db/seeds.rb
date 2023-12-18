# デフォルトグループの作成
Group.find_or_create_by(name: 'default')

# 客層データ投入
# customer_types = [
#   { name: "主婦" },
#   { name: "OL" },
#   { name: "〜30代" },
#   { name: "〜50代" },
#   { name: "アッパー" },
#   { name: "学生" },
#   { name: "観光客" },
#   { name: "ギフト" },
#   { name: "その他" }
# ]

# customer_types.each do |type|
#   CustomerType.find_or_create_by!(name: type[:name])
# end
