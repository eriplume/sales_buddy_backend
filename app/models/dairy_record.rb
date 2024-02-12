class DairyRecord < ApplicationRecord
  before_save :calculate_metrics
  belongs_to :user

  validates :total_amount, presence: true
  validates :total_number, presence: true
  validates :count, presence: true
  validates :date, presence: true, uniqueness: { scope: :user_id }

  has_many :customer_records, dependent: :destroy

  private

  # セット率の計算
  def calculate_set_rate
    self.set_rate = count.positive? ? (total_number.to_f / count) : 0
  end

  # 客単価の計算
  def calculate_average_spend
    self.average_spend = total_number.positive? ? (total_amount.to_f / total_number) : 0
  end

  def calculate_metrics
    calculate_set_rate
    calculate_average_spend
  end
end
