class DairyRecord < ApplicationRecord
  belongs_to :user

  validates :total_amount, presence: true
  validates :total_number, presence: true
  validates :count, presence: true
  validates :date, presence: true, uniqueness: true

  has_many :customer_records, dependent: :destroy

  # セット率の計算
  def calculate_set_rate
    self.set_rate = count > 0 ? (total_number.to_f / count) : 0
  end

  # 客単価の計算
  def calculate_average_spend
    self.average_spend = total_number > 0 ? (total_amount.to_f / total_number) : 0
  end

  # レコードが保存される前に計算メソッドを呼び出す
  before_save :calculate_metrics

  private

  def calculate_metrics
    calculate_set_rate
    calculate_average_spend
  end
end
